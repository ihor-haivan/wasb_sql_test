-- Rebuild SExI: create and populate SUPPLIER and INVOICE tables in the memory.default schema

DROP TABLE IF EXISTS memory.default.invoice;
DROP TABLE IF EXISTS memory.default.supplier;

CREATE TABLE memory.default.supplier (
    supplier_id TINYINT NOT NULL,
    name VARCHAR NOT NULL
);

-- Populate SUPPLIER table
INSERT INTO memory.default.supplier (supplier_id, name) VALUES
    (1, 'Catering Plus'),
    (2, 'Dave''s Discos'),
    (3, 'Entertainment tonight'),
    (4, 'Ice Ice Baby'),
    (5, 'Party Animals');

-- Create INVOICE table
CREATE TABLE memory.default.invoice (
    supplier_id TINYINT NOT NULL,
    invoice_ammount DECIMAL(8, 2) NOT NULL,
    due_date DATE NOT NULL
);

-- Populate INVOICE table
INSERT INTO memory.default.invoice (supplier_id, invoice_ammount, due_date) VALUES
    (5, 6000.0, DATE_TRUNC('month', CURRENT_DATE + INTERVAL '3' MONTH) + INTERVAL '1' MONTH - INTERVAL '1' DAY),
    (1, 2000.0, DATE_TRUNC('month', CURRENT_DATE + INTERVAL '2' MONTH) + INTERVAL '1' MONTH - INTERVAL '1' DAY),
    (1, 1500.0, DATE_TRUNC('month', CURRENT_DATE + INTERVAL '3' MONTH) + INTERVAL '1' MONTH - INTERVAL '1' DAY),
    (2, 500.0, DATE_TRUNC('month', CURRENT_DATE + INTERVAL '1' MONTH) + INTERVAL '1' MONTH - INTERVAL '1' DAY),
    (3, 6000.0, DATE_TRUNC('month', CURRENT_DATE + INTERVAL '3' MONTH) + INTERVAL '1' MONTH - INTERVAL '1' DAY),
    (4, 4000.0, DATE_TRUNC('month', CURRENT_DATE + INTERVAL '6' MONTH) + INTERVAL '1' MONTH - INTERVAL '1' DAY);