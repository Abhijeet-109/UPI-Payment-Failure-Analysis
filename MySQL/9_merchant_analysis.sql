-- 9 Merchant_analysis
Use upi_analysis;

-- Query 1 — Merchant category distribution
SELECT
    merchant_category,
    COUNT(*) AS total_transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS volume_share_pct
FROM upi_transactions
WHERE source_file = 'primary'
  AND merchant_category IS NOT NULL
GROUP BY merchant_category
ORDER BY total_transactions DESC;


-- Query 2 — Failure rate by merchant category
SELECT
    merchant_category,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
WHERE source_file = 'primary'
  AND merchant_category IS NOT NULL
GROUP BY merchant_category
ORDER BY failure_rate DESC;


-- Query 3 — Failed value by merchant category
SELECT
    merchant_category,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END), 2) AS failed_value,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) * 100.0 / SUM(amount), 2) AS failed_value_pct
FROM upi_transactions
WHERE source_file = 'primary'
  AND merchant_category IS NOT NULL
GROUP BY merchant_category
ORDER BY failed_value DESC;


-- Query 4 —  Merchant category × bank combination
SELECT
    merchant_category,
    sender_bank,
    COUNT(*) AS total,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
WHERE source_file = 'primary'
  AND merchant_category IS NOT NULL
GROUP BY merchant_category, sender_bank
HAVING COUNT(*) > 200
ORDER BY failure_rate DESC
LIMIT 15;


