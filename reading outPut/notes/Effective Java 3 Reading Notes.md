# Effective Java 3 Reading Notes

## 静态工厂方法

考虑使用静态工厂方法代替构造函数
example:

```java
public static Boolean valueOf(boolean b) {
    return b ? Boolean.TRUE : Boolean.FALSE;
}
```

相对于公共的构造方法，提供一个类的静态工厂方法的优点和缺点如下
**优点**：

* **不像构造方法，它们是有名字的**。构造方法因为java语法的限制，其方法名只能为类名。而对于静态工厂方法而言就没有其限制，完全可以自定义方法名描述返回对象，是代码更利于阅读。例如，返回一个可能为素数的 BigInteger 的构造方法 BigInteger(int，int，Random) 可以更好地表示为名为BigInteger.probablePrime 的静态工厂方法。

* **与构造方法不同，它们不需要每次调用时都创建一个新对象**。在静态工厂方法内部，可以利用缓存思想，避免每次调用都创建一个对象。例如Integer.valueOf(int i)方法，其在类初始化时，就已经构建了255个对象(-128-127)与内存中，如果i命中该区间，则直接去已经初始化好的对象。

* **与构造方法不同，是返回对象的类可以根据输入参数的不同而不同**。也是因为java本身限制，调用该类的构造方法是，也只会返回该类的实例对象。而使用静态工厂方法，声明的返回类型的任何子类都是允许的。例如java.util.EnumSet#noneOf方法
  
  ```java
  public static <E extends Enum<E>> EnumSet<E> noneOf(Class<E> elementType) {
        Enum<?>[] universe = getUniverse(elementType);
        if (universe == null)
            throw new ClassCastException(elementType + " not an enum");
  
        if (universe.length <= 64)
            return new RegularEnumSet<>(elementType, universe);
        else
            return new JumboEnumSet<>(elementType, universe);
    }
  ```
  
  * **与构造方法不同，它们可以返回其返回类型的任何子类型的对象**。 这为你在选择返回对象的类时提供了很大的灵活性。这种灵活性的一个应用是 API 可以返回对象而不需要公开它的类。 以这种方式隐藏实现类会使 API 非常紧凑。这种技术适用于基于接口的框架。例如，Java 集合框架有 45 个接口的实用工具实现，提供不可修改的集合、同步集合等等。几乎所有这些实现都是通过静态工厂方法在一个非实例类 ( java .util. collections )中导出的。返回对象的类都是非公开的。

**缺点**：

* **只提供静态工厂方法的主要限制是，没有公共或受保护构造方法的类不能被子类化**。例如，在 Collections框架中不可能将任何方便实现类子类化。可以说，这可能是因祸得福，因为它鼓励程序员使用组合而不是继承。

## 当构造方法参数过多时使用 builder 模式
