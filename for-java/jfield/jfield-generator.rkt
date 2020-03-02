#lang at-exp racket/base

;==========================功能提供=====================================
(provide jfield)
(provide f*)
(provide gen-jfields)


;==========================依赖=========================================
(require  racket/local)
(require racket/contract)
(require  scribble/text)
(require (for-syntax racket/base))
(require (for-syntax syntax/parse))
(require  "../../utl.rkt")





;=======================================================================
;java字段信息结构
(struct
  jfield(
   type
   name
   comment)
  #:transparent)



(define-syntax (f* stx)
  (syntax-parse stx
    ;模式
    ;(~var x id)表示x是一个id类型的符号变量
    [(_ ((~var type20 id) (~var name20 id))...
        ((~var type30 id) (~var name30 id) (~var comment30 id))...
        ((~var type21 id) (~var name21 id))...
        ((~var type31 id) (~var name31 id) (~var comment31 id))...)
     ;模式实例化
     #'(list (jfield 'type20 'name20 'name20)...
             (jfield 'type30 'name30 'comment30) ...
             (jfield 'type21 'name21 'name21)...
             (jfield 'type31 'name31 'comment31)...)]
    ))

(define-syntax (gen-jfields stx)
  (syntax-parse stx
    
    ;匹配精确度高的模式放前面
    [(_  (~seq  jfields ) (~optional (~var  template-file-path str)))
     #'(for/list ([jf jfields])
         (local [(define-values
                   (type name comment)
                   (values  (->string (jfield-type jf))  (->string (jfield-name jf))  (->string (jfield-comment jf))))]
           (include/text  (file (~? template-file-path "jfield-default.java")))))]


     [(_  (~seq  jfields )  (~var  template-file-path str) (~var  out-path str))
     #'(out
        ; content
        (for/list ([jf jfields])
          (local [(define-values
                    (type name comment)
                    (values  (->string (jfield-type jf))  (->string (jfield-name jf))  (->string (jfield-comment jf))))]
            (include/text  (file template-file-path ))))
        out-path)]
    ))



(module* test #f

  
  (display (f* ))
  
  (display (f* (String name)))
  
  (display (f* (String name) (String address)))
  
  (display (f* (String name 姓名) (String address)))
  
  (display (f* (String name 姓名) (String address 住址)))

  (display (f* (String name 姓名) (String address) (int height 身高)))
  
  (display (f* (String name ) (String address 住址) (int height) (Date date 日期)))
  
  (display (f* (String name ) (String address 住址) (int height)))
  
  
  ;(out (gen-get-and-set f1) "../test/field-visit-method.java")
  ;(define-values (type name comment) (values "x" "x" "this is a"))
  (gen-jfields (f* (String her_name ) (String her_Address 住址) (int height_) (Date date 日期)) "../test/a/field-only.java")

)