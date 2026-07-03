-- ====================================================================
-- 03_CREATE_TRANSACTIONS.SQL
-- Purpose: Build the final cleaned, typed, and structured transaction table.
-- ====================================================================

USE upi_analytics;

-- 1. Drop the table if it already exists
DROP TABLE IF EXISTS transactions;

-- 2. Create the typed schema table with primary key
CREATE TABLE transactions (
  transaction_id     VARCHAR(60) PRIMARY KEY,
  txn_ts             DATETIME,
  transaction_type   VARCHAR(30),
  merchant_category  VARCHAR(30),
  amount_inr         DECIMAL(12,2),
  transaction_status VARCHAR(20),
  sender_age_group   VARCHAR(10),
  receiver_age_group VARCHAR(10),
  sender_state       VARCHAR(40),
  sender_bank        VARCHAR(30),
  receiver_bank      VARCHAR(30),
  device_type        VARCHAR(20),
  network_type       VARCHAR(10),
  fraud_flag         TINYINT,
  txn_hour           TINYINT
);

-- 3. Populate final table by casting and formatting the raw staging data.
-- Note: Date parsing uses '%d-%m-%Y %H:%i' to match the DD-MM-YYYY format of the dataset.
INSERT INTO transactions
SELECT
  TRIM(transaction_id),
  STR_TO_DATE(TRIM(ts), '%d-%m-%Y %H:%i'),
  TRIM(transaction_type),
  TRIM(merchant_category),
  CAST(NULLIF(TRIM(amount_inr), '') AS DECIMAL(12,2)),
  UPPER(TRIM(transaction_status)),
  TRIM(sender_age_group),
  TRIM(receiver_age_group),
  TRIM(sender_state),
  TRIM(sender_bank),
  TRIM(receiver_bank),
  TRIM(device_type),
  TRIM(network_type),
  CASE WHEN TRIM(fraud_flag) IN ('1','True','TRUE','Yes','yes') THEN 1 ELSE 0 END,
  HOUR(STR_TO_DATE(TRIM(ts), '%d-%m-%Y %H:%i'))
FROM upi_raw
WHERE transaction_id IS NOT NULL AND TRIM(transaction_id) <> '';

-- 4. Fast check of the loaded data
SELECT COUNT(*) AS total_transactions_loaded FROM transactions;
SELECT * FROM transactions LIMIT 5;
