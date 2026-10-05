# Write your MySQL query statement below
SELECT
    ip,
    COUNT(*) AS invalid_count
FROM logs
WHERE
    -- Must have exactly 4 octets
    ip NOT REGEXP '^([0-9]{1,3}[.]){3}[0-9]{1,3}$'
    OR
    -- No leading zeros
    ip REGEXP '(^|[.])0[0-9]+'
    OR
    -- No octet greater than 255
    CAST(SUBSTRING_INDEX(ip, '.', 1) AS UNSIGNED) > 255
    OR CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 2), '.', -1) AS UNSIGNED) > 255
    OR CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 3), '.', -1) AS UNSIGNED) > 255
    OR CAST(SUBSTRING_INDEX(ip, '.', -1) AS UNSIGNED) > 255
GROUP BY ip
ORDER BY invalid_count DESC, ip DESC;