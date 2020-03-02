#lang at-exp racket/base
;==========================功能提供=====================================
(provide gen-classes)
(provide class*)

;==========================依赖=========================================
(require  racket/local)
(require  scribble/text)
(require (for-syntax racket/base))
(require (for-syntax syntax/parse))
(require  "../../utl.rkt")
(require  "../jfield/jfield-generator.rkt")

;java类信息结构
; A class contains:
;  import
;  name
;  comment
;  fields
;    fields is a list of jfield
; 
(struct
  jclass(
   import
   name
   comment
   fields
   methods)
  #:transparent)



(define-syntax (class* stx)
  (syntax-parse stx
    ;模式
    ;(~var x id)表示x是一个id类型的符号变量
    [(_ ((~optional (~var import  str))(~var cname  id) (~optional (~var comment id)) (~seq fields))...)

     ;模式实例化
     #'(list (jclass (~? import "") 'cname (~? 'comment  "") fields "")...)]
    ))




(define-syntax (gen-classes stx)
   (syntax-parse stx
     [(_  (~var  dest-dir str) (~var  package-name str) (~seq  list-of-class )  (~optional (~var  class-template-file-path str)))
      #'(for ([jc list-of-class])
          (local [
                 (define package package-name)
                 (define import (jclass-import jc))
                 (define fields (gen-jfields (jclass-fields jc)))
                 (define name (jclass-name jc))
                 (define comment (jclass-comment jc))
                 (define author "yangliang")
                 (define anotation "")
                 (define methods (jclass-methods jc))]
                 (display name)
            (out (include/text  (file (~? class-template-file-path "jclass-default.java")))
                 (path->string (build-path (package->path dest-dir package) (string-append (symbol->string name) ".java"))))))]
     
     [(_  (~var  dest-dir str) (~var  package-name str) (~seq  list-of-class )  (~var  field-template-file-path str) (~var  class-template-file-path str))
      #'(for ([jc list-of-class])
          (local [
                 (define package package-name)
                 (define import (jclass-import jc))
                 (define fields (gen-jfields (jclass-fields jc)  field-template-file-path))
                 (define name (jclass-name jc))
                 (define comment (jclass-comment jc))
                 (define author "yangliang")
                 (define anotation "")
                 (define methods (jclass-methods jc))]
                 (display name)
            (out (include/text  (file   class-template-file-path))
                 (path->string (build-path (package->path dest-dir package) (string-append (symbol->string name) ".java"))))))]))


(define-syntax (class name comment stx)
    (syntax-case stx ()
      [(_  (fields methods) ...)
       #'(list (jclass 'name 'comment "" 'methods) ...)]))




(module+ test
(string-split  "com.gen"  ".")
(gen-jfields (f* (String her_name ) (String her_Address 住址) (int height_) (Date date 日期)) "../test/a/field-only.java")
  
  (gen-classes "../../test" "com.gen" 
   (class*
       [
        "import com.x.y;"
         Animal 动物
        (f* (String name 名字) (int age))]
    
       ["import com.x.y;"
         X 
        (f* (String name 名字) (int age))])
     "../custom-template/tableEntityField.tpl" "../custom-template/tableEntityClass.tpl")
 
)