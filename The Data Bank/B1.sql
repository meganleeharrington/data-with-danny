--1. What is the unique count and total amount for each transaction type?
select txn_type
    ,count(*) as transaction_count
    ,sum(txn_amount) as transaction_amount
from customer_transactions
group by all;