USE memory.default;

WITH d AS (
    SELECT employee_id, COUNT(*) AS c
    FROM employee
    GROUP BY employee_id
    HAVING COUNT(*) > 1
)
SELECT CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS result,
       COUNT(*) AS duplicate_ids
FROM d;
