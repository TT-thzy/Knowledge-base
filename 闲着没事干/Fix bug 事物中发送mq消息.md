### tneFix bug: 事物中发送mq消息



#### 事物内发送mq消息会有什么问题？

> 有一种情况：当在事物内发送mq消息，此时事物代码的控制粒度很大，会导致事物还未提交，消费者就已经将该消息消费掉；如果此时消费者正好去回查一次数据库，而提供者这边的事物还未提交，那么消费者可能读到的数据是脏的；



#### 代码复现

##### 复现view

```java
//1.开启事物
//2.模拟mq发送消息，并被消费掉（查一次数据）	问题点
//3.修改数据
//4.commitOrcallback
```



#### Solution

1. ##### 利用spring官方提供的TransactionSynchronization#afterCommit

   ![image-20220406184549945](/Users/xiaotan/Library/Application Support/typora-user-images/image-20220406184549945.png)

2. ##### 自己写一个监听器，监听提交事件，提交成功，完成消息发送

   

3. ##### 控制事物粒度，将发送mq消息移到事物外

   



