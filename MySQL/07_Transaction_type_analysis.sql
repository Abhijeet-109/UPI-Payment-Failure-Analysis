-- 7_Transaction_type_analysis
Use upi_analysis;

-- -- Query 1: Transaction type distribution (volume + share)
Select 
	transaction_type,
    count(*) as total_txns,
    
    round(count(*) * 100.0 / sum(count(*)) over(),2) as volume_share_pct
from upi_transactions
where source_file = 'primary'
group by transaction_type
order by total_txns desc;


-- Query 2 — Failure rate by transaction type
Select
	transaction_type,
    Count(*) as total_transactions,
    sum(case when status = 'FAILED' then 1 else 0 end ) as failed,
    round( sum( case when status = 'FAILED' then 1 else 0 end) *100.0 / count(*), 2) as failure_rate
from upi_transactions
where source_file = 'primary'
group by transaction_type
order by failure_rate desc;


-- Query 3 — Failed transaction value by type
SELECT
    transaction_type,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END), 2) AS failed_value,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) * 100.0 / SUM(amount), 2) AS failed_value_pct
FROM upi_transactions
WHERE source_file = 'primary'
GROUP BY transaction_type
ORDER BY failed_value DESC;


-- Query 4 — Average transaction amount by type and status
SELECT
    transaction_type,
    status,
    COUNT(*) AS txn_count,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(SUM(amount) / 100000, 2) AS total_value_lac
FROM upi_transactions
WHERE source_file = 'primary'
GROUP BY transaction_type, status
ORDER BY transaction_type, status;


-- Query 5 — Transaction type and bank combination
SELECT
    transaction_type,
    sender_bank,
    COUNT(*) AS total,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM upi_transactions
WHERE source_file = 'primary'
GROUP BY transaction_type, sender_bank
HAVING COUNT(*) > 200
ORDER BY failure_rate DESC
LIMIT 15;



