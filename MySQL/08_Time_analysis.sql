-- 8 Time_analysis
Use upi_analysis;

-- Query 1 — Failure rate by hour of day
SELECT
    HOUR(timestamp) AS hour_of_day,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
GROUP BY hour_of_day
ORDER BY failure_rate DESC;


-- Query 2 — Failure rate by day of week
SELECT
    DAYNAME(timestamp) AS day_name,
    DAYOFWEEK(timestamp) AS day_num,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
GROUP BY day_name, day_num
ORDER BY failure_rate DESC;


-- Query 3 — Failure rate by month
SELECT
    MONTHNAME(timestamp) AS month_name,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
GROUP BY  month_name
ORDER BY failure_rate DESC;


-- Query 4 — Hour × Day combination (peak failure windows)
SELECT
    DAYNAME(timestamp) AS day_name,
    HOUR(timestamp) AS hour_of_day,
    COUNT(*) AS total,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
GROUP BY day_name, hour_of_day
HAVING COUNT(*) > 100
ORDER BY failure_rate DESC
LIMIT 15;


-- Query 5 — Failed value by hour
SELECT
    HOUR(timestamp) AS hour_of_day,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) / 100000, 2) AS failed_value_lac,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) * 100.0 / SUM(amount), 2) AS failed_value_pct
FROM upi_transactions
GROUP BY hour_of_day
ORDER BY failed_value_lac DESC;


