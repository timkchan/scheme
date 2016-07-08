# A Scheme Interpreter
![](https://github.com/timkchan/scheme/blob/master/gp.gif?raw=true)

### 1. Introduction
In this project, we will develop an interpreter for a subset of the Scheme language. As we proceed, we think about the issues that arise in the design of a programming language; many quirks of languages are byproducts of implementation decisions in interpreters and compilers.

We will also implement some small programs in Scheme. Scheme is a simple but powerful functional language. Since we only include a subset of the language, our interpreter will not exactly match the behaviour of other interpreters such as [STk].

### 2. Core Concepts

##### 2.1) Reading Scheme expressions
To test scheme reader:
```sh
$ python3 scheme_reader.py
```
Every time you type in a value into the prompt, both the str and repr values of the parsed expression are printed.
e.g.:
```lisp
read> 42
str : 42
repr: 42
read> '(1 2 3)
str : (quote (1 2 3))
repr: Pair('quote', Pair(Pair(1, Pair(2, Pair(3, nil))), nil))
read> nil
str : ()
repr: nil
read> '()
str : (quote ())
repr: Pair('quote', Pair(nil, nil))
read> (1 (2 3) (4 (5)))
str : (1 (2 3) (4 (5)))
repr: Pair(1, Pair(Pair(2, Pair(3, nil)), Pair(Pair(4, Pair(Pair(5, nil), nil)), nil)))
read> (1 (9 8) . 7)
str : (1 (9 8) . 7)
repr: Pair(1, Pair(Pair(9, Pair(8, nil)), 7))
read> (hi there . (cs . (student)))
str : (hi there cs student)
repr: Pair('hi', Pair('there', Pair('cs', Pair('student', nil))))
```

##### 2.2) Symbol evaluation
```lisp
scm> +
#[+]
scm> odd?
#[odd?]
scm> display
#[display]
```

##### 2.3) Calling built-in procedures
```lisp
scm> (+ 1 2)
3
scm> (* 3 4 (- 5 2) 1)
36
scm> (odd? 31)
True
```

##### 2.4) Definitions
```lisp
scm> (define x 15)
x
scm> (define y (* 2 x))
y
scm> y
30
scm> (+ y (* y 2) 1)
91
scm> (define x 20)
x
scm> x
20
scm> (eval (define tau 6.28))
6.28
```
It can also evaluate quoted expressions:
```lisp
scm> 'hello
hello
scm> '(1 . 2)
(1 . 2)
scm> '(1 (2 three . (4 . 5)))
(1 (2 three 4 . 5))
scm> (car '(a b))
a
scm> (eval (cons 'car '('(1 2))))
1
```

##### 2.5) Lambda expressions and procedure definition
 A begin expression is evaluated by evaluating all sub-expressions in order. The value of the begin expression is the value of the final sub-expression:
```lisp
scm> (begin (+ 2 3) (+ 5 6))
11
scm> (define x (begin (display 3) (newline) (+ 2 3)))
3
x
scm> (+ x 3)
8
scm> (begin (print 3) '(+ 2 3))
3
(+ 2 3)
```
 
Lambda expressions:
```lisp
scm> (lambda (x y) (+ x y))
(lambda (x y) (+ x y))
```
 
##### 2.6) Calling user-defined procedures
User-defined procedures:
```lisp
scm> (define f (lambda (x) (* x 2)))
f
```

However, we'd like to be able to use the shorthand form of defining named procedures:
```lisp
scm> (define (f x) (* x 2))
f
```

##### 2.7) Evaluation of special forms
This function should evaluate either the second (consequent) or third (alternative) expression of the `if` expression, depending on whether the value of the first (predicate) expression is true.
```lisp
scm> (if (= 4 2) 'a 'b)
b
scm> (if (= 4 4) (* 1 2) (+ 3 4))
2
```
It is legal to pass in just two expressions to the `if` special form. In this case, you should return the second expression if the first expression evaluates to a true value. Otherwise, return the special `okay` value, which represents an undefined value.
```lisp
scm> (if (= 4 2) 'a)
okay
```

The logical forms `and` and `or` are short-circuiting. For `and`, the interpreter should evaluate each sub-expression from left to right, and if any of these evaluates to a false value, then `False` is returned. Otherwise, it should return the value of the last sub-expression. If there are no sub-expressions in an `and` expression, it evaluates to `True`.
```lisp
scm> (and)
True
scm> (and 4 5 6)  ; all operands are true values
6
scm> (and 4 5 (+ 3 3))
6
scm> (and True False 42 (/ 1 0))  ; short-circuiting behavior of and
False
```
For `or`, evaluate each sub-expression from left to right. If any sub-expression evaluates to a true value, return that value. Otherwise, return `False`. If there are no sub-expressions in an `or` expression, it evaluates to `False`.
```lisp
scm> (or)
False
scm> (or 5 2 1)  ; 5 is a true value
5
scm> (or False (- 1 1) 1)  ; 0 is a true value in Scheme
0
scm> (or 4 True (/ 1 0))  ; short-circuiting behavior of or
4
```
`cond` form returns the value of the first result sub-expression corresponding to a true predicate, or the sub-expression corresponding to `else`.
```lisp
scm> (cond ((= 4 3) 'nope)
           ((= 4 4) 'hi)
           (else 'wait))
hi
scm> (cond ((= 4 3) 'wat)
           ((= 4 4))
           (else 'hm))
True
scm> (cond ((= 4 4) 'here (+ 40 2))
           (else 'wat 0))
42
```
The value of a `cond` is undefined if there are no true predicates and no `else`. In such a case, `do_cond_form` should return `okay`.
```lisp
scm> (cond (False 1) (False 2))
okay
```

The `let` special form binds symbols to values locally, giving them their initial values. For example:
```lisp
scm> (define x 'hi)
x
scm> (define y 'bye)
y
scm> (let ((x 42)
           (y (* 5 10)))
       (list x y))
(42 50)
scm> (list x y)
(hi bye)
```

`do_mu_form` is a non-standard Scheme expression type. A `mu` expression is similar to a `lambda` expression, but evaluates to a `MuProcedure` instance that is dynamically scoped:
```lisp
scm> (define f (mu (x) (+ x y)))
f
scm> (define g (lambda (x y) (f (+ x x))))
g
scm> (g 3 7)
13
```
##### 2.8) Implementing Scheme procedures.

The `enumerate` procedure takes in a list of values and returns a list of two-element lists, where the first element is the index of the value, and the second element is the value itself.
```lisp
scm> (enumerate '(3 4 5 6))
((0 3) (1 4) (2 5) (3 6))
scm> (enumerate '())
()
```
The `list-change` procedure lists all of the ways to make change for a positive integer `total` amount of money, using a list of currency denominations, which is sorted in descending order. The resulting list of ways of making change should also be returned in descending order.

To make change for 10 with the denominations (25, 10, 5, 1), we get the possibliites:
```lisp
10
5, 5
5, 1, 1, 1, 1, 1
1, 1, 1, 1, 1, 1, 1, 1, 1, 1
```
To make change for 5 with the denominations (4, 3, 2, 1), we get the possibilities:
```lisp
4, 1
3, 2
3, 1, 1
2, 2, 1
2, 1, 1, 1
1, 1, 1, 1, 1
```


### 3. Data Types
| __Scheme Data Type__  | __Our Internal Representation__                  |
|-----------------------|--------------------------------------------------|
| Numbers               | Python's built-in `int` and `float` data types.  |
| Symbols               | Python's built-in `string` data type.            |
| Booleans (`#t`, `#f`) | Python's built-in `True`, `False` values.        |
| Pairs                 | The `Pair` class, defined in `scheme_reader.py`. |
| `nil`                 | The `nil` object, defined in `scheme_reader.py`. |

### 4. Files

Files in this project:

* `scheme.py`: the Scheme evaluator
* `scheme_reader.py`: the Scheme syntactic analyser
* `questions.scm`: a collection of functions (User-defined procedures) written in Scheme
* `tests.scm`: a collection of test cases written in Scheme
* `scheme_tokens.py`: a tokenizer for Scheme
* `scheme_primitives.py` primitive Scheme procedures
* `buffer.py`: a buffer implementation
* `ucb.py`: utility functions for 61A


### 5. Running the Scheme Interpreter

To run your Scheme interpreter in an interactive session, type:
```sh
$ python3 scheme.py
```

You can use your Scheme interpreter to evaluate the expressions in an input file by passing the file name as a command-line argument to `scheme.py`:
```sh
$ python3 scheme.py tests.scm
```

To exit the Scheme interpreter, press `Ctrl-d` or evaluate the `exit` procedure:
```lisp
scm> (exit)
```

To test scheme reader, yvery time you type in a value into the prompt, both the str and repr values of the parsed expression are printed:
```sh
$ python3 scheme_reader.py
```


### 6. Class Project Site
[here]

[here]: <http://61a-su15-website.github.io/proj/scheme/>
[STk]: <http://inst.eecs.berkeley.edu/~scheme/>