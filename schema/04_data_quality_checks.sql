-- ====================================================================
-- 04_DATA_QUALITY_CHECKS.SQL
-- Purpose: Inspect data health, detect anomalies, and perform cleaning.
-- ====================================================================

USE upi_analytics;

-- 1. Check for Duplicate Transaction IDs (Should return 0 rows)
SELECT transaction_id, COUNT(*) AS occurence_count
FROM transactions 
GROUP BY transaction_id 
HAVING occurence_count > 1;

-- 2. Check for NULLs or invalid values in critical columns
SELECT
  SUM(txn_ts IS NULL)      AS null_timestamps,
  SUM(amount_inr IS NULL)  AS null_amounts,
  SUM(amount_inr <= 0)     AS invalid_amounts
FROM transactions;

-- 3. Spot potential typos or variations in categorical values
-- Look for near-duplicates or stray values
SELECT DISTINCT transaction_status FROM transactions;
SELECT DISTINCT merchant_category  FROM transactions;
SELECT DISTINCT sender_state       FROM transactions;

-- 4. Data Cleaning: Remove invalid rows (where amount is NULL or <= 0)
DELETE FROM transactions 
WHERE amount_inr <= 0 
   OR amount_inr IS NULL 
   OR txn_ts IS NULL;

-- 5. Final Row Count after cleanup
SELECT COUNT(*) AS total_clean_rows FROM transactions;
