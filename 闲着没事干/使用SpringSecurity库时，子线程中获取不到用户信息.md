## Question

<mark>场景</mark>：年前接到一个同步数据的需求，在同步处理逻辑中，会在同步记录中记录同步人(当前登录用户)。系统用的springSecurity做认证与授权，在调用SecurityContextHolder.getContext().getAuthentication()方法时，发现获取不到当前用户信息。
<mark>排查</mark>：为了不让用户等待，同步逻辑采用的异步处理。debug发现在主线程中可以获取到当前用户信息，可当进入异步逻辑(子线程中)就获取不到当前用户信息了。

## why

在springSecurity框架中，用户信息是存储在一个叫SecurityContext的上下文当中，而Security为操作SecurityContext对象提供了一个委托者SecurityContextHolder，通过类获取，存储SecurityContext;SecurityContextHolder提供了三种策略来存储存储SecurityContext对象。分别是

    MODE_THREADLOCAL:SecurityContext的存储通过ThreadLocal实现，这意味着只有当前线程能获取到SecurityContex;默认为该策略
    
    MODE_INHERITABLETHREADLOCAL:SecurityContext的存储通过InheritableThreadLocal实现，这就意味着除了当前线程，其子线程也能获取到SecurityContex;
    
    MODE_GLOBAL:SecurityContextHolderStrategy的基于static字段的实现。这意味着 JVM 中的所有实例共享相同的SecurityContext。

因为在本地调试,并没有改变securityContext的存储策略,使用的其默认策略MODE_THREADLOCAL,导致在异步线程(子线程)获取不到用户信息。

## source code

程序入口SecurityContextHolder.getContext()源码内容:

```java
public static SecurityContext getContext() {
        return strategy.getContext();
}
```

可以看到我们的SecurityContext对象就是通过一个全局的strategy对象获取到的；

```java
    private static SecurityContextHolderStrategy strategy;
```

主要就是看strategy对象是怎样被初始化的，首先SecurityContextHolderStrategy是一个接口，它有着三个实现类分别是ThreadLocalSecurityContextHolderStrategy、GlobalSecurityContextHolderStrategy、InheritableThreadLocalSecurityContextHolderStrategy对应上面所说的三种存储策略。在SecurityContextHolder中有一个静态代码块，在其中初始化了strategy对象，源码内容：

```java
private static void initialize() {
        if (!StringUtils.hasText(strategyName)) {  
            // Set default
            strategyName = MODE_THREADLOCAL;
        }
        if (strategyName.equals(MODE_THREADLOCAL)) {
            strategy = new ThreadLocalSecurityContextHolderStrategy();
        }
        else if (strategyName.equals(MODE_INHERITABLETHREADLOCAL)) {
            strategy = new InheritableThreadLocalSecurityContextHolderStrategy();
        }
        else if (strategyName.equals(MODE_GLOBAL)) {
            strategy = new GlobalSecurityContextHolderStrategy();
        }
        else {
            // Try to load a custom strategy
            try {
                Class<?> clazz = Class.forName(strategyName);
                Constructor<?> customStrategy = clazz.getConstructor();
                strategy = (SecurityContextHolderStrategy) customStrategy.newInstance();
            }
            catch (Exception ex) {
                ReflectionUtils.handleReflectionException(ex);
            }
        }
        initializeCount++;
  }
```

可以看到逻辑很简单，四个分支

    case1:如果strategyName为空或者strategyName为常量MODE_THREADLOCAL值，strategy为ThreadLocalSecurityContextHolderStrategy
    case2:如果strategyName为常量MODE_INHERITABLETHREADLOCAL值，strategy为InheritableThreadLocalSecurityContextHolderStrategy()
    case3:如果strategyName为常量MODE_GLOBAL值，strategy为GlobalSecurityContextHolderStrategy()
    case4:如果strategyName有值且不满足springSecurity提供的三种策略，加载用户自定义的存储策略(类名)； 扩展口子

strategyName值得获取逻辑:

```java
public static final String SYSTEM_PROPERTY = "spring.security.strategy";
private static String strategyName = System.getProperty(SYSTEM_PROPERTY);
```

ThreadLocalSecurityContextHolderStrategy源码:

```java
final class ThreadLocalSecurityContextHolderStrategy implements SecurityContextHolderStrategy {

    private static final ThreadLocal<SecurityContext> contextHolder = new ThreadLocal<>();

    @Override
    public void clearContext() {
        contextHolder.remove();
    }

    @Override
    public SecurityContext getContext() {
        SecurityContext ctx = contextHolder.get();
        if (ctx == null) {
            ctx = createEmptyContext();
            contextHolder.set(ctx);
        }
        return ctx;
    }

    @Override
    public void setContext(SecurityContext context) {
        Assert.notNull(context, "Only non-null SecurityContext instances are permitted");
        contextHolder.set(context);
    }

    @Override
    public SecurityContext createEmptyContext() {
        return new SecurityContextImpl();
    }

}
```

一种线程安全的存储策略。很简单，就是把SecurityContext放到ThreadLocal容器中进行管理，而ThreadLocal本省就是一种空间换时间的并发安全策略，它为每一个线程单独分配一个局部变量(针对该线程的生命周期)。内部就是通过一个自定义的哈希表ThreadLocalMap来实现的，该对象threadLocals是存在Thread里面的，也就是每一个Thread对象会绑定一个ThreadLocalMap。而ThreadLocalMap的key为ThreadLocal对象，value就是为线程分配的变量。诶，这篇文章不深究了

InheritableThreadLocalSecurityContextHolderStrategy源码:

```java
final class InheritableThreadLocalSecurityContextHolderStrategy implements SecurityContextHolderStrategy {

    private static final ThreadLocal<SecurityContext> contextHolder = new InheritableThreadLocal<>();

    @Override
    public void clearContext() {
        contextHolder.remove();
    }

    @Override
    public SecurityContext getContext() {
        SecurityContext ctx = contextHolder.get();
        if (ctx == null) {
            ctx = createEmptyContext();
            contextHolder.set(ctx);
        }
        return ctx;
    }

    @Override
    public void setContext(SecurityContext context) {
        Assert.notNull(context, "Only non-null SecurityContext instances are permitted");
        contextHolder.set(context);
    }

    @Override
    public SecurityContext createEmptyContext() {
        return new SecurityContextImpl();
    }

}
```

也是一种线程安全的存储策略。把SecurityContext放到InheritableThreadLocal容器中进行管理，不同于ThreadLocal容器，局部变量只存在于绑定的线程的生命周期。当开启子线程时InheritableThreadLocal容器会自动为其子线程分配一个与父线程相同的局部变量如果有的话。InheritableThreadLocal也是通过一个自定义的哈希表ThreadLocalMap来实现的，该对象inheritableThreadLocals是存在Thread里面，原理一样，只是作用不同。

GlobalSecurityContextHolderStrategy源码

```java
final class GlobalSecurityContextHolderStrategy implements SecurityContextHolderStrategy {

    private static SecurityContext contextHolder;

    @Override
    public void clearContext() {
        contextHolder = null;
    }

    @Override
    public SecurityContext getContext() {
        if (contextHolder == null) {
            contextHolder = new SecurityContextImpl();
        }
        return contextHolder;
    }

    @Override
    public void setContext(SecurityContext context) {
        Assert.notNull(context, "Only non-null SecurityContext instances are permitted");
        contextHolder = context;
    }

    @Override
    public SecurityContext createEmptyContext() {
        return new SecurityContextImpl();
    }
}
```

线程不安全的存储策略，通过static关键字修饰，这意味着JVM 中的所有实例共享相同的SecurityContext 。这通常对富客户端很有用，例如 Swing

## reslove

启动应用时加上vm参数-Dspring.security.strategy=MODE_INHERITABLETHREADLOCAL告知springSecurity框架采用MODE_INHERITABLETHREADLOCAL存储策略
