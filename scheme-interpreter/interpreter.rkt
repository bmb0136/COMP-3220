#lang racket
;;#lang racket

;; report-no-binding-found : variable -> error
(define report-no-binding-found
  (lambda (search-var)
    (error 'apply-env "No binding for ~s" search-var)))

;; report-invalid-env : environment -> error
(define report-invalid-env
  (lambda (env)
    (error 'apply-env "Bad environment: ~s" env)))

;; empty-env : () -> environment
(define empty-env
  (lambda ()
    (list 'empty-env)))

;; entend-env : environment, variable, value -> environment
(define extend-env
 (lambda (env var val)
   (list 'extend-env var val env)))

;; apply-env : evironment, variable -> value
(define apply-env
 (lambda(env search-var)
   (cond
     ((eqv? (car env)'empty-env) (report-no-binding-found search-var))
     ((eqv? (car env)'extend-env)(let ((saved-var (cadr env))
                                        (saved-val (caddr env))
                                        (saved-env (cadddr env)))
                                    (if (eqv? search-var saved-var)
                                        saved-val
                                        (apply-env saved-env search-var))))
     (else (report-invalid-env env)))))

;; interpreter : a program tree -> void
(define interpreter
  (lambda (prog)
    (let ((theEnv (empty-env)))
       (cond
         ((eqv? (car prog) 'program) (process (cdr prog) theEnv)(display "\nDone"))
         ( else (display "This doesn't look like a program."))))))
   
;; process : statments -> void
(define process
  (lambda (statements myEnv)
    (cond
      ((null? statements) myEnv)
      ( else  (process (cdr statements) (interp (car statements) myEnv))))))

;; interp : statment -> environment
(define interp
  (lambda (stmt myEnv)
       (cond
        ((eqv? (car stmt) 'print) (begin
                                    (display "\n")
                                    (display (exp myEnv (cadr stmt)))
                                    myEnv))
        ((eqv? (car stmt) '=) (extend-env myEnv (cadr stmt)(exp myEnv (caddr stmt))))
        ((eqv? (car stmt) 'if) (procIf (cdr stmt) myEnv))
        ((eqv? (car stmt) 'while) (procWhile (cdr stmt) myEnv))
        ( else (display "\nI saw something I didn't understand.")))))

;; evalCond : (op left right), environment -> bool
(define evalCond
  (lambda (con myEnv)
    (let* 
      ((op (car con))
      (l (exp myEnv (cadr con)))
      (r (exp myEnv (caddr con))))
      (cond
        ((eqv? op '&) (and (not (eqv? l 0)) (not (eqv? r 0))))
        ((eqv? op '<) (< l r))
        ((eqv? op '>) (> l r))
        (else (display "\nI saw something I didn't understand."))))))

; (while (> x 0) (then ((print x)(= x (- x 1))) end) ))) ; should print numbers 10 - 1

;; procWhile : statment, environment -> environment
(define procWhile
  (lambda (stmt myEnv)
    (let
      ((con (car stmt))
      (body (cadr (cadr stmt))))
      (if (evalCond con myEnv) (procWhile stmt (process body myEnv)) myEnv))))

;; procIf : statment, environment -> environment
(define procIf
  (lambda (stmt myEnv)
    (let
      ((con (car stmt))
      (body (cadr (cadr stmt))))
      (if (evalCond con myEnv) (process body myEnv) myEnv))))

;; exp : expression -> value    
(define exp
  (lambda (myEnv e)
    (cond
      ((integer? e) e)
      ((boolean? e) (if e 1 0))
      ((symbol? e) (apply-env myEnv e ))
      ((eqv? (car e) '+) (+ (exp myEnv (cadr e))(exp myEnv (caddr e))))
      ((eqv? (car e) '-) (- (exp myEnv (cadr e))(exp myEnv (caddr e))))
      ((eqv? (car e) '*) (* (exp myEnv (cadr e))(exp myEnv (caddr e))))
      ((eqv? (car e) '/) (/ (exp myEnv (cadr e))(exp myEnv (caddr e))))
      (else (display "I saw something I didn't understand")))))

;;; DON'T TOUCH THE LINE BELOW THIS ONE IF YOU WANT TO RECEIVE A GRADE! ;;;
(provide interpreter)
;;; DON'T TOUCH THE LINE ABOVE THIS ONE IF YOU WANT TO RECEIVE A GRADE! ;;;

;;; Sample testing programs below ;;;
;;; Actual tests NOT guaranteed match the tests below ;;;

; aprog tests simple print statement
; text file: print 1 + 2
(define aprog
  '( program ( print ( + 1 2 ) ) )) ; should print 3

; bprog tests input3.txt (should get error message - no dog variable)
(define bprog
  ' ( program ( = x ( * ( + 2 3 ) dog ) )
              ( print x ) ))

; cprog tests input2.txt
(define cprog
  '( program
     ( = x 3 )
     ( = y 5 )
     ( = z ( / ( + x y ) 3 ) )
     ( print z ) )) ; should print 8/3

; dprog tests input1.txt
(define dprog
 '( program ( = dog 1 )
            ( = x ( / ( + 2 3 ) 4 ) )
            ( = y ( / dog ( + x 3 ) ) )
            ( print ( + x y ) ) )) ; should print 101/68

; eprog tests input4.txt
(define eprog
  ' ( program ( print ( - ( - ( - 1 2 ) 3 ) 4 ) )            ; should print -8
              ( print ( / ( * ( / ( * 1 2 ) 3 ) 4 ) 5 ) ) )) ; should print 8/15

; fprog is a list representaion of a TINY program that tests if statements with logical operators
(define fprog
  '(program
    (= x 2)                                                       ; should print 2
    (if (& x 2) (then ((print x) (= x(- x 1)) (print x)) end ) ))) ; should print 1

; gprog is a list representaion of a TINY program that can handle while loops (statements)
(define gprog
  '(program
    (= x 10)
    (while (> x 0) (then ((print x)(= x (- x 1))) end) ))) ; should print numbers 10 - 1

; hprog is a list representaion of a TINY program that test if statements with relational operators
(define hprog
  '(program
    (= x 10)                                                      ; should print 10
    (if (> x 0) (then ((print x)(= x (- x 1)) (print x)) end) ))) ; should print 9

; iprog is a list representation of a TINY program that tests if statements with logical operators
(define iprog
  '(program
    (= x 5)
    (if (& x #f) (then ((print x) (= x(- x 1)) (print x)) end) ))) ; should not print anything

(provide aprog)
(provide bprog)
(provide cprog)
(provide dprog)
(provide eprog)
(provide fprog)
(provide gprog)
(provide hprog)
(provide iprog)
; How to call the interpreter for [x]prog
;(interpreter aprog)
