-- ==============================================================
-- Monthly payment plan for all suppliers
-- Each invoice is split into equal monthly instalments that finish in the month *before* its due date
-- A supplier receives at most one payment row per month
-- First payment is the end of the current month
-- The final row per supplier is rounded/adjusted so the running balance never drifts by a cent
-- ==============================================================

WITH invoices AS (          
	-- One row per invoice
    SELECT
        i.supplier_id,
        i.invoice_ammount,
        i.due_date,
        date_trunc('month', CURRENT_DATE) AS start_month,
        date_trunc('month', i.due_date) - INTERVAL '1' MONTH AS last_pay_month,
        date_diff(  -- full months *before* the due month
            'month',
            date_trunc('month', CURRENT_DATE),
            date_trunc('month', i.due_date)
        ) AS pay_months
    FROM memory.default.invoice i
),
inv_schedule AS (               
	-- Spread each invoice across its pay-months
    SELECT
        supplier_id,
        invoice_ammount,
        pay_months,
        sequence(start_month, last_pay_month, INTERVAL '1' MONTH) AS months_seq
    FROM invoices
),
exploded AS (                   
	-- One row per invoice-month, un-rounded
    SELECT
        supplier_id,
        date_trunc('month', m) + INTERVAL '1' MONTH - INTERVAL '1' DAY
            AS payment_date, -- month-end
        CAST(invoice_ammount / pay_months AS DECIMAL(12,2)) AS raw_payment
    FROM inv_schedule
    CROSS JOIN UNNEST(months_seq) AS t(m)
),
month_sum AS (                  
	-- Aggregate if a supplier has >1 invoice in a month
    SELECT
        supplier_id,
        payment_date,
        SUM(raw_payment) AS month_payment_raw
    FROM exploded
    GROUP BY supplier_id, payment_date
),
running AS (
	-- Running totals per supplier (pre-rounding)
    SELECT
        supplier_id,
        payment_date,
        month_payment_raw,
        SUM(month_payment_raw) OVER (
            PARTITION BY supplier_id
            ORDER BY payment_date
        ) AS cumulative_paid_raw,
        SUM(month_payment_raw) OVER (
            PARTITION BY supplier_id
        ) AS grand_total
    FROM month_sum
),
final_per_month AS (
	-- Round; adjust the last month per supplier
    SELECT
        supplier_id,
        payment_date,
        CASE
            WHEN payment_date = MAX(payment_date) OVER (PARTITION BY supplier_id)
            THEN  -- final month - fix rounding so total = invoice sum
                ROUND(
                    grand_total
                    - LAG(cumulative_paid_raw,1,0)
                      OVER (PARTITION BY supplier_id ORDER BY payment_date),
                    2
                )
            ELSE
                ROUND(month_payment_raw, 2)
        END AS payment_amount
    FROM running
),
balances AS (
	-- Compute cumulative paid & outstanding balance
    SELECT
        supplier_id,
        payment_date,
        payment_amount,
        SUM(payment_amount) OVER (
            PARTITION BY supplier_id
            ORDER BY payment_date
        ) AS cumulative_paid,
        SUM(payment_amount) OVER (PARTITION BY supplier_id) AS grand_total
    FROM final_per_month
)
SELECT
    s.supplier_id,
    s.name                         AS supplier_name,
    b.payment_amount,
    ROUND(b.grand_total - b.cumulative_paid, 2) AS balance_outstanding,
    b.payment_date
FROM balances b
JOIN memory.default.supplier s
  ON s.supplier_id = b.supplier_id
ORDER BY s.supplier_id, b.payment_date;
