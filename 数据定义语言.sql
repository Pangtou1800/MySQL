#DDL
/*
数据定义语言
	库和表的管理

一、库的管理
	·创建 create
    ·修改 alter
    ·删除 drop

二、表的管理
	·创建 create
    ·修改 alter
    ·删除 drop
*/

#一、库的管理
#1. 库的创建
/*
语法：
	create database 库名
*/
#案例：创建库Books
create database Books;
create database if not exists Books;
#2. 库的修改
#更改库的字符集
alter database Books character set gbk;
#3. 库的删除
drop database Books;
drop database if exists Books;

#二、表的管理
#1. 表的创建
/*
语法：
	create table 表名 (
		列名 列的类型【(长度)】 【列的约束】,
        列名 列的类型【(长度)】 【列的约束】,
        ...
        列名 列的类型【(长度)】 【列的约束】
    )
*/
#案例：创建表Book
use books;
create table Book (
	id int, #编号
    bName varchar(40), #书名
    price double, #价格
    authorId int, #作者编号
    publishDate datetime #出版日期
);
create table if not exists Book (
	id int, #编号
    bName varchar(40), #书名
    price double, #价格
    authorId int, #作者编号
    publishDate datetime #出版日期
);
desc book;
#案例：创建表Author
create table Author (
	id int,
    auName varchar(20),
    nation varchar(10)
);
desc Author;
#2. 表的修改
/*
·列名
·列的类型或约束
·添加列
·删除列
·表名

	alter table 表名
    add|drop|modify|change column 列名 【新列名】【列类型】【约束】
    
    ※change的column可以省略
*/
#1
alter table Book change column publishDate pubDate datetime;
desc Book;
#2
alter table Book modify column pubDate timestamp;
#3
alter table author add column annual double;
desc author;
#4
alter table author drop column annual;
#5
alter table author rename to book_author;
desc book_author;
#3. 表的删除
/*
drop table 表名
*/
drop table book_author;
drop table if exists book_author;
show tables;

#通用的写法
drop database if exists 库名;
create database 库名;
drop table if exists 表名;
create table 表名( id int );

#4. 表的复制
insert into Author values(1,'村上春树','日本'),(2,'莫言','中国'),(3,'冯唐','中国'),(4,'金庸','中国');
#仅复制表的结构
create table copy like author;
#复制表的结构和数据
create table copy2 
	select * from author;
select * from copy2;
#仅复制部分数据
create table copy3
	select id, auName
    from author
    where nation='中国';
select * from copy3;
#仅复制部分结构
create table copy4
	select id, auName
    from author
    where 1=0;
select * from copy4;

#1.
use test;
create table dept1(
	id int,
    name varchar(25)
);
#2.
create table dept2 select * from departments;
#3.
create table emp5(
	id int(7),
    first_name varchar(25),
    last_name varchar(25),
    dept_id int(7)
);
#4.
alter table emp5 change column last_name last_name varchar(50);
alter table emp5 modify column last_name varchar(51);
#5.
create table employees2 like employees;
#6.
drop table emp5;
#7.
alter table employees rename to emp5;
#8.
alter table dept2 add column test_column int;
alter table emp5 add column test_column int;
#9.
alter table emp5 drop column test_column;
desc emp5;
alter table emp5 rename to employees;
