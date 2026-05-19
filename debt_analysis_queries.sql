-- International Debt Statistics Analysis Queries
-- Expected table: international_debt
-- Expected columns: country_name, country_code, indicator_name, indicator_code, debt

/* 1) Understand the dataset */
-- 1a. Preview rows
SELECT *
FROM international_debt
LIMIT 10;

-- 1b. Row count
SELECT COUNT(*) AS total_rows
FROM international_debt;

-- 1c. Basic debt range
SELECT
    MIN(debt) AS min_debt,
    MAX(debt) AS max_debt,
    AVG(debt) AS avg_debt
FROM international_debt;

/* 2) Number of distinct countries */
SELECT COUNT(DISTINCT country_code) AS distinct_country_count
FROM international_debt;

/* 3) Distinct debt indicators */
SELECT DISTINCT indicator_name, indicator_code
FROM international_debt
ORDER BY indicator_name;

/* 4) Total amount of debt owed by countries */
SELECT
    country_name,
    ROUND(SUM(debt)::numeric, 2) AS total_debt_usd
FROM international_debt
GROUP BY country_name
ORDER BY total_debt_usd DESC;

/* 5) Country with the highest debt */
SELECT
    country_name,
    ROUND(SUM(debt)::numeric, 2) AS total_debt_usd
FROM international_debt
GROUP BY country_name
ORDER BY total_debt_usd DESC
LIMIT 1;

/* 6) Average amount of debt across indicators */
SELECT
    indicator_name,
    indicator_code,
    ROUND(AVG(debt)::numeric, 2) AS avg_debt_usd
FROM international_debt
GROUP BY indicator_name, indicator_code
ORDER BY avg_debt_usd DESC;

/* 7) Highest amount of principal repayments */
SELECT
    country_name,
    indicator_name,
    ROUND(MAX(debt)::numeric, 2) AS highest_principal_repayment_usd
FROM international_debt
WHERE indicator_code = 'DT.AMT.DLXF.CD'
GROUP BY country_name, indicator_name
ORDER BY highest_principal_repayment_usd DESC
LIMIT 1;

/* 8) Most common debt indicator */
SELECT
    indicator_name,
    indicator_code,
    COUNT(*) AS occurrences
FROM international_debt
GROUP BY indicator_name, indicator_code
ORDER BY occurrences DESC, indicator_name
LIMIT 1;

/* 9) Other viable debt insights */

-- 9a. Top 10 countries by average debt per indicator record
SELECT
    country_name,
    ROUND(AVG(debt)::numeric, 2) AS avg_debt_per_record_usd
FROM international_debt
GROUP BY country_name
ORDER BY avg_debt_per_record_usd DESC
LIMIT 10;

-- 9b. Countries with highest interest payment burden
-- DT.INT.% captures interest-related indicators
SELECT
    country_name,
    ROUND(SUM(debt)::numeric, 2) AS total_interest_payments_usd
FROM international_debt
WHERE indicator_code LIKE 'DT.INT.%'
GROUP BY country_name
ORDER BY total_interest_payments_usd DESC
LIMIT 10;

-- 9c. Countries with highest disbursements
-- DT.DIS.% captures disbursement-related indicators
SELECT
    country_name,
    ROUND(SUM(debt)::numeric, 2) AS total_disbursements_usd
FROM international_debt
WHERE indicator_code LIKE 'DT.DIS.%'
GROUP BY country_name
ORDER BY total_disbursements_usd DESC
LIMIT 10;
