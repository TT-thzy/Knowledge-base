# SPEL Note

## 基础

#### helloworld

```java
   public void helloWorld() {
       ExpressionParser expressionParser = new SpelExpressionParser();
       Expression expression = expressionParser.parseExpression("('Hello' + ' World').concat(#end)");
       EvaluationContext context = new StandardEvaluationContext();
       context.setVariable("end", "!");
       System.out.println(expression.getValue(context));   //Hello World!
   }
```

1）创建解析器：SpEL使用ExpressionParser接口表示解析器，提供SpelExpressionParser默认实现；
2）解析表达式：使用ExpressionParser的parseExpression来解析相应的表达式为Expression对象。
3）构造上下文：准备比如变量定义等等表达式需要的上下文数据。
4）求值：通过Expression接口的getValue方法根据上下文获得表达式值。

#### 原理

##### 核心概念：

* 表达式： 表达式是表达式语言的核心，所以表达式语言都是围绕表达式进行的，从我们角度来看是“干什么”；
* 解析器： 用于将字符串表达式解析为表达式对象，从我们角度来看是“谁来干”；
* 上下文： 表达式对象执行的环境，该环境可能定义变量、定义自定义函数、提供类型转换等等，从我们角度看是“在哪干”；
* 根对象及活动上下文对象： 根对象是默认的活动上下文对象，活动上下文对象表示了当前表达式操作的对象，从我们角度看是“对谁干”。

##### 原理：

如图：
<img src="..\..\..\picture service\spel解析流程.png"></img>

```
1.首先定义表达式：“1+2”；
2.定义解析器ExpressionParser实现，SpEL提供默认实现SpelExpressionParser；
  2.1.SpelExpressionParser解析器内部使用Tokenizer类进行词法分析，即把字符串流分析为记号流，记号在SpEL使用Token类来表示；
  2.2.有了记号流后，解析器便可根据记号流生成内部抽象语法树；在SpEL中语法树节点由SpelNode接口实现代表：如OpPlus表示加操作节点、IntLiteral表示int型字面量节点；使用SpelNodel实现组成了抽象语法树；
  2.3.对外提供Expression接口来简化表示抽象语法树，从而隐藏内部实现细节，并提供getValue简单方法用于获取表达式值；SpEL提供默认实现为SpelExpression；
3.定义表达式上下文对象（可选），SpEL使用EvaluationContext接口表示上下文对象，用于设置根对象、自定义变量、自定义函数、类型转换器等，SpEL提供默认实现StandardEvaluationContext；
4.使用表达式对象根据上下文对象（可选）求值（调用表达式对象的getValue方法）获得结果。
```

<b>ExpressionParser接口</b>:
表示解析器，默认实现是org.springframework.expression.spel.standard包中的SpelExpressionParser类，使用parseExpression方法将字符串表达式转换为Expression对象，对于ParserContext接口用于定义字符串表达式是不是模板，及模板开始与结束字符：

```java
public interface ExpressionParser {
 Expression parseExpression(String expressionString) throws ParseException;
 Expression parseExpression(String expressionString, ParserContext context) throws ParseException;
}
```

ParseContext使用实例:

```java
ExpressionParser expressionParser = new SpelExpressionParser();
        ParserContext parserContext = new ParserContext() {
            @Override
            public boolean isTemplate() {
                return true;
            }

            @Override
            public String getExpressionPrefix() {
                return "#{";
            }

            @Override
            public String getExpressionSuffix() {
                return "}";
            }
        };
        String template = "#{'Hello '}#{'World!'}";
        Expression expression = expressionParser.parseExpression(template, parserContext);
        System.out.println(expression.getValue());  //Hello World!
```

此处定义了ParserContext实现：定义表达式是模块，表达式前缀为“#{”，后缀为“}”；使用parseExpression解析时传入的模板必须以“#{”开头，以“}”结尾，如"#{'Hello '}#{'World!'}"。默认传入的字符串表达式不是模板形式，如之前演示的Hello World。

<b>EvaluationContext接口</b>
表示上下文环境，默认实现是org.springframework.expression.spel.support包中的StandardEvaluationContext类，使用setRootObject方法来设置根对象，使用setVariable方法来注册自定义变量，使用registerFunction来注册自定义函数等等。

<b>Expression接口</b>
表示表达式对象，默认实现是org.springframework.expression.spel.standard包中的SpelExpression，提供getValue方法用于获取表达式值，提供setValue方法用于设置对象值。

## 语法

#### 基础表达式

##### 字面量表达式

SpEL支持的字面量包括：字符串、数字类型（int、long、float、double）、布尔类型、null类型。

| 类型     | 示例                                                                                                                                                                                                                                                                                                                                                                                                           |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 字符串    | String str1 = parser.parseExpression("'Hello World!'").getValue(String.class);                                                                                                                                                                                                                                                                                                                               |
| 数字类型   | int int1 = parser.parseExpression("1").getValue(Integer.class);long long1 = parser.parseExpression("-1L").getValue(long.class);float float1 = parser.parseExpression("1.1").getValue(Float.class);double double1 = parser.parseExpression("1.1E+2").getValue(double.class);int hex1 = parser.parseExpression("0xa").getValue(Integer.class);long hex2 = parser.parseExpression("0xaL").getValue(long.class); |
| 布尔类型   | boolean true1 = parser.parseExpression("true").getValue(boolean.class);boolean false1 = parser.parseExpression("false").getValue(boolean.class);                                                                                                                                                                                                                                                             |
| null类型 | Object null1 = parser.parseExpression("null").getValue(Object.class);                                                                                                                                                                                                                                                                                                                                        |

```java
ExpressionParser parser = new SpelExpressionParser();

String str1 = parser.parseExpression("'Hello World!'").getValue(String.class);
int int1 = parser.parseExpression("1").getValue(Integer.class);
long long1 = parser.parseExpression("-1L").getValue(long.class);
float float1 = parser.parseExpression("1.1").getValue(Float.class);
double double1 = parser.parseExpression("1.1E+2").getValue(double.class);
int hex1 = parser.parseExpression("0xa").getValue(Integer.class);
long hex2 = parser.parseExpression("0xaL").getValue(long.class);
boolean true1 = parser.parseExpression("true").getValue(boolean.class);
boolean false1 = parser.parseExpression("false").getValue(boolean.class);
Object null1 = parser.parseExpression("null").getValue(Object.class);

System.out.println("str1=" + str1);  //str1=Hello World!
System.out.println("int1=" + int1);  //int1=1
System.out.println("long1=" + long1);   //long1=-1
System.out.println("float1=" + float1); //float1=1.1
System.out.println("double1=" + double1);   //double1=110.0
System.out.println("hex1=" + hex1); //hex1=10
System.out.println("hex2=" + hex2); //hex2=10
System.out.println("true1=" + true1);   //true1=true
System.out.println("false1=" + false1); //false1 = false
System.out.println("null1=" + null1); //null1=null
```

##### 算数运算表达式

SpEL支持加(+)、减(-)、乘(*)、除(/)、求余（%）、幂（^）运算。

| 类型   | 示例                                                                             |
| ---- | ------------------------------------------------------------------------------ |
| 加减乘除 | int result1 = parser.parseExpression("1+2-3*4/2").getValue(Integer.class);//-3 |
| 求余   | int result2 = parser.parseExpression("4%3").getValue(Integer.class);//1        |
| 幂运算  | int result3 = parser.parseExpression("2^3").getValue(Integer.class);//8        |

SpEL还提供求余（MOD）和除（DIV）而外两个运算符，与“%”和“/”等价，不区分大小写。

```java
ExpressionParser parser = new SpelExpressionParser();

System.out.println(parser.parseExpression("1+2-3*4/2").getValue(Integer.class)); //-3
System.out.println(parser.parseExpression("4 div 2").getValue(Integer.class));  //2
System.out.println(parser.parseExpression("4%3").getValue(Integer.class));  //1
System.out.println(parser.parseExpression("4 mod 3").getValue(Integer.class)); //1
System.out.println(parser.parseExpression("2^3").getValue(Integer.class));  //8
```

##### 关系表达式

等于（==）、不等于(!=)、大于(>)、大于等于(>=)、小于(<)、小于等于(<=)，区间（between）运算。

如parser.parseExpression("1>2").getValue(boolean.class);将返回false；而parser.parseExpression("1 between {1, 2}").getValue(boolean.class);将返回true。between运算符右边操作数必须是列表类型，且只能包含2个元素。第一个元素为开始，第二个元素为结束，区间运算是包含边界值的，即 xxx>=list.get(0) && xxx<=list.get(1)。

SpEL同样提供了等价的“EQ” 、“NE”、 “GT”、“GE”、 “LT” 、“LE”来表示等于、不等于、大于、大于等于、小于、小于等于，不区分大小写。

```java
System.out.println(parser.parseExpression("1 > 2").getValue(Boolean.class)); //false
System.out.println(parser.parseExpression("2 >= 2").getValue(Boolean.class));   //true
System.out.println(parser.parseExpression("2 == 2").getValue(Boolean.class));   //true
System.out.println(parser.parseExpression("2 != 2").getValue(Boolean.class));   //false
System.out.println(parser.parseExpression("1 between {1,2}").getValue(Boolean.class));  //true
```

##### 逻辑表达式

且（and或者&&）、或(or或者||)、非(!或NOT)。

```java
System.out.println(parser.parseExpression("true || false").getValue(Boolean.class)); //true
System.out.println(parser.parseExpression("true or false").getValue(Boolean.class)); //true
System.out.println(parser.parseExpression("1>2 && 2>1").getValue(Boolean.class)); //false
System.out.println(parser.parseExpression("1>2 and 2>1").getValue(Boolean.class)); //false
System.out.println(parser.parseExpression("!(1>2 || 2>1)").getValue(Boolean.class)); //false
System.out.println(parser.parseExpression("not(1>2 || 2>1)").getValue(Boolean.class)); //false
```

##### 字符串连接及截取表达式

使用“+”进行字符串连接，使用“'String'[0] [index]”来截取一个字符，目前只支持截取一个，如“'Hello ' + 'World!'”得到“Hello World!”；而“'Hello World!'[0]”将返回“H”。

```java
System.out.println(parser.parseExpression("'hello ' + 'world!'").getValue(String.class));   //hello world!
System.out.println(parser.parseExpression("'hello world!'[0]").getValue(String.class));   //h
```

##### 三目运算

三目运算符 **“表达式1?表达式2:表达式3”**用于构造三目运算表达式，如“2>1?true:false”将返回true；

##### Elivis运算符

Elivis运算符**“表达式1?:表达式2”**从Groovy语言引入用于简化三目运算符的，当表达式1为非null时则返回表达式1，当表达式1为null时则返回表达式2，简化了三目运算符方式“表达式1? 表达式1:表达式2”，如“null?:false”将返回false，而“true?:false”将返回true；

```java
System.out.println(parser.parseExpression("1>2?'正确':'错误'").getValue(String.class));   //错误
```

##### 正则表达式

使用“str matches regex，如“'123' matches '\d{3}'”将返回true；

```java
System.out.println(parser.parseExpression("'124' matches '\\d{3}'").getValue(Boolean.class)); //true
```

##### 括号优先级表达式

使用“(表达式)”构造，括号里的具有高优先级。

##### 类相关表达式

###### 类类型表达式

使用“T(Type)”来表示java.lang.Class实例，“Type”必须是类全限定名，“java.lang”包除外，即该包下的类可以不指定包名；使用类类型表达式还可以进行访问类静态方法及类静态字段

```java
//java.lang包类访问
System.out.println(parser.parseExpression("T(String)").getValue(Class.class)); //class java.lang.String
//其他包类访问
String expression2 = "T(org.example.SPELLearning.SpelTest)";
System.out.println(parser.parseExpression(expression2).getValue(Class.class)); //class org.example.SPELLearning.SpelTest
//类静态字段访问
System.out.println(parser.parseExpression("T(Integer).MAX_VALUE").getValue(int.class) == Integer.MAX_VALUE); //true
//类静态方法调用
System.out.println(parser.parseExpression("T(Integer).parseInt('1')").getValue(int.class)); //1
```

对于java.lang包里的可以直接使用“T(String)”访问；其他包必须是类全限定名；

###### 类实例化

类实例化同样使用java关键字“new”，类名必须是全限定名，但java.lang包内的类型除外，如String、Integer。

```java
System.out.println(parser.parseExpression("new String('hello world!')").getValue(String.class).toUpperCase()); //HELLO WORLD!
System.out.println(parser.parseExpression("new java.util.Date()").getValue(Date.class)); //Thu Mar 14 11:36:47 CST 2024
```

###### instanceOf表达式

SpEL支持instanceof运算符，跟Java内使用同义；如“'haha' instanceof T(String)”将返回true。

```java
    public static Date getNowTime() {
        return new Date();
    }

    @Test
    public void instanceOfExpressionTest() {
        System.out.println(parser.parseExpression("T(org.example.SPELLearning.SpelTest).getNowTime() instanceOf T(java.util.Date)").getValue(Boolean.class));  //true
    }
```

###### 变量定义及引用

变量定义通过EvaluationContext接口的setVariable(variableName, value)方法定义；在表达式中使用"#variableName"引用；除了引用自定义变量，SpE还允许引用根对象及当前上下文对象，使用<font color="green">"#root"</font>引用根对象，使用<font color="green">"#this"</font>引用当前上下文对象；

```java
EvaluationContext context = new StandardEvaluationContext();
context.setVariable("name", "路人甲java");
context.setVariable("lesson", "Spring系列");
//获取name变量，lesson变量
System.out.println(parser.parseExpression("#name").getValue(context, String.class)); //路人甲java
System.out.println(parser.parseExpression("#lesson").getValue(context, String.class)); //Spring系列
//StandardEvaluationContext构造器传入root对象，可以通过#root来访问root对象
context = new StandardEvaluationContext("我是root对象");
System.out.println(parser.parseExpression("#root").getValue(context, String.class)); //我是root对象
//#this用来访问当前上线文中的对象
System.out.println(parser.parseExpression("#this").getValue(context, String.class)); //我是root对象
```

###### 自定义函数

目前只支持类静态方法注册为自定义函数；SpEL使用StandardEvaluationContext的registerFunction方法进行注册自定义函数，其实完全可以使用setVariable代替，两者其实本质是一样的；

```java
//定义2个函数,registerFunction和setVariable都可以，不过从语义上面来看用registerFunction更恰当
StandardEvaluationContext context = new StandardEvaluationContext();
Method parseInt = Integer.class.getDeclaredMethod("parseInt", String.class);
context.registerFunction("parseInt1", parseInt);
context.setVariable("parseInt2", parseInt);
System.out.println(parser.parseExpression("#parseInt1('3')").getValue(context, int.class)); //3
System.out.println(parser.parseExpression("#parseInt2('3')").getValue(context, int.class)); //3
String expression1 = "#parseInt1('3') == #parseInt2('3')";
System.out.println(parser.parseExpression(expression1).getValue(context, boolean.class)); //true
```

###### 表达式赋值

使用 <font color="green">Expression#setValue</font> 方法可以给表达式赋值

```java
Object user = new Object() {
    private String name;
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    @Override
    public String toString() {
        return "$classname{" +
                "name='" + name + '\'' +
                '}';
    }
};
{
    //user为root对象
    ExpressionParser parser = new SpelExpressionParser();
    EvaluationContext context = new StandardEvaluationContext(user);
    parser.parseExpression("#root.name").setValue(context, "路人甲java");
    System.out.println(parser.parseExpression("#root").getValue(context, user.getClass())); //$classname{name='路人甲java'}
}
{
    //user为变量
    ExpressionParser parser = new SpelExpressionParser();
    EvaluationContext context = new StandardEvaluationContext();
    context.setVariable("user", user);
    parser.parseExpression("#user.name").setValue(context, "路人甲java");
    System.out.println(parser.parseExpression("#user").getValue(context, user.getClass())); //$classname{name='路人甲java'}
}
```

###### 对象属性存取及安全导航表达式

对象属性获取非常简单，即使用如“a.property.property”这种点缀式获取，SpEL对于属性名首字母是不区分大小写的；SpEL还引入了Groovy语言中的安全导航运算符“(对象|属性)?.属性”，用来避免“?.”前边的表达式为null时抛出空指针异常，而是返回null；修改对象属性值则可以通过赋值表达式或Expression接口的setValue方法修改。

```java
User user = new User();
EvaluationContext context = new StandardEvaluationContext();
context.setVariable("user", user);
ExpressionParser parser = new SpelExpressionParser();
//使用.符号，访问user.car.name会报错，原因：user.car为空
try {
    System.out.println(parser.parseExpression("#user.car.model").getValue(context, String.class));
} catch (EvaluationException | ParseException e) {
    System.out.println("出错了：" + e.getMessage());  //出错了：EL1007E: Property or field 'model' cannot be found on null
}
//使用安全访问符号?.，可以规避null错误
System.out.println(parser.parseExpression("#user?.car?.model").getValue(context, String.class)); //null
Car car = new Car();
car.setModel("保时捷");
user.setCar(car);
System.out.println(parser.parseExpression("#user?.car?.toString()").getValue(context, String.class)); //Car{model='保时捷'}
```

###### 对象方法调用

对象方法调用更简单，跟Java语法一样；如“'haha'.substring(2,4)”将返回“ha”；而对于根对象可以直接调用方法；

```java
System.out.println(parser.parseExpression("'abcdefg'.substring(1,3)").getValue(String.class)); //bc
Car car = new Car();
car.setModel("劳斯莱斯");
EvaluationContext context = new StandardEvaluationContext(car);
System.out.println(parser.parseExpression("#root.toString()").getValue(context, String.class)); //Car{model='劳斯莱斯'}
System.out.println(parser.parseExpression("toString()").getValue(context, String.class)); //Car{model='劳斯莱斯'}
```

###### Bean引用

SpEL支持使用“@”符号来引用Bean，在引用Bean时需要使用BeanResolver接口实现来查找Bean，Spring提供BeanFactoryResolver实现。

```java
DefaultListableBeanFactory factory = new DefaultListableBeanFactory();
User user = new User();
Car car = new Car();
car.setModel("保时捷");
user.setCar(car);
factory.registerSingleton("user", user);
StandardEvaluationContext context = new StandardEvaluationContext();
context.setBeanResolver(new BeanFactoryResolver(factory));
ExpressionParser parser = new SpelExpressionParser();
User userBean = parser.parseExpression("@user").getValue(context, User.class);
System.out.println(userBean); //User{car=Car{model='保时捷'}}
System.out.println(userBean == factory.getBean("user")); //true
```

#### 集合相关表达式

##### 内联list

从Spring3.0.4开始支持内联List，使用{表达式，……}定义内联List，如“{1,2,3}”将返回一个整型的ArrayList，而“{}”将返回空的List，对于字面量表达式列表，SpEL会使用java.util.Collections.unmodifiableList方法将列表设置为不可修改。

```java
ExpressionParser parser = new SpelExpressionParser();
//将返回不可修改的空List
List<Integer> result2 = parser.parseExpression("{}").getValue(List.class);
//对于字面量列表也将返回不可修改的List
List<Integer> result1 = parser.parseExpression("{1,2,3}").getValue(List.class);
Assertions.assertEquals(new Integer(1), result1.get(0));
try {
    result1.set(0, 2);
} catch (Exception e) {
    e.printStackTrace();  //java.lang.UnsupportedOperationException
}
//对于列表中只要有一个不是字面量表达式，将只返回原始List，
//不会进行不可修改处理
String expression3 = "{{1+2,2+4},{3,4+4}}";
List<List<Integer>> result3 = parser.parseExpression(expression3).getValue(List.class);
result3.get(0).set(0, 1);
System.out.println(result3); //[[1, 6], [3, 8]]
//声明一维数组并初始化
int[] result4 = parser.parseExpression("new int[2]{1,2}").getValue(int[].class);
System.out.println(result4[1]); //2
//定义一维数组无初始化
int[] result5 = parser.parseExpression("new int[1]").getValue(int[].class);
System.out.println(result5[0]); //0
```

##### 集合，字典元素访问

SpEL目前支持所有集合类型和字典类型的元素访问，使用“集合[索引]”访问集合元素，使用“map[key]”访问字典元素；

```java
//SpEL内联List访问
int result1 = parser.parseExpression("{1,2,3}[0]").getValue(int.class);
System.out.println(result1);  //1
//SpEL目前支持所有集合类型的访问
Collection<Integer> collection = new HashSet<Integer>();
collection.add(1);
collection.add(2);
EvaluationContext context2 = new StandardEvaluationContext();
context2.setVariable("collection", collection);
int result2 = parser.parseExpression("#collection[1]").getValue(context2, int.class);
System.out.println(result2); //2
//SpEL对Map字典元素访问的支持
Map<String, Integer> map = new HashMap<String, Integer>();
map.put("a", 1);
EvaluationContext context3 = new StandardEvaluationContext();
context3.setVariable("map", map);
int result3 = parser.parseExpression("#map['a']").getValue(context3, int.class);
System.out.println(result3);  //1
```

##### 列表，字典，数组元素修改

可以使用赋值表达式或Expression接口的setValue方法修改；

```java
 //修改list元素值
List<Integer> list = new ArrayList<Integer>();
list.add(1);
list.add(2);
EvaluationContext context1 = new StandardEvaluationContext();
context1.setVariable("collection", list);
parser.parseExpression("#collection[1]").setValue(context1, 4);
int result1 = parser.parseExpression("#collection[1]").getValue(context1, int.class);
System.out.println(result1);  //4
//修改map元素值
Map<String, Integer> map = new HashMap<String, Integer>();
map.put("a", 1);
EvaluationContext context2 = new StandardEvaluationContext();
context2.setVariable("map", map);
parser.parseExpression("#map['a']").setValue(context2, 4);
Integer result2 = parser.parseExpression("#map['a']").getValue(context2, int.class);
System.out.println(result2);   //4
```

##### 集合投影

在SQL中投影指从表中选择出列，而在SpEL指根据集合中的元素中通过选择来构造另一个集合，该集合和原集合具有相同数量的元素；SpEL使用“（list|map）.![投影表达式]”来进行投影运算：

```java
//1.测试集合或数组
List<Integer> list = new ArrayList<Integer>();
list.add(4);
list.add(5);
EvaluationContext context1 = new StandardEvaluationContext();
context1.setVariable("list", list);
Collection<Integer> result1 = parser.parseExpression("#list.![#this+1]").getValue(context1, Collection.class);
result1.forEach(System.out::println);  // 5 6
System.out.println("------------");
//2.测试字典
Map<String, Integer> map = new HashMap<String, Integer>();
map.put("a", 1);
map.put("b", 2);
EvaluationContext context2 = new StandardEvaluationContext();
context2.setVariable("map", map);
List<Integer> result2 = parser.parseExpression("#map.![value+1]").getValue(context2, List.class);
result2.forEach(System.out::println);  //2, 3
```

对于集合或数组使用如上表达式进行投影运算，其中投影表达式中“#this”代表每个集合或数组元素，可以使用比如“#this.property”来获取集合元素的属性，其中“#this”可以省略。

Map投影最终只能得到List结果，如上所示，对于投影表达式中的“#this”将是Map.Entry，所以可以使用“value”来获取值，使用“key”来获取键。

##### 集合选择

在SQL中指使用select进行选择行数据，而在SpEL指根据原集合通过条件表达式选择出满足条件的元素并构造为新的集合，SpEL使用“(list|map).?[选择表达式]”，其中选择表达式结果必须是boolean类型，如果true则选择的元素将添加到新集合中，false将不添加到新集合中。

```java
List<Integer> list = new ArrayList<Integer>();
list.add(1);
list.add(4);
list.add(5);
list.add(7);
EvaluationContext context1 = new StandardEvaluationContext();
context1.setVariable("list", list);q
Collection<Integer> result1 = parser.parseExpression("#list.?[#this>4]").getValue(context1, Collection.class);
result1.forEach(System.out::println);  //5 7
System.out.println("--------------------");
Map<String, Integer> map = new HashMap<String, Integer>();
map.put("a", 1);
map.put("b", 2);
map.put("c", 3);
EvaluationContext context2 = new StandardEvaluationContext();
context2.setVariable("map", map);
Map<String, Integer> result2 = parser.parseExpression("#map.?[key!='a']").getValue(context2, Map.class);
result2.forEach((key, value) -> {
    System.out.println(key + ":" + value);  //b:2  c:3
});
System.out.println("------------");
List<Integer> result3 = parser.parseExpression("#map.?[key!='a'].![value+1]").getValue(context2, List.class);
result3.forEach(System.out::println);   //3  4
```

对于集合或数组选择，如“#collection.?[#this>4]”将选择出集合元素值大于4的所有元素。选择表达式必须返回布尔类型，使用“#this”表示当前元素。

对于字典选择，如“#map.?[#this.key != 'a']”将选择键值不等于”a”的，其中选择表达式中“#this”是Map.Entry类型，而最终结果还是Map，这点和投影不同；集合选择和投影可以一起使用，如“#map.?[key != 'a'].![value+1]”将首先选择键值不等于”a”的，然后在选出的Map中再进行“value+1”的投影。

#### 在bean定义中使用spel表达式

##### xml风格的配置

SpEL支持在Bean定义时注入，默认使用“#{SpEL表达式}”表示，其中“#root”根对象默认可以认为是ApplicationContext，只有ApplicationContext实现默认支持SpEL，获取根对象属性其实是获取[容器](https://cloud.tencent.com/product/tke?from_column=20065&from=20065)中的Bean。

如：

```javascript
<bean id="world" class="java.lang.String">  
    <constructor-arg value="#{' World!'}"/>  
</bean>  

<bean id="hello1" class="java.lang.String">  
    <constructor-arg value="#{'Hello'}#{world}"/>  
</bean>    

<bean id="hello2" class="java.lang.String">  
    <constructor-arg value="#{'Hello' + world}"/>
</bean>  

<bean id="hello3" class="java.lang.String">  
    <constructor-arg value="#{'Hello' + @world}"/>  
</bean>
```

模板默认以前缀“#{”开头，以后缀“}”结尾，且不允许嵌套，如“#{'Hello'#{world}}”错误，如“#{'Hello' + world}”中“world”默认解析为Bean。当然可以使用“@bean”引用了。

是不是很简单，除了XML配置方式，Spring还提供一种注解方式@Value，接着往下看吧。

##### 注解风格的配置

基于注解风格的SpEL配置也非常简单，使用@Value注解来指定SpEL表达式，该注解可以放到字段、方法及方法参数上。

测试Bean类如下，使用@Value来指定SpEL表达式：

```javascript
public class SpELBean {  
    @Value("#{'Hello' + world}")  
    private String value;  
}
```

##### 在Bean定义中SpEL的问题

如果有同学问“#{我不是SpEL表达式}”不是SpEL表达式，而是公司内部的模板，想换个前缀和后缀该如何实现呢？

我们使用BeanFactoryPostProcessor接口提供postProcessBeanFactory回调方法，它是在IoC容器创建好但还未进行任何Bean初始化时被ApplicationContext实现调用，因此在这个阶段把SpEL前缀及后缀修改掉是安全的，具体代码如下：

```javascript
package com.javacode2018.spel.test1;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanExpressionResolver;
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.context.expression.StandardBeanExpressionResolver;
import org.springframework.stereotype.Component;

@Component
public class SpelBeanFactoryPostProcessor implements BeanFactoryPostProcessor {
    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
        BeanExpressionResolver beanExpressionResolver = beanFactory.getBeanExpressionResolver();
        if (beanExpressionResolver instanceof StandardBeanExpressionResolver) {
            StandardBeanExpressionResolver resolver = (StandardBeanExpressionResolver) beanExpressionResolver;
            resolver.setExpressionPrefix("%{");
            resolver.setExpressionSuffix("}");
        }
    }
}
```

上测试代码

```javascript
package com.javacode2018.spel.test1;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class LessonModel {
    @Value("%{@name},%{@msg}")
    private String desc;

    @Override
    public String toString() {
        return "LessonModel{" +
                "desc='" + desc + '\'' +
                '}';
    }
}
```

@name：容器中name的bean

@msg：容器中msg的bean

下面我们来个配置类，顺便定义name和msg这2个bean，顺便扫描上面2个配置类

```javascript
package com.javacode2018.spel.test1;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@ComponentScan
@Configuration
public class MainConfig {
    @Bean
    public String name() {
        return "牛逼";
    }

    @Bean
    public String msg() {
        return "你好！";
    }
}
```

测试用例

```javascript
@Test
public void test12() {
    AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext();
    context.register(MainConfig.class);
    context.refresh();
    LessonModel lessonModel = context.getBean(LessonModel.class);
    System.out.println(lessonModel);
}
```

运行输出

```javascript
LessonModel{desc='牛逼, 你好！'}
```
