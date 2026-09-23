--3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
with c as (
select to_char(txn_date, 'MMMM-YYYY') as month_date
    ,customer_id
    ,sum(iff(txn_type = 'deposit', 1, 0)) as deposits
    ,sum(iff(txn_type = 'purchase', 1, 0)) as purchases
    ,sum(iff(txn_type = 'wiithdrawal', 1, 0)) as withdrawals
from customer_transactions
group by all
)

select month_date
    ,SUM(case 
        when deposits > 1 and purchases = 1 then 1
        when deposits > 1 and withdrawals = 1 then 1
        else 0
    end) as criteria
from c
group by all;