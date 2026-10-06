# Write your MySQL query statement below
SELECT
    e.employee_id,
    e.employee_name,
    e.department,
    COUNT(*) AS meeting_heavy_weeks
FROM employees e
JOIN (
    SELECT
        employee_id,
        YEARWEEK(meeting_date, 1) AS week,
        SUM(duration_hours) AS total_hours
    FROM meetings
    GROUP BY employee_id, YEARWEEK(meeting_date, 1)
    HAVING SUM(duration_hours) > 20
) m
ON e.employee_id = m.employee_id
GROUP BY e.employee_id, e.employee_name, e.department
HAVING COUNT(*) >= 2
ORDER BY meeting_heavy_weeks DESC, employee_name ASC;