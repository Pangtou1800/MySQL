#TCL语言
/*
Transaction Control Language事务控制语言

事务：
	一个或一组SQL语句组成一个执行单元，这个执行单元要么全都执行，要么全都不执行
案例：
	转账
张三丰 1000
郭襄   1000
update 表 张三丰的余额=500 where name='张三丰';
update 表 郭襄的余额=1500 where name='郭襄';

#存储引擎
概念：
	在MySQL中的数据用不同的技术存储在文件中
查看：
	show engines;
对事务的支持：
	innoDB支持事务，myISAM、memory等不支持事务
    
#事务的ACID(acid)属性
1. 原子性(Atomicity)
	原子性指事务是一个不可分割的工作单位，事务中的操作要么都发生，要么都不发生。
2. 一致性(Consistency)
	事务必须使数据库从一个一致状态转换到另一个一致状态。
3. 隔离性(Isolation)
	事务的隔离性是指一个事务的执行不能被其他事务干扰，即一个事务内部的操作及使用的数据对并发的其他事务是隔离的，并发执行的各个事务之间不能相互干扰。
4. 持久性(Duration)
	持久性是指一个事务一旦被提交，它对数据库的改变就是永久性的，接下来的其他操作和数据库故障不应该对其有任何影响。
    
#事务的创建
隐式事务： 事务没有明显的开启和结束标记
	insert, update, delete语句
显式事务： 事务具有明显的开启和结束标记
前提： 必须先设置自动提交功能为禁用
	set autocommit = 0;
步骤1： 开启事务
set autocommit = 0;
start transaction; ※可选
步骤2： 编写SQL语句(select, insert, update, delete)
语句1;
语句2;
...
语句n;
步骤3： 结束事务
commit; 提交事务
rollback; 回滚事务

#并发事务问题
1. 脏读
	对于两个事务T1,T2, T1读取了已经被T2更新但还没有被提交的字段。之后如果T2回滚，T1读取的内容就是临时而且无效的。
2. 不可重复读
	对于两个事务T1,T2, T1读取了一个字段，然后T2更新了该字段。之后，T1再次读取同一个字段，值就不同了。
3. 幻读
	对于两个事务T1,T2, T1从一个表中读取了一个字段，然后T2在该表中插入了一些新的行。之后，如果T1再次读取同一个表，就会多出几行。
#数据库事务的隔离性：
	数据库系统必须具有隔离并发运行各个事务的能力，使它们不会相互影响，避免各种并发问题。
    一个事务与其他事务的隔离程度成为隔离级别。
#数据库提供的4中隔离级别：
1.READ UNCOMMITTED（读未提交数据） 脏、重、幻
2.READ COMMITTED（读已提交数据） 无脏，重、幻
3.REPEATABLE READ（可重复度） 无脏、重，幻
4.SERIALIZABLE（串行化） 无脏、重、幻
ORACLE支持2和4，默认为2
MySQL支持1,2,3,4，默认为3

savepoint 节点名
*/
show engines;
show variables like 'autocommit%';
set autocommit = 0;

#演示事务的使用步骤
use test;
drop table if exists account;
CREATE TABLE account (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(20),
    balance DOUBLE
);
insert into account(username, balance) values('张无忌',1000),('赵敏',2000);
desc account;
select * from account;
#1 开启事务
show variables like 'autocommit%';
set autocommit = 0;
start transaction;
update account set balance=2500 where username='张无忌' and id = 1;
update account set balance=5500 where username='赵敏' and id= 2;
commit;
rollback;
show variables like 'transaction_isolation';
set session transaction isolation level read uncommitted;
desc test;
use test;
select database();

/*
LEVEL1: READ UNCOMMITTED
·脏读： ○
·不可重复读： ○
·幻读： ○
演示：
01 窗口1	设置事务隔离级别为READ UNCOMMITTED
		set session transaction isolation level read uncommitted;
        show variables like 'transaction_isolation';
02 窗口1	设置事务自动提交为OFF
		set autocommit = 0;
        show variables like 'autocommit';
03 窗口1 查看当前表状态，确认表中有4条数据
		use test;
        select * from account;
04 窗口2 设置事务自动提交为OFF
		set session transaction isolation level read uncommitted;
		set autocommit = 0;
        use test;
05 窗口2 开启事务，更新一条数据
		start transaction;
        update account set username='Anne' where id = 2;
06 窗口1 开启事务
		start transaction;
        插入一条数明确标识事务开启
		insert into account values(99,'Hacker',100);
        查看当前表状态，确认表中id=2的数据被更新为"Anne"
		select * from account;
07 窗口2 回滚更新
		rollback;
08 窗口1 查看当前表状态，确认表中id=2的数据回到"Peter" >> 相比于06，脏读
		select * from account;
09 窗口2 开启事务，更新一条数，提交
		start transaction;
        update account set username='Bob' where id = 2;
        commit;
10 窗口1 查看当前表状态，确认表中id=2的数据被更新为"Bob" >> 相比于08，不可重复读
		select * from account;
11 窗口2 开启事务，插入2条数，删除1条数，提交
		start transaction;
        insert into account values(5,"Cindy",500),(6,"David",660);
        delete from account where id=2;
        commit;
12 窗口1 查看当前表状态，确认表中id=2的数据被删除，插入了id=5和6的数据 >> 相比于08，幻读
		select * from account;
13 窗口1 确认完毕，回滚;
		rollback;
*/
truncate table account;
insert into account values(1,'John',1000),(2,'Peter',1200),(3,'Rose',1500),(4,'Lily',1900);
set session transaction isolation level read uncommitted;
select @@transaction_isolation;
show variables like 'transaction_isolation';
set autocommit = 0;
select @@autocommit;
show variables like 'autocommit';
start transaction;
insert into account values(99,'Hacker',100);
select * from account;
rollback;
/*
LEVEL2: READ COMMITTED
·脏读： ×
·不可重复读： ○
·幻读： ○
演示：
01 窗口1	设置事务隔离级别为READ COMMITTED
		set session transaction isolation level read committed;
        show variables like 'transaction_isolation';
02 窗口1	设置事务自动提交为OFF
        show variables like 'autocommit';
        set autocommit = 0;
03 窗口1 查看当前表状态，确认表中有4条数据
        select * from account;
04 窗口2 设置事务自动提交为OFF
		set session transaction isolation level read uncommitted;
		set autocommit = 0;
        use test;
05 窗口2 开启事务，更新一条数据
		start transaction;
        update account set username='Anne' where id = 2;
06 窗口1 开启事务
		start transaction;
        插入一条数明确标识事务开启
		insert into account values(99,'Hacker',100);
        查看当前表状态，确认表中id=2的数据为"Peter"
		select * from account;
07 窗口2 回滚更新
		rollback;
08 窗口1 查看当前表状态，确认表中id=2的数据依然为"Peter" >> 相比于06，脏读现象消失
		select * from account;
09 窗口2 开启事务，更新一条数，提交
		start transaction;
        update account set username='Bob' where id = 2;
        commit;
10 窗口1 查看当前表状态，确认表中id=2的数被更新为"Bob" >> 相比于08，不可重复读
		select * from account;
11 窗口2 开启事务，插入2条数，删除1条数，提交
		start transaction;
        insert into account values(5,"Cindy",500),(6,"David",660);
        delete from account where id=2;
        commit;
12 窗口1 查看当前表状态，确认表中id=2的数据被删除，插入了id=5和6的数据 >> 相比于08，幻读
		select * from account;
13 窗口1 确认完毕，回滚;
		rollback;
*/
/*
LEVEL3: REPEATABLE READ
·脏读： ×
·不可重复读： ×
·幻读： ○
演示：
01 窗口1	设置事务隔离级别为READ COMMITTED
		set session transaction isolation level repeatable read;
        show variables like 'transaction_isolation';
02 窗口1	设置事务自动提交为OFF
        show variables like 'autocommit';
        set autocommit = 0;
03 窗口1 查看当前表状态，确认表中有4条数据
        select * from account;
04 窗口2 设置事务自动提交为OFF
		set session transaction isolation level read uncommitted;
		set autocommit = 0;
        use test;
05 窗口2 开启事务，更新一条数据
		start transaction;
        update account set username='Anne' where id = 2;
06 窗口1 开启事务
		start transaction;
        插入一条数明确标识事务开启
		insert into account values(99,'Hacker',100);
        查看当前表状态，确认表中id=2的数据为"Peter"
		select * from account;
07 窗口2 回滚更新
		rollback;
08 窗口1 查看当前表状态，确认表中id=2的数据依然为"Peter" >> 相比于06，脏读现象消失
		select * from account;
09 窗口2 开启事务，更新一条数，提交
		start transaction;
        update account set username='Bob' where id = 2;
        commit;
10 窗口1 查看当前表状态，确认表中id=2的数据被依然为"Peter" >> 相比于08，不可重复读现象消失
		select * from account;
11 窗口2 开启事务，插入2条数，删除1条数，提交
		start transaction;
        insert into account values(5,"Cindy",500),(6,"David",660);
        delete from account where id=2;
        commit;
12 窗口1 查看当前表状态，确认表中id=2的数据被删除，插入了id=5和6的数据 >> 相比于08，幻读
		需要使用当前读，普通select为快照读
		select * from account for update;
13 窗口1 确认完毕，回滚;
		rollback;
*/
/*
LEVEL4: SERIALIZABLE
·脏读： ×
·不可重复读： ×
·幻读： ×
演示：
01 窗口1	设置事务隔离级别为SERIALIZABLE
		set session transaction isolation level serializable;
        show variables like 'transaction_isolation';
02 窗口1	设置事务自动提交为OFF
        show variables like 'autocommit';
        set autocommit = 0;
03 窗口1 以select开启事务
        select * from account;
04 窗口2 设置事务自动提交为OFF
		set session transaction isolation level read uncommitted;
		set autocommit = 0;
        use test;
05 窗口2 以select开启事务,获取和03相同的结果
        select * from account;
06 窗口1 尝试insert, delete, update
		insert into account values(99,'Hacker',100);  => 等待其它事务，没有结果，一段时间后timeout
        rollback;
07 窗口2 回滚结束事务
		rollback;
08 窗口1 以insert, delete, update开启事务
		insert into account values(99,'Hacker',100);
09 窗口2 尝试select
		select * from account;  => 等待其它事务，没有结果，一段时间后timeout
        rollback;
10 窗口1 回滚结束事务
		rollback;
*/
#3. 演示savepoint的使用
use test;
set autocommit= 0;
start transaction;
select * from account;
delete from account where id = 3;
savepoint a;
delete from account where id = 4;
rollback to a;
rollback;