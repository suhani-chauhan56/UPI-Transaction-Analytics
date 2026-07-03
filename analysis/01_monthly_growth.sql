-- ====================================================================
-- ANALYSIS 1: MONTHLY TRANSACTION GROWTH
-- Techniques: CTE + Window Function + Date Functions
-- Purpose: Calculate Month-over-Month (MoM) growth in transaction
--          volume and spend value for successful transactions.
-- ====================================================================

USE upi_analytics;

WITH monthly AS (
    SELECT
        DATE_FORMAT(txn_ts, '%Y-%m')       AS month,
        COUNT(*)                           AS txn_count,
        SUM(amount_inr)                    AS total_amount
    FROM transactions
    WHERE transaction_status = 'SUCCESS'
    GROUP BY DATE_FORMAT(txn_ts, '%Y-%m')
)
SELECT
    month,
    txn_count,
    total_amount,
    -- Get the previous month's total spend amount using LAG()
    LAG(total_amount) OVER (ORDER BY month) AS prev_month_amount,
    -- Calculate Month-over-Month growth percentage
    ROUND(
      (total_amount - LAG(total_amount) OVER (ORDER BY month))
      / LAG(total_amount) OVER (ORDER BY month) * 100, 
      2
    ) AS mom_growth_pct
FROM monthly
ORDER BY month;
