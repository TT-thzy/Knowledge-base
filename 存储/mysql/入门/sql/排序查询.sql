#进阶查询3：排序查询
/*
	语法:
		select 查询列表 from 表名
		where 筛选条件
		order by 排序列表 [ASC OR DESC]
		
	特点:
	1.ASC：升序
	  DESC：降序
	 
	2.默认是升序
	
	3.order by 可以支持单个字段，多个字段，表达式，函数，别名
	
	4.order by 子句一般放到查询语句最后面,limit子句除外
*/
USE myemployees

#查询员工信息,要求工资从高到低排序
SELECT * FROM employees ORDER BY salary DESC;
#低到高
SELECT * FROM employees ORDER BY salary ASC;

#查询部门编号大于等于90的员工信息,按入职时间的先后进行排序
SELECT * FROM employees 
WHERE department_id>=90
ORDER BY hiredate ASC;

#按年薪的高低显示员工的信息和年薪（按表达式排序）
SELECT *,salary*12*(1+IFNULL(commission_pct,0)) AS 年薪
FROM employees
ORDER BY salary*12*(1+IFNULL(commission_pct,0)) DESC;

#按年薪的高低显示员工的信息和年薪（按别名排序）
SELECT *,salary*12*(1+IFNULL(commission_pct,0)) AS 年薪
FROM employees
ORDER BY 年薪 DESC;

#按姓名的长度显示员工的姓名和工资(按函数排序)
SELECT last_name,salary FROM employees
ORDER BY LENGTH(last_name) DESC;

#查询员工信息,要求先按工资排序,(如果工资相同)再按员工编号排序
SELECT * FROM employees
ORDER BY salary ASC,employee_id DESC;