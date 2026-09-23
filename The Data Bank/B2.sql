--2. What is the average total historical deposit counts and amounts for all customers?
with c as (
select customer_id
    ,count(txn_type) as deposit_count
    ,sum(txn_amount) as deposit_amount
from customer_transactions
where txn_type = 'deposit'
group by all
)

select round(avg(deposit_count),1) as avg_deposit_count
    ,round(sum(deposit_amount) / count(customer_id),2) as avg_deposit_amount
from c
;