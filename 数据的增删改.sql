#DML语言
/*
数据操作语言：
插入：insert
修改：update
删除：delete
*/

#一、插入语句
#方式一：
/*
语法：
	insert into 表名(列名,...) values(值,...);
*/
use test;
CREATE TABLE admin (
    id INT PRIMARY KEY,
    username VARCHAR(20),
    password VARCHAR(20)
);
insert into admin (id,username,password) values(1,'john','8888');
insert into admin (id,username,password) values(2,'lyt','6666');
#1. 插入值的类型要与列的类型一致或兼容
CREATE TABLE girls (
    id INT(11) PRIMARY KEY,
    name VARCHAR(50),
    sex CHAR(1),
    borndate DATETIME,
    phone VARCHAR(11),
    photo BLOB,
    boyfriend_id INT(11)
);
desc girls;
insert into girls(id,name,sex,borndate,phone,photo,boyfriend_id) values(13,'唐艺昕','女','1990-4-23','18988888888',null,2);
select * from girls;
#2. 可以为null的列如何插入值？
alter table girls change name name varchar(50) not null;
desc girls;
insert into girls(id,name,sex,borndate,phone,boyfriend_id) values(14,'金星','女','1990-4-23','13888888888',9);
insert into girls(id,name,sex,phone) values(15,'娜扎','女','1987-01-01');
#3. 列的顺序可以调换
insert into girls(name,sex,id,phone) values('蒋欣','女',16,'110');
#4. 列数和值的个数必须一致
#5. 可以省略列名，默认所有列。而且列的顺序和表中列的顺序一致
insert into girls values(18,'张飞','男',null,'119',null,null);
#方式二：
/*
语法：
insert into 表名
set 列名=值,...
*/
#1.
insert into girls set id=19,name='刘涛',phone='999';
alter table girls change phone phone varchar(11) not null;
desc girls;
#两种方式PK：
/*
1. 方式一支持插入多行
2. 方式一支持子查询 (不用写values！)
*/
insert into girls values(20,'唐艺昕1','女','1990-4-23','18988888888',null,2),(21,'唐艺昕2','女','1990-4-23','18988888888',null,2),(22,'唐艺昕3','女','1990-4-23','18988888888',null,2);
insert into girls(id, name, phone)
select 26,'宋茜','118';
UPDATE girls SET phone = '11809866' WHERE id = 26;

#二、修改语句
/*
1. 修改单表中的数据
语法：
	update 表名	1
    set 列=新值,列=新值,... 3
    where 筛选条件; 2

2. 修改多表中的更新（级联更新）
语法：
	SQL92语法：
		update 表1 别名 b1, 表2 别名 b2
		set 列=值,...
		where 连接条件 and 筛选条件;
	SQL99语法：
		update 表1
        left|right|outer join 表2
        on 连接条件
        set 列=值,...
        where 筛选条件;
    
*/
#1.
update girls set phone='1386677889' where name like '唐%' and id > 0;
#2. 修改张无忌的女朋友的手机号为114
update employees e
inner join girls g
on e.manager_id = g.boyfriend_id
set g.phone = '114'
where e.last_name = '张无忌' and e.employee_id > 0 and g.id >0;
#3. 修改没有男朋友的女神的男朋友编号都为2
update girls g
left outer join employees e
on g.boyfriend_id = e.manager_id
set g.boyfriend_id = 2
where e.manager_id is null and g.id > 0;
select *from girls;

#三、删除语句
/*
方式一：
1. 单表删除
语法：
	delete from 表 where 筛选条件
2. 多表删除
SQL92语法：
	delete 别名1, 别名2 from 表1 别名1, 表2 别名2 where 连接条件 and 筛选条件
SQL99语法：
	delete 别名1, 别名2 from 表1 别名1
    inner|left|right join 表2 别名2 on 连接条件
    where 筛选条件

方式二：
语法：
	truncate table 表名
*/
#1.
delete from girls where id=18;
#2.
DELETE girls FROM girls
        LEFT OUTER JOIN
    employees ON girls.boyfriend_id = employees.manager_id 
WHERE
    employees.manager_id IS NOT NULL
    AND girls.id > 0;
#3.
truncate table girls;
select * from girls;

/*
delete PK truncte
1. delete可以加where條件
2. truncate效率比较高
3. 假如要删除的表中有自增长列，如果用delete删除后再插入数据，自增长的值从断点开始；而用truncate删除后再插入数据，自增长的值从最初开始
4. truncate删除没有返回值，delete删除有返回值
5. truncate删除不能回滚，delete删除可以回滚
*/
#1.
create table my_employees (
	id int,
    first_name varchar(10),
    last_name varchar(10),
    userid varchar(10),
    salary double(10,2)
);
create table users(
	id int,
    userid varchar(10),
    department_id int
);
#2.
desc my_employees;
#3.
#方式一：
insert into my_employees(id, first_name, last_name, userid, salary)
values(1,'patel','Ralph','Rpatel',895),
	(2,'Dancs','Betty','Bdancs',860),
    (3,'Biri','Ben','Bbiri',1100),
    (4,'Newman','Chad','Cnewman',750),
    (5,'Ropeburn','Audrey','Aropebur',1550);
#方式二：
insert into my_employees
select 1,'patel','Ralph','Rpatel',895 union
select 2,'Dancs','Betty','Bdancs',860 union
select 3,'Biri','Ben','Bbiri',1100 union
select 4,'Newman','Chad','Cnewman',750 union
select 5,'Ropeburn','Audrey','Aropebur',1550;
#4.
insert into users(id,userid,department_id)
values(1,'Rpatel',10),
(2,'Bdancs',20),
(3,'Bbiri',30);
#5.
update my_employees set last_name = 'drelxer' where id = 3;
#6.
update my_employees set salary = 1000 where salary < 900;
#7.
DELETE my_employees , users FROM my_employees
        INNER JOIN
    users ON my_employees.userid = users.userid 
WHERE
    my_employees.userid = 'Bbiri';
#8.
delete from my_employees;
delete from users;
truncate table my_employees;
