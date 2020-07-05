#进阶8： 分页查询
/*
应用场景：
	当要显示的数据，一页显示不全，需要分页提交SQL文
语法：
	select 查询列表 7
    from 表 1
    【join type join 表2 2
	on 连接条件 3
    where 筛选条件 4
    group by 分组字段 5
    having 分组后筛选 6
    order by 排序字段】 8
    limit offset, size; 9
    offset: 要显示条目的索引（起始索引从0开始）
    size： 要显示的条目个数
特点：
	1. limit语句放在查询语句的最后（执行顺序上也是最后）
    2. 公式
    要显示的页数： page
    每页条目数： size
    select 查询列表
    from 表
    limit size*(page-1),size;
*/
#案例1 查询前5条员工信息
SELECT 
    *
FROM
    employees
LIMIT 0 , 5;
use mamalrelationship;
select *from girls;
select *from girls limit 0,5;
select *from girls limit 5;
#案例2 查询第11条——第25条
select * from employees limit 10,15;
#案例3 查询有奖金的员工信息，并且工资较高的前10名显示出来
SELECT 
    *
FROM
    employees
WHERE
    commission_pct IS NOT NULL
ORDER BY salary DESC
LIMIT 10;
#
drop table stuinfo;
CREATE TABLE stuinfo (
    id INT PRIMARY KEY,
    name VARCHAR(20),
    email VARCHAR(20),
    gradeId VARCHAR(20),
    sex VARCHAR(3),
    age INT
);
desc stuinfo;
CREATE TABLE grade (
    id INT PRIMARY KEY,
    gradeName VARCHAR(20)
);
desc grade;
#1
SELECT 
    SUBSTR(email, 1, INSTR(email, '@') - 1)
FROM
    stuinfo;
#2
SELECT 
    COUNT(*), sex
FROM
    stuinfo
GROUP BY sex;
#3
SELECT 
    s.name, gradeName
FROM
    stuinfo AS s
        INNER JOIN
    grade ON s.gradeId = grade.id
WHERE
    s.age > 18;
#4
SELECT 
    f.gradeId
FROM
    (SELECT 
        gradeId, MIN(age) AS minAge
    FROM
        stuinfo
    GROUP BY gradeId) AS f
WHERE
    f.minAge > 20;
SELECT 
    gradeId
FROM
    stuinfo
GROUP BY gradeId
HAVING MIN(age) > 20;
#5
/*
select 查询列表 7
from 表 1
join_type join 表2 2
on 连接条件 3
where 筛选条件 4
group by 分组字段 5
having 分组后筛选 6
order by 排序字段 8 
limit 起始索引, 分页长度 9

*/