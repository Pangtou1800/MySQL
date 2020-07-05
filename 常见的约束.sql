#常見約束
/*
含义：
	一种限制，用于限制表中行或者列的数据，为了保证表中的数据是准确可靠的（数据的一致性）。
分类：
	六大约束
    ·NOT NULL： 非空约束，用于保证该字段的值不能为空。
    ·DEFAULT： 默认约束，用于保证该字段有默认值。
    ·PRIMARY KEY： 主键约束，用于保证该字段的值具有唯一性，且非空。
	·UNIQUE： 唯一约束，用于保证该字段的值具有唯一性，但是可以为空。比如座位号。
    ·CHECK： 检查约束（MySQL不支持，但是语法上不会报错，只是没有效果）。
    ·FOREIGN KEY: 外键约束，用于限制两个表的关系，保证该字段值的值必须来自于主表的关联列的值。
                  在从表添加外键约束，用于引用主表中某列的值。
                  
添加约束的时机：
	1. 创建表时
    2. 修改表时（数据添加之前）
    
添加约束的分类：
	1. 列级约束： 
		语法上六大约束都可以设置为列级约束，但是【外键约束】没有效果
    2. 表级约束：
		除了NOT NULL、DEFAULT其他的都支持

create table 表名(
	字段名 字段类型 列级约束1 列级约束2 ...,
    字段名 字段类型 列级约束1 列级约束2 ...,
    ...
    字段名 字段类型 列级约束1 列级约束2 ...,
    表级约束1,
    表级约束2,
    ...
    表级约束n
);

主键 PK 唯一：
			唯一性	允许为空			一个表中可以设置的约束数	是否允许组合
    主键		OK		NG				最多一个					OK primary key(列1,列2)
    唯一		OK		OK（但只有一行）	多个						OK unique(列1,列2)
    
外键：
	1. 要求在从表设置外键关系
    2. 要求从表的外键列的类型和主表的关联列类型一致或兼容，列名无要求
    3. 要求主表中的关联列必须是一个key（主键、唯一键） ※外键也可，但是意义不大
    4. 要求插入数据时，先插入主表数据，再插入从表数据；删除数据时，先删除从表，再删除主表。
*/

#一、创建表时添加约束
#1.添加列级约束
/*
语法：
	直接在字段类型后面追加约束类型即可
	注意只支持： 默认、非空、主键、唯一，检查和外键不支持
*/
create database students;
use students;
CREATE TABLE stuinfo (
    id INT PRIMARY KEY, #主键
    stuName VARCHAR(20) NOT NULL, #非空
    gender CHAR(1) CHECK(gender in ('男','女')), #检查
    seat INT UNIQUE, #唯一
    age INT DEFAULT 18 #默认
    # magorId INT FOREIGN KEY REFERENCES major(id) #外键
);
CREATE TABLE major (
    id INT PRIMARY KEY,
    majorName VARCHAR(20)
);
desc stuinfo;
#主键、外键、唯一键会自动添加索引
show index from stuinfo;
#2.添加表级约束
/*
语法：
	在各个字段的最下面添加
    【constraint 约束名】 约束类型(字段名) 
*/
drop table stuinfo;
CREATE TABLE stuinfo (
    id INT,
    stuName VARCHAR(20),
    gender CHAR(1),
    seat INT,
    age INT,
    majorId INT,
    CONSTRAINT pk PRIMARY KEY (id), #主键
    CONSTRAINT uq UNIQUE (seat), #唯一
    CONSTRAINT ck CHECK (gender IN ('男' , '女')), #检查（无效）
    CONSTRAINT fk_stuinfo_major FOREIGN KEY (majorId) 
        REFERENCES major (id) # 外键
);
show index from stuinfo;
CREATE TABLE stuinfo (
    id INT,
    stuName VARCHAR(20),
    gender CHAR(1),
    seat INT,
    age INT,
    majorId INT,
    PRIMARY KEY (id), #主键
    UNIQUE (seat), #唯一
    FOREIGN KEY (majorId) REFERENCES major (id) # 外键
);
#通用写法：
CREATE TABLE IF NOT EXISTS stuinfo (
    id INT PRIMARY KEY,
    stuName VARCHAR(20) NOT NULL,
    gender CHAR(1),
    age INT DEFAULT 18,
    seat INT UNIQUE,
    majorId INT,
    CONSTRAINT fk_stuinfo_major FOREIGN KEY (majorId)
        REFERENCES major (id)
);
show index from stuinfo;
insert into major values(1,'java'),(2,'h5');
insert into stuinfo values(1,'john','男',null,19,1),(2,'johnny','男',null,19,2);
drop table stuinfo;
CREATE TABLE stuinfo (
    id INT,
    stuName VARCHAR(20),
    gender CHAR(1),
    seat INT,
    age INT,
    majorId INT,
    PRIMARY KEY (id,stuName), #主键
    UNIQUE (seat), #唯一
    FOREIGN KEY (majorId) REFERENCES major (id) # 外键
);
insert into stuinfo values(1,'john','男',null,19,1),(1,'johnny','男',null,19,2);
select * from stuinfo;
desc stuinfo;
show index from stuinfo;
truncate stuinfo;
drop table stuinfo;
drop table if exists major;
create table major( id int, majorName varchar(20));
create table major( id int primary key, majorName varchar(20));
create table major( id int unique, majorName varchar(20));

#二、修改表时添加约束
/*
语法：
	1. 添加列级约束
		alter table 表名 modify column 表名 字段类型 新约束;
	2. 添加表级约束
		alter table 表名 add 【constraint 约束名】 约束类型(字段名) 【外键引用】;
*/
#1. 添加/去除非空约束 -> 只支持列级约束
drop table if exists stuinfo;
CREATE TABLE stuinfo (
    id INT,
    stuName VARCHAR(20),
    gender CHAR(1),
    seat INT,
    age INT,
    majorId INT
/*    ,
    CONSTRAINT pk PRIMARY KEY (id), #主键
    CONSTRAINT uq UNIQUE (seat), #唯一
    CONSTRAINT ck CHECK (gender IN ('男' , '女')), #检查（无效）
    CONSTRAINT fk_stuinfo_major FOREIGN KEY (majorId) 
        REFERENCES major (id) # 外键
*/
);
desc stuinfo;
alter table stuinfo modify column stuName varchar(20) not null;
alter table stuinfo modify column stuName varchar(20);
#2. 添加/去除默认约束 -> 只支持列级约束
alter table stuinfo modify column age int default 19;
alter table stuinfo modify column age int;
desc stuinfo;
#3. 添加主键约束 -> 支持列级约束和表级约束
alter table stuinfo modify column id int primary key;
alter table stuinfo modify column id int; #此写法无法去除主键约束
alter table stuinfo add primary key(id);
desc stuinfo;
alter table stuinfo drop primary key; #解除主键约束后，会留下非空约束
alter table stuinfo modify column id int; #对各列接触非空约束
#4. 添加唯一约束 -> 支持列级约束和表级约束
alter table stuinfo modify column seat int unique;
show index from stuinfo;
alter table stuinfo modify column seat int; #此写法无法解除唯一约束
#5. 添加外键约束 -> 只支持表级约束
alter table stuinfo add constraint fk_stuinfo_major foreign key (majorId) references major(id);

#三、修改表时删除约束
#1.删除非空约束 -> 列级约束
alter table stuinfo modify column stuName varchar(20) null;
alter table stuinfo modify column stuName varchar(20);
#2.删除默认约束 -> 列级约束
alter table stuinfo modify column age int;
#3.删除主键约束
alter table stuinfo drop primary key;
#4.删除唯一约束
alter table stuinfo drop index seat;
#5.删除外键约束
alter table stuinfo drop foreign key fk_stuinfo_major;

#1.
alter table emp2 modify column id int primary key;
alter table emp2 add constraint pk primary key(id);
#2.
#3.
alter table emp2 add constraint fk_emp2_dept foreign key (dept_id) references dept2(id);

/*
			位置			支持的约束类型				可否取名
列级约束：	列的后面		foreign key以外			不可
表级约束：	所有列的后面	default, not null以外	可以（主键以外）
*/

#标识列
/*
又称为自增长列
含义：
	可以不用手动插入值，系统提供默认的序列值
特點：
	·标识列必须和主键搭配吗？
		=> 不必须是主键，但要求是一个KEY
	·一个表里可以有多少标识列？
		=> 每个表里最多有一个
	·标识列的类型有要求吗？
		=> 只能是数值型（整型浮点型不限）
	·标识列可以通过set auto_increment_increment=n来设置步长，通过手动插入值来设置初始值
*/
#一、创建表时设置标识列
drop table tab_identity;
CREATE TABLE tab_identity (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20)
);
use students;
insert into tab_identity values(2,'John');
insert into tab_identity values(null,'John');
insert into tab_identity(name) values('John');
select *from tab_identity;
desc tab_identity;
show variables like 'auto_increment%';
set auto_increment_increment = 3;
create table tab_identity (
	id int primary key,
    name varchar(20)
);
#二、修改表时设置标识列
alter table tab_identity modify column id int auto_increment;
#三、修改表时删除标识列
alter table tab_identity modify column id int;