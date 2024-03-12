# **JavaSE学习**

## 基础阶段
###  第一次 （变量）

一、内存概念：
硬盘===内存===处理器
      高速缓存
原材料	   临时存储	加工厂
lol			高速缓存
qq	    内存	cpu
wow		
java程序
字节

二、定义变量：
变量的申明：数据类型 变量名称 = 变量的值
	    房间类型  房间号码 = 房间住的人
java命名规范：
a：变量只能包含数字，字母，下划线与$
b:不能以数字开头
c:不能是java关键字
d:最好是有意义的英文单词,首字母小写

三、变量的数据类型：
数据一般分为两大类（按照用途分）
一类是数字类型
int 存的是整数
double 存的是小数
另一类是非数字
char 存的单个字符 ''
String 存的是多个字符串 ""

第二种是根据存储的地方划分
内存分为栈与堆两块
栈的特点是速度快，空间小
堆的特点是速度慢，空间大
局部变量放在栈中的8种类型称为基本类型
byte       1个字节      8位    127===2的7次方-1
short      2个字节      16位
char	   2个字节      16位
int        4个字节      32位   -2的31次方---2的31次方-1
float      4个字节      32位
long       8个字节      64位
double     8个字节      64位
boolean    1个字节       8位
      （多个合用1个字节）   
放在堆中的类型都称为引用类型（例如String）

四、变量的数据类型转换(只要类型兼容)
将小数据类型放到大数据类型中，
我们叫隐式转换,这种转换是安全的
将大数据类型放到小数据类型中，
我们叫显式转换,这种转换是不安全的

五、进制的转换
0B，0X，0，234

六、变量的操作：
a:位操作
有左位移(<<)与右位移(>>)符号位也移动(>>>)
左移一位就扩大1倍，同理右移就缩小1倍
&:位与（都要满足）
|:位或（只要满足一个）
^:位异或（相同为0，不同为1，一个数异或同一个数2次得到本身）
~:位非：加1取反

b:赋值操作
+=，-=，*=，/=,%=

c:运算操作（数字反转与拆分）
++,--:在前是先自身加1再运算，在后是先拿着运算，完了之后再加1
+,-,*,/,%(求余数)

d:比较操作(会得到true和false)
<,<=,>,>=,==,!=

e:逻辑操作
&&：逻辑与（短路）
||：逻辑或
！：取反

七、变量的交换操作

扫描器
Scanner s = new Scanner(System.in);
扫描器没有扫描一个char的方法，
所有的char都用字符串
next()扫描器扫描的字符串不能有空格
要能扫到空格需要用nextLine()

随机器:(记得引入java.util.Random)
Random r  = new Random();
产生随机数
r.nextInt();==》产生int范围的数字
r.nextInt(种子);==》产生0-种子之间
产生min-max的范围数
r.nextInt(max-min+1)+min
要产生随机字母。那么需要产生一个字母
的ascii码值的区间数

65-90：大写
97-122：小写
48-57:数字字符
当引用对象变成垃圾就会被JVM回收
### 第二次课 （条件结构）
顺序结构（从上到下）
分支结构（条件结构）
迭代结构（循环结构）

条件结构：逻辑值：true，false
语法：
if(boolean类型){
	条件为真就执行
}
二选一:
if(boolean类型){
	条件为真就执行
}else{
	条件为假就执行
}
多选一：(上面的条件不能包含下面的条件)
(由范围最小的到范围最大的)
if(){	
}else if(){
}else if(){
}else{
}

条件嵌套就是在条件中再次进行条件判断
if(){
	if(){}else{}
}else{
	if(){}else if(){}else{}
}

switch等值判断
变量的类型只能是int，short，byte，char(jdk1.7之前)
jdk1.7之后可以放String类型
遇到匹配项就执行，没有匹配执行default
匹配后有break就跳出switch，没有会继续往下执行
switch(变量){
	case 匹配值:
		语句；
		break；
	case 匹配值:
		语句；
		break；
	default:
		其他情况
}
标志:
break 标志;

三元操作符(适合执行简短的赋值代码)
条件为真 ? true : false;

奇偶判断
年龄判断
成绩判断
商场打折
1：条件嵌套（三者求最大）
2：switch等值判断（输出月份）
3：随机数生成（牌，字母）
4：猜拳游戏（只玩一把）

总结：
语法: if(){}
      if(){}else{}
      if(){}else if(){}...
      if(){
	if(){}else{}
      }else{
	if(){}else{}
      }
      //等值判断
      switch(){
	case x:
	   break;
	default:
      }
      三元表达式
      表达式 ? true :false;
      扫描器：
      随机器：

### 第三次课（循环结构while）
作业讲解：
1.偶数判断问题
2.多条件写法问题

JDK1.7
支持switch作用在String上
byte，short，char，int

double是64位：从左往右第一位是符号位
	     2-11位是2的指数的值
	     后面52为是小数的值
float是32位：从左往右第一位是符号位
	     2-9位是2的指数的值
	     后面22位是小数的值

顺序
分支（条件）
迭代（循环）
循环是为了解决重复出现的代码
或者有一定规律的代码

4种语法：
1.while循环
语法：while(boolean){}
不停止的循环叫死循环
为了让循环能够停止，一定要在循环
体内改变循环条件（变量）

循环有三要素：
1：循环变量（计数）i
2：循环条件(是否执行循环)
3：循环体（需要重复执行的代码）


循环分为已知次数与未知次数的两类
对于未知次数最简单的方式就是先写成
死循环，然后达到某种条件就break出循环

尽量不要在循环体中定义变量

continue是跳出本次循环，并进入下一次循环
可以将continue当做代码的一个拦截符号
它下面的代码是选择性执行的

break是跳出整个循环体
可以定义一个标记，直接跳到标记的位置

1、循环与条件(可以互相嵌套)
2、累加  定义一个sum=0；不断往里面累加
3、总分与平均分
4、字符串比较(累加)
字符串A.equals(字符串B)
如果相等就返回true（区分大小写）
equalsIgnoredCase（不区分大小写）

养成习惯：常量一定要在前面，用常量来比较变量

求从1累加到你输入数字的和

打印斐波拉切数列前20项
1,1,2,3,5,8...
a,b,a,b,a,b

求100-1000之间的水仙花数
143
1 * 1 * 1 + 4 * 4 * 4 + 3 * 3 * 3 ==143

输入一个数，判断该数是不是素数（只能被1与本身整除的数）

5、猜数游戏
1.电脑随机生成1个1-100之间的数字
2.用户输入一个数字
3.将用户输入的数字与随机数做比较
如果大于电脑的数提示您猜的数字太大了
反之亦然，如果猜中了就提示恭喜您猜对了
4.允许猜5次
5.请注意：如果猜对了要退出循环

先判断条件再执行循环
1:while(){}：未知次数
2:for(){}:已知次数
先执行一次再判断
3：do{
  }while();
无条件直接循环
4：foreach:

### 第四次课（循环结构do-while与for）
while(boolean){
	if（）{
		break；
	}
}
先判断再执行

do{}while(boolean);
无论如何先执行一次，不管条件真假,先执行一次后判断

for专门用来执行已知次数的循环(先判断再执行)
for(变量定义初始;条件;变量的改变){}

foreach：操作集合（后续集合时讲解使用）

while与for都是先判断再执行，有可能一次都不执行
所以在编译期不能直接将条件写死为false

//万年历（课堂案例）
	万年历的思路：
	1.计算输入年份与月份距离1900年1月1日的天数
	2.通过天数差计算出当前月份第一天是星期几
	3.确定要输出月份的天数
	4.按照格式打印万年历

万年历的思路：
1.计算输入年份与月份距离1900年1月1日的天数
2.通过天数差计算出当前月份第一天是星期几
3.确定要输出月份的天数
4.按照格式打印万年历

猴子吃桃问题：猴子有一堆桃子，第一天吃一半加另一半的1个
,第二天又吃一半加另一半的1
到第10天就只有1个桃子了，问原本一共有多少个桃子

海滩上有一堆桃子，五只猴子来分。
第一只猴子把这堆桃子平均分为五份，
多了一个，
这只猴子把多的一个扔入海中，
拿走了一份。
第二只猴子把剩下的桃子又平均分成五份，
又多了一个，
它同样把多的一个扔入海中，
拿走了一份，第三、第四、第五只猴子都是这样做的，
问海滩上原来最少有多少个桃子？

### 第五次课（循环结构嵌套循环）
遗补知识：continue，结束本次循环，继续下一次循环
           break是跳出当前整个循环

嵌套循环注意事项：

1.可以互相嵌套（类似while嵌套for，或者for嵌套do。。while等）
2.嵌套循环在不跳出的情况下，循环总次数是外层循环次数*内层循环次数
3.嵌套循环建议极限为3层，因为超过3层性能就会很差
4.在内层循环中的break只会跳出内层循环，循环结束需要外层结束
5.在内层循环中可以设计标志位直接从最内层跳出整个循环

海滩上有一堆桃子，五只猴子来分。
第一只猴子把这堆桃子平均分为五份，
多了一个，
这只猴子把多的一个扔入海中，
拿走了一份。
第二只猴子把剩下的桃子又平均分成五份，
又多了一个，
它同样把多的一个扔入海中，
拿走了一份，第三、第四、第五只猴子都是这样做的，
问海滩上原来最少有多少个桃子？

水仙花数问题

组合数问题
有1、2、3、4个数字，能组成多少个互不相同且无重复数字的三位数？都是多少？
123,124,421

图形问题

九九乘法表

百元百鸡
公鸡每只2元，母鸡每只1.5元，小鸡每只0.5元;
一百元买一百只鸡，要求三种鸡都要买，有多少种购买组合？
穷举法(在此基础上做优化)

### 第六次课（数组入门）
作业优化讲解

数组
char开空间存的是ascii为0的字符
它是为了保存一组类型相同的数据，能节约我们定义的变量个数
并加快查询操作
声明：
1:int[] a = new int[5];只是申明空间
2:int[] a = {12,5,3,89};申明时赋值
3:int[] a = new int[]{12,5,3,89};申明时赋值//不推荐

请不要先声明，再一次性赋值
以下是错误做法：
int[] a;
a={12,5,3,89};

可以先声明，再分配空间
以下做法是正确的
int[] a;
a = new int[10];

赋值：
a[0] = 8;

求平均分，总分
求数组最大值，最小值（max min）
数组的复制（从新开辟一个空间）
数组的反序（自身反序，开空间）
数组的应用（极大值计算）
数组的应用（将一个长度为16的字节数组转换成一个只包含16进制数的字符串）

数组属于引用数据类型,开辟在堆中
在堆中没有任何引用指向的空间
我们叫垃圾。JVM会定时回收垃圾。
但是引用是在栈中
访问数组是通过索引（下标）访问每个空间
索引是从0开始到长度-1

引用类型.属性
引用类型.方法()

### 第七次课（数组排序与插入）
数组的定义：三种

求平均分与总分
数组求最大与最小
数组的复制
数组的反序
极大值
字节数组转换

数组的排序

冒泡排序
适合基本能有序的数组，并且需要稳定性
时间复杂度：排序所产生的总时间
空间复杂度：排序所要占用的空间
稳定与不稳定排序：在有相同元素的前提下，前后元素的位置在排序前和后相对一致，那么就称为稳定排序,反之不稳定

选择排序
适合不需要稳定，数据比较混乱
不稳定排序

快速排序（根据情况讲解）
因为涉及到递归，这里只讲排序原理
左指针，右指针，基准位，思路就是通过与基准位的数字进行比较
一轮完成后，凡是比基准位小的都在它左边，大的在右边

有兴趣的同学可以了解下插入排序，归并排序与堆排序，希尔排序，基数排序等

数组的插入（有序数组，插入一个值，使得数组仍然有序）

数组的查找

数组的删除

数组的应用（猴子选大王）
线性数组===》环形数组（约瑟夫环）
index %= arr.length;

猴子选大王
有10只猴子围成一圈，选一个大王，规则是
从第一个开始报数，遇到3的就滚蛋，最后留下的
就是大王，请问第几只是大王？
0 0 0 0 0 0 0 0 0 0

华为面试题：（思路讲解）
12个球,其中已知有1个球与其它重量不同，请称3次求出是哪个球
说明执行过程与结果

### 第八次课（二维数组应用）
二维数组以及多维数组

语法：
int[][] arr = new int[9][9];
注意：初始化时必须有行数字，但是可以没有列数字

二维数组的意思就是数组中的每一个元素比如
arr[0]它也是一个数组。
如果把变量理解为一间房子，变量里面的值就是房间里面的内容
那么一维数组就是一层楼，有多间房子101,102,103等
而二维数组就类似一栋楼，首先有多层(行数)，然后每层又有多间房间（列数）

应用
1.二维求最大值
2.杨辉三角
1
11
121
1331
14641
3.推箱子游戏

### 第九次课（面向对象入门）
类与对象:

C（面向过程）
JAVA（面向对象）

什么是类===》类型
int age = 20;
int[] arr = {1,2,3,4};
String name = "张三";

什么是对象===》万物都是对象
世界由万物组成
java就是面向对象编程的语言
换言之：java就是面向世界万物编程的语言

面向对象语言有三大特征：封装，继承，多态

任何一个对象都可以用名词+动词来描述

类就是对象的抽象
对象就是类的具体实例

对象=名词（属性，特征）+动词（行为，方法）
如果我们可以用相同的属性或者行为来
描述2个或多个不同的对象，
那么这多个对象一定有共同之处

类就是不同现实生活中对象的共同的属性以及方法
然后我们将这些共同的属性以及方法抽取出来==》类
！！类就是对象的模板
我们可以通过类来创建出程序中的对象用new关键字
！！对象就是类产生出的实例

编程思路：
先找出现实世界对象的共同特征==>类==>创建程序中对象

类也是引用类型,它可以包含不同的其它数据类型
我们简单可以认为它就是一个包含了多个
不同小(也可以是组合)的类型的大的组合类型

类的属性都开在堆中
方法中的基本类型在栈中

类中就是有属性+方法
方法的命名遵循驼峰命名法并且首字母是英文

//变量名全小写
//方法的命名遵循驼峰命名法并且首字母是英文
//类名首字母大写

对象内存结构分析
只有方法中的8种基本类型在栈中
如果是类的属性，都在堆中
类中的方法是存在方法区
JVM：java虚拟机加载顺序是先属性后方法
一个对象中如果包含其他对象
那么其实只是持有其他对象的引用
我们不要用长生命周期的对象
去持有短生命周期对象的引用

不可达

### 第十次课（方法与封装）
面向对象编程【OOP】（Object Oriented Programming）

对象属性(特征，名词)

对象的行为（方法，动词）
思考以下几种行为：

说话

打印数组

领薪水

买东西

有参，无参，有返回，无返回

方法的语法：
public 返回类型(int,String，void...) 方法名称(类型(int,String..) 形参1,类型 形参2..){
}
对象.方法（实参。。。）

方法原型：
public 返回类型 方法名称(参数列表){

}

方法就相当于一个黑匣子
它的好处：(针对调用者)
1.维护方便
2.简化操作
3.隐藏细节

参数就是当我调用方法时需要给予的支持
类中的方法
1.无参无返回
2.有参无返回
3.无参有返回
			=====>一定要有return
4,有参有返回

定义方法的时候的参数叫形参
调用方法的传入的参数叫实参
可变参数

方法调用传参数时传的是里面的值
但是这个值可能是一个内存地址

java中只有值传递没有引用传递

如果在同一个类中调用方法，直接给方法名字
如果在不同类中调用方法，需要先new出对象
再用对象.方法()

形参类型与返回类型都可以是引用数据类型（例如：Person,Random。。。）

被private修饰的属性以及方法
都只能被本类访问
所以为了保障数据的安全
我们会将类中的属性定义为私有的
然后为每个属性都提供一对get/set方法
来为属性赋值以及取值

面向对象的三大特征
1.封装
2.继承
3.多态

封装其实包含2层含义
1.就是将一些小的数据类型
合并成一个大的数据类型（类）
产生出一个全新的类型
2.将类中的属性私有
然后提供公开的方法去访问属性
封装属性数据的安全性
### 第十一次课（对象数组构造重载）
上次课程回顾：
java4种类型的方法（参数与返回值）
被private修饰的属性以及方法
都只能被本类访问
所以为了保障数据的安全
我们会将类中的属性定义为私有的
然后为每个属性都提供一对get/set方法
来为属性赋值以及取值

自定义的类首字母大写
属性全小写，方法是骆驼命名法

面向对象的三大特征
1.封装
2.继承
3.多态

封装其实包含2层含义
1.就是将一些小的数据类型
合并成一个大的数据类型（类）
产生出一个全新的类
2.将类中的属性私有
然后提供公开的方法去访问属性
封装属性数据的安全性

本次课知识点：（对象数组，构造方法，重载，this关键字）
对象数组：
数组中的每一个元素其实保存的是对象的地址
我们构建对象数组能够简化对于多个对象的操作

构造方法是对象new的时候自动调用的方法
如果你不写，那么类中本身就会
自带一个无参的构造方法
我们在外面需要灵活的创建对象（new出）
所以会提供多个不同参数的构造方法
他们就形成了构造方法的重载

重载是麻烦了自己方便了调用者
它们能够提供调用的灵活性

重载与返回类型无关！！！
重载只与方法名和参数有关
方法名一定要相同
匹配时是强匹配（注意！！）
对于参数重载的形式有以下几种：
1.参数的个数不一样
2.参数的类型不一样
3.参数的顺序不一样(绝对不推荐)

请不要将功能完全不同的方法进行重载！！！！

this指代的是当前对象
this是个变化的引用
因为在外面我们可以直接
拿对象的引用
但是在类的里面我们可以用this来代替

this有2中用法
1.this.属性或者this.方法()
2.this()表示调用构造方法
可以用它形成构造链
但是这个代码只能写在构造方法中
并且只能在第一行

this内存分析

### 第十二次课（作业讲解与递归）
方法调用与栈空间

当调用某个方法时会在栈区为每个方法分配空间
每个方法都会以栈帧的形式压入栈中，
即每个方法从进入到退出都对应着一个栈帧的压栈和出栈

示例见图：
main--> method1--> method2--> method3

递归就是方法自己调用自己

案例：求阶乘

递归回溯：
在递归的过程中达到不成立的情况下，往回走一步再重新尝试

案例：八皇后问题

### 第十三次课（static与块）
构造（默认，new 对象的时候）
重载（方法名相同，参数列表【个数，类型，顺序】）
重载是强匹配
this.属性【方法】
this();构造中第一行形成构造链

本次课知识点：(static，块)

static只占用一份内存空间
它与对象无关
它其实是属于类的东西
当类被加载到虚拟机里面的时候会先为它分配空间
static修饰的属性或者方法一定早于我们的对象
它可以通过类名直接访问
也可以通过对象访问

它存在的问题
1.因为它是类级别，所有static的方法中
不能包含非static的引用
2.它修饰的是所有对象共享的，无法区别
每个对象的特有属性

static的特点
1.static修饰的属性及方法能被非static调用
2.static修饰的属性及方法不能调用非static

设计模式
关于单例模式（单实例）
A：懒汉式(安全性低，性能高)
B：饿汉式(安全性高，性能低)
C：静态内部类(安全性与性能都不错)

1.构造私有
2.提供一个public static 返回类型是类本身的一个方法
3.在外面直接用类名调用该方法获得对象

块执行的时间点是在构造之前，类似属性分配空间
静态块是在块之前，类似静态属性分配空间，一样只与类有关

jvm加载类的原则是
先静后动
先属性或者块后方法

### 第十四次课（内部类）
上次课知识点回顾：(static，块)

static只占用一份内存空间
它与对象无关
它其实是属于类的东西
当类被加载到虚拟机里面的时候就已经
会为它分配空间
static修饰的属性或者方法一定
出生早于我们的对象
它可以通过类名直接访问
也可以通过对象访问

设计模式
关于单例模式（单实例）
A：懒汉式(安全性低，性能高)
B：饿汉式(安全性高，性能低)

1.构造私有
2.提供一个public static 返回类型是类本身的一个方法
3.在外面直接用类名调用该方法获得对象

它存在的问题
1.因为它是类级别，所有static的方法中
不能包含非static的引用
2.它修饰的是所有对象共享的，无法区别
每个对象的特有属性

static的特点
1.static修饰的属性及方法能被非static调用
2.static修饰的属性及方法不能调用非static

局部块
普通块执行的时间点是在构造之前
静态块是在块之前，一样只与类有关

jvm加载类的原则是
先静后动
先属性后方法

特例演示：

属性,方法，构造，块

本次课知识点：（内部类）

外（1）====内（多）

内部类（常规，局部，静态，【匿名】）
内部类就是在一个类的里面再定义了一个类,作为外面这个类的一个大的属性看待
内部类必须依托外部内的实例

外部类.内部类 变量 = 外部类的实例.new 内部类();

内部类可以直接使用外部类的属性和方法(因为本身就是外部类的一部分)
外部类如果要访问内部类的属性和方法，首先要获得内部类的一个实例
所以我们通常的做法是在外部类的里面定义一个获得内部类实例的方法
当我们要访问内部类时，直接先调用方法获得内部类的实例再调用内部类的方法
外面要访问内部类都会通过外部类的方法做中介

常规内部类
Student$Book.class
局部内部类
Student$1A.class
非静态内部类里面不能写静态方法

C：静态内部类(安全性与性能都不错，但相对复杂)

理论了解：
类的生命周期：
加载-验证-准备-解析-初始化-使用-卸载
验证：验证代码完整与规范性
准备：为类变量分配内存并设置默认值
解析：将符号引用转成直接引用
初始化：执行类的构造器
编译器搜集静态块和类变量的赋值语句按语句源码的顺序合并生成

### 第十五次课（继承）
构造(无参),重载（类型，个数，顺序）
static,块，单例模式（饿汉，懒汉，静态内部类）
普通块,静态块
内部类的分类

继承：

语法：
子类 extends 父类

子类可以直接拿到父类的公有的(除了构造)
但是父类不能拿子类的
继承的单方向
一个类只允许有一个父类
继承也是单继承
单根性

任意的一个类都会默认继承Object类

父类中公开的方法或者属性子类都可以
无条件拿到（继承到）

父类(parentClass)也叫超类(superClass)也叫基类(baseClass)
子类(subClass)也叫派生类(deriveClass)

如果两个类存在is（是）的关系
那么就两个类就允许存在继承关系
父类中放的是共有的特征或者行为
子类中放的是独有的特征或者行为

继承的好处：
1.少写一些共有的代码
2.提供另外一种形式的分类
3.代码重用

使用面向对象的思想写一个猫类
有属性颜色，品种(brand)，年龄，方法吃，睡，抓老鼠
写一个狗类
有属性颜色，品种，年龄，方法吃，睡，看门lookDoor
(Animal)
catchMouse

不在一个类中的方法也有可能形成方法的重载
因为存在继承关系

问题：
1.要区别子类与父类的同名方法或者属性

super在子类中显示调用父类的属性或方法
super.属性可以显示调用父类属性
super.方法可以显示调用父类方法
但是请切记！！
super不是父类的地址（引用）
它仅仅是一个关键字

2.如果存在继承关系，那么不在一个类中的方法也能形成重载

3.关于构造一定是先调用父类的构造再调用子类的
super()表示调用父类的构造
它也只能放在子类构造方法的第一行

this是一个当前对象的地址（引用）
this.属性
this.方法()
this()调用自己本类的构造

请注意：
对于继承关系的构造方法
一定是先调用父类的再调用子类的

内存结构
this是谁当前对象

静=动
属性=方法
父=子

### 第十六次课（重写与多态）
继承：子类 extends 父类
super与this
继承内存解析
子类对象可以找到父类对象
调用子类的方法和属性先会找自己的，
如果没有再去父类对象中找

因为父类的类型比子类大，而且数据类型兼容
那么可以用父类的引用指向子类的实例
父类 a = new 子类（）；
a.方法（）这个方法只能是父类的
因为引用决定了能访问到什么
而对象决定了执行谁的

Computer
{ private CPU cpu;
  private Disk disk;
  ...
  ... 
  public void aa(){
	cpu.aaa();
	disk.bbb();
  }

}

A a = new A();
B b = new B();
Parent    -Child1,-Child3-Child3
Parent p = new Parent();
         = new Child1();
	 = new Child2();
	 = new Child3();

方法的重写（覆盖）
子类可以重写父类的方法
父 引用 = new 子（）；
引用.父类的方法（）；
调用时如果该方法被重写，那么调用的是子类的

1.要有继承
2.要有方法重写(覆盖)
3.父类的引用决定访问什么
4.子类的实例决定调用谁

养宠物实例

多态调用的顺序是
this.show(o),super.show(o),
this.show(super(o)),super.show(super(o))

instanceof 表示判断是否是某个对象的
实例，它用在显示类型转换之前做判断

从方法重写到多态

如果我需要达到多态的条件
必须要具备以下几点
1：必须要有继承
2：必须要在子类中覆盖父类的方法
3：必须要让父类的引用指向子类的对象

当达到以上三点
那么：
1：父类的引用点出的一定是父类的方法
我们说引用决定了能够点出什么
这里仅仅处在编译期
2：对象决定最终调谁的方法
我们说对象决定执行什么
这里处在运行期（这是个动态绑定的过程）

加载-验证-准备-解析-初始化-使用-卸载
invokeStatic:静态的
invokeSpecial:构造,私有，父类的
====>符号引用转成直接引用
invokeVirtual:静态分发（重载叫静态多态，编译期确定方法）
              动态分发（重写叫动态多态，运行期确定方法）

方法的名称+方法的参数合成方法的宗量
invokeInterface

直接引用包含：静态的,构造,私有，父类的
符号引用：可能被别人修改的

方法重写（覆盖）一定子类的方法
要和父类一样，子类可以有一个地方与父类
不同，就是访问修饰符。
子类一定要比父类高或者一样！！

Overload   Override
重载与重写区别在哪里？
1：重载可以存在在同一个类，也可以存在
在不同的父子类中，但是重写一定是子类重写
父类的方法
2：重载只与参数有关（个数，类型，顺序）
但是重写要完全一样，除了子类可以比父类
有更高的修饰符，异常低于父类
3：重载可以重载构造，重写不行

多态有什么好处？
1：提高代码的灵活性
2：可以重用以及扩展

设计时如何重用代码？
应该尽量设计父子类关系
将共有的放到父类，子类放自己独有的

OCP:Open Close开闭原则

如何扩展已有代码？
先继承，在重写的时候用super调父类
public void a(){1....}
子类重写
public void a(){super.a();System.out.....}

如何改写已有代码？
先继承，再重写该方法
public void a(){1....}
子类重写
public void a(){System.out.....}

static,this,super,instanceof

### 第十八次课（包修饰符final）
package 打包
是为了解决类名重名的问题
语法：package 包名.子包名;
一定放在这个文件的最上面

import 导入包
是为了使用别的包中的类
语法：import 包名.子包名.类名;
要放在package与class之间

对于一个类，包名加类名=类的全限定名
如果导入的是.*,不包含该包下子包中的类
只包含下面直接的类。另外.*默认不匹配类名

访问修饰符
private   它修饰的属性，方法都只能在本类中访问
public    它修饰的是所有类都可以访问
缺省      它修饰的只能在本包中访问
protected 它修饰的只能在本包以及子类中访问

		本类 同包的其它类 不同包父子类	 任意哪里的类

private		 √	 ×	     ×	             ×
缺省		 √	 √	     ×	             ×
protected	 √	 √	     √(子类)	     ×
public		 √	 √	     √	             √


============================================
有时候我们不希望别人重写我们的代码怎么操作？

final:最终
被它修饰的方法不能被重写
被它修饰的属性就是一个常量
被它修饰的类是不能被继承的

在方法中被final修饰的基本类型会开在常量池中
被final修饰的引用只是内存地址不能
改变，但是所指向空间的内容可以改变

封装，继承，多态，构造，块，重载，重写
static，final，this，super，包，修饰符

枚举介绍
enum一种特殊的类型，就是一种简化方式

枚举在底层会转换成
public class Color {
   private Color(){}
   public static final  Color RED = new Color();
   public static final  Color GREEN = new Color();
   public static final  Color YELLOW = new Color();
   public void test(){
	System.out.println("haha");
   }
}

values:所有项
ordinal：每项的编号
name：每项的名称

构造默认私有，可以带参数,能使用switch比较

枚举的单例写法：强力推荐

### 第十九次课（抽象类与接口）
回顾上节课知识点
package
import
class{
	private，默认，protected，public
}
final（属性【常量】，方法【重写】，类【继承】）
枚举

有时候我们希望别人一定要
重写我们的代码怎么操作？

如果一个类中有方法需要子类被形成多态
父类中也不需要关注该方法的实现
那么我们可以将该方法修饰为abstract的
但是同时该类也应该被修饰为abstract的
它的子类必须强制重写该方法
否则其子类也应该是一个抽象类

抽象方法不能修饰为private，final，static
因为子类无法重写或者与对象无关
抽象方法目的就是为了形成多态
而上面的修饰符无法让方法形成多态

抽象类其实就是在给子类定义规范
它不能直接创建出实例，但是可以通过
new子类来调用它的构造

抽象类和普通类没有什么区别
不同之处在于
1：抽象类不能产生实例
2：它中间可以有抽象方法

思考：调用了构造方法是否就是创建了对象？
结论：不是,new 子类不会实例化父类，但是会初始化父类的属性
Child c = new Child()
Parent p = new Child();
Parent p = new Parent();
思考：有人说子类其实是继承了
      所有父类的东西但是只是无法访问
      你怎么理解？
结论：父类的构造不能被继承，但是私有的可以被继承，不能被访问
抽象方法只是不能被private访问修饰符修饰

语法：public interface 接口名

接口表示的其实是一种能力
对象是对现实世界物体的抽象
类是对对象的抽象
接口是对类的行为的抽象

一个类中只有属性与get/set方法与无参的构造
并且实现了序列化接口，那么这个类
我们称之为POJO

如果一个类要实现这些功能
语法是 public class 类名 extends 父类 implements 接口名1,接口名2...

接口与抽象类的区别：
1：抽象类是类所以只能单继承，而接口（interface）可以多实现
2：抽象类继承用extends，而接口用implements
3：抽象类可以有构造，接口不能
4：抽象类可以有一般的属性，接口中的属性只能是静态常量
5：抽象类中可以有抽象方法，也可以有一般的方法，而接口中只能有抽象方法
6：抽象类中抽象方法可以被除private以外的修饰符修饰，但是接口中只能是public

常量一定是全大写

如果一个类实现了多个接口，那么就要将
所有接口中的方法全部实现，
但是相同方法只有一个
实现后可以存在方法的重载

接口与接口之间用extends
接口与类之间用implements
类与类之间用extends

接口一般来说有三种：
1：常量接口
2：一般的功能接口
3：标识接口

基本上接口以后为了解耦合
我们以后尽量让方法的参数以及返回值都是一个接口
另外在一个类中的成员变量最好也能定义为接口

class A{
  Fliable f;
 public void test(Fliable a){
	
  }
}

class Computer{			interface USB
  USB usb;
}

### 第二十次课（工厂模式）
JAVA有23种设计模式

单例，原型，建造者，工厂
创建型(4种)====工厂模式(工厂方法[特例],抽象工厂)
行为型
结构型

开闭原则：
单一职责原则：
一个类只负责一项职责
动物呼吸空气（不是所有=》陆生+水生）
里氏替换原则：用父类的地方可以换成子类（重写？）
依赖倒转原则：set，构造，接口
接口隔离原则：最小接口
迪米特法则：一个类中最少出现其它类（属性，返回，参数等）

使用创建型来替代直接new对象的代码
A a = new A();

为了让使用者与创建者分开

一个类中定义的属性最好是接口或者抽象类

class Human{   class Book implements Readable{}
     Readable b;
}  

为什么需要工厂模式？
当我们使用new创建对象的时候，多思考一下
是否可以采用工厂模式创建对象
封装对象构建的复杂性

简单工厂(适合基本固定的一些子类)
创建一个职业（Occupation-Master，Soldier）

工厂方法
创建一个职业（Occupation-Master，Soldier）
就是将简单工厂的实例化代码推迟到子类中去创建

抽象工厂：

		产品簇		产品簇
		华为		小米
产品等级	手机		手机

产品等级	路由器		路由器  

产品（手机【开关打电话发消息】与路由器【开关打开wifi设置】）接口
实现类（4中）
产品工厂接口（生产产品接口）
工厂实现类（华为与小米工厂）

### 第二十一次课（异常）
异常
bug:臭虫

对于程序中的问题总共有三种
1.编译期异常（以后自己解决）
2.运行期异常（也是会发生最多的）
3.逻辑异常(自定义异常)（最难解决）

异常是有可能出现问题的代码

语法是：try{
	有可能出现问题的代码
	}catch(异常的类型 异常信息所封装成的对象){
	处理异常的代码	
	}finally{
	最后会被执行的代码
	}

对于异常我们应当将其作为一个流程的跳转
我们在catch中一般来说会用
e.printStackTrace()来查看异常类型
以及异常发生的位置
e.getMessage() 只是简单显示异常的信息
System.out.print()
System.err.print()

异常语法糖

finally块是无论有无异常都会被执行的代码
但是有几个特例会不执行
比如System.exit(0)程序安全退出
比如发生天灾人祸

异常的体系结构是
Throwable
   |			|
  Error	(错误)		Exception(异常)
			|			|
			RuntimeException	一般异常(是程序必须要求捕获的)

RuntimeException的子类中用的多的
NullPointerException
ArithmeticException
ArrayIndexOutOfBoundsException
NumberFormatException
ClassCastException

当以后大家遇见异常的时候
1.深呼吸，感谢上天给了我一次学习的机会
2.先自己查看API文档，找到异常的类型以及异常的位置
3.解决不了可以调用我这个方法
但请给我2个参数（异常的类型，行数）

异常处理可以嵌套
```java
 try{
	try{
	
	}catch(Exception  e){
		
	}
 
 }catch(Exception e){
	//...
	try{
	
	}catch(Exception e){
	
	}
 }finally{
	//...
	try{
	
	}catch(Exception e){
	
	}
 }
```
用try{}catch(){}来处理异常的好处是：
1.保证程序能够完整的执行完毕
2.保证程序健壮性

### 第二十二次课（自定义异常与装饰者模式）

异常的体系结构是
Throwable
   |			|
  Error	(错误)		Exception(异常)
			|			|
			RuntimeException	一般异常(是程序必须要求捕获的)

RuntimeException的子类中用的多的
NullPointerException
ArithmeticException
ArrayIndexOutOfBoundsException
NumberFormatException
ClassCastException


异常语法糖
try(){
}catch(){
}

throws：将方法中的异常抛出
目的是将后台的错误信息抛向
前台(客户)，使调用者明确知道
错误信息

方法原型
修饰符 返回类型 方法名(形参列表) throws 异常类型

对于方法覆盖（重写）
方法原型只有2个地方可以不同
1.子类应该有不低于父类的修饰符
2.子类的异常类型（一般异常）应该不高于父类
=================自定义异常=========================

throw(引发异常)
自定义异常其实就是直接去继承Exception
然后写两个构造方法就OK了
记得要去调用父类的构造

throw表示手动引发一个异常
这个异常也需要在方法中捕获
如果不捕获则一样需要将其用throws抛出

装饰者模式：
在不改动原类的情况下动态的添加或者删除一些功能
1.需要扩展一个类的功能或添加附加职能，并且可以动态撤销
2.需要增加一些功能，排列组合方式多变
3.不能采用生成子类的方法进行扩充
	Food		
			condiment extends Food
			构造(Food f){}
	 面              肉，蛋，葱

### 第二十三次课（装饰者模式）
问题：
异常catch块类型能不能放Object？

JDK1.8关于接口的特殊用法
JDK1.8关于异常的语法糖try--with--resource

装饰者模式：(Wrapper)包裹
在不改动原类的情况下动态的添加或者删除一些功能
1.需要扩展一个类的功能或添加附加职能，并且可以动态撤销
2.需要增加一些功能，排列组合方式多变
3.不能采用生成子类的方法进行扩充
	Food		
			condiment extends Food
			构造(Food f){}
	 面              肉，蛋，葱

## API

### 第一次课（String）
API:Application Programming Interface

应用程序接口(一堆函数与类的集合)

java.lang(语言包，最基础的包)
java.util(集合框架，帮助类)
java.io(文件操作的包)【input output】
javax.swing
			==》(java的图形化界面)
java.awt
java.sql(用来连接数据库的包)
java.net(用来对网络进行操作的)
等等

lang包的类是不需要导入的
import java.lang.*;导入lang包下直接的类
如果要导入子包下的类则要
import java.lang.reflect.*;

String类有不变性
==比较的是对象的内存地址
String在编译期如果能确定，那么就在池中直接操作
equals比较的是对象存的内容(仅限于String中)

字符串的本质就是字符数组
{'a','b','c'}

其他API见代码
intern：获得池中原始的字符串
valueOf:是将其它类型转换为String
compareTo:比较字符串大小（返回ascii差值，相同返回长度差）
equals:比较字符串的内容
charAt:获得索引位置的字符
substring:截取字符串
toUpperCase:转换成全大写
toLowerCase:转换成全小写
toCharArray:转换成字符数组
replace:字符串替换
indexOf:获得给定字符串的索引
endsWith:判断以什么结尾
startsWith:判断以什么开始
getBytes:将字符串转成字节数组

### 第二次课（Stringbuffer与正则表达式）
String在常量池
String不变性
==和equals
indexOf，subString，length，charAt，replace
toCharArray，getBytes，intern，compareTo
split，endWith，startWith，equals，trim
equalsIgnoreCase，toUpperCase，toLowerCase

StringBuffer:String缓冲
他开在堆中，本身就是可变的
它的性能高于String
它里面封装了一部分方法专门用来做
增:append,insert
删:deleteCharAt,delete
改:setCharAt，replace
查:indexOf,lastIndexOf...
获得容量：capacity()  (old+1)*2来扩容
获得长度：length()

StringBuilder它的性能高于StringBuffer
安全性比StringBuffer要低
它的方法与StringBuffer一样

StringTokenized：字符串拆分对象

一款软件对用户的输入进行校验是必须的，请看下面的案例：

//请判断注册的账号是否合法
//合法的要求是必须字母开头，长度固定6位
[a-zA-Z].{5}

//请大家判断注册的手机号是否合法13,15,17,18开头
1[3578]\\d{9}

//现在我开发了一套自动车牌检查系统
//因为车流量非常大，所以凡是长沙
//的车并且是偶数的车就可以过桥，
//否则系统都要报警

//注册账号，首字母必须是中文，后面只能是字母+数字，长度不能超过6位

正则表达式
什么是正则表达式？
作用是什么？就是用来匹配字符串
string.matches(reg)

语法：

[-]:表示给定一个范围，匹配该范围中的一个字符
[^]:表示取反
(||)：表示分组

{min,max}：表示给定前面字符出现的个数
+:表示1-N：表示给定前面字符出现的个数
*:表示0-N：表示给定前面字符出现的个数
?:表示的0-1：表示给定前面字符出现的个数

\d:表示[0-9]
\w:表示[0-9a-zA-Z]
\s:表示匹配一个空格或TAB键或者回车换行
\D:不是数字
\W:同上
\S:同上
.：表示任意一个字符
中文字符：\u4e00-\u9fa5

正则表达式类
Pattern
Matcher（find，matches，group）

### 第三次课（包装类SystemMath）
上次作业分析：
IP地址的长度为32位，分为4段，每段8位，
用十进制数字表示，每段数字范围为0~255，
段与段之间用英文句点“.”隔开。
例如：某台计算机IP地址为10.11.44.100。

分析IP地址的组成特点：250-255、200-249、0-199。 
这三种情况可以分开考虑， 
1. 250-255：特点：三位数，百位是2，十位是5，个位是0~5，用正则表达式可以写成：25[0-5] 
2. 200-249：特点：三位数，百位是2，十位是0~4，个位是0~9，用正则表达式可以写成：2[0-4]\d 
3. 0-199：这个可以继续分拆，这样写起来更加简单明了. 
	

  3.1. 0-9：    特点：一位数，个位是0~9，用正则表达式可以写成：\d 
  3.2. 10-99：  特点：二位数，十位是1~9，个位是0~9，用正则表达式可以写成：[1-9]\d 
  3.3. 100-199：特点：三位数，百位是1，十位是0~9，个位是0~9，用正则表达式可以写成：1\d{2} 

于是0-99的正则表达式可以合写为[1-9]?\d，那么0-199用正则表达式就可以写成(1\d{2})|([1-9]?\d)，这样0~255的正则表达式就可以写成(25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d))) 
最后，前面3段加上句点.可以使用{3}重复得到，第4段再来一次同样的匹配，得到IP地址的正则表达式：

正则表达式类
Pattern
Matcher（find，matches，group）
matches:功能等同于String的matches方法
注意下面的方法与正则表达式的开始符^与结束符$有关
find：表示开始寻找
group：提取分组的内容（必须要先开始find）

基本类型				包装类
int					Integer
byte					Byte
short					Short
long					Long
double					Double
float					Float
char					Character
boolean					Boolean

String ====> 基本类型    包装类.parseXXX()
基本类型 ====> String    +""|String.valueOf()
基本类型 ====> 包装类	   包装类.valueOf()
包装类  ======>基本类型   包装类.XXXValue()非静态
String ====>包装类	    包装类.valueOf()
包装类=====>String       包装类.toString()| 包装类.valueOf()
Character中有一堆的is开头的方法专门来判断字符的性质

基本类型与包装类
1：一个是对象，父类是Object，开在堆里
   一个是基本类型，开在栈里

2：对象的默认值是null,基本类如int默认为0

3：包装类有属性有方法，基本类型没有


关于double类型的问题处理
使用java.math.BigDecimal处理加减乘除

Math
1.round（+0.5向下取整）,ceil,floor
2.常量
3.数学操作都可以使用它(pow,sqrt)

Object类
原型模式（prototype模式）
1：它是一切类的父类
2：它里面的方法可以被子类重写
3：equals比较的是引用，toString是对象的显示方法
  hashCode是获得对象的身份证，clone方法可以复制一个对象
  finalize是垃圾回收机制时会自动由JVM调用的

final，finally，finalize的区别

JNI===》Java Native Interface（了解，属于高级操作）
1.使用native修饰方法
2.javac 编译成.class
3.javah -jni class名字====>.h头文件
4.建立c的工程，引入头文件，在c中进行实现
5.将实现的c编译成动态链接库.dll
6.将.dll放入我们jdk的目录下
7.代码中要使用静态块加载该动态链接库

  System
  1.获得当前毫秒数currentTimeMillis（做性能测试）
  2.通知虚拟机回收垃圾System.gc();
  3.安全退出System.exit(0);
  4.数组的拷贝System.arraycopy

  Runtime
  1.exec可以动态执行dos命令
  2.关于性能内存的查看
### 第四次课（lang包克隆与JNI概念）
 Object类
JNI技术===》Java Native Interface
1.在java中建立一个类，编写native修饰的方法
2.将生成的.class文件使用（注意路径要定位在bin目录）
javah -jni 包名.类名编译成.h的C中的头文件
3.将jdk/include/jni.h与jdk/include/win32/jawt_md.h(jni_md.h)
拷贝到c安装目录下的include中
4.将第二步生成的.h的头文件拷贝到c工程源代码的同级目录
5.建立C的动态链接库工程,建立cpp源代码
6.在源代码中引入3个头文件
#include <stdio.h>（C自带的）
#include "com_guigu_MyJni.h"（第二步生成的）
#include "jni.h"（jni技术必须导入）
7.将头文件中的方法原型在C中实现
8.编译c生成dll文件
9.在java工程或者jdk安装目录中引入该dll
10.在类中使用静态块加载库文件（注意名字）
11.直接java正常调用

1：它是一切类的父类
2：它里面的方法可以被子类重写
3：equals比较的是引用，toString是对象的显示方法
  hashCode是获得对象的身份证，clone方法可以复制一个对象
  finalize是垃圾回收机制时会自动由JVM调用的

final，finally，finalize的区别

 A==B===>B==A
 A.equals(B)=！==>B.equals(A)

原型模式（prototype模式）===深度与浅度

### 第五次课（list集合）
util包:帮助包
最重要的是集合：强化的数组类型，可变的数组。
集合的体系结构:
```
     Collection(I)
          
    List(I)                Set(I)                Map
```
ArrayList（数组结构）	  HashSet		HashMap
LinkedList（双链表结构）  TreeSet		HashTable==>Properties
Vector（安全的）==>Stack
 向量---->   

List存储的数据是可重复有索引
Set存储的数据是不可重复无索引

集合中存储对象存的是对象的地址
泛型:它的好处在于存储时可以自动检查存入类型的合法性
取出时可以自动转型成对应的类型
ArrayList增长方式是   *3/2+1
ArrayList	 :add()追加数据（对象）
		 :get(索引)返回指定索引的对象
		 :size()返回集合的长度
		 :addAll()是表示将指定集合中的数据追加到原集合目标位置
		 :clear()清除集合中的元素
		 :contains()是否包含该元素用的equals比较，是用外面的比较里面的每一项
		 :containsAll()比较的是集合中的值,是否包含子集合中的内容(与contains一样)
		 :retainAll()交集
		 :remove(index)移除指定索引的对象
		 :removeAll(集合)移除指定集合中的对象
		 :trimToSize()调整当前的容量为实际size的大小
		 :subList截取子集合
		 :set修改指定位置的值

删除或者留下都是使用equals来进行比较
如果equals为true，那么就属于符合条件的
而且以谁为主导调方法，就是以谁里面的元素调equals方法

linkedlist:是双向链表结构
vector：安全的
stack：是vector的儿子

vector与arraylist
增量：vector默认是10个长度，增量为2倍，可以给定增量
arraylist增量是*3/2+1，不能给增量

它们三者的区别：
arraylist是可变数组结构，那么插入速度慢，查询快
linkedlist则是插入快，查询慢
vecoter什么都慢，但是严格保障安全性
	 
如果要对list中的对象进行排序
那么我们就要自己写一个排序的规则类
这个类要实现Comparator
然后在排序的时候应用这个规则类

Collections:集合的帮助类
Arrays：数组的帮助类

### 第六次课（Collections与Arrays和日期）
list排序

Collections是集合的帮助类，它里面有一堆的静态方法
比如排序，反转,求最大等等
如果要对一个集合中的对象进行排序，需要自己定义排序规则
的类实现Comparator接口，在compare[int]方法中写规则
Collections.sort(集合，规则类[Comparator])

如果要对list中的对象进行排序
那么我们就要自己写一个排序的规则类
这个类要实现Comparator
然后在排序的时候应用这个规则类

匿名内部类：就是隐藏实现类的名字的类
操作的本质就是直接new抽象类和接口
直接在new的地方重写抽象方法
具体语法详见课堂代码

Arrays是数组的帮助类，与Collections类似

千年虫的问题
Date与Calendar的使用
Date：日期类（很多方法已经过时）
Calendar:日历类（功能强于日期类）

SimpleDateFormat:日期格式类
将日期转换成我需要的格式
applyPattern：应用格式
format:格式化日期变成字符串
parse：解析字符串变成日期

StringTokenized,Random,Scanner的使用

UUID的概念

国际化处理的原理
native2ascii用来将汉字转换成unicode编码
一：Locale（国家语言类）
二：ResourceBundle（资源绑定类）
baseName_language_country.properties
三：MessageFormat（消息格式化类）

### 第七次课（Set与迭代器模式）
		Collection
List				Set			Map(键值对结构)
ArrayList			HashSet			HashMap
LinkedList			TreeSet
Vector--Stack

List是有序可重复
Set是无序不可重复

set集合是不允许添加进重复数据
要遍历set集合需要用Iterator迭代器或者foreach迭代

迭代器模式：(行为型)
作用：存取与访问分离，访问无须了解容器内部结构
迭代器模式就是分离了集合对象的遍历行为，抽象出一个迭代器类来负责，
这样既可以做到不暴露集合的内部结构，又可让外部代码透明地访问集合内部的数据。
把在元素之间游走的责任交给迭代器，而不是聚合对象。

使用场景：	1、访问一个聚合对象的内容而无须暴露它的内部表示。
		2、需要为聚合对象提供多种遍历方式。 
		3、为遍历不同的聚合结构提供一个统一的接口。

Iterator的处理机制

hashcode只是决定是否需要用equals来比较
真正决定对象是否相等的方法仍然是equals
Set集合添加元素判断是否相等，是用新加入的
与原集合中的元素进行对比

HashSet与TreeSet
TreeSet:subSet,tailSet,headSet 
ceiling,floor,highter,lower
参数传入后计算的是ascii码值
数据存入后本身会自动排序

Timer与TimeTask类
t.schedule(TimeTask,long,long)
t.cancel()

### 第八次课（Map）
Map是键值对结构(Key-Value)
key是不能重复的。它迭代出来是一个set集合
value是可以重复的.它迭代出来是一个Collection集合
values==值
keySet==键
entrySet==行

我们通常会用entrySet方式迭代，它迭代的是行类型
它的效率是最高的。

Map如果key相同，它是后面的值覆盖前面的

HashMap与Hashtable区别：
1.Map可以存null，table不可以
2.Map比Table的存储速度更快，但是没有Table安全
3.Table中的contains方法在Map中已经取消

properties是hashtable的儿子
将来会专门用来与属性文件打交道

了解HashMap的内部结构
key的hashCode来分数组，每个数组又是一个树状结构
所以hashMap的查询速度是最快的

思考题：
如何去掉一个list集合中的重复元素？
Map结构的单例模式

### 第九次课（文件对象与流）
io:input-output输入输出
流:流动的是字节
输入与输出我们以当前程序作为参照物

File类
在java中，不管是文件还是文件夹都是叫做File对象

exists判断所关联的文件是否存在
isDirectory判断是否是目录
isFile判断是否是文件
isHidden判断是否是隐藏文件
createNewFile方法是创建一个文件
mkdir(s)方法是创建一个文件夹
delete删除所关联的文件
deleteOnExit

equals在File类中是比较的文件路径相同为true，不同为false
getAbsolutePath获得文件的绝对路径
getName获得文件名
getParent是获得文件的上一次父目录的名字
getParentFile是获得文件的上一次父目录的对象

lastModified获得文件的最后修改时间
length获得文件长度以字节为单位
renameTo是重命名（在当前盘符）

list是获得文件夹下面的所有文件的名字列表
listFile是获得文件夹下面的所有文件的对象列表
listRoots获得当前系统的盘符

扫描某个文件夹

FileOutputStream:文件操作输出字节流
构造时如果给true，表示追加，默认是false，表示覆盖

FileInputStream:文件操作输入字节流
一般会定义一个缓冲区
注意：read(b)返回值是本次读取的有效字节
所以：一定记得接收其返回值n

### 第十次课（对象数据打印）
回顾：
File对象与流的概念

了解：关于文件过滤器的使用

T extends P implements A,Serializable

POJO:私有属性，get/set,无参构造，实现序列化

ObjectInputStream(要序列化的对象必须实现Serializable接口)
是将内存中的对象序列化，
然后可以保存到文件中或者通过网络传输
static的不能被序列化，因为它不属于对象
transient修饰的也不能被序列化
如果一个类的继承体系结构（包含实现的接口）有已经实现或继承了
序列化接口的，那么该类自动也能被序列化

与单例的关系（枚举可以避免反序列化产生多个实例）

DataInputStream是数据操作流，
会根据数据的长度写入文件，以字节为单位

关于字符编码：
一、ASCII 码
127个内容:ascii码
二、非 ASCII 编码
法国256，俄国256（130）
中国（2个字节）gb2312,gbk,gb18030
三. Unicode
ISO组织Unicode编码
65535*17
四、Unicode 的问题
比如，汉字严的 Unicode 是十六进制数4E25，
转换成二进制数足足有15位（100111000100101）
UTF：Unicode Transfer Format
		11100100 10111000  10100101
五、UTF-8

0000 0000-0000 007F | 0xxxxxxx
0000 0080-0000 07FF | 110xxxxx 10xxxxxx
0000 0800-0000 FFFF | 1110xxxx 10xxxxxx 10xxxxxx
0001 0000-0010 FFFF | 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
	
UTF-16，UTF-32

随机访问文件（RandomAccessFile）
seek

PrintStream打印输出流

流：分为输入输出（以当前程序）
File，Object，Data，print
FileInputStream（字节流）

### 第十一次课（内存缓冲字符）
缓冲IO与直接IO

缓存IO又被称为标准的I/O，
大多数文件系统的默认I/O操作都是缓存IO。
在Linux的缓存I/O机制中，
数据先从磁盘复制到内核空间的缓冲区，
然后再从内核空间的缓冲区复制到应用程序的地址空间。

直接I/O就是应用程序直接访问磁盘数据，
而不经过内核缓冲区，即绕过内存缓冲区，
自己管理I/O缓存区，
这样做的目的就是为了减少一次内核缓冲区到用户程序缓存的数据拷贝。

直接I/O的缺点：如果访问的数据不在内核的缓存中，
那么每次数据都会直接从磁盘进行加载，
这种磁盘加载是非常慢的。
通常直接I/O和异步I/O结合使用会得到更好的性能。

PIO与DMA机制
programming input output model
Direct Memory Access（存储器直接内存访问）
PIO模式下硬盘和内存之间的数据传输是由CPU来控制的
而在DMA模式下，CPU只须向DMA控制器下达指令，
让DMA控制器来处理数据的传送，
数据传送完毕再把信息反馈给CPU，
这样就很大程度上减轻了CPU资源占有率。
DMA模式与PIO模式的区别就在于，
DMA模式不过分依赖CPU，可以大大节省系统资源，
二者在传输速度上的差异并不十分明显。

流：分为输入输出（以当前程序）
File，Object，Data，print
FileInputStream（字节流）

磁盘IO的开销大
加buffer后能减少磁盘的IO开销

缓冲字节流(8192)
BufferedInputStream的基本用法和FileInputStream是差不多的
但是BufferedInputStream会减少磁盘IO的开销
它的性能高于FileInputStream
以后用到InputStream时尽量用BufferedInputStream包装一次

字符流
FileReader与FileWriter
缓冲字符流
BufferedReader

转换流
InputStreamReader或
OutputStreamWriter是将字节流
转换成字符流

内存流：
ByteArrayOutputStream：默认开了一块32字节的空间

a.mp3			b.mp3
□□□□□□□□□		□□□□□□□□
	    □□□□□□□□□

根据流的功能：
FileInputStream
BufferedInputStream
ObjectInputStream
DataInputStream
ByteArrayInputStream
InputStreamReader

根据流的方向：输入，输出

根据流的类型：字节流，字符流（操作文本文件）
所有以Stream结尾的都是字节流
所有以Reader或者Writer结尾的都是字符流

	输入		 输出

字节	InputStream	 OutputStream

转换 InputStreamReader  OutputStreamWriter

字符	Reader		 Writer

缓冲    Buffered（InputStream）
	Buffered（OutputStream）
	Buffered（Reader）
	Buffered（Writer）

ByteArrayOutputStream：内存流
主要是做适配器用，
它是唯一可以关掉后继续操作不会发生异常的流

Properties可以加载流获得数据（map结构）
### 第十二次课（流知识遗补与总结）
根据流的功能：
FileInputStream
BufferedInputStream
ObjectInputStream
DataInputStream
ByteArrayInputStream
InputStreamReader

根据流的方向：输入，输出

根据流的类型：字节流，字符流（操作文本文件）
所有以Stream结尾的都是字节流
所有以Reader或者Writer结尾的都是字符流

	输入		 输出

字节	InputStream	 OutputStream

转换 InputStreamReader  OutputStreamWriter

字符	Reader		 Writer

缓冲    Buffered（InputStream）
	Buffered（OutputStream）
	Buffered（Reader）
	Buffered（Writer）

ByteArrayOutputStream：内存流
主要是做适配器用，
它是唯一可以关掉后继续操作不会发生异常的流

序列流
SequenceInputStream
集合类属性对象与流
Properties==>load(配置文件)
运行时对象与流
输出Runtime运行结果

JDK1.7异常语法糖介绍
try(申明对象的对象会在执行完之后自动关闭或者断开){
}catch(Exception ex){
}

根据情况高级补充：
JDK1.8新特性lambda表达式配合Stream()新语法

### 第十三次课（界面开发入门）
swing:java的图形化界面编程
需要使用到的包(最重要的)：
1.java.awt.*;Frame Color
2.javax.swing.*;JFrame
3.java.awt.event.*;

JFrame是表示窗体，它里面默认有一个内容面板
我们将来往里面加东西都是加到面板上
frame==rootpane---layeredpane---contentpane---glasspane

layeredpane：default，palette，modal，popup，drag

j2se==界面，j2ee==网页，j2me==android
富客户端程序
javaFX
C/S:Client客户端--服务端Server(桌面程序)
运行速度快，安全性高，维护扩展不方便
B/S:Browser浏览器--服务端Server(web程序)

C/S====B/S

x+y==>Point
w+h==>dimension
x+y+w+h==>Rectangle

在swing开发中，当一个方法的参数为int的时候
基本上是一个常量

component	container	Jcomponent

重量级的组件体系
java.awt.Component
      继承者 java.awt.Container
          继承者 java.awt.Window
              继承者 java.awt.Frame
                  继承者 javax.swing.JFrame

轻量级的组件体系
java.awt.Component
      继承者 java.awt.Container
          继承者 javax.swing.JComponent
              继承者 javax.swing.JPanel

容器组件
JPanel（相当于桌布，是个中间容器）
Image:图片
Icon：相框
ImageIcon：照片框

背景图：
一般我们会重写面板的paintComponent方法来实现自己的一些需求
如果面板与窗体的paint方法都重写，那么窗体为主

1.重写窗体的paint方法
2.自定义个面板，重写面板的paintComponent，将该面板设置为内容面板
3.弄个一个JLabel，设置它的图片，大小与窗体一致

JOptionPanel(专门用来弹出对话框)
showMessageDialog
showConfirmDialog
showInputDialog(很少)

JDialog（模式窗体）
基本操作与JFrame一样，但是可以设置为模式
没有EXIT_ON_CLOSE操作

Component===组件
Container容器   与非容器
Container==	Window，JComponent
Window==Frame，Dialog
JComponent===JPanel

### 第十四次课（界面布局一）
容器组件
JPanel（相当于桌布，是个中间容器）
一般我们会重写面板的paintComponent方法来实现自己的一些需求
如果面板与窗体的paint方法都重写，那么窗体为主

JOptionPanel(专门用来弹出对话框)
showMessageDialog
showConfirmDialog
showInputDialog(很少)

JDialog（模式窗体）
基本操作与JFrame一样，但是可以设置为模式
没有EXIT_ON_CLOSE操作

Component===组件
Container容器   与非容器
Container==	Window，JComponent
Window==Frame，Dialog
JComponent===JPanel

通常使用比较多的
1。流式布局（FlowLayout）
2。边界布局（BorderLayout）
3。网格布局（GridLayout）行列
4。空布局  setBounds(x,y,w,h);
5。卡片布局(CardLayout)
6。网袋布局

卡片布局给各位自己了解

窗体原有的内容面板默认是边界布局
边界布局如果往里面放东西，默认放在中间
它就是根据NEWSC的方向放置组件
它一般可以用来构建相对复杂点的布局
边界布局的作用主要是定位大的方向

面板默认是流式布局
流式布局默认对齐方式是中间对齐
流式布局最适合用在并列排列的组件情况上

网格布局以行数为标准，如果不够列数不够，
那么不会向边界布局一样覆盖，而是会自动调整
列数

空布局根据坐标定位  setBounds(x,y,w,h);
设置大小使用setSize

### 第十五次课（界面布局二）
界面如果有布局，应该使用setPreferSize设置
设置大小setSize会无效，针对空布局可以使用，

网袋布局
GridBagLayout
GridBagConstraints(约束)

网袋布局中的每个单元格都要与一个约束相联系
所有的摆放都与GridBagConstraints的11个属性有关

1:gridx属性表示单元格横坐标的索引
2:gridy属性表示单元格纵坐标的索引
3:gridwidth属性表示该组件在X轴上占用几个单元格
4:gridheight属性表示该组件在Y轴上占用几个单元格
REMAINDER:表示占用剩下的格子
5:fill属性表示是当格子比组件大时，我们组件填充格子的方式
（不填,水平,垂直,全部）

权重
6:weightx属性表示当容器改变时，格子在X轴上所拉伸的百分比
7:weighty属性表示当容器改变时，格子在Y轴上所拉伸的百分比
	ps:请注意：5,6,7三个属性一般都是同时使用
	6,7只与格子拉伸有关，而5是与组件怎么填充格子有关
8:anchor属性表示当格子比组件大时，组件放在格子的那个方位
9:insets属性表示该组件距离相邻组件的外间距（上左下右）
10:ipadx属性表示X轴的内间距
11:ipady属性表示Y轴的内间距

this.pack();
自适应大小

使用观察者模式实现按钮点击事件响应
按钮点击事件有三种方式区别
1：为每个按钮添加一个监听者
2：为每个按钮添加一个动作的命令ActionCommand
注册同一个监听者，在监听者中获得ActionCommand
来区分使用
3：为每个按钮添加一个监听者，在监听者中获得
事件源，转成你需要的组件对象，进行处理区分

### 第十六次课（基本组件与窗体刷新）
基本组件：
1.JLabel====文本标签
2.JButton===按钮
3.JTextField===文本框
4.JPasswordField====密码框
5.JCheckbox====复选框
6.JRadioButton==单选框===ButtonGroup
7.JComboBox====下拉框
8.JTextArea===文本域
//9.JFileChooser===文件上传
10.JScrollPane===滚动面板

界面原型
9行3列
	用户注册（0）
姓名：文本框	（0,1）
密码：密码框
性别：男  女（0,3）
爱好：游泳 唱歌 
      跳舞 上网
籍贯：下拉
个人简介：文本域
提交   重置

Frame的pack是自动适应所有组件的大小

使用观察者模式实现按钮点击事件响应
事件源：触发者（被观察者）
监听器：监听者（观察者）
处理行为（方法与事件对象）

按钮点击事件有三种方式区别
1：为每个按钮添加一个监听者（匿名内部类）
2：为每个按钮添加一个动作的命令ActionCommand
注册同一个监听者，在监听者中获得ActionCommand
来区分使用
3：为每个按钮添加同一个监听者，在监听者中获得
事件源，转成你需要的组件对象，进行处理区分

事件：
ActionListener==按钮被点击事件
1.要为按钮注册一个监听器(addActionListener(I))
2.写一个类实现ActionListener接口（可以是自己）
3.重写ActionListener里面的actionPerformed方法

工具类UIManager与ToolKit
Robot机器人用来控制鼠标与键盘和截屏
### 第十七次课（事件处理一）
java.awt.*;
javax.swing.*;
java.awt.event.*
一.事件类型
a:按钮点击事件
btn.addActionListener(new ActionListener(){});

b:键盘事件
KeyListener(键盘按下，释放，类型)
要监听到事件，前提是先获得焦点

c:窗体事件
WindowListener(窗体的打开，激活，钝化，正在关闭，已经关闭，最小化，还原)
WindowStateListener(状态改变)
WindowFocusListener(获得焦点，丢失焦点)
SystemTray工具类
TrayIcon表示系统托盘图标

关于系统字体与软件字体

==========================================

d:鼠标事件(
MouseListener(点击，进入，退出，按下，释放)
MouseMotionListener(拖拽，移动)
MouseWheelListener(滚动)
)

e:获得焦点事件
FoucusListener

f:选项改变事件
ItemListener

g:状态改变事件
ChangeListener

二、适配器模式（Adapter）		
	A		B		C
1 2 3 4 5 6 7	   1 2 3 4 5	      1 2 3
适配器A implements A，B
适配器B implements C，B
适配器C implements A，B，C
适配器C有两个子类分别是适配器A与适配器B
我们的监听者需要使用接口，但是要实现的方法太多
我们更多的时候会使用适配器

三、观察者模式
事件源[被观察者]------------注册---------------监听者(观察者)
jb.addActionListener(new ActionListener(){});

### 第十八次课（事件处理二）
1.事件类型
a:按钮点击事件

适配器模式（Adapter）
		
	A		B		C
1 2 3 4 5 6 7	   1 2 3 4 5	      1 2 3

b:鼠标事件(
MouseListener(点击，进入，退出，按下，释放)
MouseMotionListener(拖拽，移动)
MouseWheelListener(滚动)
)
c:键盘事件
KeyListener(键盘按下，释放，类型)
要监听到事件，前提是先获得焦点

d:窗体事件
WindowListener(窗体的打开，激活，钝化，正在关闭，已经关闭，最小化，还原)
WindowStateListener(状态改变)
WindowFocusListener(获得焦点，丢失焦点)

e:获得焦点事件
FoucusListener
获得焦点，丢失焦点

f:选项改变事件(只针对下拉框)
ItemListener

g:状态改变事件(按钮的启用与禁用后触发)
ChangeListener

我们的监听者需要使用接口，但是要实现的方法太多
我们更多的时候会使用适配器

事件源------------注册---------------监听者
jb.addActionListener(new ActionListener(){});

二、SystemTray工具类
TrayIcon表示系统托盘图标

三、工具类UIManager与ToolKit
Robot机器人用来控制鼠标与键盘和截屏

四、观察者模式

### 第十九次课（菜单上下文工具栏）
容器：JFrame，JPanel,JOptionPane,JDialog
布局：BorderLayout，FlowLayOut，GridLayOut
      GridBagLayOut，空布局，CardLayout，BoxLayout
组件：JTextField，JTextArea（JScrollPane），JButton
JLabel，JPassword，JRadioButton（ButtonGroup）
JComboBox，JCheckBox
ImageIcon
事件：窗体，鼠标，键盘，焦点，下拉，点击
工具：Robot，ToolKit，UIManager，SystemTray
TrayIcon，Color，Font

课程内容：	

菜单条JMenuBar,
菜单JMenu,
菜单项JMenuItem,JCheckBoxMenuItem,JRadioButtonMenuItem
文件选择框JFileChooser
完成记事本程序的布局与部分功能
窗体最小化与还原功能
上下文菜单JPopupMenu（环境）
工具条JToolBar

简单组合键：设置快捷键（助记符），自己注册快捷键键盘事件
	
=================================================	
后期需要补充知识：	JTabbedPane（选项卡）
			JProgressBar（进度条）
			JSplitPane(分割面板)
			JList（列表）
			JTree（树）
			JTable（表格）

### 第二十次课（快捷键注册）

容器：JFrame，JPanel,JOptionPane,JDialog
布局：BorderLayout，FlowLayOut，GridLayOut
      GridBagLayOut，空布局，CardLayout，BoxLayout
组件：JTextField，JTextArea（JScrollPane），JButton
JLabel，JPassword，JRadioButton（ButtonGroup）
JComboBox，JCheckBox
ImageIcon
事件：窗体，鼠标，键盘，焦点，下拉，点击
工具：Robot，ToolKit，UIManager，SystemTray
TrayIcon，Color，Font

课程内容：	

菜单条JMenuBar,
菜单JMenu,
菜单项JMenuItem,JCheckBoxMenuItem,JRadioButtonMenuItem
文件选择框JFileChooser
完成记事本程序的布局与部分功能
窗体最小化与还原功能
上下文菜单JPopupMenu（环境）
工具条JToolBar

简单组合键：
1：设置快捷键（助记符）
2：菜单项独有的设置快捷键方式
setAccelerator(KeyStroke(KeyEvent，InputEvent))
3：任意组件设置快捷键
	a:自己注册快捷键键盘事件
	b:使用getInputMap与getActionMap配合

后期需要补充知识：	JTabbedPane（选项卡）
			JProgressBar（进度条）
			JSplitPane(分割面板)
			JList（列表）
			JTree（树）
			JTable（表格）

###  三十一 日志与单元测试
java.lang
java.util
java.io
java.sql
java.awt
javax.swing
java.text(SimpleDateFormat)


日志记录的作用
1：日志记录是作为交付软件的一部分功能
2：便于帮助开发者查阅并定位信息
3：便于保存在不同终端设备
4：便于开发者互相沟通（CSDN，javaeye）
5：使用日志做备份还原
log4j的级别概念（了解）
debug,info,warn,error,fatal
log4j的配置方式与使用（掌握）

log4j.rootLogger=全局配置
log4j.logger.com.guigu.dao=局部配置
log4j.appender.别名.Threshold=单独指定某个终端的级别

===============================================
黑盒与白盒
程序调试的方式
1.断点调试(watch,inspect,变量窗口,单步运行,追踪运行)
2.断言调试
a:什么是断言，怎么使用



程序测试的概念(桩模块)α版本（内测版） β版本（公测版）
1.有些什么测试？
a:单元测试(方法，单个功能)
b:模块测试(模块功能)
c:集成测试(多模块组合功能)
d:系统测试(性能，压力，安全)
上线

2.单元测试JUNIT怎么使用
junit3测试类名必须继承TestCase，开始方法必须重写setUp
结束方法必须重写tearDown，测试方法必须以test开头
junit4不要继承TestCase，开始方法使用@Before
结束方法采用@After，测试方法采用@Test注解
单元测试中一般使用断言来测试



3.junit与main测试的区别
a:一个方法一个测试与多个方法一起测试
b:测试代码与开发逻辑代码混淆
c:scanner只能使用main测试



###  三十二 加密
关于java加密
1.所谓加密就是让信息数据更安全
明文===》进行转换
基本思路就是给原数据变成字节然后增加或者删除一定ascii值
替换 
比如：     hello world 
  3  秘钥  khoor zruog 
转换
       hello
       idnjr  
秘钥：[1,-1,2,-2,3] 数组 byte[]

加密的几个概念
明文 + 密钥 = 密文


2.简单加密方式(其本质就是做替换)
a:BASE64Encoder（一般来做图片或者音[视]频字节与字符串转换）
b:URLEncoder（一般给网络传输内容做转换）


Provider[] pp = Security.getProviders();
获得安全验证提供者
Security.addProvider(new com.sun.crypto.provider.SunJCE());
如果没有自带，则手动添加验证提供者为sun

3.复杂加密方式
javax.crypto包与java.security包
a:单向加密（如：MD5，SHA）结果不可逆，保存指纹做对比
	MessageDigest类==》更新摘要(update)==》生成字节数组(digest)
	加盐
	加密次数

在哪里可以知道加密算法的名字？
Security.getAlgorithms（"服务名【例如MessageDigest，Cipher等】"）
b:双向加密
  b1：对称加密【秘钥加密】（使用一个密码加密解密）
  （如：DES,DESede,AES）
	KeyGenerator:秘钥生成器（用来指定秘钥方式）
	SecretKey:秘钥（由秘钥生成器生成[包含字节数组]）
	Cipher:生成转换器（要初始化(init)指定模式后doFinal最终生成）
		
	各种不同获得密钥的写法：
	SecretKeySpec sk = new SecretKeySpec("111111111".getBytes(), "DES");
		
	DESKeySpec dks = new DESKeySpec("11111111".getBytes());
	SecretKey sk = SecretKeyFactory.getInstance("DES").generateSecret(dks);

  b2：非对称加密（使用公钥私钥加密解密）
		（RSA）
		KeyPairGenerator：秘钥对生成器
		要初始化秘钥长度
		KeyPair:秘钥对（由秘钥对生成器生成[包含公私钥]）

4:关于mysql中自带的加密
a:ENCODE
b:AES_DECRYPT
c:ENCRYPT（linux或Unix系统）调系统底层加密

### 三十三 线程入门
装修公司只有我一个人==>10个徒弟（子线程）
张三修暖气
李四修灯泡

招聘2个兄弟
装修公司有3个人

装修公司===进程
每一个人===线程

多线程同时干活
假设公司里面有一把锤子
资源属于我们进程
资源可能会在线程中发生冲突

张三先用==》用完通知李四用==》通知我来用
线程的同步


开分公司===》子进程
主公司与分公司的资源基本不共享

进程之间可以进行通讯

工商局（cpu）进行注册登记


1：什么是线程==进程是由多个线程组成
能够同时进行并发操作
2：线程的状态
main是我们的主线程
t就是main的子线程
setDaemon：设置为精灵线程，守护线程，后台线程
setPriority：设置线程的优先级


线程的状态☆☆☆☆☆
new出来的时候，我们就做线程新生
.start(),线程的状态变为就绪
被cpu选中，运行状态的时候调用的才是run方法
当run方法执行完毕，死亡状态
当sleep时，我们视为阻塞状态

interrupt是标志线程的状态从没有中断改为中断状态


让类继承Thread或者实现Runnable
继承Thread本身就是一个线程类
实现Runnable只是表示该类可以被线程操作

线程的操作
见代码

线程的同步
对于每个对象身上都有一把锁
它的状态不是1就是0
锁旗标
要让线程同步，只需要将多个线程拥有同一个锁旗标
synchronized

0和1是同步的this ，2和3同步的是this



线程的死锁
互相拿着对方的锁旗标，但是需要对方解锁

### 三十四 线程二

看图了解状态

线程状态JDK版（官方版）：state
总共6种状态:NEW,RUNNABLE,BLOCKED,WAITING,TIMED_WAITING,TERMINATED

yield与jion的区别
yield是当前线程抢到CPU，就让出CPU，重新抢
jion将交错运行的线程变成顺序执行的线程，
加入的线程执行完之后，再回头执行原来的线程
interrupt：通知线程改成中断状态
首先，一个线程不应该由其他线程来强制中断或停止，
而是应该由线程自己自行停止
Thread.stop, Thread.suspend, Thread.resume 
都已经被废弃了
1.阻塞状态下直接抛出异常
2.运行状态下修改标志继续运行


（JVM运行时数据区包含以下5个部分）
虚拟机的线程私有区间：
堆，方法区是属于线程共享区间
栈，本地方法栈，程序计数器属于线程独有的

volatile的作用
当一个线程修改变量的时候，是修改自己线程中的变量副本
其它线程对于该变量的修改是不可见的，voletile修饰的
变量属于全局内存共享，可以实时让其它线程可见

线程组：ThreadGroup
默认新建线程组属于创建它的线程所属的线程组
就是为了统一方便管理

锁：Lock----》ReentrantLock 的使用

ReentrantLock与synchronized区别
synchronized：非公平，悲观，独享，互斥，可重入
ReentrantLock：非公平（可改），悲观，独享，互斥，可重入
可中断等待：trylock

synchronized对于多条件上锁需要多次上锁（嵌套）
ReentrantLock对于多条件只要调用newCondition方法

synchronized对于并发不高的情况下性能优于ReentrantLock
并发高的情况下低于ReentrantLock

公平/非公平：拿锁与申请顺序
悲观/乐观：写，读
独享/共享：是否多个线程共有（广义）
互斥/读写：狭义
可重入：是否需要再次申请锁

### 三十五 消费者，生产者与线程池

线程的同步

Object对象有2个方法，
当被对象wait()时，进入锁池状态
一个是wait()
一个是notify()
suspend()与wait()的区别
suspend是线程的方法，实将当前线程挂起并且不会放对象的锁
wait()是对象的方法，但是实际是在操作改对象身上的线程，它调用后会放对象的锁
resume()与notify()的区别


课堂案例：有2个线程，1个从1-->26,1个从A-Z
输出的效果是:1A2B3C....





 线程间通讯(wait,notify)
 产品最多积压10个，当数量达到10，我们就不能
 生成，要等着消费
 产品没有货为0个，我们就不能消费，要等着生产
  生产者与消费者模式
  生产者类 可被线程操作
  消费者类 可被线程操作
  产品类






粒度更细
锁：Lock----》ReentrantLock 的使用

ReentrantLock与synchronized区别
synchronized：非公平，悲观，独享，互斥，可重入
ReentrantLock：非公平（可改），悲观，独享，互斥，可重入
可中断等待：trylock

synchronized对于多条件上锁需要多次上锁（嵌套）
ReentrantLock对于多条件只要调用newCondition方法

synchronized对于并发不高的情况下性能优于ReentrantLock
并发高的情况下低于ReentrantLock


公平/非公平：拿锁与申请顺序
悲观/乐观：写，读
独享/共享：是否多个线程共有（广义）
互斥/读写：狭义
可重入：是否需要再次申请锁




什么是线程池，有什么作用？
Java通过Executors提供四种线程池，分别为：
newCachedThreadPool创建一个可缓存线程池，如果线程池长度超过处理需要，可灵活回收空闲线程，若无可回收，则新建线程。
newFixedThreadPool 创建一个定长线程池，可控制线程最大并发数，超出的线程会在队列中等待。
newScheduledThreadPool 创建一个定长线程池，支持定时及周期性任务执行。
newSingleThreadExecutor 创建一个单线程化的线程池，它只会用唯一的工作线程来执行任务，保证所有任务按照指定顺序(FIFO, LIFO, 优先级)执行。


创建一个可缓存线程池，如果线程池长度超过处理需要，可灵活回收空闲线程，若无可回收，则新建线程。
ExecutorService cachedThreadPool = Executors.newCachedThreadPool();  
  for (int i = 0; i < 10; i++) {  
   final int index = i;  
   try {  
    Thread.sleep(index * 1000);  
   } catch (InterruptedException e) {  
    e.printStackTrace();  
   }  
   cachedThreadPool.execute(new Runnable() {  
    public void run() {  
     System.out.println(index);  
    }  
   });  
  }  
线程池为无限大，当执行第二个任务时第一个任务已经完成，会复用执行第一个任务的线程，而不用每次新建线程。




创建一个定长线程池，可控制线程最大并发数，超出的线程会在队列中等待。
  ExecutorService fixedThreadPool = Executors.newFixedThreadPool(3);  
  for (int i = 0; i < 10; i++) {  
   final int index = i;  
   fixedThreadPool.execute(new Runnable() {  
    public void run() {  
     try {  
      System.out.println(index);  
      Thread.sleep(2000);  
     } catch (InterruptedException e) {  
      e.printStackTrace();  
     }  
    }  
   });  
  }  
  因为线程池大小为3，每个任务输出index后sleep 2秒，所以每两秒打印3个数字。
定长线程池的大小最好根据系统资源进行设置。如Runtime.getRuntime().availableProcessors()



创建一个定长线程池，支持定时及周期性任务执行。
ScheduledExecutorService scheduledThreadPool = Executors.newScheduledThreadPool(5);  
  scheduledThreadPool.schedule(new Runnable() {  
   public void run() {  
    System.out.println("delay 3 seconds");  
   }  
  }, 3, TimeUnit.SECONDS);  

  表示延迟3秒执行

   ScheduledExecutorService scheduledThreadPool = Executors.newScheduledThreadPool(5);  
  scheduledThreadPool.scheduleAtFixedRate(new Runnable() {  
   public void run() {  
    System.out.println("delay 1 seconds, and excute every 3 seconds");  
   }  
  }, 1, 3, TimeUnit.SECONDS);  

  表示延迟1秒后每3秒执行一次



  创建一个单线程化的线程池，它只会用唯一的工作线程来执行任务，保证所有任务按照指定顺序(FIFO, LIFO, 优先级)执行
  ExecutorService singleThreadExecutor = Executors.newSingleThreadExecutor();  
  for (int i = 0; i < 10; i++) {  
   final int index = i;  
   singleThreadExecutor.execute(new Runnable() {  
    public void run() {  
     try {  
      System.out.println(index);  
      Thread.sleep(2000);  
     } catch (InterruptedException e) {  
      e.printStackTrace();  
     }  
    }  
   });  
  }  

  结果依次输出，相当于顺序执行各个任务



ForkJoinPool pool = new ForkJoinPool();
RecursiveTask：有返回：fork后要join
返回值为Future

RecursiveAction：无返回：只有fork，但是
主线程需要等待
awaitTermination

### 三十六 网路入门

java.net网络包
java=RMI技术  Remote Method Invoke
DB《===程序A《====微信（支付宝）

http（https） ftp pop3 smtp 
协议就是双方定下的一个规矩

OSI模型（开放系统互连参考模型）：Open System Interconnect
应用==》表示==》会话==》传输==》网络==》数据链路==》物理

1.A发报价单给B（应用层提供的服务）老板(用户)
2.翻译加密（表示层）秘书
3.管理多家公司联系方式
找到B地址与联系电话，
放进信封，确认是否收到（会话层）外联部
4.快递收发（传输层）
5.各个快递点之间传送（网络层）
6.快递点检查的人（数据链路）检查是否送错，有无破损，是否误时
7.使用的交通工具

tcp/ip模型：
分为4层
应用==================》传输==》网络===》数据链路


OSI > TCP/IP

传输层协议:
tcp协议：有连接的协议（慢，安全）=打电话
udp协议：无连接（快，不安全）===发短信  丢包
单播：
多播：(组播：广播)


InetAddress=======网络层=======ip地址
URL===============应用层
URLConnection=====应用层
Socket============传输层====tcp协议（有连接）
ServerSocket======传输层
DatagramPacket====传输层====udp协议（无连接）
DatagramSocket====传输层


IPV4：4个字节===32位   255.5.6.8   256*256*256*256
IPV6：16个字节
本机的IP地址可以用
127.0.0.1代替
本机的主机名可以用
localhost代替
端口号：0-65535
jdbc:mysql://localhost:3306/student


InetAddress就是用来获得机器ip或者是名字的对象
IP分为5类
A:0-126
B:127-191
C:192-223
D:224-239
E:240-255


http://www.baidu.com其实就是对应一个IP地址
域名===》IP地址（DNS）域名解析服务
也就是对应了网络中的一台主机

http://www.baidu.com:80/welcomeTobaidu.html
1312062421@qq.com


https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png
PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png

Location
URL:统一资源定位符,用来在互联网上定位一个具体的资源
组成：协议://域名:端口/资源(文件)
URI：统一资源标识符(资源标识) identified
URN：统一资源名称(资源名字)
URI：（URL,URN）
787866012@qq.com

url的openStream方法获得网络输入流
我们通常应该使用url.openConnection()
获得URLConnection对象
再调用URLConnection对象的getInputStream方法

关于编码类：URLEncode与URLDecode

Nutch（分布搜索），Solr（分布索引）
Lunece（全文检索）（建立索引），JSoup（分析）
SEO优化
漏洞，黑客（90%是通过爬虫技术与DNS拦截得到）

### 三十七 Tcp通信

InetAddress：IP
URL：统一资源定位符（URI）
URLConnection：URL的连接


================================================
TCP通讯：(全双工，半双工，单工)
连接3次握手
1.c--->s:s确认c发送正常
2.s--->c:c确认自己发送接收，对方发送接收正常，s确认自己接收对方发送正常
3.c--->s:c确认自己发送接收，对方发送接收正常，s确认自己发送接收，对方发送接收正常
断开4次握手


socket：套接字
TCP协议的：运行原理就是建立连接后利用流进行通信
Socket与ServerSocket

1：客户端只发不接
2：客户端发完后接收服务器返回内容
(注意：readLine的问题,注意流关闭的问题)
3:从客户端的控制台接收信息发给服务器
服务器返回该信息的长度发回给客户端
直到输入bye就结束这次通讯
4：模拟请求服务器资源下载
7条流
a：客户端控制台接收文件名（字符输入）
b：客户端网络发送（字符输出）
c：服务器网络接收（字符输入）
d：服务器读取文件（文件字节输入）
e：服务器网络发送（字节输出）
f：客户端网络接收（字节输入）
g：客户端写入文件（文件字节输出）

http请求协议初识与应用

### 三十八 多线程通信

Socket中可以拿到客户与本机的
ip与端口，带local的是本机的

服务器使用多线程，
来一个用户就弄出一个线程去对付他
准备一个集合存放所有用户
当接收到的数据不是退出标志时
循环发给其它在线客户，否则单独
给予发送者回应

客户端也要采用多线程，
读数据与发数据要分开


C1===>S===>C2
群聊

张三	bye			bye

李四		=》 Server      bye

王五                            bye

###  三十九 upd通信

传输层协议（UDP）
udp:数据报文(包)协议
DatagramPacket====传输层					=====UDP
DatagramSocket====传输层
send（发送端），receiver（接收端）
有三种：
单播：是指只向一个固定的机器发送包
多播：
广播：发送端是向255.255.255.255发送，所有接收端监听某端口的机器都可以接收到
组播：是向一个用户组发送，该组里面所有用户可以接收到
组群必须是D类IP地址，人变为MulticastSocket

IP地址分为5类
A：0===127（不包含）  
B：127==192（不包含）  
C：192==224（不包含）  
D：224==240（不包含）
E：240==255

丢包


DatagramPacket有2个作用
1.发送的包===>要给定发送的内容以及发送的地址与端口
DatagramPacket dp = 
new DatagramPacket(byte[],0,length,InetAddress,port);
2.接收的包===>只要指定接收包的大小
DatagramPacket dp = 
new DatagramPacket(byte[],0,length);


DatagramSocket有2个作用
1.发送的人===>只需要new出来就可以了
DatagramSocket ds = new DatagramSocket();
2.接收的人===>需要指定接收的地址以及端口
DatagramSocket ds = new DatagramSocket(port,InetAddress);

最大包为65535


文件传输如果使用UDP可能会造成丢包
一般我们会首先传数据总量大小，然后再
传送数据,或者最后发送一个结束标志，通知
接收方结束

心跳包
后台线程每隔2分钟就发送一个数据包给客户
客户就给与一个答复，只要有答复，就证明用户在线
否则，都服务器就断开与客户端的连接

lang
util
io
sql
加密
text
swing
net

管理系统【业务逻辑】===swing+jdbc+集合
仿QQ【技术】===swing+jdbc+net+线程+io+集合

JList
JTable
JTree
JSplitPane
JTabbedPane
JPrograssBar



