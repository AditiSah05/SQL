# Write your MySQL query statement below
SELECT
    p.patient_id,
    p.patient_name,
    p.age,
    DATEDIFF(MIN(n.test_date), MIN(pos.test_date)) AS recovery_time
FROM patients p
JOIN covid_tests pos
    ON p.patient_id = pos.patient_id
   AND pos.result = 'Positive'
JOIN covid_tests n
    ON p.patient_id = n.patient_id
   AND n.result = 'Negative'
   AND n.test_date > pos.test_date
GROUP BY p.patient_id, p.patient_name, p.age
ORDER BY recovery_time ASC, p.patient_name ASC;