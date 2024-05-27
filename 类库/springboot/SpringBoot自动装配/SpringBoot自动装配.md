## SpringBoot自动装配

### 什么是自动装配

> **<mark>定义</mark>**：其实就是boot定义的一套规范，在SPI的设计思想上进行实现；这一套规范规定了boot启动时会去扫描外部引用的jar包中META-INF目录下的spring.factories文件的内容，再将文件配置信息通过反射加载到spring容器中，并执行类中定义的各种行为。而对于外部jar包而言，只要遵循boot的这一套规范，就能将自己的功能装配容器中；
> **<mark>作用</mark>**：优化繁琐的java config;
> **<mark>自动配置生效前提</mark>**：
>     1. 引入了相关依赖
>     2. 没有自定义配置

### 自动装配的原理，如何实现的？

#### 核心组成

在boot项目中，我们想要开启自动配置功能，就必须再启动类上加上@EnableAutoConfiguration注解，该注解是一个复合注解，主要是由以下两个注解组成；

1. @AutoConfigurationPackage

2. @Import(AutoConfigurationImportSelector.class)

> 对于@AutoConfigurationPackage注解而言，顾名思义他的功能就是自动配置包路径，他会将主启动类同级目录下的所有组件加载进一个Map容器中；

> 而@ImportAutoConfigurationImportSelector.class(）注解就是将AutoConfigurationImportSelector类加载进了容器中；而AutoConfigurationImportSelector类就是自动配置的核心，由它将所有的自动配置类按需加载到Map容器中；

#### AutoConfigurationImportSelector实现自动配置活动图

![](C:\Users\uu\AppData\Roaming\marktext\images\2022-09-07-14-34-38-image.png)

#### AutoConfigurationImportSelector.selectImports()主要实现源码

```java
public String[] selectImports(AnnotationMetadata annotationMetadata) { 
    //判断自动装配是否开启 
   if (!isEnabled(annotationMetadata)) {  
      return NO_IMPORTS;  
  }  
  //加载META-INF/spring-autoconfigure-metadata.json下的元数据信息
   AutoConfigurationMetadata autoConfigurationMetadata = AutoConfigurationMetadataLoader.loadMetadata(this.beanClassLoader);  
   //获取@EnableAutoConfiguration注解中的 `exclude` 和 `excludeName`属性
   AnnotationAttributes attributes = getAttributes(annotationMetadata);  
   //获取候选加载的配置信息 META-INF/spring.factories
   List<String> configurations = getCandidateConfigurations(annotationMetadata, attributes);  
   //去除重复的配置信息
   configurations = removeDuplicates(configurations);  
   //获取注解中配置的`exclusion`信息
   Set<String> exclusions = getExclusions(annotationMetadata, attributes);  
   //检查要排除的类是否能被类加载器加载（是否是一个完整的类）
   checkExcludedClasses(configurations, exclusions);  
   //从候选类中移除需要排除的类
   configurations.removeAll(exclusions);  
   //过滤，检查候选配置类上的注解@ConditionalOnClass，如果要求的类不存在，则这个候选类会被过滤不被加载
   configurations = filter(configurations, autoConfigurationMetadata); 
    //广播事件
   fireAutoConfigurationImportEvents(configurations, exclusions);
   //返回要被加载的类数组
   return StringUtils.toStringArray(new AutoConfigurationEntry(configurations, exclusions).getConfigurations());  
}
```
