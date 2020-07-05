#常见的数据类型
/*
数值型：
	整形
	小数：
		定点数
        浮点数
字符型：
	较短的文本：
		CHAR, VARCHAR
	较长的文本：
		TEXT, BLOB
日期型
*/
#一、整型
/*
分类：
	tinyint, smallint, mediumint, int/integer, bigint
    1        2         3          4            8
特点：
	·如果不设置符号，默认有符号；如果想设置符号，添加关键字unsigned
    ·如果值超过了范围，会报out of range异常，插入失败（旧版本默认插入临界值）
    ·如果不设置长度，会有默认长度；长度代表显示结果的长度，搭配zerofill关键字使用，而且使用后默认变为无符号整型
     > 新版本中长度值已经失效
*/
#1.如何设置无符号和有符号
create table tab_int (
	t1 int,
    t2 int unsigned
);
desc tab_int;
insert into tab_int set t1 = -1, t2 = 1, t3=5;
insert into tab_int values(2147483647,4294967295);
insert into tab_int values(2147483648,4294967296);
select * from tab_int;
truncate table tab_int;
drop table tab_int;
alter table tab_int modify column t3 int zerofill;
#二、小数
/*
分类：
	1. 浮点型
		float(M,D)
		double(M,D)
	2. 定点型
		dec(M,D)
		decimal(M,D)
特点：
	1. M和D
		M： 整数位+小数位
        D： 小数位
        如果超过范围则插入临界值
	2. M和D都可以省略，DEC的时候默认是(10,0),float和double则会根据插入的数值的精度来决定
    3. 定点型的精确度较高，如果要求插入数值的精度高（如货币运算）则优先使用
*/
create table tab_float(
	f1 float(5,2),
    f2 double(5,2),
    f3 decimal(5,2)
);
drop table tab_float;
create table tab_float(
	f1 float,
    f2 double,
    f3 decimal
);
desc tab_float;
insert into tab_float values(123.45,123.45,123.45);
select * from tab_float;
insert into tab_float values(123.456,123.456,123.456);
insert into tab_float values(123.4,123.4,123.4);
insert into tab_float values(1523.4,1523.4,1523.4);
insert into tab_float values(123.4523,123.4523,123.4523);

#原则：
/*
所选择的类型越简单越好，能保存数值的类型越小越好
*/

#三、字符型
/*
分类：
	较短的文本
		char, varchar
	较长的文本
		text, blob(较大的二进制)
特点：
	char(M)     M: 最大字符数，0~255		固定长	效率高	M可以省略，默认为1
    varchar(M)  M: 最大字符数，0~65535	可变长	效率低	M不可以省略	
*/

#四、其他
/*
	·bit  bit(M) M: 1~8
    ·binary, varbinary
    ·enum enum(enum1,enum2...) > 每个字段只能存放一个enum值
    ·set set(set1,set2...) > 每个字段能存放多个set值
*/

create table tab_char(
	c1 enum('a','b','c')
);
desc tab_char;
insert into tab_char values('a'),('b'),('c'),('A');
insert into tab_char values('e');
select *from tab_char;
create table tab_set(
	s1 set('a','b','c','d')
);
desc tab_set;
insert into tab_set values('a');
insert into tab_set values('a,b'),('a,b,c');
select * from tab_set;

#五、日期型
/*
分类：
	year, date, time, datetime, timestamp
特点：
				bytes	start					end
	datetime	8		1000-01-01 00:00:00		9999-12-31 23:59:59
    timestamp	4		19700101080001			2038年的某个时刻
1. 范围不同
2. timestamp和实际时区有关，更能反映实际的日期；而datetime则只能反映出插入时的当地时区
3. timestamp的属性受MySQL版本和SQLMode的影响很大    
*/

create table tab_date (
	t1 datetime,
    t2 timestamp
);

insert into tab_date values(now(), now());
select * from tab_date;
show variables like 'time_zone';
set time_zone='+9:00';