# spring容器版的策略模式使用

## 场景：

 现在有四种运算策略，分别是加减乘除，现在我需要前台传一个kind进来，我就要得到相应的策略；

## code

### 前置
常量（测试用）
```java
public interface ArithmeticMessage {

    String add="add Strategy";
    String subtract="subtract Strategy";
    String multiply="multiply Strategy";
    String divide="divide Strategy";
}
```
策略类型
```java
public enum StrategyEnum {

  add(01,"add"),subtract(02,"subtract"),multiply(03,"multiply"),divide(04,"divide");

    int code;
    String strategyType;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getStrategyType() {
        return strategyType;
    }

    public void setStrategyType(String strategyType) {
        this.strategyType = strategyType;
    }

    StrategyEnum(int code, String strategyType) {
        this.code = code;
        this.strategyType = strategyType;
    }

}
```
### 策略
运算策略上层接口
```java
public interface ArithmeticService {

    /**
     * 解决策略
     * @return
     */
    String arithmetic();

    /**
     * 类型绑定
     * @return
     */
    String getStrategy();
```
加法策略
```java
@Service
public class AddService implements ArithmeticService{

    public String arithmetic() {
        return ArithmeticMessage.add;
    }

    public String getStrategy() {
        return StrategyEnum.add.getStrategyType();
    }

}
```
减法策略
```java
@Service
public class SubtractService implements ArithmeticService{

    public String arithmetic() {
        return ArithmeticMessage.subtract;
    }

    public String getStrategy() {
        return StrategyEnum.subtract.getStrategyType();
    }
}
```
乘法策略
```java
@Service
public class MultiplyService implements ArithmeticService{
    public String arithmetic() {
        return ArithmeticMessage.multiply;
    }

    public String getStrategy() {
        return StrategyEnum.multiply.getStrategyType();
    }
}
```
除法策略
```java
@Service
public class DivideService implements ArithmeticService{
    public String arithmetic() {
        return ArithmeticMessage.divide;
    }

    public String getStrategy() {
        return StrategyEnum.divide.getStrategyType();
    }
}
```
### 内核
核心类（简单工厂的变相 <font color="red"> maybe </font>）
```java
@Component
public class StrategyManage implements InitializingBean, ApplicationContextAware {

    private ApplicationContext context;
    private static ConcurrentHashMap<String, ArithmeticService> map = new ConcurrentHashMap<String, ArithmeticService>();

    /**
     * 获取策略
     */
    public static ArithmeticService getArithmetic(StrategyEnum strategyKind) {
        return map.get(strategyKind.getStrategyType());
    }

    /**
     * Spring启动后，初始化Bean时，若该Bean实现InitializingBean接口，会自动调用afterPropertiesSet()方法，完成一些用户自定义的初始化操作。
     *
     * @throws Exception
     */
    public void afterPropertiesSet() throws Exception {
        Map<String, ArithmeticService> beans = context.getBeansOfType(ArithmeticService.class);
        for (ArithmeticService arithmeticService : beans.values()) {
            map.put(arithmeticService.getStrategy(), arithmeticService);
        }
    }


    /**
     * Spring发现某个Bean实现了ApplicationContextAware接口，Spring容器会在创建该Bean之后，
     * 自动调用该Bean的setApplicationContext（参数）方法，调用该方法时，会将容器本身ApplicationContext对象作为参数传递给该方法。
     *
     * @param applicationContext
     * @throws BeansException
     */
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.context = applicationContext;
    }
}
```
### 测试
Test
```java
@SpringBootTest
public class StrategyTest {

    @org.junit.jupiter.api.Test
    public void test(){
        System.out.println(StrategyManage.getArithmetic(StrategyEnum.add).arithmetic());
        System.out.println(StrategyManage.getArithmetic(StrategyEnum.subtract).arithmetic());
        System.out.println(StrategyManage.getArithmetic(StrategyEnum.multiply).arithmetic());
        System.out.println(StrategyManage.getArithmetic(StrategyEnum.divide).arithmetic());
    }
}
```
Result

![image-20220507154310705](/Users/xiaotan/Library/Application Support/typora-user-images/image-20220507154310705.png)

