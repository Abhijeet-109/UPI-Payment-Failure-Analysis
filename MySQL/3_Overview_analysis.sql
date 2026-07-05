-- 3. Overview Analysis

use upi_analysis;

--  Total transaction volume and value
select 
	count(*) as totla_transactions,
    sum(amount) as total_value,
    round(avg(amount), 2) as avg_transaction_value,
    min(amount) as min_amount,
    max(amount) as max_amount 
from upi_transactions;


--  Overall success vs failure rate
SELECT 
    status,
    COUNT(*) AS transaction_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM upi_transactions
GROUP BY status;


--  Monthly transaction trend ,transaction volume and failure rate month by month.
SELECT 
    DATE_FORMAT(timestamp, '%Y-%m') AS month,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed_transactions,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
GROUP BY DATE_FORMAT(timestamp, '%Y-%m')
ORDER BY month;

--  Compares P2P vs P2M transaction volumes and their respective failure rates.
SELECT 
    transaction_type,
    COUNT(*) AS total,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
GROUP BY transaction_type
ORDER BY failure_rate DESC;


-- Shows which network type (4G/5G/WiFi/3G) has the highest failure rate.
SELECT 
    payment_mode,
    COUNT(*) AS total,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
GROUP BY payment_mode
ORDER BY failure_rate DESC;












