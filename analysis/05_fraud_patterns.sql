-- ====================================================================
-- ANALYSIS 5: FRAUD PATTERN DETECTION
-- Techniques: CTE + Aggregations + Cross Join + Statistical Outliers
-- Purpose: Audit transactions for security and fraud analytics.
--          Identifies states and technical profiles with elevated fraud
--          rates, and lists transaction outliers beyond 3 standard deviations.
-- ====================================================================

USE upi_analytics;

-- Query A: Fraud rate by state
SELECT
    sender_state,
    COUNT(*)                                  AS total_txn,
    SUM(fraud_flag)                           AS fraud_txn,
    ROUND(SUM(fraud_flag)/COUNT(*) * 100, 3)  AS fraud_rate_pct
FROM transactions
GROUP BY sender_state
ORDER BY fraud_rate_pct DESC;


-- Query B: Fraud rate by technical configuration (device & network types)
SELECT 
    device_type, 
    network_type,
    COUNT(*) AS total_txn,
    SUM(fraud_flag) AS fraud_txn,
    ROUND(SUM(fraud_flag)/COUNT(*) * 100, 3) AS fraud_rate_pct
FROM transactions
GROUP BY device_type, network_type
ORDER BY fraud_rate_pct DESC;


-- Query C: Statistical Outliers (Mean + 3 * StdDev)
-- Identifies transaction amounts that are mathematically unusual.
WITH stats AS (
    SELECT AVG(amount_inr) AS mu, STDDEV(amount_inr) AS sigma
    FROM transactions
)
SELECT 
    t.transaction_id, 
    t.txn_ts, 
    t.sender_state,
    t.merchant_category, 
    t.amount_inr, 
    t.fraud_flag,
    ROUND(s.mu, 2) AS average_amount,
    ROUND(s.mu + 3 * s.sigma, 2) AS three_sigma_threshold
FROM transactions t
CROSS JOIN stats s
WHERE t.amount_inr > s.mu + 3 * s.sigma     -- Statistically anomalous amount
ORDER BY t.amount_inr DESC
LIMIT 100;
