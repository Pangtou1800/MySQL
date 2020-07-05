use test;
#1. 查询工资最低的员工信息： last_name, salary
SELECT 
    last_name, salary
FROM
    employees
WHERE
    salary = (SELECT 
            MIN(salary)
        FROM
            employees);
#2. 查询平均工资最低的部门信息
SELECT 
    *
FROM
    departments
WHERE
    department_id = (SELECT 
            department_id
        FROM
            employees
        GROUP BY department_id
        ORDER BY AVG(salary)
        LIMIT 0 , 1);
#3. 查询平均工资最低的部门信息和该部门的平均工资
SELECT 
    *
FROM
    departments AS d
        LEFT OUTER JOIN
    (SELECT 
        AVG(salary) AS avgSal, department_id
    FROM
        employees
    GROUP BY department_id) AS avgEmp ON d.department_id = avgEmp.department_id
ORDER BY avgEmp.avgSal ASC
LIMIT 0 , 1;
#4. 查询平均工资最高的job信息
	SELECT 
    *
FROM
    jobs
WHERE
    job_id = (SELECT 
            job_id
        FROM
            employees
        GROUP BY job_id
        ORDER BY AVG(salary) DESC);
#5. 查询平均工资高于公司平均工资的部门有哪些
SELECT 
    department_id
FROM
    employees
GROUP BY department_id
HAVING AVG(salary) > (SELECT 
        AVG(salary)
    FROM
        employees);
#6. 查询公司中所有manager的详细信息
SELECT 
    *
FROM
    employees
WHERE
    employee_id IN (SELECT DISTINCT
            manager_id
        FROM
            employees);
#7. 查询各个部门中最高工资最低的那个部门的最低工资是多少
SELECT 
    MIN(salary)
FROM
    employees
WHERE
    department_id = (SELECT 
            department_id
        FROM
            employees
        GROUP BY department_id
        ORDER BY MAX(salary)
        LIMIT 0 , 1);
#8. 查询平均工资最高的部门的manager的详细信息
SELECT 
    *
FROM
    employees
WHERE
    employee_id = (SELECT 
            d.manager_id
        FROM
            departments AS d
                LEFT OUTER JOIN
            (SELECT 
                AVG(salary) AS avgSal, department_id
            FROM
                employees
            GROUP BY department_id) AS avgEmp ON d.department_id = avgEmp.department_id
        ORDER BY avgEmp.avgSal DESC
        LIMIT 0 , 1);