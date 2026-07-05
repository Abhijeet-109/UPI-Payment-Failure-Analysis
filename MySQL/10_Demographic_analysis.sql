-- 10 Demographic_analysis

Use upi_analysis;

-- Query 1 — Failure rate by sender age group
SELECT
    sender_age_group,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
WHERE source_file = 'primary'
  AND sender_age_group IS NOT NULL
GROUP BY sender_age_group
ORDER BY failure_rate DESC;


-- Query 2 — Failure rate by gender
SELECT
    gender,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
WHERE source_file = 'secondary'
  AND gender IS NOT NULL
GROUP BY gender
ORDER BY failure_rate DESC;


-- Query 3 — Failure rate by transaction purpose
SELECT
    purpose,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
WHERE source_file = 'secondary'
  AND purpose IS NOT NULL
GROUP BY purpose
ORDER BY failure_rate DESC;


-- Query 4 — Failed value by purpose
SELECT
    purpose,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END), 2) AS failed_value,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) * 100.0 / SUM(amount), 2) AS failed_value_pct
FROM upi_transactions
WHERE source_file = 'secondary'
  AND purpose IS NOT NULL
GROUP BY purpose
ORDER BY failed_value DESC;


-- Query 5 — Age group × gender combination
SELECT
    sender_age_group,
    gender,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
GROUP BY sender_age_group, gender
HAVING COUNT(*) > 100
ORDER BY failure_rate DESC;