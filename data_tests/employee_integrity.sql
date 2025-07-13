USE memory.default;

SELECT CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS result,
       COUNT(*) AS invalid_manager_refs
FROM employee
WHERE manager_id IS NOT NULL
  AND manager_id NOT IN (SELECT employee_id FROM employee);
