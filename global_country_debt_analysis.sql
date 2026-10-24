-- ============================================================
-- Project: Global Country Debt Analysis
-- Database: MySQL 8.0+
-- Note: INSERT values below are illustrative practice data only,
--       not official country debt statistics.
-- ============================================================

CREATE DATABASE IF NOT EXISTS global_debt_analysis;
USE global_debt_analysis;

DROP TABLE IF EXISTS country_debt;

CREATE TABLE country_debt (
    country_name VARCHAR(100) NOT NULL,
    country_code VARCHAR(10) NOT NULL,
    indicator_name VARCHAR(255) NOT NULL,
    indicator_code VARCHAR(50) NOT NULL,
    debt DECIMAL(20, 2)
);

-- ------------------------------------------------------------
-- Sample data (illustrative only)
-- ------------------------------------------------------------
INSERT INTO country_debt
    (country_name, country_code, indicator_name, indicator_code, debt)
VALUES
    ('India', 'IND', 'External Debt', 'DT.DOD.DECT.CD', 500000000000),
    ('India', 'IND', 'Public Debt', 'GC.DOD.TOTL.GD.ZS', 800000000000),
    ('United States', 'USA', 'External Debt', 'DT.DOD.DECT.CD', 25000000000000),
    ('United States', 'USA', 'Public Debt', 'GC.DOD.TOTL.GD.ZS', 33000000000000),
    ('Japan', 'JPN', 'External Debt', 'DT.DOD.DECT.CD', 4500000000000),
    ('Japan', 'JPN', 'Public Debt', 'GC.DOD.TOTL.GD.ZS', 9000000000000),
    ('Germany', 'DEU', 'External Debt', 'DT.DOD.DECT.CD', 6000000000000),
    ('Germany', 'DEU', 'Public Debt', 'GC.DOD.TOTL.GD.ZS', 3000000000000),
    ('United Kingdom', 'GBR', 'External Debt', 'DT.DOD.DECT.CD', 8000000000000),
    ('United Kingdom', 'GBR', 'Public Debt', 'GC.DOD.TOTL.GD.ZS', 4000000000000);

-- ------------------------------------------------------------
-- Section 1: Explore the data
-- ------------------------------------------------------------

-- 1. Display all records
SELECT *
FROM country_debt;

-- 2. Count total records
SELECT COUNT(*) AS total_records
FROM country_debt;

-- 3. List unique countries
SELECT DISTINCT country_name
FROM country_debt
ORDER BY country_name;

-- 4. Highest debt record
SELECT country_name, indicator_name, debt
FROM country_debt
ORDER BY debt DESC
LIMIT 1;

-- 5. Lowest positive debt record
SELECT country_name, indicator_name, debt
FROM country_debt
WHERE debt > 0
ORDER BY debt ASC
LIMIT 1;

-- ------------------------------------------------------------
-- Section 2: Data Analyst analysis queries
-- ------------------------------------------------------------

-- 6. Count records for each country
SELECT country_name, COUNT(*) AS record_count
FROM country_debt
GROUP BY country_name
ORDER BY record_count DESC, country_name;

-- 7. Average debt across all records
SELECT ROUND(AVG(debt), 2) AS average_debt
FROM country_debt;

-- 8. Countries with at least two records
SELECT country_name, COUNT(*) AS record_count
FROM country_debt
GROUP BY country_name
HAVING COUNT(*) >= 2
ORDER BY country_name;

-- 9. Total recorded debt per country
-- Caution: only sum records when their indicators/units are comparable.
SELECT country_name, SUM(debt) AS total_recorded_debt
FROM country_debt
GROUP BY country_name
ORDER BY total_recorded_debt DESC;

-- 10. Records with debt above the overall average
SELECT country_name, indicator_name, debt
FROM country_debt
WHERE debt > (SELECT AVG(debt) FROM country_debt)
ORDER BY debt DESC;

-- 11. Rank records by debt from highest to lowest
SELECT
    country_name,
    indicator_name,
    debt,
    DENSE_RANK() OVER (ORDER BY debt DESC) AS debt_rank
FROM country_debt
ORDER BY debt_rank, country_name;

-- 12. Highest debt value for each country
SELECT country_name, MAX(debt) AS highest_recorded_debt
FROM country_debt
GROUP BY country_name
ORDER BY highest_recorded_debt DESC;

-- 13. Each record alongside its country's average
SELECT
    country_name,
    indicator_name,
    debt,
    ROUND(AVG(debt) OVER (PARTITION BY country_name), 2) AS country_average_debt
FROM country_debt
ORDER BY country_name, debt DESC;

-- 14. CTE: records with debt above 1 trillion
WITH high_debt AS (
    SELECT country_name, indicator_name, debt
    FROM country_debt
    WHERE debt > 1000000000000
)
SELECT *
FROM high_debt
ORDER BY debt DESC;

-- 15. Top three countries by maximum recorded debt
SELECT country_name, MAX(debt) AS max_recorded_debt
FROM country_debt
GROUP BY country_name
ORDER BY max_recorded_debt DESC
LIMIT 3;

-- ------------------------------------------------------------
-- Section 3: Indicator-level analysis
-- ------------------------------------------------------------

-- Average recorded value by indicator
SELECT
    indicator_name,
    indicator_code,
    ROUND(AVG(debt), 2) AS average_recorded_value
FROM country_debt
GROUP BY indicator_name, indicator_code
ORDER BY average_recorded_value DESC;

-- Debt category for each record (thresholds are illustrative)
SELECT
    country_name,
    indicator_name,
    debt,
    CASE
        WHEN debt >= 1000000000000 THEN 'Very High'
        WHEN debt >= 100000000000 THEN 'High'
        WHEN debt >= 10000000000 THEN 'Medium'
        ELSE 'Low'
    END AS debt_category
FROM country_debt
ORDER BY debt DESC;

-- ------------------------------------------------------------
-- Suggested next improvement:
-- Add a year column and import verified data with source metadata.
-- Check each indicator's unit before comparing or aggregating values.
-- ------------------------------------------------------------
