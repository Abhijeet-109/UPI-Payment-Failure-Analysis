-- 5_Bank_analysis

Use upi_analysis;

-- Query 1 — Sender bank failure rate
select 
	sender_bank,
    count(*) as total,
    sum( case when status = 'FAILED' then 1 else 0 end ) as failed,
    round( sum( case when status = 'FAILED' then 1 else 0 end ) * 100.0 / count(*), 2) as failure_rate
from upi_transactions
group by sender_bank
order by failure_rate desc;


-- Query 2 — Receiver bank failure rate
select 
	receiver_bank,
    count(*) as total,
    sum( case when status = 'FAILED' then 1 else 0 end ) as failed,
    round( sum( case when status = 'FAILED' then 1 else 0 end ) * 100.0 / count(*), 2) as failure_rate
from upi_transactions
group by receiver_bank
order by failure_rate desc;


--  Query 3 — Bank pair failure analysis
Select 
	sender_bank,
    receiver_bank,
    count(*) as total,
    sum( case when status = 'FAILED' then 1 else 0 end ) as failed,
    round( sum( case when status = 'FAILED' then 1 else 0 end ) *100.0 / count(*), 2) as failure_rate
from upi_transactions
Where sender_bank IS NOT NULL and receiver_bank IS NOT NULL
group by sender_bank, receiver_bank
Having count(*) > 100
order by failure_rate DESC
limit 15;


-- Query 4 — Best performing banks
Select 
	sender_bank,
    count(*) as total_sent,
    sum( case when status = 'SUCCESS' then 1 else 0 end ) as successful,
    round( sum( case when status = 'SUCCESS' then 1 else 0 end ) *100.0 / count(*), 2) as success_rate
from upi_transactions
where sender_bank IS NOT NULL 
group by sender_bank
order by success_rate DESC;


-- Query 5 — Bank volume vs failure rate comparison
Select 
	sender_bank,
    count(*) as total_transactions,
	round(count(*) *100.0 / sum(count(*)) over (), 2) as market_share_pct,
    sum( case when status = 'FAILED' then 1 else 0 end ) as failed,
    round( sum( case when status = 'FAILED' then 1 else 0 end ) *100.0 / count(*), 2) as failure_rate
from upi_transactions
where sender_bank IS NOT NULL 
group by sender_bank
order by total_transactions desc;


 
