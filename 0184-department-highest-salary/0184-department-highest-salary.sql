# Write your MySQL query statement below
SELECT
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Employee e
JOIN Department d
    ON e.departmentId = d.id
JOIN (
    SELECT departmentId, MAX(salary) AS maxSalary
    FROM Employee
    GROUP BY departmentId
) t
ON e.departmentId = t.departmentId
AND e.salary = t.maxSalary;