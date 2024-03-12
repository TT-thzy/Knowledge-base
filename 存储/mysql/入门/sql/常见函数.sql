#进阶4：常见函数

/*

概念：类似于java的方法，将一组逻辑语句封装在方法体中，对外暴露方法名
好处：1、隐藏了实现细节  2、提高代码的重用性
调用：select 函数名(实参列表) 【from 表】;
特点：
	①叫什么（函数名）
	②干什么（函数功能）

分类：
	1、单行函数
	如 concat、length、ifnull等
	2、分组函数
	
	功能：做统计使用，又称为统计函数、聚合函数、组函数
	
常见函数：
	一、单行函数
	字符函数：
	length:获取字节个数(utf-8一个汉字代表3个字节,gbk为2个字节)
	concat
	substr
	instr
	trim
	upper
	lower
	lpad
	rpad
	replace
	
	数学函数：
	round
	ceil
	floor
	truncate
	mod
	
	日期函数：
	now
	curdate
	curtime
	year
	month
	monthname
	day
	hour
	minute
	second
	str_to_date
	date_format
	其他函数：
	version
	database
	user
	控制函数
	if
	case	

*/

USE myemployees

#一、字符函数

#1.length()获取参数值的字节个数
SELECT LENGTH('john');
SELECT LENGTH('张三分hahaha'); #utf8:中文占三个字符	gbk:中文站两个字符

SHOW VARIABLES LIKE '%char%';#显示字符集

#2.concat()拼接字符
SELECT CONCAT(last_name,' ',first_name) AS 姓名 FROM employees;

#3.upper、lower大小写
SELECT UPPER('i like you');
SELECT LOWER('I LOVE YOU');
#将姓名变大写,名字变小写，然后连接
SELECT CONCAT(UPPER(first_name),' ',LOWER(last_name)) FROM employees;

#4.substr or substring 截取指定字符串
#索引位置从1开始
#截取从指定索引出后面所有的字符
SELECT SUBSTR('李莫愁爱上了陆展元',7) AS out_put;
#截取从指定索引处指定的字符长度的字符
SELECT SUBSTR('李莫愁爱上了陆展元',1,3) AS out_put;

#5.instr返回子串第一次出现的索引,如果找不到返回0
SELECT INSTR('李莫愁爱上了陆展元','陆展元');

#6.trim去除前后空格
SELECT TRIM('      张翠山       ');
#去除前后的指定字符
SELECT TRIM('a' FROM 'aaaaaa张a三a丰aaaaaa');

#7.lpad用指定字符实现左填充指定长度
SELECT LPAD('殷素素',10,'*');
SELECT LPAD('殷素素',2,'*');

#8.rpad用指定字符实现由填充指定长度
SELECT RPAD('殷素素',12,'*');

#二、数学函数

#1.round 四舍五入
SELECT ROUND(-1.55);
SELECT ROUND(1.55);
SELECT ROUND(1.578,2);

#2.ceil向上取整,返回>=该参数的最小整数
SELECT CEIL(1.52);
SELECT CEIL(-1.52);


#3.floor向下取整,返回<=该参数的最大整数
SELECT FLOOR(1.52);
SELECT FLOOR(-1.52);

#4.truncate 截断
SELECT TRUNCATE(1.6999,1);

#mod取余
/*
	mod(a,b):a-a/b*b
*/
SELECT MOD(10,-3);
SELECT MOD(-10,3);

#三、日期函数

#1.now 返回当前系统日期和时间
SELECT NOW();

#2.curdate 返回当前系统日期，不包括时间
SELECT CURDATE();
#curtime 返回当前系统时间，不包括日期
SELECT CURTIME();

#可以获取指定的部分
SELECT YEAR(NOW()) AS 年;
SELECT YEAR('1998-1-2') AS 年;
SELECT YEAR(hiredate) AS 年 FROM employees;

SELECT MONTH(NOW()) AS 月;
SELECT MONTHNAME(NOW()) AS 月;  #英文显示月份

#3.str_to_date 将字符通过指定的格式转换成日期
SELECT STR_TO_DATE('1995-3-2','%Y-%c-%d') AS out_put;
#查询入职日期为1992-4-3的员工信息
SELECT * FROM employees WHERE hiredate='1992-4-3';
#查询入职日期为4-3 1992的员工信息
SELECT * FROM employees WHERE hiredate=STR_TO_DATE('4-3 1992','%c-%d %Y');

#date_format 将日期转换成字符
SELECT DATE_FORMAT(NOW(),'%y年%m月%d日');
#查询有奖金的员工名和入职日期(xx月/xx日 xx年)
SELECT last_name,DATE_FORMAT(hiredate,'%m月%d日 %y年') FROM employees
WHERE commission_pct IS NOT NULL;

#四、其他函数
SELECT VERSION();#查看当前版本
SELECT DATABASE();#查看当前数据库
SELECT USER();#查看当前用户

#五、流程控制函数

#1.if函数
SELECT IF(10>5,'大','小');

SELECT last_name,commission_pct,IF(commission_pct IS NULL,'没奖金，呵呵','有奖金,哈哈') AS 备注 FROM employees

#2.case函数的使用一
/*
	语法:
	case 要判断的字段或表达式
	when 常量1 then 要显示的 值1(不需要加分号) 或 语句1;
	when 常量2 then 要显示的 值2 或 语句2;
	when 常量3 then 要显示的 值3 或 语句3;
	···
	else 要显示的值或表达式
	end
*/

#查询员工的工资 要求
/*
部门号为30，显示为原来工资的1.1倍
部门号为40，显示为原来工资的1.2倍
部门号为50，显示为原来工资的1.3倍
其他部门，显示为原来工资
*/
SELECT salary 原始工资,department_id,
CASE department_id
WHEN 30 THEN salary*1.1
WHEN 40 THEN salary*1.2
WHEN 50 THEN salary*1.3
ELSE salary
END AS 新工资
FROM employees

#2.case函数的使用二
/*
	语法:
	case 
	when 条件1 then 要显示的 值1(不需要加分号) 或 语句1;
	···
	else 要显示的值或表达式
	end
*/

#查询员工工资的情况
/*
如果工资>20000，显示级别为A
如果工资>15000，显示级别为B
如果工资>10000，显示级别为C
否则，显示级别为D
*/
SELECT salary,
CASE
WHEN salary>20000 THEN 'A'
WHEN salary>15000 THEN 'A'
WHEN salary>10000 THEN 'A'
ELSE 'D'
END AS 工资级别
FROM employees