# spring中观察者模式的使用

## 场景
在开发⼯作中，会遇到⼀种场景，做完某⼀件事情以后，需要⼴播⼀些消息或者通知，告诉其他的模块进⾏⼀些事件处理，⼀般来说，可以⼀个⼀个发送请求去通知，但是有⼀种更好的⽅式，那就是事件监听，事件监听也是设计模式中发布-订阅模式、观察者模式的⼀种实现。
对于 Spring 容器的⼀些事件，可以监听并且触发相应的⽅法。通常的⽅法有 2 ，ApplicationListener 接⼝和@EventListener 注解。

## 简介
要想顺利的创建监听器，并起作⽤，这个过程中需要这样⼏个⾓⾊：
1、事件（event）可以封装和传递监听器中要处理的参数，如对象或字符串，并作为监听器中监听的⽬标。
2、监听器（listener）具体根据事件发⽣的业务处理模块，这⾥可以接收处理事件中封装的对象或字符串。
3、事件发布者（publisher）事件发⽣的触发者。

## 核心 ApplicationListener
```java
@FunctionalInterface
public interface ApplicationListener<E extends ApplicationEvent> extends EventListener {
    void onApplicationEvent(E var1);

    static <T> ApplicationListener<PayloadApplicationEvent<T>> forPayload(Consumer<T> consumer) {
        return (event) -> {
            consumer.accept(event.getPayload());
        };
    }
}
```
它是⼀个泛型接⼝，泛型的类型必须是 ApplicationEvent 及其⼦类，只要实现了这个接⼝，那么当容器有相应的事件触发时，就能触发 onApplicationEvent ⽅法。

## 简单试例
监听容器启动触发事件
```java
@Component
public class MySpringListener implements ApplicationListener<ApplicationStartedEvent> {

    public void onApplicationEvent(ApplicationStartedEvent applicationStartedEvent) {
        System.out.println("事件触发："+applicationStartedEvent.getClass().getName());
    }

}
```
Result:
```

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.4.5)

2022-05-07 18:24:37.608  WARN 13824 --- [           main] o.s.boot.StartupInfoLogger               : InetAddress.getLocalHost().getHostName() took 5002 milliseconds to respond. Please verify your network configuration (macOS machines may need to add entries to /etc/hosts).
2022-05-07 18:24:42.614  INFO 13824 --- [           main] c.shushi.demo.SpringListenerApplication  : Starting SpringListenerApplication using Java 1.8.0_321 on xiaotandeMacBook-Pro.local with PID 13824 (/Users/xiaotan/IdeaProjects/springListener/target/classes started by xiaotan in /Users/xiaotan/IdeaProjects/springListener)
2022-05-07 18:24:42.615  INFO 13824 --- [           main] c.shushi.demo.SpringListenerApplication  : No active profile set, falling back to default profiles: default
2022-05-07 18:24:43.548  INFO 13824 --- [           main] c.shushi.demo.SpringListenerApplication  : Started SpringListenerApplication in 21.367 seconds (JVM running for 21.767)
事件触发：org.springframework.boot.context.event.ApplicationStartedEvent
2022-05-07 18:24:43.553  INFO 13824 --- [extShutdownHook] com.alibaba.druid.pool.DruidDataSource   : {dataSource-0} closing ...

Process finished with exit code 0

```
## 自定义
自定义事件
```java
public class MyEvent extends ApplicationEvent {

    private String msg;

    /**
     * Create a new {@code ApplicationEvent}.
     *
     * @param source the object on which the event initially occurred or with
     *               which the event is associated (never {@code null})
     */
    public MyEvent(Object source,String msg) {
        super(source);
        this.msg=msg;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
```
自定义监听者
```java
@Component
public class MyCustomerListener implements ApplicationListener<MyEvent> {

    public void onApplicationEvent(MyEvent myEvent) {
        System.out.println("事件触发：" + myEvent.getMsg());
    }
}
```
事件发布（触发事件）测试
```java
@SpringBootTest(classes = SpringListenerApplication.class)
public class ListenerTest {

    @Autowired
    private ApplicationEventPublisher applicationEventPublisher; //发布者

    /**
     * 事件发布
     */
    @Test
    public void springListenerTest(){
        applicationEventPublisher.publishEvent(new MyEvent(this,"牛逼"));
    }
}

```
运行后Result:
```

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.4.5)

2022-05-07 18:41:07.398  WARN 13909 --- [           main] o.s.boot.StartupInfoLogger               : InetAddress.getLocalHost().getHostName() took 5002 milliseconds to respond. Please verify your network configuration (macOS machines may need to add entries to /etc/hosts).
2022-05-07 18:41:12.404  INFO 13909 --- [           main] cpm.shushi.demo.ListenerTest             : Starting ListenerTest using Java 1.8.0_321 on xiaotandeMacBook-Pro.local with PID 13909 (started by xiaotan in /Users/xiaotan/IdeaProjects/springListener)
2022-05-07 18:41:12.406  INFO 13909 --- [           main] cpm.shushi.demo.ListenerTest             : No active profile set, falling back to default profiles: default
2022-05-07 18:41:13.743  INFO 13909 --- [           main] o.s.s.concurrent.ThreadPoolTaskExecutor  : Initializing ExecutorService 'applicationTaskExecutor'
2022-05-07 18:41:14.259  INFO 13909 --- [           main] cpm.shushi.demo.ListenerTest             : Started ListenerTest in 22.195 seconds (JVM running for 23.103)
事件触发：org.springframework.boot.context.event.ApplicationStartedEvent

事件触发：牛逼

2022-05-07 18:41:14.597  INFO 13909 --- [extShutdownHook] com.alibaba.druid.pool.DruidDataSource   : {dataSource-0} closing ...
2022-05-07 18:41:14.598  INFO 13909 --- [extShutdownHook] o.s.s.concurrent.ThreadPoolTaskExecutor  : Shutting down ExecutorService 'applicationTaskExecutor'

Process finished with exit code 0

```
## 使用@EventListener注解
注释掉前面自定义的监听者
```java
@Component
public class MyAnnotationListener {

    @EventListener(MyEvent.class)
    public void handle(MyEvent event){
        System.out.println("事件触发（注解）：" + event.getMsg());
    }

}
```
运行Result:
```
 .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.4.5)

2022-05-07 18:49:25.556  WARN 13941 --- [           main] o.s.boot.StartupInfoLogger               : InetAddress.getLocalHost().getHostName() took 5000 milliseconds to respond. Please verify your network configuration (macOS machines may need to add entries to /etc/hosts).
2022-05-07 18:49:30.561  INFO 13941 --- [           main] cpm.shushi.demo.ListenerTest             : Starting ListenerTest using Java 1.8.0_321 on xiaotandeMacBook-Pro.local with PID 13941 (started by xiaotan in /Users/xiaotan/IdeaProjects/springListener)
2022-05-07 18:49:30.563  INFO 13941 --- [           main] cpm.shushi.demo.ListenerTest             : No active profile set, falling back to default profiles: default
2022-05-07 18:49:31.564  INFO 13941 --- [           main] o.s.s.concurrent.ThreadPoolTaskExecutor  : Initializing ExecutorService 'applicationTaskExecutor'
2022-05-07 18:49:31.989  INFO 13941 --- [           main] cpm.shushi.demo.ListenerTest             : Started ListenerTest in 21.709 seconds (JVM running for 22.661)
事件触发：org.springframework.boot.context.event.ApplicationStartedEvent

事件触发（注解）：牛逼

2022-05-07 18:49:32.241  INFO 13941 --- [extShutdownHook] com.alibaba.druid.pool.DruidDataSource   : {dataSource-0} closing ...
2022-05-07 18:49:32.242  INFO 13941 --- [extShutdownHook] o.s.s.concurrent.ThreadPoolTaskExecutor  : Shutting down ExecutorService 'applicationTaskExecutor'

Process finished with exit code 0

```