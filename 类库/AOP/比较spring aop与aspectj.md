## 比较spring aop与aspectj

### AOP概念

- **Aspect切面**：一个分布在应用程序中多个位置的标准代码/功能，通常与实际的业务逻辑（例如事务管理）不同。 每个切面都侧重于一个特定的横切功能。
- **Joinpoint连接点**：这是程序执行中的特定点，如方法执行，构调用造函数或字段赋值等。
- **Advice通知**：在一个连接点中，切面采取的行动。通知提供了在AOP中需要在切入点所选择的连接点处进行扩展现有行为的手段；包括前置通知（before advice）、后置通知(after advice)、环绕通知（around advice）。
- **Pointcut切点**：一个匹配连接点的正则表达式。 每当任何连接点匹配一个切入点时，就执行与该切入点相关联的指定通知。
- **Weaving织入**：链接切面和目标对象来创建一个通知对象的过程。
- **Target Object**: 需要被织入横切关注点的对象，即该对象是切入点选择的对象，需要被通知的对象，从而也可称为被通知对象。

通知类型:

- **前置通知（Before advice）**：在某连接点之前执行的通知，但这个通知不能阻止连接点之前的执行流程（除非它抛出一个异常）。

- **后置通知（After returning advice）**：在某连接点正常完成后执行的通知：例如，一个方法没有抛出任何异常，正常返回。

- **异常通知（After throwing advice）**：在方法抛出异常退出时执行的通知。

- **最终通知（After (finally) advice）**：当某连接点退出的时候执行的通知（不论是正常返回还是异常退出）。

- **环绕通知（Around Advice）**：包围一个连接点的通知，如方法调用。这是最强大的一种通知类型。环绕通知可以在方法调用前后完成自定义的行为。它也会选择是否继续执行连接点或直接返回它自己的返回值或抛出异常来结束执行。

### spring aop vs aspectj

#### Capabilities and Goals

简而言之，Spring AOP和AspectJ有不同的目标。Spring AOP旨在通过Spring IoC提供一个简单的AOP实现，以解决编码人员面临的最常出现的问题。这并不是完整的AOP解决方案，它只能用于**Spring容器管理的beans**。另一方面，AspectJ是最原始的AOP实现技术，提供了玩这个的AOP解决方案。AspectJ更为健壮，相对于Spring AOP也显得更为复杂。值得注意的是，AspectJ能够被应用于**所有的领域对象**。在Spring 2.0使用了和AspectJ 5一样的注解，并使用AspectJ来做切入点解析和匹配。但是，AOP在运行时仍旧是纯的Spring AOP，并不依赖于AspectJ的编译器或者织入器(weaver)。

#### Weaving

AspectJ and Spring AOP使用了不同的织入方式，这影响了他们在性能和易用性方面的行为。  
AspectJ使用了三种不同类型的织入：

* 编译时织入：AspectJ编译器同时加载我们切面的源代码和我们的应用程序，并生成一个织入后的类文件作为输出。
* 编译后织入：这就是所熟悉的二进制织入。它被用来编织现有的类文件和JAR文件与我们的切面。
* 加载时织入：这和之前的二进制编织完全一样，所不同的是织入会被延后，直到类加载器将类加载到JVM。
  AspectJ使用的是编译期和类加载时进行织入，Spring AOP利用的是运行时织入。运行时织入，在使用目标对象的代理执行应用程序时，编译这些切面（使用JDK动态代理或者CGLIB代理）。

<img src="..\..\picture service\类库\aop\1.png">

#### Internal Structure and Application

Spring AOP 是一个基于代理的AOP框架。这意味着，要实现目标对象的切面，将会创建目标对象的代理类。这可以通过下面两种方式实现：

- JDK动态代理：Spring AOP的首选方法。 每当目标对象实现一个接口时，就会使用JDK动态代理，内部使用**反射实现**。
- CGLIB代理：如果目标对象没有实现接口，则可以使用CGLIB代理，内部使用**字节码增强框架ASM**。

另一方面，AspectJ在运行时不做任何事情，类和切面是直接编译的。因此，不同于Spring AOP，他不需要任何设计模式。织入切面到代码中，它引入了自己的编译期，称为AspectJ compiler (ajc)。通过它，我们编译应用程序，然后通过提供一个小的（<100K）运行时库运行它。

<img src="..\..\picture service\类库\aop\2.png">

#### Joinpoints

Spring AOP基于代理模式。因此，它需要目标类的子类，并相应的应用横切关注点。但是也伴随着局限性，我们不能跨越“final”的类来应用横切关注点（或切面），因为它们不能被覆盖，从而导致运行时异常。同样地，也不能应用于静态和final的方法。由于不能覆写，Spring的切面不能应用于他们。因此，Spring AOP由于这些限制，只支持执行方法的连接点。然而，AspectJ在运行前将横切关注点直接织入实际的代码中。 与Spring AOP不同，它不需要继承目标对象，因此也支持其他许多连接点。AspectJ支持如下的连接点：

| Joinpoint                    | Spring AOP Supported | AspectJ Supported |
| ---------------------------- | -------------------- | ----------------- |
| Method Call                  | No                   | Yes               |
| Method Execution             | Yes                  | Yes               |
| Constructor Call             | No                   | Yes               |
| Constructor Execution        | No                   | Yes               |
| Static initializer execution | No                   | Yes               |
| Object initialization        | No                   | Yes               |
| Field reference              | No                   | Yes               |
| Field assignment             | No                   | Yes               |
| Handler execution            | No                   | Yes               |
| Advice execution             | No                   | Yes               |

同样值得注意的是，在Spring AOP中，切面不适用于同一个类中调用的方法。这很显然，当我们在同一个类中调用一个方法时，我们并没有调用Spring AOP提供的代理的方法。如果我们需要这个功能，可以在不同的beans中定义一个独立的方法，或者使用AspectJ。

#### Simplicity

Spring AOP显然更加简单，因为它没有引入任何额外的编译期或在编译期织入。它使用了运行期织入的方式，因此是无缝集成我们通常的构建过程。尽管看起来很简单，Spring AOP只作用于Spring管理的beans。然而，使用AspectJ，我们需要引入AJC编译器，重新打包所有库（除非我们切换到编译后或加载时织入）。这种方式相对于前一种，更加复杂，因为它引入了我们需要与IDE或构建工具集成的AspectJ Java工具（包括编译器（ajc），调试器（ajdb），文档生成器（ajdoc），程序结构浏览器（ajbrowser））。

#### Performance

考虑到性能问题，编译时织入比运行时织入快很多。Spring AOP是基于代理的框架，因此应用运行时会有目标类的代理对象生成。另外，每个切面还有一些方法调用，这会对性能造成影响。
AspectJ不同于Spring AOP，是在应用执行前织入切面到代码中，没有额外的运行时开销。由于以上原因，AspectJ经过测试大概8到35倍快于Spring AOP。

### 总结

| Spring AOP            | AspectJ                              |
| --------------------- | ------------------------------------ |
| 用纯Java实现              | 使用Java编程语言的扩展实现                      |
| 无需单独的编译过程             | 需要 AspectJ 编译器 (ajc)，除非设置了 LTW       |
| 仅运行时编织可用              | 运行时编织不可用。支持编译时、编译后和加载时 Weaving       |
| 功能较弱 – 仅支持方法级别编织      | 更强大——可以编织字段、方法、构造函数、静态初始化器、最终类/方法等…… |
| 只能在Spring容器管理的bean上实现 | 可以在所有域对象上实现                          |
| 仅支持方法执行切入点            | 支持所有切入点                              |
| 代理是由目标对象创建的，切面应用于这些代理 | 在执行应用程序之前（运行时之前），方面直接编织到代码中          |
| 比 AspectJ 慢很多         | 更好的性能                                |
| 易于学习和应用               | 比 Spring AOP 相对复杂一些                  |