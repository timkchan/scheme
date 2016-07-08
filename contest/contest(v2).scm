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
	(speed 0)
	(pixelsize 10)

(define (draw)


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
	(define init 20)	

	(define lst (list "#97A5C8" "#232E80" "#707173" "#FFFF00" "#FF0000" "#0000FF" "#8000FF" "#FF00FF" ))	;TK: Could make an infifnite list.

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
	
(inf-squ-fib 5 lst)



	; (square-fib (* (expt phi 1) init) "#0fffc0")
	; (square-fib (* (expt phi 2) init) "#0f340c")
	; (square-fib (* (expt phi 3) init) "#1f02c0")
	; (square-fib (* (expt phi 4) init) "#1f4080")
	; (square-fib (* (expt phi 5) init) "#1f4080")




  (exitonclick))

; Please leave this last line alone.  You may add additional procedures above
; this line.
(draw)
