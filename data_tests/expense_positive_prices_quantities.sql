USE memory.default;

SELECT CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS result,
       COUNT(*) AS bad_rows
FROM expense
WHERE unit_price <= 0
   OR quantity   <= 0;
