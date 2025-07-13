USE memory.default;

SELECT CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS result,
       COUNT(*) AS past_due_rows
FROM invoice
WHERE due_date <= CURRENT_DATE;
