-- ====================================================================
-- ANALYSIS 4: MERCHANT CATEGORY ANALYSIS
-- Techniques: Aggregations + Window Functions (RANK, Grand Total SUM)
-- Purpose: Evaluate spending volume across categories, ranking them by
--          total revenue and calculating their relative share of total spend.
-- ====================================================================

USE upi_analytics;

SELECT
    merchant_category,
    COUNT(*)                                   AS txn_count,
    SUM(amount_inr)                            AS total_amount,
    ROUND(AVG(amount_inr), 2)                  AS avg_ticket,
    -- Rank merchant categories by total spend amount
    RANK() OVER (ORDER BY SUM(amount_inr) DESC) AS spend_rank,
    -- Compute category spend as a percentage of total spend across all categories
    ROUND(100 * SUM(amount_inr) / SUM(SUM(amount_inr)) OVER (), 2) AS pct_of_total_spend
FROM transactions
WHERE transaction_status = 'SUCCESS'
GROUP BY merchant_category
ORDER BY total_amount DESC;
