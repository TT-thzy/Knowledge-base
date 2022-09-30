# Mybatis源码分析小结

```java
 @Test
    public void test() throws Exception {
        InputStream inputStream = Resources.getResourceAsStream("SqlMapConfig.xml");
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        SqlSession sqlSession = sqlSessionFactory.openSession();
        IAccountDao mapper = sqlSession.getMapper(IAccountDao.class);
        Account account = mapper.findById(1);
        System.out.println(account);
        sqlSession.commit();
        sqlSession.close();
        inputStream.close();
    }
```

先决条件：程序员和Mybatis的关系是什么：程序员通过mybatis框架来操作数据库

### 问题1：首先我们必须告诉MyBatis要怎么操作数据库？

答：MyBatis提供了一个类Configuration， Mybatis 读取XML配置文件后会将内容放在一个Configuration类中，Configuration类会存在整个Mybatis生命周期，以便重复读取；

### 问题2：想要Mybatis与数据库打交道，就要有一个类似于JDBC的Connection对象，在MyBatis中叫SqlSesion，所以我们要有一个SqlSession？

答： Mybatis 读取XML配置文件后会将内容放在一个Configuration类中，SqlSessionFactoryBuilder会读取Configuration类中信息创建SqlSessionFactory。SqlSessionFactory创建SqlSession。（使用建造者模式创建SqlSessionFactory工厂对象，在由该工厂对象生产SqlSession对象）

```java
 InputStream inputStream = Resources.getResourceAsStream("SqlMapConfig.xml");
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
```

#### SqlSessionFactory sqlSessionFactory =new SqlSessionFactoryBuilder().build(inputStream)干了什么

通过build(inputstream)方法实际上是跳到了下面的方法

```java
public SqlSessionFactory build(InputStream inputStream, String environment, Properties properties) {
    try {
        //***核心代码***
      XMLConfigBuilder parser = new XMLConfigBuilder(inputStream, environment, properties);
      return build(parser.parse());
        //*************
    } catch (Exception e) {
      throw ExceptionFactory.wrapException("Error building SqlSession.", e);
    } finally {
      ErrorContext.instance().reset();
      try {
        inputStream.close();
      } catch (IOException e) {
        // Intentionally ignore. Prefer previous error.
      }
    }
  }

//build(parser.parse())干的事是：
  public SqlSessionFactory build(Configuration config) {
    return new DefaultSqlSessionFactory(config);
  }

/*
SqlSessionFactory工厂接口有两个工厂子类，分别是：
    1. DefaultSqlSessionFactory用于生产DefaultSqlSession
    2.SqlSessionManager
此处通过建造者构建的工厂对象是DefautSqlSessionFactory
*/
```

####   SqlSession sqlSession = sqlSessionFactory.openSession()干了什么

通过sqlSessionFactory.openSession()方法实际上是跳到了下面的方法

```java
 public SqlSession openSession() {
    return openSessionFromDataSource(configuration.getDefaultExecutorType(), null, false);
     //参数1：默认的执行器
     //参数2：事务隔离级别
     //参数3：是否自动提交事务
 }

//configuration.getDefaultExecutorType()实际执行的是
public ExecutorType getDefaultExecutorType() {
    return defaultExecutorType;		
  }
//返回值是枚举类型的ExecutorType ExecutorType中有三个值分别是：SIMPLE（普通的执行									器，每次执行sql语句都会产生一个新的语句对象PreparedStatement）, REUSE（会重用预处									 理语句（PreparedStatement），就是多个sql语句会重用一个语句对象）, BATCH（仅重用语                                       句还会执行批量更新）；这里用的是默认值SIMPLE
//protected ExecutorType defaultExecutorType = ExecutorType.SIMPLE;

//openSessionFromDataSource(configuration.getDefaultExecutorType(), null, false)跳到此处，主要功能是生产DefaultSqlSession对象
 private SqlSession openSessionFromDataSource(ExecutorType execType, TransactionIsolationLevel level, boolean autoCommit) {
    Transaction tx = null;
    try {
      final Environment environment = configuration.getEnvironment();
      final TransactionFactory transactionFactory = getTransactionFactoryFromEnvironment(environment);
      tx = transactionFactory.newTransaction(environment.getDataSource(), level, autoCommit);
      final Executor executor = configuration.newExecutor(tx, execType);
      return new DefaultSqlSession(configuration, executor, autoCommit);
    } catch (Exception e) {
      closeTransaction(tx); // may have fetched a connection so lets call close()
      throw ExceptionFactory.wrapException("Error opening session.  Cause: " + e, e);
    } finally {
      ErrorContext.instance().reset();
    }
  }

```

### 问题三：SqlSession（接口）能干什么？

1. 直接使用SqlSession，通过命名信息去执行SQL返回结果，该方式是IBatis版本留下的，SqlSession通过Update、Select、Insert、Delete等方法操作。
2. 获取对应的Mapper，让映射器通过命名空间和方法名称找到对应的SQL，发送给数据库执行后返回结果。（此处其实就是Mybatis通过JDK的动态代理技术实现该接口，底层最后还是使用的IBatis中SqlSession通过Update、Select、Insert、Delete等方法操作）

### 问题四：既然Mybatis底层利用JDK动态代理技术实现该接口，但是我们在使用MyBatis的时候，都是只写接口不用写实现类，为什么呢？

我们既然能够从SqlSession中得到BlogMapper接口的，那么我们肯定需要先在哪里把它放进去了，然后 SqlSession 才能生成我们想要的代理类啊。我们可以从getMapper()联系，可能会有一个setMapper()或者addMapper()方法。确实是有！

```java
configuration.addMapper(BlogMapper.class);
```

跟着这个 addMapper 方法的代码实现是这样的：

```java
public <T> void addMapper(Class<T> type) { 
    mapperRegistry.addMapper(type);
 }
```

我们看到这里 mapper 实际上被添加到 mapperRegistry （mapper注册器）中。继续跟进代码：

```java
public class MapperRegistry {
    
 private final Map<Class<?>, MapperProxyFactory<?>> knownMappers = new HashMap<Class<?>, MapperProxyFactory<?>>();
  
 public <T> void addMapper(Class<T> type) {
    if (type.isInterface()) { // 只添加接口
      if (hasMapper(type)) { // 不允许重复添加
        throw new BindingException("Type " + type + " is already known to the MapperRegistry.");
      }
      boolean loadCompleted = false;
      try {
        knownMappers.put(type, new MapperProxyFactory<T>(type)); // 注意这里
 
        MapperAnnotationBuilder parser = new MapperAnnotationBuilder(config, type);
        parser.parse();
        loadCompleted = true;
 
      } finally {
        if (!loadCompleted) {
          knownMappers.remove(type);
        }
      }
    }
  }
```

我们首先看到MapperRegistry类，有一个私有属性knowMappers，它是一个`HashMap` 。其`Key` 为当前Class对象，`value` 为一个MapperProxyFactory实例;

在MapperRegistry类的addMapper()方法中，knownMappers.put(type, new MapperProxyFactory<T>(type));相当于把：诸如BlogMapper 之类的Mapper接口被添加到了MapperRegistry 中的一个HashMap中。并以 Mapper 接口的 Class 对象作为 Key , 以一个携带Mapper接口作为属性的MapperProxyFactory 实例作为value 。MapperProxyFactory从名字来看，好像是一个工厂，用来创建Mapper Proxy的工厂。

#### IAccountDao mapper = sqlSession.getMapper(IAccountDao.class)干了什么

上面我们已经知道，Mapper 接口被到注册到了`MapperRegistry`中——放在其名为knowMappers 的HashMap属性中；

此时sqlSession是DefaultSqlSession，我们直接进DefaultSqlSession类中看sqlSession.getMapper(Class<T> type)方法干了些什么：

```java
 @Override
  public <T> T getMapper(Class<T> type) {
    return configuration.<T>getMapper(type, this);	////最后会去调用MapperRegistry.getMapper
  }

//configuration.<T>getMapper(type, this)跳到此
public <T> T getMapper(Class<T> type, SqlSession sqlSession) {
    return mapperRegistry.getMapper(type, sqlSession);
}
```

如代码所示，这里的 getMapper 调用了 configuration.getMapper , 这一步操作其实最终是调用了MapperRegistry,而此前我们已经知道，MapperRegistry是存放了一个HashMap的，我们继续跟踪进去看看，那么这里的get，肯定是从这个hashMap中取数据。我们来看看代码：

```java
 private final Map<Class<?>, MapperProxyFactory<?>> knownMappers = new HashMap<Class<?>, MapperProxyFactory<?>>();

public <T> T getMapper(Class<T> type, SqlSession sqlSession) {
    final MapperProxyFactory<T> mapperProxyFactory = (MapperProxyFactory<T>) knownMappers.get(type);//往knownMappers中取当前Mapper对象对应的Mapper
    if (mapperProxyFactory == null) {
      throw new BindingException("Type " + type + " is not known to the MapperRegistry.");
    }
    try {
      return mapperProxyFactory.newInstance(sqlSession);//重点
    } catch (Exception e) {
      throw new BindingException("Error getting mapper instance. Cause: " + e, e);
    }
  }
```

我们调用的session.getMapper(IAccountDao.class);最终会到达上面这个方法，这个方法，根据IAccountDao的class对象,以它为key在knowMappers 中找到了对应的value —— MapperProxyFactory(IAccountDao) 对象，然后调用这个对象的newInstance()方法。根据这个名字，我们就能猜到这个方法是创建了一个对象，代码是这样的：

```java

public class MapperProxyFactory<T> { //映射器代理工厂
 
  private final Class<T> mapperInterface;
  private Map<Method, MapperMethod> methodCache = new ConcurrentHashMap<Method, MapperMethod>();
 
  public MapperProxyFactory(Class<T> mapperInterface) {
    this.mapperInterface = mapperInterface;
  }
  // 删除部分代码，便于阅读
 
  @SuppressWarnings("unchecked")
  protected T newInstance(MapperProxy<T> mapperProxy) {
    //使用了JDK自带的动态代理生成映射器代理类的对象
    return (T) Proxy.newProxyInstance(
             mapperInterface.getClassLoader(),
             new Class[] { mapperInterface }, 
             mapperProxy);
  }
 
  public T newInstance(SqlSession sqlSession) {
    final MapperProxy<T> mapperProxy = new MapperProxy<T>(sqlSession, mapperInterface, methodCache);
    return newInstance(mapperProxy);
  }

```

看到这里，就清楚了，最终是通过Proxy.newProxyInstance产生了一个IAccountMapper的代理对象。Mybatis 为了完成 Mapper 接口的实现，运用了代理模式。具体是使用了JDK动态代理，这个Proxy.newProxyInstance方法生成代理类的三个要素是

1.  ClassLoader —— 指定当前接口的加载器即可
2.  当前被代理的接口是什么 —— 这里就是IAccountMapper
3.  代理类是什么 —— 这里就是 MapperProxy

代理模式中，代理类(MapperProxy)中才真正的完成了方法调用的逻辑。我们贴出MapperProxy的代码，如下：

```java

public class MapperProxy<T> implements InvocationHandler, Serializable {// 实现了InvocationHandler
  
  @Override
 public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
    try {
      if (Object.class.equals(method.getDeclaringClass())) { //判断想要调用的方法是否来自Object类
        return method.invoke(this, args);	//注意1
      } else if (isDefaultMethod(method)) { //过滤Mapper接口中的default方法的
        return invokeDefaultMethod(proxy, method, args); //注意2
      }
    } catch (Throwable t) {
      throw ExceptionUtil.unwrapThrowable(t);
    }
    final MapperMethod mapperMethod = cachedMapperMethod(method);//使用了缓存
     //CRUD
    return mapperMethod.execute(sqlSession, args);//注意3
  }

  private MapperMethod cachedMapperMethod(Method method) {
    MapperMethod mapperMethod = methodCache.get(method);
    if (mapperMethod == null) {
      mapperMethod = new MapperMethod(mapperInterface, method, sqlSession.getConfiguration());
      methodCache.put(method, mapperMethod);
    }
    return mapperMethod;
  }
}    
```

此时我们调用Account account = mapper.findById(1)方法时实际上最后是会调用这个MapperProxy的invoke方法。这段代码中，if 语句先判断，我们想要调用的方法是否来自Object类，这里的意思就是，如果我们调用toString()方法，那么是不需要做代理增强的，直接还调用原来的method.invoke()就行了。还有就是JDK 8接口中可以拥有default 方法，用户执行的是接口中的default方法的话，MyBatis就需要为用户提供正常的代理流程invokeDefaultMethod()。只有调用selectBlog()之类的方法的时候，才执行增强的调用——即mapperMethod.execute(sqlSession, args);这一句代码逻辑。
而`mapperMethod.execute(sqlSession, args);`这句最终就会执行增删改查了，代码如下：

```java
 public Object execute(SqlSession sqlSession, Object[] args) {
    Object result;
    switch (command.getType()) {
      case INSERT: {
    	Object param = method.convertArgsToSqlCommandParam(args);
        result = rowCountResult(sqlSession.insert(command.getName(), param));
        break;
      }
      case UPDATE: {
        Object param = method.convertArgsToSqlCommandParam(args);
        result = rowCountResult(sqlSession.update(command.getName(), param));
        break;
      }
      case DELETE: {
        Object param = method.convertArgsToSqlCommandParam(args);
        result = rowCountResult(sqlSession.delete(command.getName(), param));
        break;
      }
      case SELECT:
        if (method.returnsVoid() && method.hasResultHandler()) {
          executeWithResultHandler(sqlSession, args);
          result = null;
        } else if (method.returnsMany()) {
          result = executeForMany(sqlSession, args);
        } else if (method.returnsMap()) {
          result = executeForMap(sqlSession, args);
        } else if (method.returnsCursor()) {
          result = executeForCursor(sqlSession, args);
        } else {
          Object param = method.convertArgsToSqlCommandParam(args);
          result = sqlSession.selectOne(command.getName(), param);
        }
        break;
      case FLUSH:
        result = sqlSession.flushStatements();
        break;
      default:
        throw new BindingException("Unknown execution method for: " + command.getName());
    }
    if (result == null && method.getReturnType().isPrimitive() && !method.returnsVoid()) {
      throw new BindingException("Mapper method '" + command.getName() 
          + " attempted to return null from a method with a primitive return type (" + method.getReturnType() + ").");
    }
    return result;
  }
```

再往下一层，就是执行JDBC那一套了，获取链接，执行，得到ResultSet，解析ResultSet映射成JavaBean。

### 总结：

![image-20211230092015573](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20211230092015573.png)