-- ====================================================================
-- 02_IMPORT_INSTRUCTIONS.SQL
-- Purpose: Load upi_clean.csv data into the upi_raw staging table.
-- ====================================================================

USE upi_analytics;

/*
====================================================================
OPTION A: FAST METHOD (LOAD DATA LOCAL INFILE)
====================================================================

Step 1: Check where MySQL allows file reads by running this:
*/
SHOW VARIABLES LIKE 'secure_file_priv';

/*
If a path is returned, move 'upi_clean.csv' to that directory.
Alternatively, enable local infile in MySQL Workbench and use LOCAL:

To enable LOCAL:
1. In MySQL Workbench, right-click the database connection -> Edit Connection.
2. Go to 'Advanced' tab -> 'Others' text box, add: OPT_LOCAL_INFILE=1
3. Reconnect to the database.
4. Run the query below:
*/

-- SET GLOBAL local_infile = 1;

-- If using Windows, remember to double-check the path (forward slashes are fine in MySQL).
-- Replace 'C:/path/to/upi_clean.csv' with your actual path.
-- For example: 'c:/Users/HP/Desktop/New folder (2)/upi_clean.csv'

LOAD DATA LOCAL INFILE 'c:/Users/HP/Desktop/New folder (2)/upi_clean.csv'
INTO TABLE upi_raw
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/*
====================================================================
OPTION B: ZERO-CONFIG METHOD (Table Data Import Wizard)
====================================================================

1. In MySQL Workbench, go to the left panel (Schemas).
2. Right-click 'upi_raw' table -> Select 'Table Data Import Wizard'.
3. Browse and select the 'upi_clean.csv' file from your system.
4. Click 'Next'. Ensure 'Use existing table' is selected and points to 'upi_raw'.
5. Click 'Next'. Map the CSV columns to the table columns:
   - CSV column "transaction id"   -> Target column "transaction_id"
   - CSV column "timestamp"        -> Target column "ts"
   - CSV column "transaction type" -> Target column "transaction_type"
   - CSV column "merchant_category"-> Target column "merchant_category"
   - ... (other columns will map automatically by name)
6. Click 'Next' -> 'Next' to run the import. It may take a couple of minutes to load 250,000 rows.
7. Click 'Finish'.
*/

-- ====================================================================
-- VERIFY THE IMPORT
-- ====================================================================

-- Count should be exactly 250,000
SELECT COUNT(*) AS total_rows_imported FROM upi_raw;

-- Review the first few rows to verify values are in correct columns
SELECT * FROM upi_raw LIMIT 10;
