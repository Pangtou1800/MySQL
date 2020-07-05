#存储过程和函数
/*
存储过程和函数
好处：
	1.提高代码重用性
    2.简化操作
*/
#存储过程
/*
含义： 一组预先编译好的SQL语句的集合，类似于批处理语句
好处：
	3.减少了编译次数，并且减少了和数据库服务器的连接次数，提高了效率
*/
#一、创建
/*
语法：
	create procedure 存储过程名(参数列表) 
    begin
		存储过程体（一组合法的SQL语句）
    end;
注意：
	1.参数列表包含三部分
		·参数的模式
        ·参数名
        ·参数类型
	举例： in stuname varchar(20)
		>参数模式：
			in:		该参数可以作为输入，也就是说该参数需要调用方传入值
			out:	该参数可以作为输出，也就是说该参数可以作为返回值
            inout:	该参数既可以作为输入，也可以作为输出，也就是说既需要传入值，又可以返回值
	2.如果存储过程体仅仅只有一句话，begin end可以省略
    3.存储过程体中的每条SQL语句的结尾要求必须加分号。存储过程的结尾可以使用delimiter重新设置
		>语法：
			delimiter 结束标记
		举例：
			delimiter $   
*/
#二、使用（调用）
/*
语法：
	call 存储过程名(实参列表);
*/
#1.空参列表
#案例： 插入到admin表中五条记录
desc admin;
select * from admin;
delimiter $
create procedure myp1()
begin
	insert into test.admin (username,password) values('john1','0000'),('lily','0000'),('rose','0000'),('jack','0000'),('tom','0000');
end $
call myp1()$
select * from admin$
delimiter ;
#2.带in模式参数的存储过程
#案例： 创建存储过程实现 根据女神名，查询对应的男神信息
use mamalrelationship;
delimiter &
create procedure myp2(in beautyName varchar(20))
begin
	select bo.*
    from
    boys bo
    right outer join girls b
    on bo.id = b.boyfriend_id
    where b.name = beautyName;
end &
call myp2("热巴")&
delimiter ;
call myp2("小昭");
#案例： 创建存储过程实现，用户是否登录成功
use test;
delimiter ^
create procedure myp3(in username varchar(10), in password varchar(10))
begin
	  declare counter varchar(10) default 0;
      select count(*) into counter from admin where admin.username = username and admin.password = password > 0;
      select if(counter > '0',"登录成功","登录失败");
end ^
delimiter ;
select * from admin where username='john';
call myp3('john','8888');
#3.创建带out模式的存储过程
#案例： 根据女神名，返回对应的男神名
use mamalrelationship;
delimiter &
create procedure myp4(in girlname varchar(20), out boyname varchar(20))
begin
	select boys.boyName into boyname
    from boys
    right outer join girls
    on boys.id = girls.boyfriend_id
    where girls.name = girlname;
end &
delimiter ;
set @boyname = '';
call myp4('小昭', @boyname);
select @boyname;
#案例： 根据女神名，返回对应的男神名和魅力值
delimiter ~
create procedure myp5(in girlname varchar(20), out boyname varchar(20), out userCP int)
begin
	select boys.boyName , boys.userCP into boyname, userCP
    from boys
    right outer join girls
    on boys.id = girls.boyfriend_id
    where girls.name = girlname;
end ~

call myp5('小昭',@boyname,@boyCP);
select @boyname, @boyCP;
#4.带inout模式参数的存储过程
#案例： 传入A和B两个值，要求A和B都翻倍并返回
create procedure myp8(inout A int, inout B int) 
begin
	select A*2, B*2 into A, B;
end ~
set @A=10~
set @B=20~
call myp8(@A,@B)~
select @A, @B;
drop procedure myp8;
delimiter ;

#1.
delimiter ~
create procedure test_pro1(in username varchar(20), in loginPW varchar(20))
begin
	insert into test.admin(username, password) values(username, loginPW);
end ~
call test_pro1('Blade','3333')~
select * from test.admin~
#2.
create procedure test_pro2(in girlid int, out girlname varchar(20), out phone varchar(20))
begin
	select name, girls.phone into girlname, phone
    from mamalrelationship.girls
    where id = girlid;
end~
call test_pro2(2,@girlname, @phone)~
select @girlname, @phone~
#3.
create procedure test_pro3(in birth1 datetime, in birth2 datetime, out result int)
begin
	select datediff(birth1,birth2) into result;
end~
select datediff(now(),str_to_date('2020-06-03','%Y-%m-%D'))~
call test_pro3('1998-1-1',now(),@result);
select @result;

#二、删除存储过程
/*
语法：
	drop procedure 存储过程名;
*/
delimiter ;
drop procedure test_pro3;

#三、查看存储过程的结构（信息）
/*
语法：
	show create procedure 存储过程名;
*/
use mamalrelationship;
show create procedure test_pro2;
show create table girls;
show create database test;
#
use test;
delimiter ~
create procedure test_pro4(in myDate datetime, out strDate varchar(20)) begin
	select date_format(myDate, '%y年%m月%d日') into strDate;
end~
delimiter ;
call test_pro4('2020-06-30', @strDate);
select @strDate;
#
use mamalrelationship;
delimiter ~
drop procedure test_pro5~
create procedure test_pro5(in girlName varchar(20), out mamalNames varchar(20)) begin
	select concat(name,' and ', ifnull(boyName, '')) into mamalNames
    from girls
    left outer join boys
    on girls.boyfriend_id = boys.id
    where name = girlName;
end~
delimiter ;
call test_pro5('柳岩',@mamalNames);
select @mamalNames;
#
delimiter ~
drop procedure test_pro6~
create procedure test_pro6(in startIdx int, in size int) begin
	select * from girls limit startIdx,size;
end~
call test_pro6(3,4)~
select * from girls~

#函数
/*
含义： 一组预先编译好的SQL语句的集合，类似于批处理语句
区别:

存储过程： 可以有0个返回或多个返回; 适合做批量的增删改
函数： 只能有1个返回; 适合做处理数据后返回一个结果
*/
#一、创建
/*
语法：
	create function 函数名(参数列表) returns 返回类型
    begin
		函数体
	end;
注意：
	1.参数列表包含两部分： 参数名 参数类型
	2.函数体肯定有return语句
    return语句没有放在函数体的最后也不报错，但是后方语句不会执行
    3.函数体中只有一句话时begin end可以省略
    4.使用delimiter语句设置结束标记
*/
#二、调用
/*
select 函数名(参数列表);
*/
#案例演示：
#1.无参有返回
#案例： 返回公司的员工个数
delimiter ;
select @@log_bin_trust_function_creators;
set @@global.log_bin_trust_function_creators = 1;
use test;
delimiter ~
create function myf1() returns int
begin
	declare result int;
	select count(*) into result from employees;
    return result;
end ~
select myf1()~
set @@global.log_bin_trust_function_creators = 0~
create function myf11() returns int
reads sql data
begin
	declare result int;
	select count(*) into result from employees;
    return result;
end ~
select myf11()~
#2.有参有返回
#案例： 根据员工名返回他的工资
create function myf2(empName varchar(20)) returns double
reads sql data
begin
	set @result=0;
SELECT 
    salary into @result
FROM
    employees
WHERE
    last_name = empName;
    return @result;
end~
select myf2('john')~
select * from employees~
update employees set salary = 109.34 where employee_id = 1~
#案例： 根据部门名，返回部门的平均工资
drop function myf3~
create function myf3(depName varchar(20)) returns double
reads sql data
begin
	declare result double;
SELECT 
    AVG(salary)
INTO result FROM
    employees
        INNER JOIN
    departments ON employees.department_id = departments.department_id
WHERE
    departments.department_name = depName;
    return result;
end~
select * from employees~
select * from departments~
insert into departments values(1,'IT',3,5)~
update employees set department_id = 1 where employee_id = 1~
select myf3('IT')~

#三、查看函数
delimiter ;
show create function myf3;
#四、删除函数
drop function myf2;

use information_schema;
show tables;
select count(*) from routines;
select * from routines limit 1, 1;
select distinct routine_schema from routines;
select * from routines where routine_schema = 'test';

#1.
use test;
delimiter ~
create function test_fun1(num1 float, num2 float) returns float
no sql
begin
	declare result float;
    set result = num1 + num2;
    return result;
end~
select test_fun1(1.02, 30.5)~