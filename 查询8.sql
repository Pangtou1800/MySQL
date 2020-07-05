#二、SQL99語法
/*
語法：
	select 查詢列表
    from 表1 as 別名 【連接類型】
	join 表2 as 別名
    on 連接條件
    【where 篩選條件】
    【group by 分組】
    【having 篩選條件】
    【order by 排序列表】

分類：
	内連接 （★） ： inner
	外連接
		左外 （★） ： left 【outer】
		右外 （★） ： right 【outer】
		全外 ： full 【outer】
	交叉連接 ： cross
*/

#一） 内連接
/*
語法：
	select 查詢列表
    from 表1 as 別名
    inner join 表2 as 別名
    on 連接條件;
    
分類：
	等值連接 #与SQL92语法的等值连接效果完全相同
    非等值連接
	自連接

特点：
	·添加排序、分组、筛选
    ·关键字inner可以省略
    ·筛选条件放在where后面，连接条件放在on后面，提高分离性，便于阅读
    ·inner join连接和SQL92语法中的等值连接效果一样，都是查询多表的交集部分
*/
#1. 等值连接
#案例1. 查询员工名，部门名
SELECT 
    last_name, department_name
FROM
    employees AS e
        INNER JOIN
    departments AS d ON e.department_id = d.department_id;
#案例2. 查询名字中包含'e'的员工名和工种名【筛选】
SELECT 
    last_name, job_title
FROM
    employees AS e
        INNER JOIN
    jobs AS j ON e.job_id = j.job_id
WHERE
    last_name LIKE '%e%';
#案例3. 查询部门个数>3的城市名和部门个数【分组+筛选】
SELECT 
    COUNT(*) AS depart_num, city
FROM
    departments AS d
        INNER JOIN
    locations AS l ON d.location_id = l.location_id
GROUP BY city
HAVING COUNT(*) > 3;
#案例4. 查询哪个部门的部门员工个数>3的部门名和员工个数，并按个数降序【添加排序】
SELECT 
    department_name, COUNT(*) AS employee_num
FROM
    departments AS d
        INNER JOIN
    employees AS e ON d.department_id = e.department_id
GROUP BY department_name
HAVING COUNT(*) > 3
ORDER BY employee_num DESC;
#案例5. 查询员工名、部门名、工种名，并按部门名降序【添加三表连接】
SELECT 
    last_name, department_name, job_title
FROM
    employees AS e
        INNER JOIN
    departments AS d ON e.department_id = d.department_id
        INNER JOIN
    jobs AS j ON e.job_id = j.job_id
ORDER BY department_name DESC;
#2. 非等值连接
#案例1. 查询员工的工资级别
SELECT 
    last_name, salary, grade_level
FROM
    employees AS e
        INNER JOIN
    job_grades AS g ON salary BETWEEN lowest_sal AND highest_sal;
#案例2. 查询每个工资级别的个数>2的个数，并且按工资级别降序
SELECT 
    COUNT(*) AS grade_num, grade_level
FROM
    employees
        INNER JOIN
    job_grades ON salary BETWEEN lowest_sal AND highest_sal
GROUP BY grade_level
HAVING COUNT(*) > 2
ORDER BY grade_level DESC;
#3. 自连接
#案例1. 查询姓名中包含字符'K'的员工的名字和上级的名字
SELECT 
    e.last_name, m.last_name
FROM
    employees AS e
        INNER JOIN
    employees AS m ON e.manager_id = m.employee_id
WHERE
    e.last_name LIKE '%K%';

#二） 外連接
/*
应用场景： 用于查询一个表中有，另一个表中没有的数据
特点：
	1. 外连接的查询特点为主表中的所有记录
		如果有从表中和它匹配的，则显示匹配的值
        如果从表中没有和它匹配的，则显示null => 剔除时以主键做条件更佳
        外连接查询结果=内连接结果+主表中有而从表中没有的记录
	2. 左外连接中，left join左边的是主表；右外连接中，right join右边的是主表
    3. 左外和右外交换两个表的顺序，可以实现同样的效果
    4. 全外连接=内连接的结果+表1中有而表2没有+表2中有而表1中没有
    5. 交叉连接就是笛卡尔乘积
*/
#引入: 查询男朋友不在男神表的女神
use mamalrelationship;
SELECT 
    *
FROM
    girls;
SELECT 
    *
FROM
    boys;
SELECT 
    name, boyName
FROM
    girls
        LEFT OUTER JOIN
    boys ON boyfriend_id = boys.id;
#案例1. 查询哪个部门没有员工【左外】
SELECT 
    department_name, COUNT(*) AS employee_num
FROM
    departments AS d
        LEFT OUTER JOIN
    employees AS e ON d.department_id = e.department_id
group by department_name
having employee_num = 0;
#案例2. 查询哪个部门没有员工【右外】
SELECT 
    department_name, COUNT(*) AS employee_num
FROM
    employees AS e
        RIGHT OUTER JOIN
    departments AS d ON e.department_id = d.department_id
GROUP BY department_name
HAVING employee_num = 0;
#全外
/*
select girls.*, boys.*
from girls
full outer join girls.boyfriend_id = boys.id;
*/
#交叉连接
use mamalrelationship;
SELECT 
    girls.*, boys.*
FROM
    girls
        CROSS JOIN
    boys;
SELECT 
    girls.*, boys.*
FROM
    girls
        INNER JOIN
    boys;
#SQL92 P.K. SQL99
#功能： SQL99功能更多
#可读性： SQL99分离性强，可读性更高
/*
[a ( o ) b]
取o： 内连接
取a+o： 左外，a做主表
取b+o: 右外，b做主表
取a: 左外+b主键 is null
取b： 右外+a主键 is null
取a+o+b： 全外
取a+b: 全外+a主键 is null or b主键 is null
*/
#1.
SELECT 
    girls.name, boys.*
FROM
    girls
        LEFT OUTER JOIN
    boys ON girls.boyfriend_id = boys.id
WHERE
    girls.id > 3;
#2.
use test;
SELECT 
    city, department_name
FROM
    locations AS l
        JOIN
    departments AS d ON l.location_id = d.location_id
WHERE
    d.department_id IS NULL;
#3.
SELECT 
    e.*, department_name
FROM
    employees AS e
        INNER JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    department_name IN ('SAL' , 'IT'); 
#won't get a result if 'SAL' doesn't have any employees
SELECT 
    department_name, e.*
FROM
    employees AS e
        RIGHT OUTER JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    department_name IN ('SAL' , 'IT');
