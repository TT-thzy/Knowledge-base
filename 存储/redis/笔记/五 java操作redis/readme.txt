六、Redis事务
我的操作		别人的操作
set k1 100
	<---------------set k1 1000
incr k1
get k1
按照顺序串行化执行，而不会被插入，
如果中间出现问题（大家理解为编译期语法错误等，则全部失败）
如果中间出现问题（大家理解为运行期空指针等，则部分失败）
非强一致性（强一致性就是要么同时成功，要么同时失败）
MULTI（开始）===============begin transaction
EXEC（执行）================commit
DISCARD（放弃）=============rollback
WATCH key。。（监控一个或者多个key）（乐观锁，悲观锁，CAS锁（Check-And-Set））
先监控，再开事务，如果监控后有对监控的key做修改，后面的事务失效
执行了EXEC或者DISCARD后，前面的锁都会被自动放掉
UNWATCH（取消对key的监控）



三阶段：MULTI开启，多个指令入队，EXEC批量执行
三个特征：单独的隔离操作，事务中的命令按序执行，不会被其它客户端命令打断
	   没有隔离级别的概念（因为事务中的命令没有提交都不会真正执行）
	   不保证原子性（某条失败，其后的仍然执行，没有回滚）



Jedis
java操作redis
	<dependency>
  		<groupId>redis.clients</groupId>
  		<artifactId>jedis</artifactId>
  		<version>2.1.0</version>
  	</dependency>

A：连接测试（API测试大家一定要自己练习）
B：事务控制测试
C：主从复制测试

D：池操作=============重点
池配置config
池pool
jedis