-- ====================================================================
-- 01_CREATE_DATABASE.SQL
-- Purpose: Initialize the database and raw staging table.
-- ====================================================================

-- 1. Create and select the database
CREATE DATABASE IF NOT EXISTS upi_analytics;
USE upi_analytics;

-- 2. Create the staging table (loads all columns as VARCHAR to prevent import errors)
DROP TABLE IF EXISTS upi_raw;
CREATE TABLE upi_raw (
  transaction_id     VARCHAR(60),
  ts                 VARCHAR(30),
  transaction_type   VARCHAR(30),
  merchant_category  VARCHAR(30),
  amount_inr         VARCHAR(20),
  transaction_status VARCHAR(20),
  sender_age_group   VARCHAR(10),
  receiver_age_group VARCHAR(10),
  sender_state       VARCHAR(40),
  sender_bank        VARCHAR(30),
  receiver_bank      VARCHAR(30),
  device_type        VARCHAR(20),
  network_type       VARCHAR(10),
  fraud_flag         VARCHAR(6),
  hour_of_day        VARCHAR(5),
  day_of_week        VARCHAR(15),
  is_weekend         VARCHAR(10)
);
