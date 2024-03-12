#进阶2:条件查询
/*
 select 查询列表 from 表名 where 筛选条件；
 
 分类:
	一、按条件表达式筛选（> < = != <= >=）
	二、按逻辑表达式筛选(&& || ! and or not)
		作用:用来连接条件表达式
	三、模糊查询(like, betwwen and, in,is null)
	
*/

USE myemployees
#一、按条件表达式筛选

#查询工资>12000的员工信息
SELECT * FROM employees WHERE salary>12000;

#查询部门编号不等于90号的员工名和部门编号
SELECT first_name,department_id 
FROM employees
WHERE department_id<>90;

#二、按逻辑表达式筛选

#查询工资在10000到20000之间的员工名、工资及奖金
SELECT last_name,salary,commission_pct FROM employees
WHERE salary>=10000 AND salary<=20000;

#查询部门编号不是在90到110之间,或者工资高于15000的员工信息
SELECT * FROM employees
WHERE department_id<90 OR department_id>110 OR salary>15000;

#三、模糊查询
/*
	like
		特点:
		1.一般与通配符配合使用
			通配符:
			%:任意多个字符，包含0个字符
			_:任意单个字符
	between and
		特点:
		1.可以提高代码整洁度
		2.包含临界值(等价于 >= and <=)
		3.顺序不可颠倒
	in
		含义:判断某个字段的值是否属于in列表的其中某一项
		特点:
		1.提高代码整洁度
		2.in列表的值类型必须一致或兼容
	is null(is not null)
*/

#like

#查询员工名中包含字符a的员工信息
SELECT * FROM employees
WHERE last_name LIKE '%a%';

#查询员工名中第三个字符为n，第五个字符为l的员工信息
SELECT * FROM employees
WHERE last_name LIKE '__n_l%';

#查询员工名中第二个字符为_的员工名
#1.\
SELECT last_name FROM employees
WHERE last_name LIKE '_\_%';
#2.ESCAPE
SELECT last_name FROM employees
WHERE last_name LIKE '_$_%'ESCAPE '$';   #ESCAPE:把某个字符设为转义符号

#between and

#查询员工编号在100到120的员工信息
SELECT * FROM employees
WHERE employee_id BETWEEN 100 AND 120;

#in

#查询员工的工种编号为IT_PROG,AD_VP,AD_PRES中的一个员工名和工种编号
SELECT last_name,job_id FROM employees
WHERE job_id IN ('IT_PROG','AD_VP','AD_PRES');

#is null

#查询没有奖金的员工名和奖金率
SELECT last_name,commission_pct FROM employees
WHERE commission_pct IS NULL;

#查询有奖金的员工名和奖金率
SELECT last_name,commission_pct FROM employees
WHERE commission_pct IS NOT NULL;

#安全等于  <=>

#查询没有奖金的员工名和奖金率
SELECT last_name,commission_pct FROM employees
WHERE commission_pct <=> NULL;

#查询工资为12000的员工信息
SELECT * FROM employees
WHERE salary <=> 12000;