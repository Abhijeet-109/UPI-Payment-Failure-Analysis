Create Database UPI_analysis;
Use UPI_analysis;

-- Creating Table to store Transaction Data

Create table upi_transactions(
transaction_id varchar(50),
timestamp datetime,
transaction_type varchar(50),
merchant_category varchar(100),
amount decimal(12,2),
status varchar(20),
sender_age_group varchar(20),
receiver_age_group varchar(20),
sender_state varchar(50),
sender_bank varchar(100),
receiver_bank varchar(100),
device_type varchar(50),
payment_mode varchar(50),
city varchar(50),
gender varchar(20),
purpose varchar(100),
source_file varchar(20)
);

-- Loading clean data form lcoal system 

Show Variables Like 'local_infile';
Set Global local_infile = 1;

Load Data Infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/merged_upi_transactions.csv"
Into table upi_transactions
Fields Terminated by ','
Enclosed by '"'
Lines Terminated by '\r\n'
Ignore 1 rows -- Ignores header row 
(transaction_id, timestamp, transaction_type, merchant_category, amount, status,
sender_age_group, receiver_age_group, sender_state, sender_bank, receiver_bank,
device_type, payment_mode, city, gender, purpose, source_file);
