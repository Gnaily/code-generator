#lang at-exp racket/base


;==========================功能提供=====================================
(provide package->path)
(provide render)
(provide out)
(provide .->/)
(provide ->string)
(provide a_b->aB)
(provide a_b->A_B)


;==========================依赖=========================================

(require  racket/local)
(require racket/path)
(require  scribble/text)
(require racket/file)
(require (for-syntax racket/base))
(require (for-syntax syntax/parse))




;====================转换============================================



(define (package->path base package)
  (rec-build base (string-split package ".")))


(define (rec-build first rest)
  (cond [(eq? 0 (length rest)) (build-path first)]
        [else
         (let*
             ([new-first (build-path first (list-ref rest 0))]
              [new-rest  (list-tail rest 1)])
           (rec-build new-first new-rest))]))


(define (->string input)
  (cond [(string? input) input]
        [(symbol? input) (symbol->string input)]
        (error "type must be symbol or string")))


(define (.->/ pname) (string-replace pname "."  "\\"))

(define (a_b->aB string)
    (local
      [(define string-list (string-split (string-replace string "_"  " ")))]
      (string-append*
       (string-downcase (list-ref string-list 0 ))
       (map (lambda (str) (string-titlecase str))
            (list-tail string-list 1 )))))


(define (a_b->A_B string)
    (local
      ;local variable
      [(define list (string-split string "_" ))
       (define len  (length list))
       (define first (list-ref list 0 ))
       (define rest  (list-tail list 1 ))]
      
      (cond
        [(> len 1)
         (string-join
          (map (lambda (s) (string-upcase s)) list) "_")]
        [(string-upcase first)])))

;====================================渲染模板==============================

;宏函数render对模板进行渲染，模板中的变量需要自己先定义值, render是以下之一：
;
;(render template-file-path)
;   参数:template-file-path 模板文件路径
;   返回:
;(render template-file-path out-path) 
;   参数:模板文件路径,out-path 输出文件路径 
;   返回:
(define-syntax (render stx)
  (syntax-parse stx
    [(_ (~var  template-file-path str))
     #'(include/text  template-file-path)]
     
    [(_ (~var  template-file-path str ) (~var out-path str ))
     #'(out (include/text  template-file-path) out-path)
     ]))

(define-syntax (and-render stx)
  (syntax-parse stx
    [(_ (~var  template-file-path str))
     #'(include/text  (file template-file-path))]
     
    [(_ (~var  template-file-path str ) (~var out-path str ))
     #'(out (include/text (file template-file-path)) out-path)
     ]))


;将内容写入文件。如果文件已存在，将存在的文件重命名——文件名加上.last_前缀。
;参数:
;   content 输出内容
;   file-path:文件路径
;
(define (out content file-path)
  
  (let*
      ([fname (file-name-from-path file-path)]
       [name (path->string fname)]
       [new-name (string-append ".last_" name)]
       [new-path (string-replace file-path name new-name)])
    
 (cond
    [(file-exists?  file-path) (rename-file-or-directory file-path new-path #t)]
    [else (make-parent-directory* file-path)]))

  (define outport (open-output-file file-path #:exists 'replace))
  (output  content outport)
  (close-output-port outport)
  (fprintf (current-output-port)
           "\ngenerated  ~a!"
           file-path))
  


(module+ test
  (string-split "request_param_1" "_")
   (string-append "request_param_1" "_" "x")
   (a_b->A_B  "request_param_1")
   (a_b->A_B  "request")
   (a_b->aB  "request")
   (.->/ "com.a.b.c")
  
(define-syntax (m stx)
  (syntax-parse stx
    
    ;匹配精确度高的模式放前面
    [(_  (~optional (~var  template-file-path str))  )
     #'(display (~? template-file-path "empty"))]))
  (m  )
  
 (define p (build-path "D:/" "a" "b"))
  p
 (package->path "D:" "com.a.b")



;(render1 (define title 2) "template.html" )
  (let*
      ([type "String"]
       [name "x"]
       [comment "this is x"])
    (render "./for-java/jfield/jfield-only.java"))


  ;(foo 'a 'b 'c)
  ;(out 20 "test/out.test")
  
  )