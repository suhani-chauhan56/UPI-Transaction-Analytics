-- ====================================================================
-- 05_CREATE_LOOKUP_TABLE.SQL
-- Purpose: Initialize the state-to-region lookup reference table.
-- ====================================================================

USE upi_analytics;

-- 1. Drop table if it exists
DROP TABLE IF EXISTS state_region;

-- 2. Create schema for the lookup table
CREATE TABLE state_region (
  state_name VARCHAR(40) PRIMARY KEY,
  region     VARCHAR(20)
);

-- 3. Populate lookup data with key Indian states and their corresponding regions
INSERT INTO state_region (state_name, region) VALUES
('Maharashtra', 'West'), 
('Gujarat', 'West'), 
('Rajasthan', 'North'),
('Delhi', 'North'), 
('Uttar Pradesh', 'North'),
('Karnataka', 'South'), 
('Tamil Nadu', 'South'),
('Andhra Pradesh', 'South'), 
('Telangana', 'South'),
('West Bengal', 'East');

-- 4. Verify lookup data
SELECT * FROM state_region;
