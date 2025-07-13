-- Rebuild SExI: create and populate EMPLOYEE table in the memory.default schema

-- Employees table: stores company employee information
DROP TABLE IF EXISTS memory.default.employee;
CREATE TABLE memory.default.employee (
    employee_id TINYINT NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    job_title VARCHAR NOT NULL,
    manager_id TINYINT -- nullable if top-level executive
);

-- Populate the table with initial data
INSERT INTO memory.default.employee (employee_id, first_name, last_name, job_title, manager_id) VALUES
    (1, 'Ian', 'James', 'CEO', 4),
    (2, 'Umberto', 'Torrielli', 'CSO', 1),
    (3, 'Alex', 'Jacobson', 'MD EMEA', 2),
    (4, 'Darren', 'Poynton', 'CFO', 2),
    (5, 'Tim', 'Beard', 'MD APAC', 2),
    (6, 'Gemma', 'Dodd', 'COS', 1),
    (7, 'Lisa', 'Platten', 'CHR', 6),
    (8, 'Stefano', 'Camisaca', 'GM Activation', 2),
    (9, 'Andrea', 'Ghibaudi', 'MD NAM', 2);
