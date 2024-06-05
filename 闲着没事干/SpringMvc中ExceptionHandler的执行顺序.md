## ExceptionHandler的执行顺序

在项目开发中经常会遇到统一异常处理的问题，在springMVC中有一种解决方式，使用ExceptionHandler。举个例子:

```java
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler({IllegalArgumentException.class})
    @ResponseBody
    public Result handleIllegalArgumentException(IllegalArgumentException e) {
        logger.error(e.getLocalizedMessage(), e);
        return Result.fail(e.getMessage());
    }

    @ExceptionHandler({RuntimeException.class})
    @ResponseBody
    public Result handleRuntimeException(RuntimeException e) {
        logger.error(e.getLocalizedMessage(), e);
        return Result.failure();
    }
}
```

在这段代码中，我们可以看到存在两个异常处理的函数分别处理IllegalArgumentException和RuntimeException，但是转念一想，就会想到一个问题，IllegalArgumentException是RuntimeException的子类，那么对IllegalArgumentException这个异常又会由谁来处理呢？
起初在网上看到一些答案，可以通过Order设置，但是经过简单的测试，发现Order并不起任何作用

#### 源码解读

决定最终选择哪个ExceptionHandler的核心代码为ExceptionHandlerMethodResolver的getMappedMethod方法。代码如下:

```java
private Method getMappedMethod(Class<? extends Throwable> exceptionType) {
  List<Class<? extends Throwable>> matches = new ArrayList<Class<? extends Throwable>>();
  for (Class<? extends Throwable> mappedException : this.mappedMethods.keySet()) {
    if (mappedException.isAssignableFrom(exceptionType)) {
      matches.add(mappedException);
    }
  }
  if (!matches.isEmpty()) {
    Collections.sort(matches, new ExceptionDepthComparator(exceptionType));
    return this.mappedMethods.get(matches.get(0));
  }
  else {
    return null;
  }
}
```

这个首先找到可以匹配异常的所有ExceptionHandler，然后对其进行排序，取深度最小的那个(即匹配度最高的那个)。至于深度比较器的算法如下，就是做了一个简单的递归，不停地判断父异常是否为目标异常来取得最终的深度。

```java
    /**
     * Create a new ExceptionDepthComparator for the given exception type.
     * @param exceptionType the target exception type to compare to when sorting by depth
     */
    public ExceptionDepthComparator(Class<? extends Throwable> exceptionType) {
        Assert.notNull(exceptionType, "Target exception type must not be null");
        this.targetException = exceptionType;
    }


    @Override
    public int compare(Class<? extends Throwable> o1, Class<? extends Throwable> o2) {
        int depth1 = getDepth(o1, this.targetException, 0);
        int depth2 = getDepth(o2, this.targetException, 0);
        return (depth1 - depth2);
    }

    private int getDepth(Class<?> declaredException, Class<?> exceptionToMatch, int depth) {
        if (exceptionToMatch.equals(declaredException)) {
            // Found it!
            return depth;
        }
        // If we've gone as far as we can go and haven't found it...
        if (exceptionToMatch == Throwable.class) {
            return Integer.MAX_VALUE;
        }
        return getDepth(declaredException, exceptionToMatch.getSuperclass(), depth + 1);
    }
```

### 结论

源码不长，我们也可以很容易地就找到我们想要的答案——ExceptionHandler的处理顺序是由异常匹配度来决定的，且我们也无法通过其他途径指定顺序(其实也没有必要)。
