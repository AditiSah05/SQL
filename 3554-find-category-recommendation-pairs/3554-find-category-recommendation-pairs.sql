# Write your MySQL query statement below
SELECT
    LEAST(i1.category, i2.category) AS category1,
    GREATEST(i1.category, i2.category) AS category2,
    COUNT(DISTINCT p1.user_id) AS customer_count
FROM ProductPurchases p1
JOIN ProductInfo i1
    ON p1.product_id = i1.product_id
JOIN ProductPurchases p2
    ON p1.user_id = p2.user_id
   AND p1.product_id <> p2.product_id
JOIN ProductInfo i2
    ON p2.product_id = i2.product_id
WHERE i1.category < i2.category
GROUP BY i1.category, i2.category
HAVING COUNT(DISTINCT p1.user_id) >= 3
ORDER BY customer_count DESC, category1 ASC, category2 ASC;