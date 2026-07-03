-- ====================================================================
-- POWER BI EXPORT PREPARATION
-- Techniques: VIEW + LEFT JOIN
-- Purpose: Consolidate the transaction records and state-region lookup
--          into a single logical view that can be connected directly
--          to Power BI, or exported as a single flat CSV.
-- ====================================================================

USE upi_analytics;

-- 1. Create or replace the view
CREATE OR REPLACE VIEW v_transactions AS
SELECT
    t.transaction_id,
    t.txn_ts,
    t.transaction_type,
    t.merchant_category,
    t.amount_inr,
    t.transaction_status,
    t.sender_age_group,
    t.receiver_age_group,
    t.sender_state,
    t.sender_bank,
    t.receiver_bank,
    t.device_type,
    t.network_type,
    t.fraud_flag,
    t.txn_hour,
    r.region
FROM
    transactions t
    LEFT JOIN state_region r ON t.sender_state = r.state_name;

-- 2. Verify the view
SELECT * FROM v_transactions LIMIT 10;

/*
====================================================================
HOW TO EXPORT FOR POWER BI
====================================================================

Option 1: Direct Database Connection (Recommended)
1. Open Power BI Desktop.
2. Click "Get Data" -> "MySQL database".
3. Enter Server (e.g., "localhost") and Database ("upi_analytics").
4. Under "Navigator", select the view "v_transactions" and click "Load".
5. Power BI will handle the queries dynamically.

Option 2: File-based Load (CSV)
1. Run the following query in MySQL Workbench to load the view:
SELECT * FROM v_transactions;
2. In the Results Grid toolbar, click the "Export" button (next to the floppy disk icon).
3. Save the file as a CSV UTF-8 file (e.g., "upi_final_analytics.csv").
4. Open Power BI Desktop.
5. Click "Get Data" -> "Text/CSV" -> Select "upi_final_analytics.csv".
6. Verify columns and click "Load".
*/