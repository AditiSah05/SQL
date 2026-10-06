# Write your MySQL query statement below
WITH efficiency AS (
    SELECT
        driver_id,
        CASE
            WHEN MONTH(trip_date) BETWEEN 1 AND 6 THEN 'first'
            ELSE 'second'
        END AS half,
        distance_km / fuel_consumed AS fuel_efficiency
    FROM trips
),
averages AS (
    SELECT
        driver_id,
        AVG(CASE WHEN half = 'first' THEN fuel_efficiency END) AS first_half_avg,
        AVG(CASE WHEN half = 'second' THEN fuel_efficiency END) AS second_half_avg
    FROM efficiency
    GROUP BY driver_id
)
SELECT
    d.driver_id,
    d.driver_name,
    ROUND(a.first_half_avg, 2) AS first_half_avg,
    ROUND(a.second_half_avg, 2) AS second_half_avg,
    ROUND(a.second_half_avg - a.first_half_avg, 2) AS efficiency_improvement
FROM averages a
JOIN drivers d
    ON a.driver_id = d.driver_id
WHERE a.first_half_avg IS NOT NULL
  AND a.second_half_avg IS NOT NULL
  AND a.second_half_avg > a.first_half_avg
ORDER BY efficiency_improvement DESC, d.driver_name ASC;