# CompletableFuture工作原理

## CompletableFuture类结构

```java
volatile Object result;    // Either the result or boxed AltResult

volatile Completion stack;    // Top of Treiber stack of dependent actions
```

CompletableFuture中主要维护了两个成员变量:

* result: 当前任务执行的结果(或异常);
* stack: 是CompletableFuture.Completion对象，表示操作数栈栈顶，在进行CompletableFuture链式调用的过程中，所有链式调用的CompletableFuture任务都会被压入该stack中，在任务调用的过程按后进先出的顺序出栈执行完所有任务;

CompletableFuture.Completion类体系:

<img src="file:///E:/user%20document/Personal-Knowledge-base/picture%20service/completableFuture/Completion类图.png" title="" alt="" data-align="center">

CompletableFuture.Completion的类结构:

```java
abstract static class Completion extends ForkJoinTask<Void>
        implements Runnable, AsynchronousCompletionTask {

        volatile Completion next;      // Treiber stack link

}
```

该类维护另一个指针变量:

* next: 存储下一个任务链式调用栈;

UniCompletion的类结构:

```java
 abstract static class UniCompletion<T,V> extends Completion {
        Executor executor;                 // executor to use (null if none)

        CompletableFuture<V> dep;          // the dependent to complete

        CompletableFuture<T> src;          // source for action
 }
```

该类是Completion的子类，他主要维护了三个成员变量:

* executor：异步任务执行器，如果为空则有主线程执行任务不进行异步执行。
* dep：指向当前任务构建的CompletabueFuture
* src：指向源CompletableFuture任务

## CompletableFuture工作原理

简单例子:

```java
public static void main(String[] args) {
    CompletableFuture<String> baseFuture = CompletableFuture.completedFuture("Base Future");

    log.info(baseFuture.thenApply((r) -> r + " Then Apply").join());

    baseFuture.thenAccept((r) -> log.info(r)).thenAccept((Void) -> log.info("Void"));
}
```

1. 上面的代码我们通过创建一个简单的CompletableFuture对象，再执行baseFuture.thenApply()调用后会进行一个入栈操作，如下图baseFuture引用的CompletableFuture的stack属性将会指向baseFuture.thenApply()结果返回的新CompletableFuture对象，而新CompletableFuture对象的src属性将指向来源CompletableFuture即baseFuture所引用的对象。

<img src="file:///E:/user%20document/Personal-Knowledge-base/picture%20service/completableFuture/1.png" title="" alt="" data-align="center">

2. 在上一步的基础上再执行下一行代码，结果的引用关系图如下图：

<img src="file:///E:/user%20document/Personal-Knowledge-base/picture%20service/completableFuture/2.png" title="" alt="" data-align="center">

在执行完baseFuture.thenAccept()的时候，thenAccept返回的任务将被压入栈顶，next指向上一个代码段的返回对象。在thenAccept返回的新CompletableFuture对象中再进行一次thenAccept的调用，就再产生一个新的CompletableFuture对象，dept属性就指向最新的CompletableFuture对象。

<b>theApply源码:</b>

```java
public <U> CompletableFuture<U> thenApply(
    Function<? super T,? extends U> fn) {
    return uniApplyStage(null, fn);
}

private <V> CompletableFuture<V> uniApplyStage(
    Executor e, Function<? super T,? extends V> f) {
    if (f == null) throw new NullPointerException();
    // 创建一个新的CompletableFuture对象
    CompletableFuture<V> d =  new CompletableFuture<V>();
    // e：如果是异步调用直接执行代码块
    // !d.uniApply：执行任务，如果返回false则任务未执行需入栈
    if (e != null || !d.uniApply(this, f, null)) {
        UniApply<T,V> c = new UniApply<T,V>(e, d, this, f);
        // 创建出新的UniApply对象进行入栈
        push(c);
        // 尝试执行任务
        c.tryFire(SYNC);
    }
    return d;
}

final <S> boolean uniApply(CompletableFuture<S> a,
                           Function<? super S,? extends T> f,
                           UniApply<S,T> c) {
    Object r; Throwable x;
    // 任务未完成结果为null直接返回false
    if (a == null || (r = a.result) == null || f == null)
        return false;
    // 验证是否出现异常结果，如有则任务执行结束
    tryComplete: if (result == null) {
        if (r instanceof AltResult) {
            if ((x = ((AltResult)r).ex) != null) {
                completeThrowable(x, r);
                break tryComplete;
            }
            r = null;
        }
        try {
            // 异步执行任务
            if (c != null && !c.claim())
                // 任务未执行返回false
                return false;
            @SuppressWarnings("unchecked") S s = (S) r;
            // 任务执行完成将结果写入result
            completeValue(f.apply(s));
        } catch (Throwable ex) {
            completeThrowable(ex);
        }
    }
    return true;
}
```

    以上代码片段主要描述了CompletableFuture在执行任务时会创建出新的CompletableFuture对象，使用新对象执行任务并获取结果使用CAS写入到result属性，如果任务未执行将压入栈顶，再重新尝试任务执行，在CompletableFuture其他方法的调用也都大同小异;

### CompletableFuture异步方法原理(方法后带Aync标志)

需要进行CompletableFuture异步调用则要使用Async结尾的方法执行任务，这里我们就拿thenAcceptAsync()的源码进行分析：

```java
public CompletableFuture<Void> thenAcceptAsync(Consumer<? super T> action) {
    return uniAcceptStage(asyncPool, action);
}

private CompletableFuture<Void> uniAcceptStage(Executor e, Consumer<? super T> f) {
    if (f == null) throw new NullPointerException();
    CompletableFuture<Void> d = new CompletableFuture<Void>();
    // 如果是异步任务，这里的参数e不会为空，也就是会将任务执行压入栈顶
    if (e != null || !d.uniAccept(this, f, null)) {
        UniAccept<T> c = new UniAccept<T>(e, d, this, f);
        push(c);
        // 重点还是这个入口
        c.tryFire(SYNC);
    }
    return d;
}

static final class UniAccept<T> extends UniCompletion<T,Void> {
    Consumer<? super T> fn;
    UniAccept(Executor executor, CompletableFuture<Void> dep,
              CompletableFuture<T> src, Consumer<? super T> fn) {
        super(executor, dep, src); this.fn = fn;
    }
    final CompletableFuture<Void> tryFire(int mode) {
        CompletableFuture<Void> d; CompletableFuture<T> a;
        // dep为空即任务已被执行过，直接返回null
        // uniAccept()结果为false，可能是任务执行中未完成，也可能是由线程池中的其他任务执行完成
        if ((d = dep) == null || !d.uniAccept(a = src, fn, mode > 0 ? null : this))
            return null;
        dep = null; src = null; fn = null;
        // 说明当前线程执行了该任务，返回结果继续执行前一个任务
        return d.postFire(a, mode);
    }
}

final CompletableFuture<T> postFire(CompletableFuture<?> a, int mode) {
    if (a != null && a.stack != null) {
        // postComplete调用过来的，或者上一个任务执行完成，清空栈数据，否则调用postComplete完成任务
        if (mode < 0 || a.result == null)
            a.cleanStack();
        else
            // 完成任务执行并进行出栈
            a.postComplete();
    }
    if (result != null && stack != null) {
        if (mode < 0)
            // postComplete调用过来的任务已完成
            return this;
        else
            // 完成任务执行并进行出栈
            postComplete();
    }
    return null;
}
```

    CompletableFuture进行异步主要是通过将任务压入栈顶后tryFire方法进行异步处理，如果任务未被执行则会通过postFire方法有线程池中的线程进行任务执行，任务执行结果再使用CAS将结果返回到result，其他线程即可得知任务是否被执行过，如果当前现场判断当前任务为被执行，则调用postComplete()执行完成任务。
