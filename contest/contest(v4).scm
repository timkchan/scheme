;;; Scheme Recursive Art Contest Entry
;;;
;;; Please do not include your name or personal info in this file.
;;;
;;; Title: <CS61A X FIBB>
;;;
;;; Description:
;;;   <Albert: You think you are done with fibbinacci?
;;;    Use these three lines to describe
;;;    its inner meaning.>

(define (draw)

	(speed 6)

	(define (square-fib n bg)
		(color '"#000000")
		
			(fd n) 
			(left 90)
			(fd n)
			(left 90)
			(begin_fill)
			(fd n)
			(left 90)
			(fd n)
			(left 90)
			
		
		
		
		(color bg)
		(quartercircle n) (end_fill))	

	(define phi (/ (+ 1 (sqrt 5)) 2))
	(define init 30)	

	(define lst (list "#FF0000" "#FF8000" "#FFFF00" "#00FF00" "#00FFFF" "#0000FF" "#8000FF" "#FF00FF" ))	;TK: Could make an infifnite list.

	(define (inf-squ-fib n colour_list)
		(define (helper curr colour)
			(if (> curr n)
				nil
				((square-fib (* (expt phi curr) init) (car colour))
				 (helper (+ curr 1) (cdr colour))
				)
			)
		)
		(helper 0 colour_list)
	)

(inf-squ-fib 7 lst)








  (exitonclick))

; Please leave this last line alone.  You may add additional procedures above
; this line.
(draw)
