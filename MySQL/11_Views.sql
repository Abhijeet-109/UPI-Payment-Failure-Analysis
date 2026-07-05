-- 11 Views

Use upi_analysis;

-- View 1 — Overall failure summary
CREATE VIEW vw_overall_summary AS
SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS total_failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS overall_failure_rate,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END), 2) AS total_failed_value,
    ROUND(AVG(amount), 2) AS avg_transaction_amount
FROM upi_transactions;


-- View 2 — Bank failure summary
CREATE VIEW vw_bank_failure AS
SELECT
    sender_bank,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END), 2) AS failed_value
FROM upi_transactions
GROUP BY sender_bank;


-- View 3 — State failure summary
CREATE VIEW vw_state_failure AS
SELECT
    sender_state,
    COUNT(*) AS total_transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS volume_share_pct,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END), 2) AS failed_value
FROM upi_transactions
WHERE sender_state IS NOT NULL
GROUP BY sender_state;


-- View 4 — Time failure summary (hourly)
CREATE VIEW vw_hourly_failure AS
SELECT
    HOUR(timestamp) AS hour_of_day,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) / 100000, 2) AS failed_value_lac
FROM upi_transactions
GROUP BY hour_of_day;


-- View 5 — Transaction type failure summary
CREATE VIEW vw_transaction_type_failure AS
SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END), 2) AS failed_value
FROM upi_transactions
WHERE source_file = 'primary'
GROUP BY transaction_type;


-- View 6 — Merchant category failure summary
CREATE VIEW vw_merchant_failure AS
SELECT
    merchant_category,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END), 2) AS failed_value
FROM upi_transactions
WHERE source_file = 'primary'
  AND merchant_category IS NOT NULL
GROUP BY merchant_category;

SHOW FULL TABLES IN upi_analysis WHERE TABLE_TYPE = 'VIEW';