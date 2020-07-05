#流程控制结构
/*
顺序结构： 程序从上往下顺序执行
分支结构： 程序可以从两条或多条路径中选择一条执行
循环结构： 程序在满足一定条件的基础上，重复执行一段代码

一、分支结构
	1.if函数
		功能：
			实现简单的双分支
        语法：
			select if(表达式1, 表达式2, 表达式3)
		执行顺序：
			如果表达式1成立，则if函数返回表达式2的值，否则返回表达式3的值
		应用：
			任何地方
	2.case结构
		·情况1： 类似于switch语句，一般用于实现等值判断
			语法：
				case 变量|表达式|字段
                when 要判断的值1 then 返回值1【或语句1;】
                when 要判断的值2 then 返回值2【或语句2;】
                ...
                else 要返回的值【n或语句n;】
                end 【case;】
        ·情况2： 类似于多重if，一般用于实现区间判断
			语法：
				case
                when 要判断的条件1 then 返回值1【或语句1;】
                when 要判断的条件2 then 返回值2【或语句2;】
                ...
                else 要返回的值n【或语句n;】
                end 【case;】
		特点：
			1.既可以作为表达式，嵌套在其他语句中使用（任何地方），
              也可以作为独立的语句使用（begin end之间）。
			2.如果when中的值或条件成立，则执行对应的then后的语句并结束case，
              如果都不满足则执行else后的语句。
			3.else可以省略。此时所有when都不满足时则返回null。
	3.if结构
		功能：
			实现多重分支
		语法：
			if 条件1 then 语句1;
            elseif 条件2 then 语句2;
            ...
            else 语句n;
            end if;
		应用：
			只能用在begin end中
		
*/
#案例： 创建存储过程，根据传入的成绩来显示等级，比如传入的成绩：90~100，显示A，80~90，显示B，60~80，显示C，否则显示D
delimiter ~
create procedure test_case(in score int)
begin
	case
    when score between 90 and 100 then select 'A';
    when score between 80 and 90 then select 'B';
    when score between 70 and 80 then select 'C';
    else select 'D';
    end case;
end ~
call test_case(59)~
#案例：
create procedure test_case2(in score int, out grade varchar(1))
begin
	if score between 90 and 100
		then set grade = 'A';
	elseif score between 80 and 90
		then set grade = 'B';
	elseif score between 60 and 80
		then set grade = 'C';
	else
		set grade = 'D';
    end if;
end~
call test_case2(75, @grade)~
select @grade~
/*
二、循环结构
分类：
	while, loop, repeat
循环控制：
	iterate（类似于continue），结束本次循环，继续下一次
    leave（类似于break），跳出
    
1.while
	语法：
		【标签: 】while 循环条件 do
			循环体;
		end while【 标签】;
2.loop
	语法：
		【标签: 】loop
			循环体;
		end loop【 标签】;
	※可以用来模拟简单的死循环

3.repeat
	语法：
		【标签: 】repeat
			循环体;
		until 结束循环条件
        end repeat【 标签】;
*/
#案例： 根据设定的次数批量插入admin表
delimiter ;
use test;
delimiter ~
create procedure pro_while1(in insertCtr int)
begin
	declare ctr int default 1;
	while1: while ctr <= insertCtr do
		insert into admin(username, `password`) values('lily','dddeee');
        set ctr = ctr + 1;
    end while while1;
end ~
call pro_while1(4)~
select * from admin~
#案例：添加leave语句
drop procedure pro_while2~
create procedure pro_while2(in insertCtr int)
begin
	declare ctr int default 1;
	while1: while ctr <= insertCtr do
		if ctr > 20 then 
			leave while1;
        end if;
		insert into admin(username, `password`) values(concat('lily',ctr),'dddeee');
        set ctr = ctr + 1;
    end while while1;
end ~
call pro_while2(50)~
select * from admin~
delete from admin where username='lily' and id > 0;
#案例：添加iterate语句
drop procedure pro_while3;
create procedure pro_while3(in insertCtr int)
begin
	declare ctr int default 0;
	while1: while ctr <= insertCtr do
		set ctr = ctr + 1;
        if mod(ctr,2) = 1 then 
			iterate while1;
        end if;
		insert into admin(username, `password`) values(concat('lily',ctr),'dddeee');
    end while while1;
end ~
call pro_while3(20)~
select * from admin~
#案例
delimiter ;
create table stringcontent(
	id int primary key auto_increment,
    content varchar(20)
);
desc stringcontent;
delimiter ~
drop procedure insertRanStr;
create procedure insertRanStr(in ctr int)
begin
	declare idx int default 0;
    declare alphabets varchar(26) default 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    declare startPos int default 1;
    declare strLen int default 1;
    declare randStr varchar(20);
    L:while idx < ctr do
		set startPos = rand() * 26 + 1;
        set strLen = rand() * (26 - startPos + 1) + 1;
        set randStr = substr(alphabets, startPos, if(strLen > 20, 20, strLen));
		insert into stringcontent(content) values(randStr);
        set idx = idx + 1;
    end while L;
end ~
call insertRanStr(20)~
select * from stringcontent~