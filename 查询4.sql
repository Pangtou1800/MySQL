#进阶4： 常见函数
/*
概念： 将一组逻辑语句封装在方法体中，对外暴露方法名
好处： 1、隐藏了实现细节 2、提高代码重用性
调用： select 函数名(实参列表) 【from 表】;
特点： 
	1.叫什么（函数名）
    2.干什么（函数功能）
分类：
	1.单行函数
        字符函数：
			length, concat, substr(substring), instr, trim, upper, lower, lpad, rpad, replace
        数学函数:
			round, ceil, floor, truncate, mod
        日期函数:
			now, curdate, curtime, year, month, monthname, day, hour, minute, second, str_to_date, date_format
        其他函数【补充】:
			version, database, user
        流程控制函数【补充】:
			if, case
    2.分组函数
		功能： 做统计使用，又称为统计函数、聚合函数、组函数
*/

#一、字符函数
#1.length 获取参数值的[字节]个数
SELECT LENGTH('john');
SELECT LENGTH('张三丰');
show variables like 'character%';
#2.concat 拼接字符串
SELECT 
    CONCAT(last_name, ',', first_name) AS 姓名
FROM
    employees;
#3.upper, lower
SELECT UPPER('John'), LOWER('John');
SELECT 
    CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS 姓名
FROM
    employees;
#4.substr, substring 截取字符
# 注意1： 索引从1开始
# 注意2： 以字符为单位
#startPos
SELECT SUBSTR('李莫愁爱上了陆展元', 7) AS output; 
 #startPos, length
SELECT 
    SUBSTR('李莫愁爱上了陆展元',
        1,
        3) AS output;
#案例： 姓名中首字符大写，其他字符小写，然后用下划线拼接显示
SELECT 
    CONCAT(UPPER(SUBSTR(last_name, 1, 1)),
            '_',
            LOWER(SUBSTR(last_name, 2))) AS 姓名
FROM
    employees;
#5.instr 查找子串第一次出现的位置，找不到时返回0
SELECT 
    INSTR('杨不悔爱上了殷六侠',
            '殷六侠') AS strPos;
#6.trim 日本語全角ブランク対応していない～
SELECT 
    CONCAT('|',
            TRIM(' a b c あ　い　う　　　　'),
            '|') AS trimOut;
SELECT TRIM('a' FROM 'aaBaaaaDaa') AS trimAOut;
#7,8.lpad, rpad
SELECT LPAD('AAA', 10, '*');
SELECT RPAD('AAA', 10, '*');
SELECT 
    LPAD('猫', 5, 'a') AS catLPad,
    RPAD('猫', 5, 'bcd') AS catRPad,
    LPAD('33', 10, '0') AS zero;
#9.replace
SELECT REPLACE('abcdadbc', 'a', 'e');

#二、数学函数
#1.round
SELECT ROUND(1.65), ROUND(- 1.65), ROUND(1.65, 1);
#2.ceil 没有重载函数
SELECT CEIL(1.002), CEIL(- 1.002);
#3.floor 没有重载函数
SELECT FLOOR(1.002), FLOOR(- 1.002);
#4.truncate 截断
SELECT TRUNCATE(1.65, 1), TRUNCATE(- 1.65, 1);
#5.mod 取余 mod(a,b) : a-a/b*b
SELECT MOD(10, 3), MOD(- 10, 3);

#三、日期函数
#1.now 返回当前系统日期+时间
SELECT NOW();
#2.curdate 返回系统日期
SELECT CURDATE();
#3.curtime 返回系统时间
SELECT CURTIME();
#4.year,month,day,hour,minute,second
SELECT 
    YEAR(NOW()),
    YEAR('19920115'),
    YEAR('1992-01-15'),
    MONTH(NOW()),
    MONTHNAME(NOW()),
    DAY(NOW()),
    HOUR(NOW()),
    MINUTE(NOW()),
    SECOND(NOW());
#5.str_to_date
SELECT STR_TO_DATE('9-13-1992', '%m-%d-%Y');
/*
%Y : 四位的年
%y : 二位的年
%m : 月份（01， 02，。。。12）
%c : 月份（1,2，。。。12）
%d : 日
%H : 小时（24小时制）
%h : 小时（12小时制）
%i : 分钟
%s : 秒
*/
SELECT STR_TO_DATE('19983-2', '%Y%c-%d') AS output, STR_TO_DATE('1992年4月3号', '%Y年%m月%d号');
#查询入职日期为1992年4月3号的员工信息
SELECT 
    *,
    STR_TO_DATE('1992年4月3号', '%Y年%m月%d号') AS queryDate
FROM
    employees
WHERE
    hiredate = STR_TO_DATE('1992年4月3号', '%Y年%m月%d号');
#6.date_format将日期转换为字符
SELECT DATE_FORMAT(NOW(), '%y年%m月%d日');
#查询有奖金的员工名和入职日期(xx月/xx日 xx年)
SELECT 
    last_name,
    DATE_FORMAT(hiredate, '%m月/%d日 %y年') AS 入职日期
FROM
    employees
WHERE
    commission_pct IS NOT NULL;
    
#四、其他函数
SELECT VERSION();
SELECT DATABASE();
SELECT USER();

#五、流程控制函数
#1.if函数 ※Just EXCEL
SELECT 
    IF(MOD(SECOND(NOW()), 2) = 1,
        'Odd',
        'Even') AS SecNow;
SELECT 
    last_name,
    commission_pct,
    IF(commission_pct IS NULL,
        '没奖金，呵呵',
        '有奖金，嘻嘻') AS 备注
FROM
    employees;
#2.case函数的使用一： switch case的效果
/*
case 要判断的变量，表达式，字段
when 常量1 then 要显示的值1，语句1;
when 常量2 then 要显示的值2，语句2;
...
else 要显示的值n，语句n;
end
*/
SELECT 
    CASE MOD(SECOND(NOW()), 2)
        WHEN 1 THEN CONCAT('odd:', NOW())
        ELSE CONCAT('even:', NOW())
    END AS timeTest;
SELECT 
    salary AS 原始工资,
    department_id,
    CASE department_id
        WHEN 30 THEN salary * 1.1
        WHEN 40 THEN salary * 1.2
        WHEN 50 THEN salary * 1.3
        ELSE salary
    END AS 新工资
FROM
    employees;

#3.case函数的使用二： 多重if
/*
case
when 条件1 then 要显示的值1或语句1;
when 条件2 then 要显示的值2或语句2;
...
else 要显示的值n或语句n;
end
*/
SELECT 
    CASE
        WHEN MOD(SECOND(NOW()), 2) = 1 THEN CONCAT('odd:', NOW())
        ELSE CONCAT('even:', NOW())
    END AS timeTest;
SELECT 
    salary,
    CASE
        WHEN salary > 20000 THEN 'A'
        WHEN salary > 15000 THEN 'B'
        WHEN salary > 10000 THEN 'C'
        ELSE 'D'
    END AS salary_rank
FROM
    employees;

#1.
select now();
#2.
SELECT 
    employee_id, last_name, salary, salary * 1.2 AS 'new salary'
FROM
    employees;
#3.
SELECT 
    LENGTH(last_name) AS nameLength,
    SUBSTR(last_name, 1, 1) AS firstAplhabet
FROM
    employees
ORDER BY firstAplhabet;
#4.
SELECT 
    CONCAT(last_name,
            ' earns ',
            salary,
            ' monthly but wants ',
            salary * 3) AS dreamSalary
FROM
    employees;
#5.
SELECT 
    last_name,
    job_id AS job,
    CASE job_id
        WHEN 'AD_PRES' THEN 'A'
        WHEN 'ST_MAN' THEN 'B'
        WHEN 'IT_PROG' THEN 'C'
        WHEN 'SA_PRE' THEN 'D'
        WHEN 'ST_CLERK' THEN 'E'
    END AS grade
FROM
    employees;
