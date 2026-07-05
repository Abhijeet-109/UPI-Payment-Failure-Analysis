-- 2. Data Validation 

Use UPI_analysis;
-- Validating Each unique values 

select distinct status, count(*) as Count
from upi_transactions 
group by status;

select distinct transaction_type, count(*) as Count
from upi_transactions
group by transaction_type;

select distinct payment_mode, count(*) as Count 
from upi_transactions
group by payment_mode;

select distinct device_type, count(*) as Counta
from upi_transactions
group by device_type;

select distinct sender_bank, count(*) as Count
from upi_transactions
group by sender_bank;


-- Validating the if Null values are exists
SELECT 
    SUM(CASE WHEN sender_state IS NULL THEN 1 ELSE 0 END) AS null_state,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN merchant_category IS NULL THEN 1 ELSE 0 END) AS null_merchant,
    SUM(CASE WHEN purpose IS NULL THEN 1 ELSE 0 END) AS null_purpose
FROM upi_transactions;
