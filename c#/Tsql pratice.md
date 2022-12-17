--1，根据这个SQL数据结构，创建对应的数据表（需可重复执行的SQL语句）
--可重复创建表

```sql
drop table if exists dbo.SELLHistory;
create table SELLHistory(
Id int identity(1,1) primary key, --主键
YearMonth nvarchar(20),			--实践
Area nvarchar(20),				--地区
Brand nvarchar(20),				--品牌
Sold decimal(20,2),				--销售量
Stock decimal(20,2)				--库存
);

select * from SELLHistory;

select count(1) from SELLHistory;
```



--2，根据品牌，月份分组，查询每个品牌，每个月份的总销量，平均销量

```sql
select Brand '品牌',YearMonth, sum(Sold) as '总销量',AVG(Sold) as '平均销量'  from SELLHistory group by Brand,YearMonth;
```

--3，根据区域分组，查询每个区域的销售总量与库存总量

```sql
select Area '地区',sum(Sold) '总销量',sum(Stock) '总库存' from SELLHistory group by Area;
```

--4，查询每个区域两个月之间每个品牌的销量增长率		销售增长率=本年销售额/上年销售额-1

```sql
;WITH QUERY AS(
SELECT Brand,YearMonth,sum(Sold) AS CNT FROM dbo.SELLHistory
GROUP BY YearMonth,Brand
)

SELECT X.YearMonth,Y.Brand,ISNULL(X.IncreaseRate,0) FROM 
(SELECT A.Brand,A.YearMonth,CAST((b.CNT-a.CNT) AS DECIMAL(18,2))/CAST(a.CNT AS DECIMAL(18,2)) AS IncreaseRate FROM QUERY A
JOIN QUERY B ON A.Brand=B.Brand AND B.YearMonth=A.YearMonth+1) X 
RIGHT JOIN (SELECT DISTINCT Brand FROM dbo.SELLHistory) Y ON X.Brand=Y.Brand


```



--将小米东南地区的销售量提高

```sql
update SELLHistory set Sold=100000 where Id=57;
```

--5，查询每个区域每个月销量top3的品牌

```sql
SELECT * FROM (
 SELECT X.Area,x.YearMonth,x.Brand,x.CNT,ROW_NUMBER() OVER(PARTITION BY X.Area,x.YearMonth ORDER BY X.CNT DESC) AS RINDEX FROM 
 (
  SELECT Area,YearMonth,Brand,SUM(Sold) AS CNT FROM dbo.SELLHistory GROUP BY Area,YearMonth,Brand
 ) X
) Y WHERE Y.RINDEX<=3
go
```


