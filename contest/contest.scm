;;; Scheme Recursive Art Contest Entry
;;;
;;; Please do not include your name or personal info in this file.
;;;
;;; Title: <Tail-Recursion X FIBONACCI X MONDRIAN>
;;;
;;; Description:
;;;   <Albert: Think you are done with RECURSION? NOT YET!
;;;    Albert: Think you are done with FIBONACCI? NOT YET!
;;;    ME: Blimey! I am sure MONDRIAN is involved too! See?>	

(define (draw)

	(speed 0)

	;TK: Draw a square and an arc with filled colour.
	(define (square-fib n colour)
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
					(color colour)
				(quartercircle n)
			(end_fill)
	)	

	;TK: Constans.
	(define phi (/ (+ 1 (sqrt 5)) 2))	;TK: Golden Ratio.
	(define init 30)	;TK: Initioal arc radius.
	(define lst (list "#97A5C8" "#232E80" "#707173" "#FFFF00" "#FF0000" "#0000FF" "#8000FF" "#FF00FF" ))	;TK: List of colours. Could make an infifnite list wtih con-steam.

	;TK: Recursively calling square-fib
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

	;TK: Initial Idea. Then made into recursion.
		; (square-fib (* (expt phi 0) init) "#0fffc0")
		; (square-fib (* (expt phi 1) init) "#0f340c")
		; (square-fib (* (expt phi 2) init) "#1f02c0")
		; (square-fib (* (expt phi 3) init) "#1f4080")
		; (square-fib (* (expt phi 4) init) "#1f4080")

	;TK: Final Drawing Call.
	(inf-squ-fib 5 lst)

  (exitonclick))

; Please leave this last line alone.  You may add additional procedures above
; Lalalalalalala, I am above the line below me. LOLOL!
; this line.
(draw)
