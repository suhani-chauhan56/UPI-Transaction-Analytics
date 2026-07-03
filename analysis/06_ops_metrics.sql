-- ====================================================================
-- OPERATIONAL METRICS: FAILURE AND SUCCESS RATES
-- Techniques: Aggregations + Boolean Sums
-- Purpose: Monitor platform operations by determining the percentage
--          of successful vs failed transactions.
-- ====================================================================

USE upi_analytics;

SELECT
    -- Sums the number of failed rows divided by total rows
    ROUND(SUM(transaction_status = 'FAILED') / COUNT(*) * 100, 2) AS failure_rate_pct,
    -- Sums the number of successful rows divided by total rows
    ROUND(SUM(transaction_status = 'SUCCESS') / COUNT(*) * 100, 2) AS success_rate_pct,
    COUNT(*) AS total_transactions
FROM transactions;
