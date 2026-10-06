# Write your MySQL query statement below
WITH reaction_counts AS (
    SELECT
        user_id,
        reaction,
        COUNT(*) AS reaction_count
    FROM reactions
    GROUP BY user_id, reaction
),
user_totals AS (
    SELECT
        user_id,
        COUNT(*) AS total_reactions
    FROM reactions
    GROUP BY user_id
)
SELECT
    r.user_id,
    r.reaction AS dominant_reaction,
    ROUND(r.reaction_count / u.total_reactions, 2) AS reaction_ratio
FROM reaction_counts r
JOIN user_totals u
    ON r.user_id = u.user_id
WHERE u.total_reactions >= 5
  AND r.reaction_count = (
      SELECT MAX(r2.reaction_count)
      FROM reaction_counts r2
      WHERE r2.user_id = r.user_id
  )
  AND r.reaction_count / u.total_reactions >= 0.60
ORDER BY reaction_ratio DESC, r.user_id ASC;