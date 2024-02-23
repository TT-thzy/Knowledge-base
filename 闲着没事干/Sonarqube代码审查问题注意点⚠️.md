### Sonarqube代码审查问题总结

#### 1. spring 事务处理中，同一个类中:A方法（无事务）调B方法（有事务）,事务不生效问题（@Transation）

Cause:不是走代理对象去执行有事务的方法，直接用对象本身去调的方法（this.方法名），导致事务失效；简单来说就是无增强；

Solution:两个方法都加@Transation注解,或使用编程式事务，或将代理类注进来，使用代理对象调用即可；



#### 2.单例中双重锁check问题

Cause:最后一步构建对象时，不是原子性操作；

Solution:加volatile关键字，利用内存屏障解决指令重排问题；



#### 3.构建BigDecimal对象时精度丢失问题

Cause:使用new BigDecimal(double val)构造对象时，会有精度丢失问题;

Solution:使用new BigDecimal(string val)构建对象；阿里巴巴手册有明确规定；

Export:

​	为什么会有精度丢失问题？

> 主要是小数会有除不尽的情况，而double或float有<u>长度限制</u>（用词不准确），就会有截断问题，导致精度丢失；

​	为什么用BigDecimal做运算能避免精度丢失问题？

> <font color="red">**Todo**</font> 以前研究过还写过文章，忘了，回去补上 ；大概是通过一标度位代替小数点，避免用小数做运算；



#### 4.在try或catch语句块进行资源关闭问题

Cause:跳过资源关闭操作；

Solution:在finally语句块做资源关闭操作；





####  