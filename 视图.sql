#视图
/*
含义：
	虚拟表，和普通表一样使用。MySQL5.1版本出现的新特性，是通过表动态生成的数据。
    只保存了SQL逻辑，不保存查询结果。
特点：
	·重用SQL语句
    ·简化复杂的SQL操作，不必知道它的查询细节
    ·保护数据，提高安全性
对比：
		create	实际占用物理空间	使用
视图		view	没有				增删改查（一般不能增删改）
表		table	有				增删改查
    
*/

#案例： 查询姓张的学生名和专业名
use students;
select stuName, majorName from stuinfo inner join major on stuinfo.majorId = major.id where stuName like '张%';
select * from stuinfo;
select * from major;
insert into major values(1,'java'),(2,'C++');
insert into stuinfo values(3,'张四','男',15,20,2),(4,'李五','女',15,20,1);
commit;
set autocommit = 1;
show variables like 'autocommit';
CREATE VIEW v1 AS
    SELECT 
        stuname, majorname
    FROM
        stuinfo
            INNER JOIN
        major ON stuinfo.majorId = major.id;
select * from v1 where stuname like '张%';

#一、如何创建视图
/*
create view 视图名
as
查询语句;
*/
show databases;
use test;
show tables;
#1.
CREATE VIEW myV1 AS
    SELECT 
        e.last_name, d.department_name, j.job_title
    FROM
        employees e
            INNER JOIN
        departments d ON e.department_id = d.department_id
            INNER JOIN
        jobs j ON e.job_id = j.job_id;
select * from myV1 where last_name like '%a%';
#2.
CREATE VIEW myV2 AS
    SELECT 
        department_id, AVG(salary) avgSal
    FROM
        employees
    GROUP BY department_id;
drop view myV2;
select * from myV2;
SELECT 
    myV2.department_id, myV2.avgSal, g.grade_level
FROM
    myV2
        INNER JOIN
    job_grades g ON myV2.avgSal BETWEEN g.lowest_sal AND g.highest_sal;
#3.
select min(avgSal), department_id from myV2;
#4.
drop view myV3;
create view myV3 as 
select min(avgSal) minAvgSal, department_id from myV2;
select department_name, minAvgSal from departments d inner join myV3 on d.department_id = myV3.department_id;

#二、视图的修改
/*
方式一：
	create or replace view 视图名
    as
    查询语句;
方式二：
	alter view 视图名
    as
    查询语句;
*/
create or replace view myV3 as 
select avg(salary), job_id from employees group by job_id;
alter view myV3 as
select * from employees;

#三、删除视图
/*
语法：
	drop view 视图名【,视图名】...;
*/
drop view myV1, myV2, myV3;

#四、查看视图
/*
语法：
	desc 视图名;
*/
desc myV3;
show create view myV3;

#1.
use test;
desc employees;
create or replace view emp_v1
as
select last_name, salary , email from employees where phone_number like '011%';
#2.
CREATE OR REPLACE VIEW emp_v2 AS
    SELECT 
        *
    FROM
        departments
    WHERE
        department_id IN (SELECT 
                department_id
            FROM
                employees
            GROUP BY department_id
            HAVING MAX(salary) > 12000);
select * from emp_v2;

#五、视图的更新
CREATE OR REPLACE VIEW myV1 AS
    SELECT 
        last_name,
        email
    FROM
        employees;
CREATE OR REPLACE VIEW myV2 AS
    SELECT 
        last_name,
        email,
        salary * 12 * (1 + IFNULL(commission_pct, 0)) annual
    FROM
        employees;
select * from myV1;
#1 插入
desc employees;
alter table employees modify column employee_id int auto_increment;
insert into myV1(last_name, email) values('John', 'john@qq.com');
insert into myV2(last_name, email, annual) values('John', 'john@qq.com', 30000);
select * from employees;
#2 修改
update myV1 set last_name="Jane" where last_name="John";
#3 删除
delete from myV1 where last_name="John";
/*
具备以下特点的视图是不允许更新的：
	1. 包含以下关键字的SQL语句：
		分组函数、distinct、group by、having、union或union all
	2. 常量视图
    3. select中包含子查询
    4. 使用join的SQL语句（联合查询）
    5. from一个不能更新的视图
    6. where子句的子查询引用了from子句的表
*/
#1.
drop table book;
create table Book (
	bid int primary key,
    banme varchar(20) unique not null,
    price float default(10),
    btypeId int,
    constraint fk_book_booktype foreign key (btypeId) references booktype(id));

CREATE TABLE Booktype (
    id INT PRIMARY KEY,
    name VARCHAR(20)
);

alter table book change column banme bname varchar(20) not null;
desc book;
#2.
start transaction;
insert
into
Book (bid, bname, price, btypeId)
values(1,"小李飞刀",20.3,1);
commit;
#3.
CREATE OR REPLACE VIEW myV1 AS
    SELECT 
        bname, name
    FROM
        book
            JOIN
        booktype ON book.btypeid = booktype.id
    WHERE
        price > 2000;
#4.
CREATE OR REPLACE VIEW myV1 AS
    SELECT 
        bname, price
    FROM
        book
    WHERE
        price BETWEEN 90 AND 120;
#5.
drop view myV1;

use test;
show tables;
desc stuinfo;
desc major;
CREATE TABLE major (
    id INT PRIMARY KEY,
    majorName VARCHAR(20)
);
show index from stuinfo;
desc grade;
alter table stuinfo add constraint fk_stuinfo_grade foreign key (gradeId) references grade(id);
alter table stuinfo drop foreign key fk_stuinfo_grade;
alter table stuinfo modify column gradeId int;
alter table stuinfo drop index fk_stuinfo_grade;

insert into grade values(1,'java'),(2,'h5'),(3,'BigData');
insert into stuinfo values(1,'John',null,1,null,null),(2,'Johne',null,2,null,null),(3,'Hohn',null,3,null,null),(4,'Johnny',null,1,null,null),(5,'Johsn',null,1,null,null);
select *from grade;

alter table stuinfo add constraint uniqueEmail unique (email);
alter table stuinfo drop index email;
select *from stuinfo;

delete from grade where id = 2;

#方式一 级联删除
alter table stuinfo drop foreign key fk_stuinfo_grade;
alter table stuinfo add constraint fk_stuinfo_grade foreign key (gradeId) references grade(id) on delete cascade;
#方式二 级联置空
alter table stuinfo add constraint fk_stuinfo_grade foreign key (gradeid) references grade(id) on delete set null;
show variables like 'auto_increment%';