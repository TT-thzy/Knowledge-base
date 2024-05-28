## synchronized关键字
在学习知识前，我们先来看一个现象：
```java
public class SynchronizedDemo implements Runnable {
    private static int count = 0;

    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            Thread thread = new Thread(new SynchronizedDemo());
            thread.start();
        }
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("result: " + count);
    }

    @Override
    public void run() {
        for (int i = 0; i < 1000000; i++)
            count++;
    }
}
```
开启了10个线程，每个线程都累加了1000000次，如果结果正确的话自然而然总数就应该是10 * 1000000 = 10000000。可就运行多次结果都不是这个数，而且每次运行结果都不一样。这是为什么了？有什么解决方案了？
通过学习Java内存模型，已经知道出现线程安全的主要来源于JMM的设计，主要集中在主内存和线程的工作内存而导致的内存可见性问题，以及重排序导致的问题，进一步知道了happens-before规则。
线程运行时拥有自己的栈空间，会在自己的栈空间运行，如果多线程间没有共享的数据也就是说多线程间并没有协作完成一件事情，那么，多线程就不能发挥优势，不能带来巨大的价值。那么共享数据的线程安全问题怎样处理？很自然而然的想法就是每一个线程依次去读写这个共享变量，这样就不会有任何数据安全的问题，因为每个线程所操作的都是当前最新的版本数据。那么，在java关键字synchronized就具有使每个线程依次排队操作共享变量的功能。很显然，这种同步机制效率很低。

### synchronized实现原理
在java代码中使用synchronized可是使用在代码块和方法中，根据synchronized用的位置可以有如下这些使用场景：

| **使用位置**       | **作用范围**   | **被锁的对象** | **示例代码**                                          |
| ------------------ | -------------- | -------------- | ----------------------------------------------------- |
| 方法               | 实例方法       | 类的实例对象   | public synchronized void method() { .......}          |
| 静态方法           | 类对象         | Class对象      | public static synchronized void method1() { .......}  |
| 代码块             | 实例对象       | 类的实例对象   | synchronized (this) { .......}                        |
| class对象          | 类对象         | Class对象      | synchronized (SynchronizedScopeDemo.class) { .......} |
| 任意实例对象object | 实例对象object | 类的实例对象   | final String lock = "";synchronized (lock) { .......} |

如表所示synchronized可以用在方法上也可以使用在代码块中，方法是实例方法和静态方法分别锁的是该类的实例对象和该类的对象。而使用在代码块中根据锁的目标对象也可以分为三种，具体的可以看表数据。这里的需要注意的是如果锁的是类对象的话，尽管new多个实例对象，依然会被锁住。

#### 对象锁(monitor)机制
现在来进一步分析synchronized的具体底层实现，有如下一个简单的示例代码：
```java
public class SynchronizedDemo {
    public static void main(String[] args) {
        synchronized (SynchronizedDemo.class) {
            System.out.println("hello synchronized！");
        }
    }
}
```
上述代码通过synchronized“锁住”当前类对象来进行同步，将java代码进行编译之后通过javap -v SynchronizedDemo .class来查看对应的main方法字节码如下：
```java
public static void main(java.lang.String[]);

•    descriptor: ([Ljava/lang/String;)V
​
•    flags: ACC_PUBLIC, ACC_STATIC
​
•    Code:
​
•      stack=2, locals=3, args_size=1
​
•         0: ldc           #2                  // class com/codercc/chapter3/SynchronizedDemo
​
•         2: dup
​
•         3: astore_1
​
•         4: **monitorenter**
​
•         5: getstatic     #3                  // Field java/lang/System.out:Ljava/io/PrintStream;
​
•         8: ldc           #4                  // String hello synchronized！
​
•        10: invokevirtual #5                  // Method java/io/PrintStream.println:(Ljava/lang/String;)V
​
•        13: aload_1
​
•        14: monitorexit
​
•        15: **goto**          23
​
•        18: astore_2
​
•        19: aload_1
​
•        20: **monitorexit**
​
•        21: aload_2
​
•        22: **athrow**
​
•        23: **return
```

重要的字节码已经在原字节码文件中进行了标注，再进入到synchronized同步块中，需要通过monitorenter指令获取到对象的monitor（也通常称之为对象锁）后才能往下进行执行，在处理完对应的方法内部逻辑之后通过monitorexit指令来释放所持有的monitor，以供其他并发实体进行获取。代码后续执行到第15行goto语句进而继续到第23行return指令，方法成功执行退出。另外当方法异常的情况下，如果monitor不进行释放，对其他阻塞对待的并发实体来说就一直没有机会获取到了，系统会形成死锁状态很显然这样是不合理。
因此针对异常的情况，会执行到第20行指令通过monitorexit释放monitor锁，进一步通过第22行字节码athrow抛出对应的异常。从字节码指令分析也可以看出在使用synchronized是具备隐式加锁和释放锁的操作便利性的，并且针对异常情况也做了释放锁的处理。
每个对象都存在一个与之关联的monitor，线程对monitor持有的方式以及持有时机决定了synchronized的锁状态以及synchronized的状态升级方式。monitor是通过C++中ObjectMonitor实现，代码可以通过openjdk hotspot链接（hg.openjdk.java.net/jdk8u/jdk8u… ）进行下载openjdk中hotspot版本的源码，具体文件路径在src\share\vm\runtime\objectMonitor.hpp，具体源码为：

```c++
// initialize the monitor, exception the semaphore, all other fields
​
// are simple integers or pointers
​
  ObjectMonitor() {
​
•    _header       = NULL;
​
•    _count        = 0;
​
•    _waiters      = 0,
​
•    _recursions   = 0;
​
•    _object       = NULL;
​
•    _owner        = NULL;
​
•    **_WaitSet**      = NULL;
​
•    _WaitSetLock  = 0 ;
​
•    _Responsible  = NULL ;
​
•    _succ         = NULL ;
​
•    _cxq          = NULL ;
​
•    FreeNext      = NULL ;
​
•    **_EntryList**    = NULL ;
​
•    _SpinFreq     = 0 ;
​
•    _SpinClock    = 0 ;
​
•    OwnerIsThread = 0 ;
​
•    _previous_owner_tid = 0;
​
}

```

从ObjectMonitor的结构中可以看出主要维护WaitSet以及EntryList两个队列来保存ObjectWaiter 对象，当每个阻塞等待获取锁的线程都会被封装成ObjectWaiter对象来进行入队，与此同时如果获取到锁资源的话就会出队操作。另外_owner则指向当前持有ObjectMonitor对象的线程。等待获取锁以及获取锁出队的示意图如下图所示：

<img src="..\picture service\并发编程\9.png">

当多个线程进行获取锁的时候，首先都会进行_EntryList队列，其中一个线程获取到对象的monitor后，对monitor而言就会将_owner变量设置为当前线程，并且monitor维护的计数器就会加1。如果当前线程执行完逻辑并退出后，monitor中_owner变量就会清空并且计数器减1，这样就能让其他线程能够竞争到monitor。另外，如果调用了wait()方法后，当前线程就会进入到_WaitSet中等待被唤醒，如果被唤醒并且执行退出后，也会对状态量进行重置，也便于其他线程能够获取到monitor。

从线程状态变化的角度来看，如果要想进入到同步块或者执行同步方法，都需要先获取到对象的monitor，如果获取不到则会变更为BLOCKED状态，具体过程如下图所示：

<img src="..\picture service\并发编程\10.png">

从上图可以看出任意线程对Object的访问，首先要获得Object的monitor，如果获取失败，该线程就会进入到同步队列中，线程状态变为BLOCKED。当monitor持有者释放后，在同步队列中的线程才会有机会重新获取monitor，才能继续执行。

#### synchronized的happens-before关系
happens-before规则其中有一条就是监视器锁规则：对同一个监视器的解锁happens-before于对该监视器的加锁。为了进一步了解synchronized的并发语义，通过示例代码分析这条happens-before规则，示例代码如下：
```java
public class MonitorDemo {
    private int a = 0;
•
    public synchronized void writer() {     // 1
        a++;                                // 2
    }                                       // 3
•
    public synchronized void reader() {    // 4
        int i = a;                         // 5
    }                                      // 6
}
```

在并发时，第5步操作中读取到的变量a的值是多少呢？这就需要通过happens-before规则来进行分析，示例代码的happens-before关系如下图所示：

<img src="..\picture service\并发编程\11.png">

上图中每一个箭头连接的两个节点就代表之间的happens-before关系，黑色的是通过程序顺序规则推导出来，通过监视器锁规则可以推导出线程A释放锁happens-before线程B加锁，即红色线表示。蓝色的线则是通过传递性规则进一步推导的happens-before关系。最终得到的结论就是操作2 happens-before 5;
根据happens-before的定义中的一条：如果A happens-before B，则A的执行结果对B可见。那么在该示例代码中，线程A先对共享变量A进行加1，由2 happens-before 5关系可知线程A的执行结果对线程B可见即线程B所读取到的a的值为1。

#### 锁获取和锁释放的内存语义
JMM核心为两个部分：happens-before规则以及内存抽象模型。在分析完synchronized的happens-before关系后还是不太完整的，接下来看看基于java内存抽象模型的synchronized的内存语义，具体过程如下图所示：

<img src="..\picture service\并发编程\12.png">

针对线程A的操作而言，从上图可以看出线程A会首先先从主内存中读取共享变量a=0的值然后将该变量拷贝到线程本地内存。然后基于该值进行数据操作后变量a变为1，然后会将值写入到主内存中。

<img src="..\picture service\并发编程\13.png">

对线程B而言执行流程如上图所示。线程B获取锁的时候会强制从主内存中共享变量a的值，而此时变量a已经是最新值了。接下来线程B会将该值拷贝到工作内存中进行操作，同样的执行完操作后也会重新写入到主内存中。
从横向来看，线程A和线程线程都是基于主内存中的共享变量互相感知到对方的数据操作，并基于共享变量来完成并发实体中的协同工作，整个过程就好像线程A给线程B发送了一个数据变更的“通知”，这种通信机制就是基于共享内存的并发模型结构导致。

#### 对象头
在同步的时候是获取对象的monitor,即获取到对象的锁。那么对象的锁怎么理解？无非就是类似对对象的一个标志，那么这个标志就是存放在Java对象的对象头。Java对象头里的Mark Word里默认的存放的对象的Hashcode、分代年龄和锁标记位。32位JVM Mark Word默认存储结构为

<img src="..\picture service\并发编程\14.png">

Java SE 1.6中，锁一共有4种状态，级别从低到高依次是：**无锁状态、偏向锁状态、轻量级锁状态和重量级锁状态**，这几个状态会随着竞争情况逐渐升级。**锁可以升级但不能降级**，意味着偏向锁升级成轻量级锁后不能降级成偏向锁。这种锁升级却不能降级的策略，目的是为了提高获得锁和释放锁的效率。对象的MarkWord变化为下图：

<img src="..\picture service\并发编程\15.png">

#### 锁优化
通过上面的讨论对synchronized应该有一定了解，它最大的特征就是在同一时刻只有一个线程能够获得对象monitor，从而确保当前线程能够执行到相应的同步逻辑，对线程之间而言表现为互斥性（排它性） 。自然而然这种同步方式会有效率相对低下的弊端，既然同步流程不能发生改变，那么能不能让每次获取锁的速度更快或者降低阻塞等待的概率呢？也就是通过局部的优化来提升系统整体的并发同步的效率。比如去收银台付款的场景，之前的方式是大家都去排队，然后去纸币付款收银员找零。甚至有的时候付款的时候还需要在包里拿出钱包拿出钱，这个过程是比较耗时的。针对付款的流程，就可以通过线上化的手段来进行优化，在现在只需要通过支付宝扫描二维码就可以完成付款了，也省去了收银员找零的时间。尽管整个付款场景还是需要排队，但是因为付款（类似于获取锁释放锁）这个环节的优化导致耗时大大缩短，对收银台（系统整体并发效率）而言操作效率就极大的带来提升。如此类比，如果能对锁操作过程进行优化的话，也会对并发效率带来极大的提升。

##### 偏向锁
HotSpot的作者经过研究发现，大多数情况下，锁不仅不存在多线程竞争，而且总是由同一线程多次获得，为了让线程获得锁的代价更低而引入了偏向锁。

###### 获取

当一个线程访问同步块并获取锁时，会在**对象头**和**栈帧中的锁记录**里存储锁偏向的线程ID，以后该线程在进入和退出同步块时不需要进行CAS操作来加锁和解锁，只需简单地测试一下对象头的Mark Word里是否存储着指向当前线程的偏向锁。如果测试成功，表示线程已经获得了锁。如果测试失败，则需要再测试一下Mark Word中偏向锁的标识是否设置成1（表示当前是偏向锁）：如果没有设置，则使用CAS竞争锁；如果设置了，则尝试使用CAS将对象头的偏向锁指向当前线程

###### 撤消
偏向锁使用了一种**等到竞争出现才释放锁**的机制，所以当其他线程尝试竞争偏向锁时，持有偏向锁的线程才会释放锁。

<img src="..\picture service\并发编程\16.png">

如图，偏向锁的撤销，需要等待全局安全点（在这个时间点上没有正在执行的字节码）。它会首先暂停拥有偏向锁的线程，然后检查持有偏向锁的线程是否活着，如果线程不处于活动状态，则将对象头设置成无锁状态；如果线程仍然活着，拥有偏向锁的栈会被执行，遍历偏向对象的锁记录，栈中的锁记录和对象头的Mark Word要么重新偏向于其他线程，要么恢复到无锁或者标记对象不适合作为偏向锁，最后唤醒暂停的线程。

下图线程1展示了偏向锁获取的过程，线程2展示了偏向锁撤销的过程。

<img src="..\picture service\并发编程\17.png">

###### 关闭

偏向锁在Java 6和Java 7里是默认启用的，但是它在应用程序启动几秒钟之后才激活，如有必要可以使用JVM参数来关闭延迟：**-XX:BiasedLockingStartupDelay=0**。如果你确定应用程序里所有的锁通常情况下处于竞争状态，可以通过JVM参数关闭偏向锁：**-XX:-UseBiasedLocking=false**，那么程序默认会进入轻量级锁状态

##### 轻量级锁

###### 加锁
线程在执行同步块之前，JVM会先在当前线程的栈桢中创建用于存储锁记录的空间，并将对象头中的Mark Word复制到锁记录中，官方称为Displaced Mark Word。然后线程尝试使用CAS将对象头中的Mark Word替换为指向锁记录的指针。如果成功，当前线程获得锁，如果失败，表示其他线程竞争锁，当前线程便尝试使用自旋来获取锁。


###### 解锁
轻量级解锁时，会使用原子的CAS操作将Displaced Mark Word替换回到对象头，如果成功，则表示没有竞争发生。如果失败，表示当前锁存在竞争，锁就会膨胀成重量级锁。下图是两个线程同时争夺锁，导致锁膨胀的流程图。

<img src="..\picture service\并发编程\18.png">

因为自旋会消耗CPU，为了避免无用的自旋（比如获得锁的线程被阻塞住了），一旦锁升级成重量级锁，就不会再恢复到轻量级锁状态。当锁处于这个状态下，其他线程试图获取锁时，都会被阻塞住，当持有锁的线程释放锁之后会唤醒这些线程，被唤醒的线程就会进行新一轮的夺锁之争。

##### 锁比较

<img src="..\picture service\并发编程\19.png">