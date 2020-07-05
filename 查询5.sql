#二、分组函数
/*
功能： 用作统计使用，又称为聚合函数或统计函数或组函数
分类：
	sum 求和
    avg 平均值
    max 最大值
    min 最小值
    count 计算个数 → 非空值的个数
特点：
	1. sum, avg一般用于处理数值型
    2. max, min, count可以处理任意类型
    3. 以上所有的分组函数都忽略null值
    4. count函数单独介绍
    5. 和分组函数一同查询的字段要求是group by后的字段
*/
#1. 简单使用
SELECT 
    SUM(salary) 和,
    AVG(salary) 平均,
    ROUND(AVG(salary), 2) 平均2,
    MAX(salary) 最大,
    MIN(salary) 最小,
    COUNT(salary) 个数
FROM
    employees;
#2. 参数支持哪些类型
# > 不会报错 没有意义
SELECT 
    SUM(last_name), AVG(last_name)
FROM
    employees;
# > 可以比较就OK
SELECT 
    MAX(last_name), MIN(last_name)
FROM
    employees;
# > 完全OK
SELECT 
    COUNT(last_name), COUNT(commission_pct)
FROM
    employees;
#3. 是否忽略null值
SELECT 
    SUM(commission_pct),
    AVG(commission_pct),
    MAX(commission_pct),
    MIN(commission_pct),
    COUNT(commission_pct)
FROM
    employees;
#sum结果不为null, 故推断null没有参与运算
#同理avg也忽略null值

#4. 和distinct搭配使用
SELECT 
    SUM(DISTINCT salary),
    SUM(salary),
    AVG(DISTINCT salary),
    AVG(salary),
    MAX(DISTINCT salary),
    MAX(salary),
    MIN(DISTINCT salary),
    MIN(salary),
    COUNT(DISTINCT salary),
    COUNT(salary)
FROM
    employees;
    
#5. count函数的详细介绍
#指定列不为空
SELECT 
    COUNT(salary)
FROM
    employees;
#任一列不为空
SELECT 
    COUNT(*), COUNT(1)
FROM
    employees;
#效率： 
#MYISAM存储引擎下，count(*)的效率高 （Ver5.5之前）
#INNODB存储引擎下，count(*)和count(1)的效率差不多，但是都高于count(字段)
select count(null) from employees; #???

#6. 和分组函数一同查询的字段有限制
SELECT 
    AVG(salary), employee_id
FROM
    employees;

#1.
SELECT 
    MAX(salary), MIN(salary), AVG(salary), SUM(salary)
FROM
    employees;
#2.
SELECT 
    DATEDIFF(MAX(hiredate), MIN(hiredate)) AS difference
FROM
    employees;
SELECT DATEDIFF(NOW(), '1992-1-15');
#3.
SELECT 
    COUNT(*)
FROM
    employees
WHERE
    department_id = '90';