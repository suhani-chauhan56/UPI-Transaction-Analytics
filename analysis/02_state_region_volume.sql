-- ====================================================================
-- ANALYSIS 2: STATE-WISE VOLUME AND REGIONAL ROLLUPS
-- Techniques: INNER JOIN + Aggregations (COUNT, SUM, AVG)
-- Purpose: Analyze transaction performance geographically at both
--          state level and rolled up to the region level.
-- ====================================================================

USE upi_analytics;

-- Query A: State-wise performance details for successful transactions
SELECT
    t.sender_state,
    r.region,
    COUNT(*)                  AS txn_count,
    SUM(t.amount_inr)         AS total_amount,
    ROUND(AVG(t.amount_inr), 2) AS avg_amount
FROM transactions t
INNER JOIN state_region r ON t.sender_state = r.state_name
WHERE t.transaction_status = 'SUCCESS'
GROUP BY t.sender_state, r.region
ORDER BY total_amount DESC;


-- Query B: Higher-grain regional rollup analysis
SELECT 
    r.region,
    COUNT(*) AS txn_count,
    SUM(t.amount_inr) AS total_amount,
    ROUND(AVG(t.amount_inr), 2) AS avg_amount
FROM transactions t
INNER JOIN state_region r ON t.sender_state = r.state_name
WHERE t.transaction_status = 'SUCCESS'
GROUP BY r.region
ORDER BY total_amount DESC;
