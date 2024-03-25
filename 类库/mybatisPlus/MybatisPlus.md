## MybatisPlus

### 简介
MyBatis-Plus（简称 MP）是一个 MyBatis 的增强工具，在 MyBatis 的基础上只做增强不做改变，为简化开发、提高效率而生。
* 润物无声 : 只做增强不做改变，引入它不会对现有工程产生影响，如丝般顺滑。
* 效率至上 : 只需简单配置，即可快速进行 CRUD 操作，从而节省大量时间。
* 丰富功能 : 热加载、代码生成、分页、性能分析等功能一应俱全。

### 简单示例
#### 环境搭建
##### 数据准备
###### 创建数据库
```sql
create database mybaitsPlusTest;
```

###### 创建表
```sql
use database mybatisPlusTest;

CREATE TABLE USER
(
    id BIGINT(20)NOT NULL COMMENT '主键ID',
    NAME VARCHAR(30)NULL DEFAULT NULL COMMENT '姓名',
    age INT(11)NULL DEFAULT NULL COMMENT '年龄',
    email VARCHAR(50)NULL DEFAULT NULL COMMENT '邮箱',
    PRIMARY KEY (id)
);
```

###### 数据初始化
```sql
INSERT INTO user (id, name, age, email)VALUES
(1, 'Jone', 18, 'test1@baomidou.com'),
(2, 'Jack', 20, 'test2@baomidou.com'),
(3, 'Tom', 28, 'test3@baomidou.com'),
(4, 'Sandy', 21, 'test4@baomidou.com'),
(5, 'Billie', 24, 'test5@baomidou.com');
```

##### maven依赖
```
<dependencies>
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter</artifactId>
	</dependency>
	
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-test</artifactId>
		<scope>test</scope>
		<exclusions>
			<exclusion>
				<groupId>org.junit.vintage</groupId>
				<artifactId>junit-vintage-engine</artifactId>
			</exclusion>
		</exclusions>
	</dependency>
	
	<!--mybatis-plus-->
	<dependency>
		<groupId>com.baomidou</groupId>
		<artifactId>mybatis-plus-boot-starter</artifactId>
		<version>3.3.1</version>
	</dependency>

	<!--mysql依赖-->
	<dependency>
		<groupId>mysql</groupId>
		<artifactId>mysql-connector-java</artifactId>
	</dependency>

	<!--lombok用来简化实体类-->
	<dependency>
		<groupId>org.projectlombok</groupId>
		<artifactId>lombok</artifactId>
		<optional>true</optional>
	</dependency>
</dependencies>

```

#### 配置
在 application.properties 配置文件中添加 MySQL 数据库的相关配置：
mysql 5:
```
#mysql数据库连接
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.url=jdbc:mysql://localhost:3306/mybatis_plus?characterEncoding=utf-8&useSSL=false
spring.datasource.username=root
spring.datasource.password=root
```

mysql 8:
```
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://localhost:3306/mybatis_plus?serverTimezone=GMT%2B8
spring.datasource.username=root
spring.datasource.password=root
```

注意：
1. 这里的 url 使用了 ?serverTimezone=GMT%2B8 后缀，因为8.0版本的jdbc驱动需要添加这个后缀，否则运行测试用例报告如下错误：
```
java.sql.SQLException: The server time zone value 'ÖÐ¹ú±ê×¼Ê±¼ä' is unrecognized or represents more 
```
2. 这里的 driver-class-name 使用了  com.mysql.cj.jdbc.Driver ，在 jdbc 8 中 建议使用这个驱动，否则运行测试用例的时候会有 WARN 信息。

#### 编码
在 Spring Boot 启动类中添加 @MapperScan 注解，扫描 Mapper 文件夹。
```java
@SpringBootApplication
@MapperScan("com.thzy.demomptest.mapper")
public class DemomptestApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemomptestApplication.class, args);
    }

}
```

添加User实体：
```java
@Data
public class User {
    private Long id;
    private String name;
    private Integer age;
    private String email;
}
```

添加mapper:
```java
@Repository
public interface UserMapper extends BaseMapper<User> {
}
```

测试类:
```java
@SpringBootTest
class DemomptestApplicationTests {

    @Autowired
    private UserMapper userMapper;

    @Test
    public void findAll() {
        List<User> users = userMapper.selectList(null);
        System.out.println(users);
    }
}
```
通过以上几个简单的步骤，我们就实现了 User 表的 CRUD 功能，甚至连 XML 文件都不用编写！

##### 查看sql输出日志
```
#mybatis日志
mybatis-plus.configuration.log-=impl=org.apache.ibatis.logging.stdout.StdOutImpl
```

### 常用操作

#### 主键策略
插入操作：
```java
//添加
@Test
public void testAdd() {
    User user = new User();
    user.setName("lucy");
    user.setAge(20);
    user.setEmail("1243@qq.com");
    int insert = userMapper.insert(user);
    System.out.println(insert);
}
```
注意：数据库插入id值默认为：全局唯一id
<img src = "..\..\picture service\类库\mybatisPlus\1.png">

##### ASSIGN_ID
MyBatis-Plus默认的主键策略是：ASSIGN_ID （使用了雪花算法）:
```java
@TableId(type = IdType.ASSIGN_ID)
private String id;
```

<font color= "red">雪花算法：分布式ID生成器</font>

雪花算法是由Twitter公布的分布式主键生成算法，它能够保证<b>不同表的主键的不重复性</b>，以及<b>相同表的主键的有序性</b>。
核心思想:
长度共64bit（一个long型）。
1. 首先是一个符号位，1bit标识，由于long基本类型在Java中是带符号的，最高位是符号位，正数是0，负数是1，所以id一般是正数，最高位是0。
2. 41bit时间截(毫秒级)。
3. 10bit作为机器的ID（5个bit是数据中心，5个bit的机器ID，可以部署在1024个节点）。
4. 12bit作为毫秒内的流水号（意味着每个节点在每毫秒可以产生 4096 个 ID）。

<img src = "..\..\picture service\类库\mybatisPlus\2.png">

优点：整体上按照时间自增排序，并且整个分布式系统内不会产生ID碰撞，并且效率较高。

##### auto自增策略
需要在创建数据表的时候设置主键自增
实体字段中配置 @TableId(type = IdType.AUTO)
```java
@TableId(type = IdType.AUTO)
private Long id;
```

要想影响所有实体的配置，可以设置全局主键配置
```java
#全局设置主键生成策略
mybatis-plus.global-config.db-config.id-type=auto
```

#### 自动填充

##### 更新操作
注意：update时生成的sql自动是动态sql：UPDATE user SET age=? WHERE id=? 
```java
//修改
@Test
public void testUpdate() {
    User user = new User();
    user.setId(1340868235401764865L);
    user.setName("lucymary");
    int count = userMapper.updateById(user);
    System.out.println(count);
}
```

##### 自动填充
项目中经常会遇到一些数据，每次都使用相同的方式填充，例如记录的创建时间，更新时间等。
我们可以使用MyBatis Plus的自动填充功能，完成这些字段的赋值工作。

```
@TableField(fill = FieldFill.INSERT)
private Date createTime;  //create_time

@TableField(fill = FieldFill.INSERT_UPDATE)
private Date updateTime; //update_time
```

实现元对象处理器接口:
```java
@Component
public class MyMetaObjectHandler implements MetaObjectHandler {
    //mp执行添加操作，这个方法执行
    @Override
    public void insertFill(MetaObject metaObject) {
        this.setFieldValByName("createTime",new Date(),metaObject);
        this.setFieldValByName("updateTime",new Date(),metaObject);
    }

    //mp执行修改操作，这个方法执行
    @Override
    public void updateFill(MetaObject metaObject) {
        this.setFieldValByName("updateTime",new Date(),metaObject);
    }
}
```

#### 乐观锁（版本号机制）
主要适用场景：当要更新一条记录的时候，希望这条记录没有被别人更新，也就是说实现线程安全的数据更新。
基于版本号机制的乐观锁实现方式：取出记录时，获取当前version，更新时，带上这个version
执行更新时， set version = newVersion where version = oldVersion，如果version不对，就更新失败。

mybatisPlus中的乐观锁支持：
```java
@Version
private Integer version;
```

添加配置:
```java
@Configuration
public class MpConfig {
    /**
     * 乐观锁插件
     */
    @Bean
    public OptimisticLockerInterceptor optimisticLockerInterceptor() {
        return new OptimisticLockerInterceptor();
    }
}
```

#### 查询

##### 简单条件查询
通过map封装查询条件：
<font color = "red">注意：map中的key对应数据库中的列名。如：数据库user_id，实体类是userId，这时map的key需要填写user_id</font>
```java
//简单条件查询
@Test
public void testSelect2() {
    Map<String, Object> columnMap = new HashMap<>();
    columnMap.put("name","Jack");
    columnMap.put("age",20);
    List<User> users = userMapper.selectByMap(columnMap);
    System.out.println(users);
}
```
##### 分页查询
MyBatis Plus自带分页插件，只要简单的配置即可实现分页功能：
```java
/**
 * 分页插件
 */
@Bean
public PaginationInterceptor paginationInterceptor() {
    return new PaginationInterceptor();
}
```

```java
//分页查询
@Test
public void testSelectPage() {
    Page<User> page = new Page(1,3);
    Page<User> userPage = userMapper.selectPage(page, null);
    //返回对象得到分页所有数据
    long pages = userPage.getPages(); //总页数
    long current = userPage.getCurrent(); //当前页
    List<User> records = userPage.getRecords(); //查询数据集合
    long total = userPage.getTotal(); //总记录数
    boolean hasNext = userPage.hasNext();  //下一页
    boolean hasPrevious = userPage.hasPrevious(); //上一页

    System.out.println(pages);
    System.out.println(current);
    System.out.println(records);
    System.out.println(total);
    System.out.println(hasNext);
    System.out.println(hasPrevious);
}

```

##### 条件构造器
Wrapper:
<img src = "..\..\picture service\类库\mybatisPlus\3.png">

Wrapper ： 条件构造抽象类，最顶端父类  
    AbstractWrapper ： 用于查询条件封装，生成 sql 的 where 条件
        QueryWrapper ： 查询条件封装
        UpdateWrapper ： Update 条件封装
    AbstractLambdaWrapper ： 使用Lambda 语法
        LambdaQueryWrapper ：用于Lambda语法使用的查询Wrapper
        LambdaUpdateWrapper ： Lambda 更新封装Wrapper

###### ge、gt、le、lt、isNull、isNotNull
```java
@Test
public void testQuery() {
QueryWrapper<User>queryWrapper = newQueryWrapper<>();
queryWrapper
        .isNull("name")
        .ge("age", 12)
        .isNotNull("email");
    int result = userMapper.delete(queryWrapper);
System.out.println("delete return count = " + result);
}
```
###### eq、ne
注意：seletOne()返回的是一条实体记录，当出现多条时会报错
```java
@Test
public void testSelectOne() {
QueryWrapper<User>queryWrapper = newQueryWrapper<>();
queryWrapper.eq("name", "Tom");
Useruser = userMapper.selectOne(queryWrapper);//只能返回一条记录，多余一条则抛出异常
System.out.println(user);
}
```

###### between、notBetween
```java
@Test
public void testSelectCount() {
QueryWrapper<User>queryWrapper = newQueryWrapper<>();
queryWrapper.between("age", 20, 30);
    Integer count = userMapper.selectCount(queryWrapper); //返回数据数量
System.out.println(count);
}
```

###### like、notLike、likeLeft、likeRight
```java
@Test
public void testSelectMaps() {
QueryWrapper<User>queryWrapper = newQueryWrapper<>();
queryWrapper
        .select("name", "age")
        .like("name", "e")
        .likeRight("email", "5");
List<Map<String, Object>>maps = userMapper.selectMaps(queryWrapper);//返回值是Map列表
maps.forEach(System.out::println);
}
```

###### orderBy、orderByDesc、orderByAsc
```java
@Test
public void testSelectListOrderBy() {
QueryWrapper<User>queryWrapper = newQueryWrapper<>();
queryWrapper.orderByDesc("age", "id");
List<User>users = userMapper.selectList(queryWrapper);
users.forEach(System.out::println);
}
```

| **查询方式**     | **说明**                          |
| ---------------- | --------------------------------- |
| **setSqlSelect** | 设置 SELECT 查询字段              |
| **where**        | WHERE  语句，拼接  + WHERE 条件   |
| **and**          | AND  语句，拼接  + AND 字段=值    |
| **andNew**       | AND  语句，拼接  + AND (字段=值)  |
| **or**           | OR  语句，拼接  + OR 字段=值      |
| **orNew**        | OR  语句，拼接  + OR (字段=值)    |
| **eq**           | 等于=                             |
| **allEq**        | 基于 map 内容等于=                |
| **ne**           | 不等于<>                          |
| **gt**           | 大于>                             |
| **ge**           | 大于等于>=                        |
| **lt**           | 小于<                             |
| **le**           | 小于等于<=                        |
| **like**         | 模糊查询 LIKE                     |
| **notLike**      | 模糊查询 NOT LIKE                 |
| **in**           | IN  查询                          |
| **notIn**        | NOT  IN 查询                      |
| **isNull**       | NULL  值查询                      |
| **isNotNull**    | IS  NOT NULL                      |
| **groupBy**      | 分组 GROUP BY                     |
| **having**       | HAVING  关键词                    |
| **orderBy**      | 排序 ORDER BY                     |
| **orderAsc**     | ASC  排序 ORDER  BY               |
| **orderDesc**    | DESC  排序 ORDER  BY              |
| **exists**       | EXISTS  条件语句                  |
| **notExists**    | NOT  EXISTS 条件语句              |
| **between**      | BETWEEN  条件语句                 |
| **notBetween**   | NOT  BETWEEN 条件语句             |
| **addFilter**    | 自由拼接 SQL                      |
| **last**         | 拼接在最后，例如：last(“LIMIT 1”) |

#### 删除

根据id删除:
```java
@Test
public void testDeleteById(){
    int result = userMapper.deleteById(5L);
system.out.println(result);
}
```

批量删除:
```java
@Test
public void testDeleteBatchIds() {
    int result = userMapper.deleteBatchIds(Arrays.asList(8, 9, 10));
system.out.println(result);
}
```

简单条件删除
```java
@Test
public void testDeleteByMap() {
HashMap<String, Object> map = new HashMap<>();
map.put("name", "Helen");
map.put("age", 18);
    int result = userMapper.deleteByMap(map);
system.out.println(result);
}
```

逻辑删除:
* 物理删除：真实删除，将对应数据从数据库中删除，之后查询不到此条被删除数据
* 逻辑删除：假删除，将对应数据中代表是否被删除字段状态修改为“被删除状态”，之后在数据库中仍旧能看到此条数据记录

逻辑删除的使用场景：
1. 可以进行数据恢复
2. 有关联数据，不便删除

添加deleted 字段，并加上 @TableLogic 注解 :
```java
@TableLogic
private Integer deleted;
```

application.properties 加入以下配置，此为默认值，如果你的默认值和mp默认的一样,该配置可无
```
mybatis-plus.global-config.db-config.logic-delete-value=1
mybatis-plus.global-config.db-config.logic-not-delete-value=0
```

测试后发现，数据并没有被删除，deleted字段的值由0变成了1，测试后分析打印的sql语句，是一条update语句。
注意：被删除前，数据的deleted 字段的值必须是 0，才能被选取出来执行逻辑删除的操作
```java
@Test
public void testLogicDelete() {
    int result = userMapper.deleteById(1L);
system.out.println(result);
}
```

MyBatis Plus中查询操作也会自动添加逻辑删除字段的判断:
```java
@Test
public void testLogicDeleteSelect() {
List<User> users = userMapper.selectList(null);
users.forEach(System.out::println);
}
```


