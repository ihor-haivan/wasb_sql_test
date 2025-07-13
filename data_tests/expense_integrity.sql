USE memory.default;

SELECT CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS result,
       COUNT(*) AS orphan_rows
FROM expense e
LEFT JOIN employee emp USING (employee_id)
WHERE emp.employee_id IS NULL;
