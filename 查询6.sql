#进阶5： 分组查询
/*
select column, group_function(column)
from table
[where condition]
[group by group_by_expression]
[order by column];
语法：
	select 分组函数，列（要求出现在group by的后面）
	from 表
	【where 筛选条件】
	group by 分组的列表
    【having 子句】
	【order by 子句】
注意：
	查询列表必须特殊，要求是分组函数和group by后出现的字段
特点：
	1、分组查询中的筛选条件可以分为两类
					数据源			位置
		·分组前筛选	原始表			group by子句前的where中
        ·分组后筛选	分组后的结果集	group by子句后的having中
        
        >分组函数做条件肯定放在having中
        >能用分组前筛选的优先分组前（如：group by字段）
	2、group by子句支持单个字段分组，多个字段分组（多个字段之间用逗号隔开，没有顺序），表达式或函数分组（用得比较少）
    3、也可以添加排序
*/

#引入： 查询每个部门的平均工资

#案例1: 查询每个工种的最高工资
SELECT 
    MAX(salary), job_id
FROM
    employees
GROUP BY job_id;
#案例2： 查询每个位置上的部门个数
SELECT 
    COUNT(*), location_id
FROM
    departments
GROUP BY location_id;
#案例3： 查询邮箱中包含'A'字符的， 每个部门的平均工资 【添加筛选条件】
SELECT 
    AVG(salary), department_id
FROM
    employees
WHERE
    email LIKE '%A%'
GROUP BY department_id;
#案例4： 查询有奖金的每个领导手下员工的最高工资
SELECT 
    MAX(salary), manager_id
FROM
    employees
WHERE
    commission_pct IS NOT NULL
GROUP BY manager_id;
#案例5： 查询哪个部门的员工个数大于2 【添加复杂的筛选条件】
/*
select
	count(*), department_id
from 
	employees
where
	count(*) > 2  ## NG
group by department_id;
*/
#Sol.1
SELECT 
    COUNT(*), department_id
FROM
    employees
GROUP BY department_id
HAVING COUNT(*) > 2;
#Sol.2
SELECT 
    stuffNums, department_id
FROM
    (SELECT 
        COUNT(*) AS stuffNums, department_id
    FROM
        employees
    GROUP BY department_id) AS firstSearch
WHERE
    stuffNums > 2;
#案例6： 查询每个工种有奖金的员工的最高工资大于12000的工种编号和最高工资
SELECT 
    job_id, MAX(salary), AVG(salary)
FROM
    employees
WHERE
    commission_pct IS NOT NULL
GROUP BY job_id
HAVING MAX(salary) > 12000;
#案例7： 查询领导编号大于102的每个领导手下的最低工资>5000的领导编号是哪个，以及其最低工资
SELECT 
    manager_id, MIN(salary)
FROM
    employees
WHERE
    manager_id > '102'
GROUP BY manager_id
HAVING MIN(salary) > 5000;
#案例8： 按员工姓名的长度分组，查询每一组的员工个数，筛选员工个数>5的有哪些 【按表达式或函数分组】
SELECT 
    last_name, LENGTH(last_name), COUNT(*)
FROM
    employees
GROUP BY last_name , LENGTH(last_name)
HAVING COUNT(*) > 5;
#MySQL支持group by和having使用别名，但Oracle以及其他DB会不支持
SELECT 
    last_name, LENGTH(last_name) AS nameLen, COUNT(*) AS cnt
FROM
    employees
GROUP BY last_name , nameLen
HAVING cnt > 5;
#案例9： 查询每个部门每个工种的平均工资 【按多个字段分组】
SELECT 
    AVG(salary), department_id, job_id
FROM
    employees
GROUP BY department_id , job_id;
#案例10： 查询每个部门每个工种的平均工资，并按平均工资高低排序 【添加排序】
SELECT 
    AVG(salary) AS avSal, department_id, job_id
FROM
    employees
WHERE
    department_id > '100'
GROUP BY department_id , job_id
HAVING avSal > 1000
ORDER BY avSal;
#1
 SELECT 
    MAX(salary), MIN(salary), AVG(salary)
FROM
    employees
GROUP BY job_id
ORDER BY job_id;
#2
SELECT 
    MAX(salary) - MIN(salary) difference
FROM
    employees;
#3
SELECT 
    MIN(salary) AS minSal, manager_id
FROM
    employees
WHERE
    manager_id IS NOT NULL
GROUP BY manager_id
HAVING minSal >= 6000;
#4
SELECT 
    department_id, COUNT(*), AVG(salary) AS avgSal
FROM
    employees
GROUP BY department_id
ORDER BY avgSal;
#5
SELECT 
    job_id, COUNT(*) AS stuffNum
FROM
    employees
GROUP BY job_id;