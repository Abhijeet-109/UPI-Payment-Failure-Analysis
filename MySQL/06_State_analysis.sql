-- 6 State_analysis
Use upi_analysis;

-- Query 1 — State-wise failure rate
Select 
	sender_state,
    count(*) as total_transactions,
    sum( case when status = 'FAILED' then 1 else 0 end ) as failed,
    round( sum( case when status = 'FAILED' then 1 else 0 end ) *100.0 / count(*), 2) as failure_rate
from upi_transactions
where sender_state IS NOT NULL 
group by sender_state
order by failure_rate desc;


-- Query 2 — State-wise transaction volume and value
Select 
	sender_state,
    count(*) as total_transactions,
    round(count(*) * 100.0 / sum(count(*)) over (), 2) as volume_share_pct,
    sum( case when status = 'FAILED' then 1 else 0 end ) as failed,
    round(sum( case when status = 'FAILED' then 1 else 0 end ) *100.0 / count(*),2) as failure_rate
from upi_transactions
where sender_state IS NOT NULL 
group by sender_state
order by total_transactions desc;


-- Query 3 — Top 5 and bottom 5 states by failure rate

	-- Top 5 worst states
Select 'worst' as category, sender_state,
	count(*) as total,
	ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
from upi_transactions
where sender_state IS NOT NULL
group by sender_state
order by failure_rate desc
limit 5;
    
    -- Top 5 best states
Select 'Best' as category, sender_state,
	count(*) as total,
	ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
from upi_transactions
where sender_state IS NOT NULL
group by sender_state
order by failure_rate asc
limit 5;


-- Query 4 — State and bank combination
Select 
	sender_bank,
    sender_state,
    count(*) as total,
    sum( case when status = 'FAILED' then 1 else 0 end ) as failed,
	ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
from upi_transactions
where sender_state IS NOT NULL
group by sender_state, sender_bank
Having count(*) > 200
order by failure_rate desc
limit 15;


-- Query 5 — Failed transaction value by state
SELECT 
    sender_state,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END), 2) AS failed_value,
    ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END) * 100.0 / SUM(amount), 2) AS failed_value_pct
FROM upi_transactions
WHERE sender_state IS NOT NULL
GROUP BY sender_state
ORDER BY failed_value DESC;    
