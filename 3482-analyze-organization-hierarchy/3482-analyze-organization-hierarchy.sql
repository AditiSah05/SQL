# Write your MySQL query statement below
WITH RECURSIVE org AS (
    SELECT
        employee_id,
        employee_name,
        manager_id,
        salary,
        1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.salary,
        o.level + 1
    FROM Employees e
    JOIN org o
        ON e.manager_id = o.employee_id
),
hierarchy AS (
    SELECT
        e.employee_id AS manager_id,
        e.employee_id AS employee_id
    FROM Employees e

    UNION ALL

    SELECT
        h.manager_id,
        e.employee_id
    FROM hierarchy h
    JOIN Employees e
        ON e.manager_id = h.employee_id
)
SELECT
    o.employee_id,
    o.employee_name,
    o.level,
    COUNT(h.employee_id) - 1 AS team_size,
    SUM(e.salary) AS budget
FROM org o
JOIN hierarchy h
    ON o.employee_id = h.manager_id
JOIN Employees e
    ON h.employee_id = e.employee_id
GROUP BY o.employee_id, o.employee_name, o.level
ORDER BY o.level ASC, budget DESC, o.employee_name ASC;