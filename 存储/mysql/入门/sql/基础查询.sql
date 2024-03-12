#进阶1:基础查询
/*
select 查询列表 from 表名;

特点：
1.查询列表可以是:表中的字段、常量值、表达式、函数
2.查询的结果是一个虚拟的表格

*/

#使用指定的数据库
USE myemployees;

#1.查询表中的单个字段
SELECT last_name FROM employees;

#2.查询表中的多个字段
SELECT last_name,salary,email FROM employees;

#3.查询表中的所有字段
SELECT * FROM employees;

#4.查询常量值
SELECT 100;
SELECT 'john';

#5.查询表达式
SELECT 100*96;
SELECT 100%98;

#6.查询函数
SELECT VERSION();   #版本

#7.起别名
#方式1 AS
SELECT 100%98 AS 余数;
SELECT last_name AS 姓,first_name AS 名 FROM employees;

#方式2 空格
SELECT last_name 姓,first_name 名 FROM employees;

#当别名中有关键字时,用双引号(mysql推荐)或单引号括起来
SELECT salary  "out put" FROM employees;

#8.去重 distinct
#案例:查询员工表中所有的部门编号
SELECT DISTINCT department_id FROM employees;

#9.+号的作用
/*
mysql中的+号:
仅仅只有一个功能:运算符
*/
#案例:查询员工名和姓连接成一个字段，并显示为姓名
SELECT last_name+first_name AS 姓名 FROM employees;  #结果不行

#正确	
SELECT CONCAT(last_name," ",first_name) AS 姓名 FROM employees;

#10.显示表department的结构
DESC departments;

#显示表employees中的全部列，各个列之间有逗号连接,列头显示为out put
SELECT CONCAT(first_name,",",last_name,",",job_id,",",commission_pct) AS "out put" FROM employees #结果为NULL，应为commission_pct有可能为NULL

#ifnull()：参数1:可能为NULL的列名	参数2：为空时，改为此数
SELECT CONCAT(first_name,",",last_name,",",job_id,",",IFNULL (commission_pct,0)) AS "out put" FROM employees