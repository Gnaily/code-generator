#lang at-exp racket/base
(require  racket/local)
(require  scribble/text)
(require  "../../../../utl.rkt")


;java方法信息结构
(struct
  jmethod(
   return
   name
   params)
  #:transparent)





(define
  (gen-methods list-of-method)
  (for/list ([jm list-of-method])
            (local [(define return (jmethod-return jm))
                    (define name (jmethod-name jm))
                    
                    (define params
                      (cond
                        [(list? (jmethod-params jm)) (datum-intern-literal (jmethod-params jm))]
                        [""]))]
                   (include/text "jmethod.java"))))

(define-syntax methods
    (syntax-rules ()
      [(_ (return name  (type  n $ ...) ...) ...)
       (list (jmethod 'return 'name (list 'type  'n '$  ...) ...) ...)]))

(module* test #f

  
 (datum->syntax (,a))

 
(define ms (methods (String  test(int age , String test , int a))
                    (String  test1(int age))
                    ))
  (display ms)
(out (gen-methods ms) "../test/method.java")   
 )