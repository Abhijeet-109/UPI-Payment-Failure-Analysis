-- 12 Final_business_insights

Use upi_analysis;

-- Query 1 — Executive KPI summary
SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS total_failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS overall_failure_rate,
    ROUND(SUM(amount) / 10000000, 2) AS total_value_cr,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) / 10000000, 2) AS failed_value_cr,
    ROUND(AVG(amount), 2) AS avg_transaction_amount
FROM upi_transactions;


-- Query 2 — Top 3 highest risk banks
SELECT
    sender_bank,
    COUNT(*) AS total_transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS market_share_pct,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) / 100000, 2) AS failed_value_lac
FROM upi_transactions
GROUP BY sender_bank
ORDER BY failure_rate DESC
LIMIT 3;


-- Query 3 — Critical time windows
SELECT
    DAYNAME(timestamp) AS day_name,
    HOUR(timestamp) AS hour_of_day,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) / 100000, 2) AS failed_value_lac
FROM upi_transactions
GROUP BY day_name, hour_of_day
HAVING COUNT(*) > 100
ORDER BY failure_rate DESC
LIMIT 10;


-- Query 4 — State risk matrix (volume vs failure)
SELECT
    sender_state,
    COUNT(*) AS total_transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS volume_share_pct,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) / 100000, 2) AS failed_value_lac,
    CASE
        WHEN COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () >= 10
             AND SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) >= 5
        THEN 'High Volume High Risk'
        WHEN COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () >= 10
             AND SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) < 5
        THEN 'High Volume Low Risk'
        WHEN COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () < 10
             AND SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) >= 5
        THEN 'Low Volume High Risk'
        ELSE 'Low Volume Low Risk'
    END AS risk_category
FROM upi_transactions
WHERE sender_state IS NOT NULL
GROUP BY sender_state
ORDER BY failed_value_lac DESC;


-- Query 5 — Consolidated failure summary across all dimensions
SELECT 'Bank' AS dimension, sender_bank AS category,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) / 100000, 2) AS failed_value_lac
FROM upi_transactions GROUP BY sender_bank
HAVING COUNT(*) > 1000

UNION ALL

SELECT 'State', sender_state,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2),
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) / 100000, 2)
FROM upi_transactions WHERE sender_state IS NOT NULL GROUP BY sender_state
HAVING COUNT(*) > 1000

UNION ALL

SELECT 'Transaction Type', transaction_type,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2),
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) / 100000, 2)
FROM upi_transactions WHERE source_file = 'primary' GROUP BY transaction_type

UNION ALL

SELECT 'Merchant Category', merchant_category,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2),
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) / 100000, 2)
FROM upi_transactions WHERE source_file = 'primary' AND merchant_category IS NOT NULL GROUP BY merchant_category

ORDER BY failure_rate DESC;



