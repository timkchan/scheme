; Some utility functions that you may find useful.
(define (cons-all first rests)
  ; BEGIN Question 19
  (if (null? rests)
  nil
  (cons (cons first (car rests)) (cons-all first (cdr rests))))
)
  ; END Question 19

(define (apply-to-all proc items)
  ; BEGIN Question 20
  (if (null? items)
    nil
    (cons (proc (car items)) (apply-to-all proc (cdr items)))
  )
)
  ; END Question 20

(define (zip pairs)
  ; BEGIN Question 20
  (list (apply-to-all car pairs) (apply-to-all car (apply-to-all cdr pairs)))
)
  ; END Question 20

(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (cddr x) (cdr (cdr x)))
(define (cadar x) (car (cdr (car x))))

; Problem 18

;; Returns a list of two-element lists
(define (enumerate lst)
  ; BEGIN Question 18
  (define (helper n current lst)
    (if (null? lst)
      current
      (helper (+ n 1) (append current (list (cons n (list (car lst))))) (cdr lst))
    )
  )
  (helper 0 nil lst)
)
  ; END Question 18

(enumerate '(5 6 7 8))
; expect ((0 5) (1 6) (2 7) (3 8))

; Problem 19

;; List all ways to make change for TOTAL with DENOMS
(define (list-change total denoms)
  ; BEGIN Question 20
  (cond
    ((null? denoms) nil)
    ((< total 0) nil)
    ((= total 0) (cons (cons (car denoms) nil) nil))
    ((> (car denoms) total) (list-change total (cdr denoms)))
    ((= (car denoms) total) (append (list-change (- total (car denoms)) denoms) (list-change total (cdr denoms))))
    (else (append (cons-all (car denoms) (list-change (- total (car denoms)) denoms)) (list-change total (cdr denoms))))
  )
)
  ; END Question 20

; Make sure the lists are in descending order
(list-change 10 '(25 10 5 1))
; expect ((10) (5 5) (5 1 1 1 1 1) (1 1 1 1 1 1 1 1 1 1))
(list-change 5 '(4 3 2 1))
; expect ((4 1) (3 2) (3 1 1) (2 2 1) (2 1 1 1) (1 1 1 1 1))

;; Problem 20 (optional)
;; Draw the hax image using turtle graphics.
(define (hax d k)
  ; BEGIN Question 20
  'REPLACE-THIS-LINE
  nil)
  ; END Question 20

; Problem 21
;; Returns a function that takes in an expression and checks if it is the special
;; form FORM
(define (check-special form)
  (lambda (expr) (equal? form (car expr))))

(define lambda? (check-special 'lambda))
(define define? (check-special 'define))
(define quoted? (check-special 'quote))
(define let?    (check-special 'let))

;; Converts all let special forms in EXPR into equivalent forms using lambda
(define (analyze expr)
  (cond ((atom? expr)
         ; BEGIN Question 21
         expr
         ; END Question 21
         )
        ((quoted? expr)
         ; BEGIN Question 21
         expr
         ; END Question 21
         )
        ((or (lambda? expr)
             (define? expr))
         (let ((form   (car expr))
               (params (cadr expr))
               (body   (cddr expr)))
           ; BEGIN Question 21
           (if (null? (cdr (cddr expr)))
            (cons form (cons params (cons (car body) nil)))
            (cons form (cons params (cons (car body) (cons (analyze (cadr (cddr expr))) nil)))))
           ; END Question 21
           ))
        ((let? expr)
         (let ((values (cadr expr))
               (body   (cddr expr)))
           ; BEGIN Question 21
           (cons
            (cons 'lambda (list (car (zip values)) (analyze (car body))))
              (apply-to-all analyze (cadr (zip values))))
           ; END Question 21
           ))
        (else
         ; BEGIN Question 21
         (list (car expr) (analyze (cadr expr)) (analyze (car (cddr expr))))
         ; END Question 21
         )))

(analyze 1)
; expect 1
(analyze 'a)
; expect a
(analyze '(+ 1 2))
; expect (+ 1 2)

;; Quoted expressions remain the same
(analyze '(quote (let ((a 1) (b 2)) (+ a b))))
; expect (quote (let ((a 1) (b 2)) (+ a b)))

;; Lambda parameters not affected, but body affected
(analyze '(lambda (let a b) (+ let a b)))
; expect (lambda (let a b) (+ let a b))
(analyze '(lambda (x) a (let ((a x)) a)))
; expect (lambda (x) a ((lambda (a) a) x))

(analyze '(let ((a 1)
                (b 2))
            (+ a b)))
; expect ((lambda (a b) (+ a b)) 1 2)
(analyze '(let ((a (let ((a 2)) a))
                (b 2))
            (+ a b)))
; expect ((lambda (a b) (+ a b)) ((lambda (a) a) 2) 2)
(analyze '(let ((a 1))
            (let ((b a))
              b)))
; expect ((lambda (a) ((lambda (b) b) a)) 1)
(analyze '(+ 1 (let ((a 1)) a)))
; expect (+ 1 ((lambda (a) a) 1))

