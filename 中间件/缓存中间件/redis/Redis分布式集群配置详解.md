## Redis分布式集群配置详解

### 1. 为什么搭建分布式集群

> Redis的sentinel哨兵模式虽然可以一定程度实现Redis的高可用，但是还存在单节点写入压力过大的问题，因为客户端写入数据只能在Master节点，当写入量特别大的时候主节点压力就会很大。Redis 3.x开始提供了Cluster集群模式，可以实现对数据分布式写入。由于分布式集群的性能会相对较低，也不能支持Redis的所有操作，跨节点操作需要改进（flush、mget、keys等命令不能跨节点使用），客户端的维护也更复杂，所以业务能在哨兵下满足需求尽量用哨兵模式。

### 2.  工作流程和原理

1. Redis Cluster至少需要**三个主节点**才能工作；
2. Redis Cluster采用了数据分片机制，使用16384个（0-16383）Slot虚拟槽来平均存储数据（*当有一个key需要存储的时候，集群首先对该key使用crc16的算法得到一个结果，然后将这个结果对16384取余，那么该key通过上面计算得到的值就是我们说的哈希槽,然后放到相应的节点上，查询与修改等都是如此*）。也可以根据每个节点的内存情况手动分配，手动分配时需要把16384个分配完，否则集群无法正常工作；
3. Redis Cluster每一个节点都可以作为客户端的连接入口并写入数据。Redis cluster的分片机制让每个节点都存放了一部分数据，比如1W个key分布在5个节点，每个节点可能只存储了2000个key，但是每一个节点都有一个类似index索引记录了所有key的分布情况；
4. 每一个节点还应该有一个Slave节点作为备份节点（比如用3台机器部署成Redis cluster，还应该为这三台Redis做主从部署，所以一共要6台机器），当master节点故障时slave节点会选举提升为master节点；
5. Redis Cluster集群默认监听在16379端口。集群中所有Master都参与选举，当半数以上的master节点与故障节点通信超时将触发故障转移。任意master挂掉且该master没有slave节点，集群将进入fail状态，这也是为什么还要为他们准备Slave节点的原因。如果master有slave节点，但是有半数以上master挂掉，集群也将进入fail状态。当集群fail时，所有对集群的操作都不可用，会出现clusterdown the cluster is down的错误
6. 每Redis提供了节点之间相互发送的ping命令，用于测试每个节点的健康状态，集群中连接正常的节点接收到其他节点发送的ping命令时，会返回一个pong字符串。Redis投票机制：如果一个节点A给B发送ping没有得到pong返回，那么A就会通知其他节点再次给B发送ping，如果集群中超过一半的节点给B发送ping都没有得到返回，那么B就被坐实game over了，所以为了避免单点故障，一般都会为Redis的每个节点提供一个备份节点，B节点挂掉了立马启动B的备份节点服务器。

### 3. 配置流程

在一台虚拟机上测试，**配置最少6台redis服务端**

应为Redis Cluster至少需要三个主节点才能工作，而对于三个主节点我们要为他配置备份机，也就是从机;

1. 准备六个redis服务端启动的配置文件

   ![image-20220119181124140](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20220119181124140.png)

2. 然后修改对应信息

   ```markdown
   1、port #端口  
   2、pidfile #后台进程文件名字  
   3、logfile #日志文件名字  
   4、dbfilename #持久化文件名字名字
   5、cluster-enabled yes  #开启集群
   6、cluster-config-file nodes-(对应端口).conf  #集群配置信息文件，由Redis自行更新，不用手动配置。每个节点都有一个集群配置文件用于持久化保存集群信息，需确保与运行中实例的配置文件名    不冲突。
   7、cluster-node-timeout 15000  #节点互连超时时间，毫秒为单位
   8、cluster-slave-validity-factor 10  #在进行故障转移的时候全部slave都会请求申请为master，但是有些slave可能与master断开连接一段时间了导致数据过于陈旧，不应该被提升为master。该参数就是用来判断slave节点与master断线的时间是否过长。判断方法是：比较slave断开连接的时间和(node-timeout * slave-validity-factor)+ repl-ping-slave-period如果节点超时时间为三十秒, 并且slave-9、validity-factor为10，假设默认的repl-ping-slave-period是10秒，即如果超过310秒slave将不会尝试进行故障转移
   10、cluster-migration-barrier 1  #master的slave数量大于该值，slave才能迁移到其他孤立master上，如这个参数被设为2，那么只有当一个主节点拥有2个可工作的从节点时，它的一个从节点才会尝试迁移。
   11、cluster-require-full-coverage yes  #集群所有节点状态为ok才提供服务。建议设置为no，可以在slot没有全部分配的时候提供服务。
   ```

3. 编写sh脚本启动六台服务

   ```shell
   redis-server redis-6379.conf
   redis-server redis-6380.conf
   redis-server redis-6381.conf
   redis-server redis-6382.conf
   redis-server redis-6383.conf
   redis-server redis-6384.conf
   ```

   ![image-20220119181839816](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20220119181839816.png)

4. 启动后查看应用进程状态，可以看到端口后面多了[cluster]这样的信息

   ![image-20220119181956478](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20220119181956478.png)

5. 启动成功后会追加如下文件

   ![image-20220119183013122](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20220119183013122.png)

6. 单单启动cluster后还没有正式组成集群，还需要用到redis-trib.rb命令来创建集群，由于redis-trib.rb命令是一个ruby脚本，会对ruby环境有一些依赖，在执行前需要安装以下软件包（Redis 5开始可以使用redis-cli --cluster来创建集群，命令语法和redis-trib.rb脚本一样，省去了配置ruby环境的步骤），此处演示的是redis-cli --cluster来创建集群

   ```shel
   [root@localhost bin]# redis-cli --cluster create 127.0.0.1:6379 127.0.0.1:6380 127.0.0.1:6381 127.0.0.1:6382 127.0.0.1:6383 127.0.0.1:6384 --cluster-replicas 1
   ```

   说明：--cluster-replicas 参数为每个主结点需要几个从节点，1表示每个主节点需要1个从节点。

   **注：**--cluster-replicas 参数配成2会报错 ；因为此时我只配了6台机器，如果参数为2，对应的是2台主机，2台从机；而分布式集群构建的大前提就是需要**三台主机**

   ![image-20220119182418790](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20220119182418790.png)

    启动后：

   ![image-20220119183130879](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20220119183130879.png)

​        Can I set the above configuration 回答yes 成功：

![image-20220119183051290](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20220119183051290.png)

7. 添加集群主节点

   ```shell
   redis-cli --cluster add-node 192.168.163.132:6382 192.168.163.132:6379 
   ```

   说明：为一个指定集群添加节点，需要先连到该集群的任意一个节点IP（192.168.163.132:6379），再把新节点加入。该2个参数的顺序有要求：新加入的节点放前

8. 添加集群从节点

   ```shell
   redis-cli --cluster add-node 192.168.163.132:6382 192.168.163.132:6379 --cluster-slave --cluster-master-id 117457eab5071954faab5e81c3170600d5192270
   ```

   说明：把6382节点加入到6379节点的集群中，并且当做node_id为 117457eab5071954faab5e81c3170600d5192270 的从节点。如果不指定 **--cluster-master-id** 会随机分配到任意一个主节点。

9. 删除节点

   ```shell
   redis-cli --cluster del-node 192.168.163.132:6384 f6a6957421b80409106cb36be3c7ba41f3b603ff
   ```

   说明：指定IP、端口和node_id 来删除一个节点，从节点可以直接删除，有slot分配的主节点不能直接删除。删除之后，该节点会被shutdown。



### 4. 测试

1、集群一旦搭建好了后必须使用

```shell
redis-cli -c -h 主机地址 -p 端口号
```

 操作以集群模式进行操作。集群模式下只有0号数据库可用，无法再通过select来切换数据库。登录后创建一些key用于测试，可以看到输出信息显示这个key是被存到了其他机器上。使用get获取key的时候也可以看到该key是被分配到了哪个节点

![image-20220119190615354](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20220119190615354.png)

![image-20220119190700980](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20220119190700980.png)

![image-20220119191053218](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20220119191053218.png)

2、查看redis cluster节点状态

cluster nodes命令可以看到自己和其他节点的状态，集群模式下有主节点挂掉的话可以在这里观察到切换情况；cluste info命令可以看到集群的详细状态，包括集群状态、分配槽信息

![image-20220119190832559](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20220119190832559.png)

![image-20220119190906940](C:\Users\王涛.com\AppData\Roaming\Typora\typora-user-images\image-20220119190906940.png)

3、手动切换redis cluster的主从关系：

redis cluster发生主从切换后，即使之前的主节点恢复了也不会变回主节点，而是作为从节点在工作，这一点和sentine模式是一样的。如果想要它变回主节点，只需要在该节点执行命令cluster failover;

参考：

https://www.linuxe.cn/post-375.html

https://www.cnblogs.com/zhoujinyi/p/11606935.html

