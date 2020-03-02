@;{
	可以在下面内部的@list{}中扩展一些东西。例如注解静态字段。
	public static @|type| (string-upcase @|name|)="@|name|";
	@"@"TableField(value=@|name|)
}


@list{

	/** @|comment| **/
	private @|type| @(a_b->aB @|name|); 

}

@(define gen-getter-and-setter #t)
@(when  (eq? #f @|gen-getter-and-setter|)

   @(define name-titlecase (string-titlecase @|name|)) 

   @(define (method prefix) (string-append prefix name-titlecase))


   @list{
       /**
        * 设置@|comment|
        */
       public @|type| @(method "get")(){
           return @|name|;
       }


       /**
        * 获取@|comment|
        */    
       public void @(method "set") (@|type| @|name|){
           this.@|name|=@|name|;
       }

     })
