-- Detect manager approval cycles in the EMPLOYEE hierarchy

WITH RECURSIVE manager_path (employee_id, manager_id, path, cycle_detected) AS (
    -- Base row for each employee
    SELECT
        employee_id,
        manager_id,
        ARRAY[employee_id] AS path,
        FALSE AS cycle_detected
    FROM memory.default.employee

    UNION ALL

    -- Recurse up the hierarchy
    SELECT
        e.employee_id,
        e.manager_id,
        mp.path || ARRAY[e.employee_id] AS path,
        contains(mp.path, e.employee_id) AS cycle_detected
    FROM memory.default.employee e
    JOIN manager_path mp
      ON e.employee_id = mp.manager_id
    WHERE NOT mp.cycle_detected           -- Stop expanding once a cycle is found
	  AND e.manager_id IS NOT NULL
)

SELECT
    employee_id,
    array_join(path, ',') AS manager_cycle_path
FROM manager_path
WHERE cycle_detected;
