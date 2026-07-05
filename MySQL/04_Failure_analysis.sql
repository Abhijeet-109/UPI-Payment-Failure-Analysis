-- Failure Analysis 
 Use upi_analysis;
 
 -- Failure rate by amount range
 Select 
	 Case 
		When amount < 100 then 'Below 100'
        When amount Between 100 and 1000 then '100-1000'
        When amount Between 1001 and 10000 then '1001-10000'
        when amount > 10000 then 'Above 10000'
    End as Amount_range,
    count(*) as total,
    sum(case when status = 'FAILED' then 1 else 0 end ) as failed,
    round(sum(case when status = 'FAILED' then 1 else 0 end ) *100.0 / count(*), 2) as failure_rate
from upi_transactions
group by Amount_range
order by failure_rate DESC;


--  Failure rate by device type
Select 
	device_type,
    count(*) as total,
    sum(case when status = 'FAILED' then 1 else 0 end ) as failed,
    round(sum(case when status = 'FAILED' then 1 else 0 end) *100.0 / count(*), 2) as failure_rate
from upi_transactions
group by device_type
order by failure_rate DESC;


-- Hourly failure pattern
Select 
	HOUR(timestamp) as hour_of_day,
    COUNT(*) as total,
    sum(case when status = 'FAILED' then 1 else 0 end ) as failed,
    round(sum(case when status = 'FAILED' then 1 else 0 end ) *100.0 / count(*), 2) as failure_rate
from upi_transactions
group by hour_of_day
order by failure_rate DESC;


-- Day of week failure pattern
select 
	dayname(timestamp) as day_of_week,
    count(*) as total,
    sum(case when status = 'FAILED' then 1 else 0 end ) as failed,
    round(sum(case when status = 'FAILED' then 1 else 0 end ) *100.0 / count(*), 2) as failure_rate
from upi_transactions
group by day_of_week
order by failure_rate desc;


-- Top 10 high value failed transactions
Select 
		transaction_id,
        amount,
        sender_bank,
        receiver_bank,
        timestamp,
        payment_mode,
        transaction_type
from upi_transactions
where status = 'FAILED' 
order by amount DESC
limit 10;


--  Failed transaction value concentration
Select 
	round( sum( amount ), 2) as total_value,
    round( sum( Case when status = 'FAILED' then amount else 0 end ), 2) as total_failed_value,
    round( sum( case when status = 'FAILED' then amount else 0 end ) *100.0 / sum(amount) ,2) as failed_value_percentage
from upi_transactions;
