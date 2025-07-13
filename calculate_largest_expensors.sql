-- Report employees whose total expensed amount exceeds 1,000

WITH aggregated_expenses AS (
	-- Aggregate expenses per employee
    SELECT
        employee_id,
        SUM(unit_price * quantity) AS total_expensed_amount
    FROM memory.default.expense
    GROUP BY employee_id
)
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.manager_id,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    ag.total_expensed_amount
FROM aggregated_expenses ag
JOIN memory.default.employee e
  ON e.employee_id = ag.employee_id
LEFT JOIN memory.default.employee m
  ON m.employee_id = e.manager_id
WHERE ag.total_expensed_amount > 1000
ORDER BY ag.total_expensed_amount DESC;
