#进阶7： 子查询
/*
含义：
	出现在其他语句中的select语句，称为子查询或内查询
    外部的查询语句，称为主查询或外查询
分类：
	1. 按子查询出现的位置分类
		select后面 ：
			A. 标量子查询
        from后面 ：
			D. 表子查询
        where或having后面： ※重点
			A. 标量子查询（单行） √
            B. 列子查询（多行） √
            C. 行子查询（使用较少）
        exists后面（相关子查询）
			D. 表子查询
	2. 按结果集的行列数不同分类
		A. 标量子查询（结果集只有一行一列）
        B. 列子查询（结果集只有一列多行） 或称为 多行子查询
        C. 行子查询（结果集有一行多列）
        D. 表子查询（结果集一般为多行多列）
*/
#示例：
	SELECT 
    first_name
FROM
    employees
WHERE
    department_id IN (SELECT 
            department_id
        FROM
            departments
        WHERE
            location_id = 700);

#一、where或having后面
#1.标量子查询（单行子查询）
#2.列子查询（多行子查询）
#3.行子查询（多列多行）
/*
特点：
	1.子查询放在小括号内
    2.子查询一般放在条件右侧
    3.标量子查询一般搭配单行操作符使用
		> < <= >= = <>
	4.列子查询一般搭配多行操作符使用
		in, any/some, all
	5.子查询是优先于主查询执行的
非法使用标量子查询的情况：
	1. 单行操作符后对象为列子查询
    2. 单行操作符后对象为null
*/
#1.标量子查询
#案例1. 谁的工资比Abel高？
SELECT 
    *
FROM
    employees
WHERE
    salary > (SELECT 
            salary
        FROM
            employees
        WHERE
            last_name = 'Abel');
#案例2. 返回job_id与141号员工相同，salary比143号员工多的员工
SELECT 
    *
FROM
    employees
WHERE
    job_id = (SELECT 
            job_id
        FROM
            employees
        WHERE
            employee_id = '141')
        AND salary > (SELECT 
            salary
        FROM
            employees
        WHERE
            employee_id = '143');
#案例3. 返回公司工资最少的员工的last_name, job_id和salary
SELECT 
    last_name, job_id, salary
FROM
    employees
WHERE
    salary = (SELECT 
            MIN(salary)
        FROM
            employees);
#案例4. 查询最低工资大于50号部门最低工资的部门id和其最低工资
SELECT 
    department_id, MIN(salary)
FROM
    employees
GROUP BY department_id
HAVING MIN(salary) > (SELECT 
        MIN(salary)
    FROM
        employees
    WHERE
        department_id = '50');
#2. 列子查询（多行子查询）
# in, not in, any, some, all
# any, some, all可以被min, max取代而替换为标量子查询
# in 可以替换为 = any, not in 可以替换为 <> all
#案例1. 查询location_id是1400或1700的部门中所有员工姓名
SELECT 
    last_name
FROM
    employees
WHERE
    department_id IN (SELECT DISTINCT
            department_id
        FROM
            departments
        WHERE
            location_id IN ('1400' , '1700'));
#案例2. 返回其它工种中比job_id为'IT_PROG'部门【任一】工资低的员工的员工号、姓名、job_id、以及salary
SELECT 
    employee_id, last_name, job_id, salary
FROM
    employees
WHERE
    salary < ANY (SELECT DISTINCT
            salary
        FROM
            employees
        WHERE
            job_id = 'IT_PROG')
        AND job_id <> 'IT_PROG';
#案例3. 返回其它工种中比job_id为'IT_PROG'部门【所有】工资低的员工的员工号、姓名、job_id、以及salary
SELECT 
    employee_id, last_name, job_id, salary
FROM
    employees
WHERE
    salary < ALL (SELECT DISTINCT
            salary
        FROM
            employees
        WHERE
            job_id = 'IT_PROG')
        AND job_id <> 'IT_PROG';
#3. 行子查询（结果一行多列或多行多列）
#案例： 查询员工编号最小并且工资最高的员工信息
SELECT 
    *
FROM
    employees
WHERE
    employee_id = (SELECT 
            MIN(employee_id)
        FROM
            employees)
        AND salary = (SELECT 
            MAX(salary)
        FROM
            employees);
SELECT 
    *
FROM
    employees
WHERE
    (employee_id , salary) = (SELECT 
            MIN(employee_id), MAX(salary)
        FROM
            employees);

#二、select后面
/*
仅支持标量子查询
*/
#案例： 查询每个部门的员工个数（表内并没有这个字段）
#用连接查询也可以做
SELECT 
    d.*,
    (SELECT 
            COUNT(*)
        FROM
            employees e
        WHERE
            e.department_id = d.department_id) AS employee_num
FROM
    departments d;
#案例2. 查询员工号=102的部门名
SELECT 
    (SELECT 
            department_name
        FROM
            departments d
        WHERE
            d.department_id = e.department_id) AS department_name
FROM
    employees e
WHERE
    e.employee_id = 102;
    
    use mamalrelationship;
SELECT 
    girls.*,
    (SELECT 
            boyName
        FROM
            boys
        WHERE
            boys.id = girls.boyfriend_id)
FROM
    girls
WHERE
    id > 3;
    
#三、from后面
/*
将子查询结果充当一张表，要求必须起别名
*/
#案例： 查询每个部门的平均工资的工资等级

SELECT 
    AVG(salary) AS avgSal, department_id
FROM
    employees
GROUP BY department_id;

SELECT 
    *
FROM
    job_grades;
    
SELECT 
    a.*, j.grade_level
FROM
    (SELECT 
        AVG(salary) AS avgSal, department_id
    FROM
        employees
    GROUP BY department_id) AS a
        INNER JOIN
    job_grades AS j ON a.avgSal BETWEEN j.lowest_sal AND j.highest_sal;
    
#四、exists后面（相关子查询）
/*
语法：
	exists(完整的查询语句)
结果：
	子查询的结果有没有值 有：1 没有：0
*/
SELECT 
    EXISTS( SELECT 
            employee_id
        FROM
            employees);
#案例1. 查询有员工的部门名
SELECT 
    department_name
FROM
    departments
WHERE
    EXISTS( SELECT 
            *
        FROM
            employees e
        WHERE
            e.department_id = departments.department_id);
SELECT 
    department_name
FROM
    departments d
WHERE
    d.department_id IN (SELECT DISTINCT
            department_id
        FROM
            employees);
#案例2. 查询没有女朋友的男神信息
SELECT 
    boys.*
FROM
    boys
WHERE
    NOT EXISTS( SELECT 
            girls.id
        FROM
            girls
        WHERE
            girls.boyfriend_id = boys.id);
#1.
SELECT 
    last_name, salary
FROM
    employees
WHERE
    department_id = (SELECT 
            department_id
        FROM
            employees
        WHERE
            last_name = 'Zlotkey');
#2.
SELECT 
    employee_id, last_name, salary
FROM
    employees
WHERE
    salary > (SELECT 
            AVG(salary)
        FROM
            employees);
#3.
SELECT 
    employee_id, last_name, salary
FROM
    employees
WHERE
    salary > (SELECT 
            avgDep.avgSal
        FROM
            (SELECT 
                AVG(salary) AS avgSal, department_id
            FROM
                employees
            GROUP BY department_id) AS avgDep
        WHERE
            department_id = avgDep.department_id);
SELECT 
    e.employee_id, e.last_name, e.salary
FROM
    employees e
        LEFT OUTER JOIN
    (SELECT 
        AVG(salary) AS avgSal, department_id
    FROM
        employees
    GROUP BY department_id) AS avgDep ON e.department_id = avgDep.department_id
WHERE
    e.salary > avgDep.avgSal;
#4.
SELECT 
    e.employee_id,
    e.last_name,
    e.department_id,
    u_dep.last_name,
    u_dep.department_id
FROM
    employees AS e
        LEFT OUTER JOIN
    (SELECT 
        department_id, last_name
    FROM
        employees
    WHERE
        last_name LIKE '%u%') AS u_dep ON e.department_id = u_dep.department_id;
        
SELECT 
    employee_id, last_name, department_id
FROM
    employees
WHERE
    department_id IN (SELECT 
            department_id
        FROM
            employees
        WHERE
            last_name LIKE '%u%');
#5.
SELECT 
    employee_id, department_id
FROM
    employees
WHERE
    department_id IN (SELECT 
            department_id
        FROM
            departments
        WHERE
            location_id = '1700');
#6
SELECT 
    last_name, salary
FROM
    employees
WHERE
    manager_id IN (SELECT 
            employee_id
        FROM
            employees
        WHERE
            last_name = 'King');
#7
SELECT 
    CONCAT(last_name, '.', first_name) AS '姓.名'
FROM
    employees
WHERE
    salary = (SELECT 
            MAX(salary)
        FROM
            employees);