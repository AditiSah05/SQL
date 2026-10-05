WITH ranked AS (
    SELECT
        student_id,
        subject,
        score,
        ROW_NUMBER() OVER (
            PARTITION BY student_id, subject
            ORDER BY exam_date
        ) AS first_rank,
        ROW_NUMBER() OVER (
            PARTITION BY student_id, subject
            ORDER BY exam_date DESC
        ) AS latest_rank
    FROM Scores
)
SELECT
    student_id,
    subject,
    MAX(CASE WHEN first_rank = 1 THEN score END) AS first_score,
    MAX(CASE WHEN latest_rank = 1 THEN score END) AS latest_score
FROM ranked
GROUP BY student_id, subject
HAVING COUNT(*) >= 2
   AND MAX(CASE WHEN latest_rank = 1 THEN score END)
       > MAX(CASE WHEN first_rank = 1 THEN score END)
ORDER BY student_id, subject;