USE memory.default;

WITH stats AS (
    SELECT COUNT(*) AS cnt FROM employee
)
SELECT CASE WHEN cnt = 9 THEN 'PASS' ELSE 'FAIL' END AS result,
       cnt
FROM stats;
