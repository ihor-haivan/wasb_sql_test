USE memory.default;

SELECT CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS result,
       COUNT(*) AS non_positive_amounts
FROM invoice
WHERE invoice_ammount <= 0;
