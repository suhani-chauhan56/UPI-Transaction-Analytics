-- ====================================================================
-- ANALYSIS 3: PEAK TRANSACTION HOURS
-- Techniques: Date Functions + Conditional Aggregations
-- Purpose: Analyze transaction traffic hourly and see how user behavior
--          changes between Weekdays and Weekends.
-- ====================================================================

USE upi_analytics;

-- Query A: Peak transaction hours overall
SELECT
    txn_hour,
    COUNT(*) AS txn_count,
    SUM(amount_inr) AS total_amount,
    ROUND(AVG(amount_inr), 2) AS avg_amount
FROM transactions
GROUP BY txn_hour
ORDER BY txn_count DESC;


-- Query B: Peak hour comparison (Weekday vs Weekend)
-- DAYOFWEEK returns 1 for Sunday and 7 for Saturday in MySQL.
SELECT
    CASE WHEN DAYOFWEEK(txn_ts) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    txn_hour,
    COUNT(*) AS txn_count,
    SUM(amount_inr) AS total_amount
FROM transactions
GROUP BY day_type, txn_hour
ORDER BY day_type, txn_count DESC;
