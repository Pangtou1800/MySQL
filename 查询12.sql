#进阶9： 联合查询
/*
union 联合、合并： 将多条查询语句的结果合并成一个结果
语法：
	查询语句1
	union
    查询语句2
    【...
    union
    查询语句n】
应用场景：
	要查询的结果来自于多个表，且表之间没有直接的连接关系，但查询信息一致时
注意事项：
	1. 要求多条查询语句的查询列数一致
    2. 多条查询语句的每列的类型和顺序最好保持一致（可以执行）
    3. union关键字完全一致的行会自动去重，union all关键字可以包含重复项
*/
#案例： 查询部门编号大于90或者邮箱中包含a的员工信息
SELECT 
    *
FROM
    employees
WHERE
    department_id > 90 OR email LIKE '%a%';
SELECT 
    *
FROM
    employees
WHERE
    department_id > 90 
UNION SELECT 
    *
FROM
    employees
WHERE
    email LIKE '%a%';
#应用场景
CREATE TABLE t_ca (
    t_id INT PRIMARY KEY,
    tName VARCHAR(20),
    tGender VARCHAR(5)
);
CREATE TABLE t_ua (
    t_id INT PRIMARY KEY,
    tName VARCHAR(20),
    tGender VARCHAR(5)
);
insert into t_ca (t_id, tName, tGender) values(1,'韩梅梅','女');
insert into t_ca (t_id, tName, tGender) values(2,'李雷','男');
insert into t_ca (t_id, tName, tGender) values(3,'李明','男');
alter table t_ca change tName t_name varchar(30);
alter table t_ca change tGender t_sex varchar(15);
insert into t_ua (t_id, tName, tGender) values(1,'John','male');
insert into t_ua (t_id, tName, tGender) values(2,'Lucy','female');
insert into t_ua (t_id, tName, tGender) values(3,'Jack','male');
insert into t_ua (t_id, tName, tGender) values(4,'Rose','female');
#案例： 查询所有男性用户
select * from t_ca where t_sex = '男'
union
select * from t_ua where tGender = 'male';


