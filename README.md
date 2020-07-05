# 本单元目标

## 一、为什么要学习数据库

## 二、数据库的相关概念

    1、DB：数据库，保存一组有组织的数据的容器
    2、DBMS：数据库管理系统，又称为数据库软件（产品），用于管理DB中的数据
    3、SQL：结构化查询语言，用于和DBMS的通信

## 三、数据库存储数据的特点

    1、将数据放到表中，表在放到库中
    2、一个数据库中可以有多个表，每个表都有一个名字用来标识自己，表名具有唯一性
    3、表具有一些特性，这些特性定义了数据在表中如何存储
    4、表由列组成，也称为字段。所有表都是由一个或多个列组成的
    5、表中的数据是按行存储的

## 四、初始MySQL

### MySQL产品的介绍和安装

### MySQL服务的启动和停止

    方式一：计算机-右击管理-服务
    方式二：通过管理员身份运行CMD
        net start 服务名（启动服务）
        net stop 服务名（停止服务）

### MySQL服务的登陆和退出

    方式一：通过MySQL自带的客户端 ※只限于root用户

    

    方式二：通过Windows自带的CMD
    登陆：
        mysql [-h 主机名 -P 端口号 ] -u 用户名 -p 密码

    退出：
        exit 或 Ctrl + C

### MySQL的常见命令

    1.查看当前所有数据库
        show databases
    2.打开指定的库
        use 库名
    3.查看当前库的所有表
        show tables
    4.查看其他库的所有表
        show tables from 库名
    5.创建表
        create table (
            列名 列类型,
            列名 列类型,
            ...
            列名 列类型
        );
    6.查看表结构
        desc 表名
    7.查看服务器的版本
    方式一：登录到MySQL服务端
        select version();
    方式二：没有登录到服务端
        mysql --version
    或
        mysql --V

### MySQL的语法规范

    1.不区分大小写，但建议关键字大写，表名、列名小写
    2.每条命令用;或者\g结尾
    3.每条命令根据需要，可以进行缩进或换行
    4.注释
        单行注释： #注释文字
        单行注释： -- 注释文字 ※注意需要空格
        多行注释： /* 注释文字 */

## 五、DQL语言的学习

### 基础查询

### 条件查询

### 排序查询

    一、語法
    select 查詢列表
    from 表名
    where 筛选条件
    order by 排序列表 【asc|desc】

    二、特点

    1. asc：升序

       desc：降序

    2. 排序列表支持单个字段、多个字段、函数、表达式、别名
    3. order by的位置一半放在查询语句的最后（除limit语句之外）

### 常见函数

    一、概述
    好处：提高重用性和隐藏实现细节
    调用：select 函数名（实参列表）

    二、单行函数

    1. 字符函数

    concat: 连接
    substr：截取子串
    upper、lower：大小写
    replace：替换
    length：获取字节长度
    trim：去前后空格
    lpad、rpad：左右填充
    instr：获取子串第一次出现的索引

    2. 数学函数

    ceil：向上取整
    round：四舍五入
    floor：向下取整
    mod：取模
    truncate：截断
    rand：随机数，[0-1)

    3. 日期函数

    str_to_date：将字符转换为时间
    date_format：将日期转换为字符
    now：返回当前日期外加时间
    curdate：返回当前日期
    curtime：返回当前时间
    year, month, day, hour, minute, second: 取出对应部分
    datediff：返回两个日期相差的天数
    monthname：以英文形式返回月

    4. 其他函数

    version：当前服务器数据库版本
    database：当前打开的数据库
    user：当前用户
    password('xx')：返回该字符的密码形式 => MySQL8.0已经不能使用
    md5：返回字符的MD5码

    5. 流程控制函数

    if(条件,表达式1,表达式2)
    case
    when then
    when then
    else
    end

    

    三、分组函数

    1. 分类

    max：最大值
    min：最小值
    sum：和
    avg：平均值
    count：计数

    2. 特点

    >1 语法
    select max(字段) from 表名;
    >2 支持的类型
    sum, avg一般用于处理数值型
    max, min, count可以处理任何数值类型
    >3 以上分组函数都忽略null值
    >4 都可以搭配关键字distinct使用
    >5 count函数
    count(字段)：统计该字段非空值的个数
    count(*)：统计结果集的行数 MyISAM存储引擎效率最高
    count(1)：效率<=count(*)  InnoDB存储引擎效率相近
    >6 和分组函数一同查询的字段要求是group by后出现的字段

### 分组查询

    一、语法
    select 分组函数，分组后的字段 5
    from 表 1
    【where 筛选条件】 2
    group by 分组字段 3
    【having 分组后的筛选】 4
    【order by 排序列表】 6

    ※ group by和having为了通用性不使用别名

    二、特点

                关键字  表           位置
    分组前筛选  where   原始表      group by之前
    分组后筛选  having  分组后结果  group by之后

### 连接查询

    一、含义
    当查询中涉及到了多个表的字段，需要使用多表连接查询

    select 字段1,字段2
    from 表1，表2

    笛卡尔乘积：当查询多个表时，没有添加有效的连接条件，导致多个表所有行实现完全连接
    如何解决：添加有效的连接条件

    二、分类

    按年代分：
        SQL92：
            内连接   > 等值，非等值，自连接
            外连接   > 也支持一部分外连接（用于oracle, sqlserver, MySQL不支持）
        SQL99：
            内连接   > 等值，非等值，自连接
            外连接   > 左外，右外，全外（MySQL不支持全外）
            交叉连接

    

#### SQL92语法

    1.等值连接
        select 查询列表
        from 表1 as 别名1, 表2 as 别名2
        where 表1.key = 表2.key
        【and 筛选条件】
        【group by 分组字段】
        【having 分组后筛选】
        【order by 排序字段】

    特点：

        1. 一般为表起别名
        2. 多表顺序可以调换
        3. n表连接至少需要n-1个连接条件
        4. 多表连接结果是多表的交集部分

    2.非等值连接
        select 查询列表
        from 表1 as 别名1, 表2 as 别名2
        where 非等值连接条件
        【and 筛选条件】
        【group by 分组字段】
        【having 分组后筛选】
        【order by 排序字段】

    3.自连接
        select 查询列表
        from 表1 as 别名1, 表1 as 别名2
        where 别名1.key = 别名2.key
        【and 筛选条件】
        【group by 分组字段】
        【having 分组后筛选】
        【order by 排序字段】
    子查询
    分页查询
    union联合查询

#### SQL99语法

    1.内连接
        语法：
        select 查询列表
        from 表1 as 别名1
        【inner】 join 表2 as 别名2
        on 连接条件
        【where 筛选条件】
        【group by 分组条件】
        【having 分组后筛选】
        【order by 排序列表】
        【limit 子句】；

        特点：

        1. 标的顺序可以调换
        2. 内连接的结果=多表的交集
        3. n表连接至少需要n-1个连接条件

    2.外连接
        语法：
        select 查询列表
        from 表1 as 别名1
        left|right|full 【outer】 join 表2 as 别名2
        on 连接条件
        【where 筛选条件】
        【group by 分组条件】
        【having 分组后筛选】
        【order by 排序列表】
        【limit 子句】；

        特点：

        1. 查询的结果=主表中所有的行，其中从表和它匹配的将显示匹配航；没有匹配则显示null
        2. left join左侧是主表，right join右侧是主表，full join两边都是主表
        3. 一般用于查询除了交集部分的不匹配行

    3.交叉连接
        语法：
        select 查询列表
        from 表1 as 别名1
        cross join 表2 as 别名2;

        特点：

        生成一个笛卡尔乘积

### 子查询

    一、含义
        嵌套在其它语句内部的select语句称为子查询
        外面的语句可以是insert、update、delete、select等，select使用较多
        外面如果为select语句，则此语句称为外查询或主查询

    

    二、分类

        1. 按出现位置

            ·select后面
                仅支持标量子查询
            ·from后面
                表子查询
            ·where或having后面
                标量子查询
                列子查询
                行子查询
            ·exists后面
                任意

        2. 按结果集行列

            ·标量子查询（单行子查询）：结果集为一行一列
            ·列子查询（多行子查询）：结果集为多行一列
            ·行子查询：结果集为多行多列
            ·表子查询（嵌套子查询）：结果集为任意

    三、示例（where或having后的子查询）

        1. 标量子查询

            >查询最低工资的员工姓名和工资
            select
                last_name, salary
            from
                employees
            where
                salary = (
                    select
                        min(salary)
                    from
                        employees
                );

        2. 列子查询

            >查询所有是领导的员工的姓名
            select
                last_name
            from
                employees
            where
                emloyee_id in (
                    select distinct
                        manager_id
                    from
                        employees
                );

### 分页查询

    一、应用场景
        当要查询的条目数太多，一页显示不全

    二、语法
        select 查询列表
        from 表
        limit 【offset, 】size;

        注意：
        ·offset代表起始条目数，从0开始，省略默认为0
        ·size代表显示条目数

        页数为page时：
        limit (page-1)*size, size

### 联合查询

    一、含义
        union：合并、联合，将多次查询结果合并成一个结果

    二、语法
        查询语句1
        union 【all】 查询语句2
        ...
        union 【all】 查询语句n

    

    三、意义
        1.将一条比较复杂的查询语句拆分成多条
        2.适用于查询多个表的时候，查询的列基本一致

    四、特点
        1.要求多条查询语句的查询列数必须一致
        2.要求多条查询语句的查询各列类型、顺序最好一致
        3.union 去重；union all 包含重复项

### 查询总结

    语法
        select 查询列表 7
        from 表1 【as 别名1】 1
        【inner|left|right|cross join 表2 【as 别名2】】 2
        【on 连接条件】 3
        【where 筛选条件】 4
        【group by 分组列表】 5 ※支持别名
        【having 分组后筛选】 6 ※支持别名
        【order by 排序列表】 8 ※支持别名
        【limit 起始条目索引, 条目数】; 9

    

## 六、DML语言的学习

### 插入

    一、方式一
        语法：
            insert into 表名 【(字段名, ...)】
            values(值, ...)【, (值, ...)】; 
        

        特点：

            1. 要求值的类型和字段的类型要一致或兼容
            2. 字段的个数和顺序不一定于原始表中的字段个数和顺序一致，

              但必须保证字段和值一一对应

            3. 假如表中有可以为null的字段，可以：

                1> 字段和值都不写
                2> 字段记入后，值使用null

            4. 字段和值的个数必须一致
            5. 字段名可以省略，默认值为所有列

    二、方式二
        语法：
            insert into 表名
            set 字段1=值1【, 字段2=值2...】;

    ※两种方式的区别：

        ·方式一支持一次插入多行
        ·方式一支持子查询，语法如下：
            insert into 表名 查询语句;

### 修改

    一、修改单表的记录
        语法：
            update 表名
            set 字段1=值1【,字段2=值2...】
            【where 筛选条件】;

    二、修改多表的记录（级联更新）
        语法:
            update 表1 as 别名1
            inner|left|right join 表2 as 别名2
            on 连接条件
            set 字段1=值1【,字段2=值2...】
            【where 筛选条件】;

### 删除

    一、方式一：使用delete

        1. 删除单表的记录

            语法：
                delete from 表名
                where 筛选条件
                【limit 条目数】;

        2. 删除多表的记录（级联删除）

            语法：
                delete 别名1【,别名2】
                from 表1 as 别名1
                inner|left|right join 表2 as 别名2
                on 连接条件
                where 筛选条件;

    二、方式二：使用truncate
        语法：
            truncate table 表名;

    ※两种方式的区别：

        1. truncate效率较高
        2. 自增列在删除后再插入时，truncate从1开始，delete从断点开始
        3. delete可以添加筛选条件，truncate不可以
        4. delete返回受影响的行数，truncate没有返回值
        5. delete可以回滚，truncate不能回滚

## 七、DDL语言的学习

### 库的管理

    一、创建库
        create database 【if not exists】 库名
        【character set 字符集】
        【存储引擎】
        【语法模式】;

    二、修改库
        alter database 库名 【character set 字符集】;
        ※库名不能用DDL语言修改（可以在关闭服务的情况下去修改目录名）

    三、删除库
        drop database 【if exists】 库名;

### 表的管理

    一、创建表
        create table 【if not exists】 表名 (
            字段名 字段类型 【约束】,
            字段名 字段类型 【约束】,
            ...
            字段名 字段类型 【约束】
        );

    二、修改表
        1.添加列
            alter table 表名 add column 列名 类型 【约束】 【first|(after 字段)】;
            ※不指定位置时默认在最后
            
        2.修改列的类型或约束
            alter table 表名 modify column 列名 类型 【约束】;

        3.修改列名
            alter table 表名 change 【column】 旧列名 新列名 类型 【约束】;

        4.删除列
            alter table 表名 drop column 列名;

        5.修改表名
            alter table 表名 rename to 新表名;

    三、删除表
        drop table 【if exists】 表名;

    四、复制表
        1.复制表的结构
            create table 表名 like 参照表;
        
        2.复制表的数据
            create table 表名
            select 列
            from 参照表
            【where 筛选条件】;

### 数据类型

    一、数值型
        1.整型
            tinyint, smallint, mediumint, int|integer, bigint
            1        2         3          4            8

            >特点：
                ·都可以设置有符号和无符号，默认有符号，关键字unsigned
                ·如果超出范围会有outOfRange异常，旧版本插入临界值
                ·长度可以不指定，使用默认值
                 长度代表最大宽度，如果不够则左补零，但需要搭配fillzero使用，
                 fillzero指定后变为无符号数
        2.浮点型
            浮点数：
                float(M,D)
                double(M,D)

            定点数：
                dec(M,D)
                decimal(M,D)

            >特点：
                ·M代表整数位+小数位，D代表小数位
                ·如果超出范围会有outOfRange异常，旧版本插入临界值
                ·M和D都可以省略，dec默认为(10,0)
                ·如果精度要求较高，则优先考虑使用定点数

    二、字符型
        char, varchar, binary, varbinary, bit, enum, set, text, blob

        >char:
            固定长度的字符，写法为char(M)，M代表最大长度，可以省略，默认值为1
        >varchar:
            可变长度的字符，写法为varchar(M)，M代表最大长度，不可以省略

    三、日期型
        year, date, time, datetime, timestamp
                          8         4
                                    比较容易受时区和语法版本的影响，但记录了时区

### 常见约束

    一、常见约束
        NOT NULL:       非空，该字段的值必填
        UNIQUE：        唯一，该字段的值不可重复
        DEFAULT：       默认，该字段有默认值
        CHECK：         检查，MySQL不支持
        PRIMARY KEY：   主键，该字段的值不可重复且非空 => UNIQUE NOT NULL
        FOREIGN KEY:    外键，该字段引用了其他表的值

        主键和唯一

        >区别：
            ·一个表只能有一个主键，但可以有多个唯一键    
            ·主键不允许为空，唯一可以为空
        >相同:
            ·都具有唯一性
            ·都支持组合键

        外键
        1.用于限制两个表的关系，从表的字段值引用了主表的某字段值
        2.外键列和主表的被引用列要求类型一致，意义相同，名称无要求
        3.主表的被引用列要求是一个Key（一般就是主键）
        4.插入数据时先插入主表，删除数据时先删除从表
            可以通过以下两种方式来删除主表的记录：
                方式一：级联删除
                    在创建外键时在最后添加 on delete cascade
                方式二：级联置空
                    在创建外键时在最后添加 on delete set null
        
    二、创建表时添加约束
        create table 表名(
            字段名 字段类型 not null, #非空
            字段名 字段类型 primary key, #主键
            字段名 字段类型 unique, #唯一
            字段名 字段类型 default 默认值, #默认
            constraint 约束名 foreign key(字段名) references on 主表(被引用列)
        );

        注意：
                    支持            起名
        列级约束    除了外键        不可
        表级约束    除了非空和默认  可，但主键无效

        列级约束可以在一个字段上添加多个，空格隔开，没有顺序要求

    三、修改表时添加或删除约束
        1.非空
            添加：
                alter table 表名 modify column 字段名 字段类型 not null;
            删除：
                alter table 表名 modify column 字段名 字段类型;
        2.默认
            添加：
                alter table 表名 modify column 字段名 字段类型 default 默认值;
            删除：
                alter table 表名 modify column 字段名 字段类型;
        3.主键
            添加：
                alter table 表名 add 【constraint 约束名】 primary key(字段名);
            删除：
                alter table 表名 drop primary key;
        4.唯一
            添加：
                alter table 表名 add 【constraint 约束名】 unique(字段名);
            删除：
                alter table 表名 drop index 索引名;
        5.外键
            添加：
                alter table 表名 add 【constraint 约束名】 foreign key(字段名) references 主表(被引用列);
            删除：
                alter table 表名 drop foreign key 索引名;

    四、自增长列（标识列）
        ·特点：
            1.不需要手动插入值，可以自动提供序列值，默认从1开始，步长为1
              show variables like 'auto_increment%';
              如果要更改起始值，则手动插入数据；如果要更改步长，则
                set auto_increment_increment = 步长;
            2.一个表最多有一个自增长列
            3.自增长列只支持数值型
            4.自增长列必须是一个KEY
        
        ·创建表时设置自增长列
            create table 表名(
                字段名 字段类型 约束 auto_increment,
                ...
                字段名 字段类型
            );

        ·修改表时添加自增长列
            alter table 表名 modify column 字段名 字段类型 约束 auto_increment;

        ·修改表时删除自增长列
            alter table 表名 modify column 字段名 字段类型 约束;

## 八、TCL语言

### 事务

    一、含义
        事务：一条或多条SQL语句组成一个执行单位，这一组SQL语句要么都执行，要么都不执行

    

    二、特点（ACID）
        A: 原子性
            一个事务是不可再分割的整体，要么都执行，要么都不执行
        C: 一致性
            一个事务执行前后数据都是一致的
            一个事务使数据从一个一致状态切换到另一个一致状态
        I: 隔离性
            不同事务并发执行时不会相互影响
            一个事务不受其他事务的干扰，多个事务是相互隔离的
        D: 持久性
            事务结束后，事务对数据库的更新是长久的
            一个事务一旦提交了，则永久持久化到本地

    

    三、事务的使用步骤
        了解：
            ·隐式（自动）事务
                没有明显的开始和结束，本身就是一条事务可以自动提交，
                如insert, update, delete
            ·显式事务
                具有明显的开始和结束

        使用显式事务：

        1. 开始事务

            set autocommit = 0;
            start transaction;

        2. 编写一组SQL语句 ※指的就是insert, update, delete, select

        2.5 设置回滚点
            savepoint 回滚点名;
        
        2.6 回到回滚点
            rollback to 回滚点名;

        3. 结束事务

            commit;
            rollback;
        
    四、并发事务
        1.事务的并发是如何发生的？
            多个事务同时操作同一个数据库的相同数据时
        2.并发问题有哪些？
            ·脏读
                读取了未提交数据（更新数据）
            ·不可重复读
                一个事务内多次查询结果不同
            ·幻读
                一个事务读取了其他事务的已提交数据（插入数据）
        3.如何解决并发问题
            => 设置隔离级别
        4.隔离级别
            ·READ UNCOMMITTED   读未提交    脏读、不可重复读、幻读 都会发生
            ·READ COMMITTED     读已提交    避免脏读，不可重复读、幻读会发生
            ·REPEATABLE READ    可重复读    避免脏读、不可重复读，幻读会发生
            ·SERIALIZABLE       串行化      脏读、不可重复读、幻读都可以避免

## 九、视图

    一、含义
        MySQL5.1版本出现的新特性。
        视图本身是一个虚拟表，它的数据来自于表，是查看时动态生成的。

        好处：
            1.简化SQL语句
            2.提高了SQL语句的重用性
            3.保护基表数据，提高安全性

    二、创建
        create view 视图名 as 查询语句;

    三、修改
        ·方式一：
            create or replace view 视图名 as 查询语句;
        ·方式二：
            alter view 视图名 as 查询语句;

    四、删除

        drop view 视图名;

    五、查看
        show create view 视图名;    

    六、使用
        1.插入 insert
        2.修改 update
        3.删除 delete
        4.查看 select

        注意：视图一般用于查询，不用做更新，具有以下特点的视图不可以更新
            ·包含分组函数、group by、distinct、having、union
            ·join
            ·常量视图
            ·where后的子查询用到了from的表
            ·用到了不可更新的视图

    七、视图和表的对比
            关键字  是否占用物理空间        使用
    视图    view    占用较小，只保存SQL逻辑 查询
    表      table   占用较大，保存实际数据  增删改查

## 十、变量

### 一、系统变量

    说明：
        变量由系统提供，不需要自定义

    语法：
            ·查看系统变量
                show 【global|session】 variables like '';
                ※不指定默认session
            ·查看指定系统变量的值
                select @@【global|session.】变量名;
                ※不指定默认session
            ·为系统变量赋值
                方式一：
                    set 【global|session】 变量名=值;
                方式二：
                    set @@【global|session.】变量名=值;
            

    1.全局变量
        服务器层面，作用域为整个服务器，对所有连接（会话）有效。
        必须拥有super权限才能为系统变量赋值。

    2.会话变量
        服务器为每一个连接的客户端都提供了系统变量，作用域为当前的连接（会话）。

### 二、自定义变量

    说明：
        用户自己定义的变量

    1. 用户变量

        作用域：针对于当前的会话（连接）有效
        位置：begin end里面或外面
        使用：
            ·声明并赋值：
                set @变量名=值; 
                set @变量民:=值; 
                select @变量名:=值; 
            ·更新值：
                方式一：
                    set @变量名=值; 
                    set @变量民:=值; 
                    select @变量名:=值; 
                方式二：
                    select xx into @变量名 from 表; 
            ·使用
                select @变量名; 

    

    2. 局部变量

        作用域：
            仅仅在定义它的begin end中有效
        位置：
            只能放在begin end中，而且只能放在第一句
        使用：
            ·声明并赋值
                declare 变量名 类型【 default 默认值】; 
            ·更新值
                方式一：
                    set 变量名=值; 
                    set 变量民:=值; 
                    select 变量名:=值; 
                方式二：
                    select xx into 变量名 from 表; 

            ·使用
                直接使用
                select 变量名;

## 十二、存储过程和函数

    说明：
        将完成一组特定功能的逻辑语句包装起来，对外暴露名字
    好处：
        1.提高重用性
        2.SQL语句简化
        3.减少了和数据库服务器连接的次数，提高效率

### 存储过程

    一、创建

        delimiter ~
        create procedure 存储过程名(参数模式 参数名 参数类型)
        begin
            存储过程体
        end ~

        注意：
            1.参数模式：in, out, inout ※其中in可以省略
            2.存储过程体的每一条SQL语句都需要用分号结尾

    二、调用

        call 存储过程名(实参列表);

        举例：
            ·in模式
                call sp1('值'); 
            ·out模式
                set @name; 
                call sp1(@name); 
                select @name; 
            ·inout模式
                set @name = 值; 
                call sp1(@name); 
                select @name; 

    

    三、查看

        show create procedure 存储过程名;

    四、删除

        drop procedure 存储过程名;

### 函数

    一、创建

        delimiter ~
        create function 存储过程名(参数名 参数类型) returns 返回类型
        begin
            函数体
        end ~

        注意：
            1.函数必须有一个返回值，函数体中肯定有return语句

    二、调用

        select 函数名(实参列表);     

    三、查看

        show create function 函数名;

    四、删除

        drop function 函数名;

## 十三、流程控制结构

### 顺序结构

    程序从上往下依次执行

### 分支结构

    按条件进行选择执行，从两条或者多条路径中选择一条执行

    一、if函数

        功能： 
            实现双分支

        语法：
            if(条件, 值1, 值2)

        位置：
            可以作为表达式放在任何位置

    二、case结构

        功能：
            实现多分支

        语法1：
            case 表达式|字段
            when 值1 then 语句1;
            when 值2 then 语句2;
            ...
            else 语句n;
            end 【case】;

        语法2：
            case
            when 条件1 then 语句1;
            when 条件2 then 语句2;
            ...
            else 语句n;
            end 【case】;

        位置：
            任何位置
            如果在begin end外面，则一般是作为表达式结合其他语句使用；
            如果在begin end里面，则一般是作为独立的语句使用。

    三、if结构

        功能：
            实现多分支

        语法：
            if 条件1 then 语句1;
            elseif 条件2 then 语句2;
            ...
            else 语句n;
            end if;

        位置：
            只能在begin end里面

### 循环结构

    满足一定的条件下，重复执行一组语句

    位置：
        只能放在begin end中

    特点：
        都能实现循环结构

    对比：
        ·这三种循环都可以省略名称，但如果循环中添加了循环控制语句（leave, iterate），
         则必须添加名称
        ·loop一般用于实现简单的死循环
        ·while先判断后执行，repeat先执行后判断

    一、while

        语法：
            【名称:】 while 循环条件 do
                循环体
            end while 【名称】;

    二、loop

        语法：
            【名称:】 loop
                循环体
            end loop 【名称】;

    三、repeat

        语法：
            【名称:】 repeat
                循环体
            until 结束条件
            end repeat 【名称】;

    四、循环控制语句

        1.leave
            类似于break，用于跳出所在循环
        2.iterate
            类似于continue，用于结束本次循环，继续下一次
