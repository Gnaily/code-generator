#lang racket/base
(require  racket/local)
(require racket/string)
(require db)
(require  "../utl.rkt")
(require  "jfield/jfield-generator.rkt")
(require  "jclass/jclass-generator.rkt")

(define conn (mysql-connect   #:server "39.108.13.59"
                 #:port 8878
                 #:database "assetmgr"
                 #:user "htuser"
                 #:password "W4fN8jD3Ntuw4cjp"))


(define (->java-type dbtype)
  
        (cond
          [(string=? dbtype "bit") "Boolean"]
          [(string=? dbtype "tinyint") "Integer"]
          [(string=? dbtype "smallint") "Integer"]
          [(string=? dbtype "int") "Integer"]
          [(string=? dbtype "bigint") "Long"]
          [(string=? dbtype "float") "Float"]
          [(string=? dbtype "double") "Double"]
          [(string=? dbtype "decimal") "BigDecimal"]
          [(string=? dbtype "char") "Char"]
          [(string=? dbtype "varchar") "String"]
          [(string=? dbtype "text") "String"]
          [(string=? dbtype "date") "Date"]
          [(string=? dbtype "datetime") "Date"]
          [(string=? dbtype "timestamp") "Date"]))


; 将数据库中某张表的字段转为java字段
(define (java-field-list table-name)

  (for/list ([item (query-rows conn "select data_type,column_name,column_comment from information_schema.columns  where table_name=?" table-name )])
    (local [(define-values
              (type name comment) (values  (->java-type (vector-ref item 0))  (vector-ref item 1)  (vector-ref item 2)))]
        (jfield type name comment))))

 


(module+ test



 (gen-classes "../test" "com.gen" 
   (class*
       [
        "import com.x.y;"
         PersonEntity 
         (java-field-list "assetmgr_assets_change_log")]
    
       ["import com.x.y;"
         X 
        (f* (String name 名字) (int age))])
   ;should repair path
   "../custom-template/tableEntityField.tpl"  "../custom-template/tableEntityClass.tpl")
 
 )