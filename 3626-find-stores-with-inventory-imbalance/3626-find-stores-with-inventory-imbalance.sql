# Write your MySQL query statement below
WITH ranked AS (
    SELECT
        store_id,
        product_name,
        quantity,
        price,
        ROW_NUMBER() OVER (
            PARTITION BY store_id
            ORDER BY price DESC
        ) AS expensive_rank,
        ROW_NUMBER() OVER (
            PARTITION BY store_id
            ORDER BY price ASC
        ) AS cheap_rank
    FROM inventory
),
store_data AS (
    SELECT
        store_id,
        MAX(CASE WHEN expensive_rank = 1 THEN product_name END) AS most_exp_product,
        MAX(CASE WHEN expensive_rank = 1 THEN quantity END) AS expensive_qty,
        MAX(CASE WHEN cheap_rank = 1 THEN product_name END) AS cheapest_product,
        MAX(CASE WHEN cheap_rank = 1 THEN quantity END) AS cheap_qty,
        COUNT(*) AS product_count
    FROM ranked
    GROUP BY store_id
)
SELECT
    s.store_id,
    s.store_name,
    s.location,
    d.most_exp_product,
    d.cheapest_product,
    ROUND(d.cheap_qty / d.expensive_qty, 2) AS imbalance_ratio
FROM store_data d
JOIN stores s
    ON s.store_id = d.store_id
WHERE d.product_count >= 3
  AND d.expensive_qty < d.cheap_qty
ORDER BY imbalance_ratio DESC, s.store_name ASC;