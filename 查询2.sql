#进阶2： 条件查询
/*
语法：
	select
		查询列表    执行3
	from
		表名       执行1
	where
		筛选条件;   执行2
        
分类：
	一、按条件表达式筛选
	条件运算符： > < = != <> >= <=
    二、按逻辑表达式筛选
	逻辑运算符：
		&& || !
        and or not    
    三、模糊查询
		like
        between and
        in
        is null        
*/
#一、按条件表达式筛选

#案例1： 查询工资>12000的员工信息
SELECT 
    *
FROM
    employees
WHERE
    salay > 12000;

#案例2： 查询部门编号不等于90号的员工名和部门编号
SELECT 
    last_name, department_id
FROM
    employees
WHERE
    department_id <> 90;
#   department_id != 90;

#二、按逻辑表达式筛选

#案例1： 查询工资在10000到20000之间的员工名、工资以及奖金
SELECT 
    last_name, salary, commission_pct
FROM
    employees
WHERE
    salary >= 10000 AND salary <= 20000;
    
#案例2： 查询部门编号不是在90到110之间，或者工资高于15000的员工信息
SELECT 
    *
FROM
    employees
WHERE
    NOT (department_id >= 90
        AND department_id <= 110)
        OR salary > 15000;

#三、模糊查询
#1.like
/*
	1.一般和通配符搭配使用
		% 任意多个字符
        _ 任意单个字符
*/

#案例1：查询员工名中包含字符a的员工信息
SELECT 
    *
FROM
    employees
WHERE
    last_name LIKE '%a%';
#案例2：查询员工名中第三个字符为n，第五个字符为l的员工名和工资
SELECT 
    last_name, salary
FROM
    employees
WHERE
    last_name LIKE '__n_l%';
#案例3：查询员工命中第二个字符为下划线(_)的员工名
SELECT 
    last_name
FROM
    employees
WHERE
    last_name LIKE '_\_%';

#2.between and
/*
	1. 使用between and可以提高语句的简洁度
    2. 包含临界值
    3. 不能调换顺序
*/
#案例1： 查询员工编号在100到120之间的员工信息
SELECT 
    *
FROM
    employees
WHERE
    employee_id BETWEEN 100 AND 120;

#3.in
/*
含义： 判断某字段的值是否属于in列表中的某一项

	1. 使用in提高语句简洁度
    2. in列表的值类型必须统一或兼容
    3. 不支持模糊查询
*/
#案例1： 查询员工的工种编号是 IT_PROG、AD_VP、AD_PRES 中的一个的员工名和工种编号
SELECT 
    last_name, job_id
FROM
    employees
WHERE
    job_id IN ('IT_PROG' , 'AD_VP', 'AD_PRES');

#4.is null

#案例1： 查询没有奖金的员工名和奖金率
SELECT 
    last_name, commission_pct
FROM
    employees
WHERE
    commission_pct IS NULL;
    
#安全等于 <=>
SELECT 
    last_name, commission_pct
FROM
    employees
WHERE
    commission_pct <=> NULL;
    
#案例2： 查询工资为12000的员工信息
SELECT 
    last_name, salary
FROM
    employees
WHERE
    salary <=> 12000;

#查询员工号为176的员工姓名和部门号和年薪
SELECT 
    last_name,
    department_id,
    salary * 12 * (1 + IFNULL(commission_pct, 0)) AS 年薪
FROM
    employees
WHERE
    employee_id = '176';
    
# 查询没有奖金，且工资小于18000的salary，last_name
SELECT 
    salary, last_name
FROM
    employees
WHERE
    commission_pct IS NULL
        AND salary < 18000;
# 查询employees表中job_id不为'IT'或工资等于12000的员工信息
SELECT 
    *
FROM
    employees
WHERE
    job_id <> 'IT' OR salary = 12000;
    
# 查询departments表的结构
desc departments;