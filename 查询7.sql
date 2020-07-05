#进阶6： 连接查询
/*
含义： 又称为多表查询，当查询的字段来自多个表时，使用连接查询

笛卡尔乘积： 表1有m行，表2有n行，结果=m*n行
发生原因： 没有有效的连接条件
避免方法： 添加有效的连接条件

分类：
	按年代分类：
		>SQL92标准
			#1 等值连接
				1). 多表等值连接的结果为多表的交集部分
                2). n表连接，至少需要n-1个连接条件
                3). 多表的顺序没有要求
                4). 一般需要为表起别名
                5). 可以搭配前面介绍的所有子句使用，比如排序、分组、筛选
        >SQL99标准 【推荐】 支持 内连接+外连接（左外和右外）+交叉连接
	按功能分类：
		>内连接：
			·等值连接
            ·非等值连接
            ·自连接
		>外连接：
			·左外连接
            ·右外连接
            ·全外连接
		>交叉连接
*/
/* prepare data:
create database mamalRelationship;
show tables from mamalRelationship;
use mamalRelationship;
show tables;
CREATE TABLE girls (
    id INT PRIMARY KEY,
    name VARCHAR(20),
    sex VARCHAR(5),
    borndate DATETIME,
    phone VARCHAR(15),
    photo BLOB,
    boyfriend_id INT
);
desc girls;
select * from girls;
truncate table girls;
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(1,'柳岩','女','1998-02-03 00:00:00','18209876577',null,8);
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(2,'苍老师','女','1987-12-30 00:00:00','18219876577',null,9);
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(3,'Angelababay','女','1989-02-03 00:00:00','18209876567',null,3);
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(4,'热巴','女','1993-02-03 00:00:00','18209876577',null,2);
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(5,'周冬雨','女','1998-02-03 00:00:00','18209876577',null,9);
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(6,'周芷若','女','1998-02-03 00:00:00','18209876577',null,1);
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(7,'岳灵珊','女','1998-02-03 00:00:00','18209876577',null,9);
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(8,'小昭','女','1998-02-03 00:00:00','18209876577',null,1);
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(9,'双儿','女','1998-02-03 00:00:00','18209876577',null,9);
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(10,'王语嫣','女','1998-02-03 00:00:00','18209876577',null,4);
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(11,'夏雪','女','1998-02-03 00:00:00','18209876577',null,9);
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(12,'赵敏','女','1998-02-03 00:00:00','18209876577',null,1);
select database();
CREATE TABLE boys (
    id INT PRIMARY KEY,
    boyName VARCHAR(20),
    userCP INT
);
insert into boys(id,boyName,userCP) values(1,'张无忌',100);
insert into boys(id,boyName,userCP) values(2,'鹿晗',100);
insert into boys(id,boyName,userCP) values(3,'黄晓明',100);
insert into boys(id,boyName,userCP) values(4,'段誉',100);
SELECT 
    *
FROM
    boys;
*/
#笛卡尔乘积现象：
SELECT 
    name, boyName
FROM
    boys,
    girls;
#添加连接条件
SELECT 
    name, boyName
FROM
    boys,
    girls
WHERE
    girls.boyfriend_id = boys.id;

#一、内连接
#1. 等值连接
#案例1. 查询女神名和对应的男神名
SELECT 
    name, boyName
FROM
    girls,
    boys
WHERE
    girls.boyfriend_id = boys.id;
#案例2. 查询员工名和对应的部门名
SELECT 
    last_name, department_name
FROM
    employees,
    departments
WHERE
    employees.department_id = departments.department_id;
#【为表起别名】
/*
1.提高語句的簡潔度
2.區分多個重名的字段
3.如果为表起了别名，则不能再使用原始表名限定字段
4.可以加筛选
5.可以加分组
6.可以加排序
7.也可以三表以上连接
*/
#案例3. 查询员工名、工种号、工种名
SELECT 
    last_name, t1.job_id, job_title
FROM
    employees as t1,
    jobs as t2
WHERE
    t1.job_id = t2.job_id;
#案例4. 查询有奖金的员工名和部门名
SELECT 
    last_name, department_name, commission_pct
FROM
    employees,
    departments
WHERE
    employees.department_id = departments.department_id
        AND employees.commission_pct IS NOT NULL;
#案例5. 查询城市中第二个字符为'O'的部门名和城市名
SELECT 
    department_name, city
FROM
    departments AS d,
    locations AS l
WHERE
    d.location_id = l.location_id
        AND city LIKE '_O%';
#案例6. 查询每个城市的部门个数
SELECT 
    COUNT(*), city
FROM
    departments AS d,
    locations AS l
WHERE
    d.location_id = l.location_id
GROUP BY city;
#案例7. 查询有奖金的每个部门的部门名和领导编号和该部门的最低工资
SELECT 
    department_name, d.manager_id, MIN(salary)
FROM
    departments AS d,
    employees AS e
WHERE
    d.department_id = e.department_id
        AND e.commission_pct IS NOT NULL
GROUP BY department_name , d.manager_id;
#案例8. 查询每个工种的工种名和员工个数，并且按员工个数降序
SELECT 
    job_title, COUNT(*)
FROM
    employees AS e,
    jobs AS j
WHERE
    e.job_id = j.job_id
GROUP BY j.job_id
ORDER BY COUNT(*) DESC;
#案例9. 查询员工姓名、部门名和所在的城市
SELECT 
    last_name, department_name, city
FROM
    employees AS e,
    departments AS d,
    locations AS l
WHERE
    e.department_id = d.department_id
        AND d.location_id = l.location_id;
#2. 非等值连接
#案例1. 查询员工的工资和工资级别
/* prepare data
CREATE TABLE job_grades (
    grade_level VARCHAR(3),
    lowest_sal INT,
    highest_sal INT
);
insert into job_grades values('A', 1000, 2999);
insert into job_grades values('B', 3000, 5999);
insert into job_grades values('C', 6000, 9999);
insert into job_grades values('D', 10000, 14999);
insert into job_grades values('E', 15000, 24999);
insert into job_grades values('F', 25000, 40000);
*/
SELECT 
    salary, grade_level
FROM
    employees AS e,
    job_grades AS j
WHERE
    e.salary BETWEEN j.lowest_sal AND j.highest_sal;
#3. 自连接
#案例1. 查询员工名和上级的名字
SELECT 
    e1.last_name,
    e1.employee_id,
    e1.manager_id,
    e2.last_name,
    e2.employee_id
FROM
    employees AS e1,
    employees AS e2
WHERE
    e1.manager_id = e2.employee_id;
#1.
SELECT 
    last_name, d.department_id, d.department_name
FROM
    employees e,
    departments d
WHERE
    e.department_id = d.department_id;
#2.
SELECT 
    e.job_id, d.location_id
FROM
    employees AS e,
    departments AS d
WHERE
    e.department_id = e.department_id
        AND e.department_id = 90;
#3.
SELECT 
    last_name, department_name, l.location_id, city
FROM
    employees e,
    departments d,
    locations l
WHERE
    e.department_id = d.department_id
        AND d.location_id = l.location_id
        AND commission_pct IS NOT NULL;
#4.
SELECT 
    last_name, job_id, e.department_id, department_name
FROM
    employees e,
    departments d,
    locations l
WHERE
    e.department_id = d.department_id
        AND d.location_id = l.location_id
        AND city = 'TORONTO';
#5.
SELECT 
    department_name, job_title, MIN(salary)
FROM
    employees e,
    departments d,
    jobs j
WHERE
    e.department_id = d.department_id
        AND e.job_id = j.job_id
GROUP BY e.job_id , e.department_id;
#6.
SELECT 
    country_id
FROM
    departments d,
    locations l
WHERE
    d.location_id = l.location_id
GROUP BY country_id
HAVING COUNT(*) > 2;
#7
SELECT 
    e1.last_name AS employees,
    e1.employee_id AS 'Emp#',
    e2.last_name AS manager,
    e2.employee_id AS 'Mgr#'
FROM
    employees AS e1,
    employees AS e2
WHERE
    e1.manager_id = e2.employee_id
        AND e1.last_name = 'kochhar';