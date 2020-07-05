#变量
/*
系统变量：
	全局变量
    会话变量

自定义变量：
	用户变量
    局部变量
*/
#一、系统变量
/*
说明： 变量由系统提供，不是用户定义，属于服务器层面
语法：
	1.查看所有的系统变量
		show global|session variables;
		省略时查看会话变量
	2.查看满足条件的部分变量
		show global|session variables like 'char%';
	3.查看指定的某个系统变量的值
		select @@global|session.系统变量名;
	4.为某个系统变量赋值
		方式一：
		set global|session.系统变量名=值;
        方式二：
		set @@global|session.系统变量名=值;
	注意：
		如果是全局级别，则需要加global关键字，如果是会话级别，则需要加session关键字，不写默认是session
*/
show variables;

show session variables;
show global variables like 'char%';
show session variables like 'char%';

#1.全局变量
/*
作用域： 服务器每次启动将为所有的全局变量付初始值，针对所有的会话有效，但是不能跨重启
*/
#查看所有的全局变量
show global variables;
#查看部分的全局变量
show global variables like '%char%';
#查看指定的某个全局变量的值
select @@global.autocommit;
select @@global.transaction_isolation;
#为某个指定的全局变量赋值
set @@global.autocommit = 1;
set global autocommit = 1;

#2.会话变量
/*
作用域： 仅仅针对当前会话（连接）有效
*/
#查看所有的会话变量
show session variables;
show variables;
#查看部分的会话变量
show session variables like '%char%';
show variables like '%char%';
#查看指定的某个会话变量的值
select @@session.autocommit;
select @@transaction_isolation;
#为某个指定的会话变量赋值
set @@session.autocommit=0;
set autocommit=1;
set session autocommit = 1;

#二、自定义变量
/*
说明： 变量是用户自定义的
使用步骤：
	1.声明
    2.赋值
    3.使用
*/
#1.用户变量
/*
作用域： 针对当前会话（连接）有效，同于会话变量的作用域

可以用在任何地方，也就是begin end里面或外面都行

赋值操作符： = 或 :=
#1.声明并初始化
	set @用户变量名=值;
    set @用户变量名:=值;
    select @用户变量名:=值;
#2.赋值（更新）用户变量的值
	方式一： 通过set或select（再次声明即可）
    方式二： 通过select into
		select 字段 into @变量名 from 表; （查询结果必须只有一个值）
#3.使用（查看用户变量的值）
	select @用户变量名;
*/
#案例
set @name='John';
set @name=100;
select @name;
use test;
select count(*) into @counter from employees;
select @counter;
#2.局部变量
/*
作用域: 仅仅在局部有效，即定义它的begin end中

应用在begin end中的第一句话

#1.声明
	declare 变量名 类型;
    declare 变量名 类型 default 值;
#2.赋值
	方式一： 通过set或select
		set 变量名=值;
        set 变量名:=值;
        select @变量名:=值;
    方式二： 通过select into
		select 字段 into @变量名 from 表; （查询结果必须只有一个值）
#3.使用
select 局部变量名;
*/
/*
对比用户变量和局部变量
			作用域		定义位置				语法
用户变量		当前会话		会话中的任何位置		声明语法不同，必须加@符号；不用限定类型
局部变量		begin end	begin end中的第一句	一般不用加@符号，除非使用select；需要限定类型
*/
#案例：声明两个变量并赋初值，求两个变量之和并打印
#用户变量
set @m = 1;
set @n = 2;
set @sum = @m + @n;
select @sum;
#局部变量
/*
begin;
declare m int default 1;
declare n int default 2;
declare sum;
set sum = m +n;
select @sum;
end;
*/