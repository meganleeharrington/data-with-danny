--5. What is the percentage of customers who increase their closing balance by more than 5%? 
--The time period is ambiguous, but I am assuming they increase their first closing balance from their last closing balance) 
with a as (
    select customer_id
        ,txn_date
        ,case
            when txn_type = 'purchase' then txn_amount * -1
            when txn_type = 'withdrawal' then txn_amount * -1
            else txn_amount
            end as txn_amount
        ,dense_rank() over (partition by customer_id order by txn_date asc) as rnk
    from customer_transactions
),

b as (
    select customer_id
        ,rnk
        ,sum(txn_amount) as daily_total
    from a
    group by customer_id, rnk
    order by rnk
),

c as (
    select customer_id
        ,rnk
        ,daily_total
        ,sum(daily_total) over (partition by customer_id order by rnk) as running_total
    from b
    order by rnk
),

ob as (
    select customer_id
        ,running_total as opening_balance
    from c
    where rnk = 1
),

mr as (
    select customer_id
        ,max(rnk) as max_rnk
    from c
    group by all
),

cb as (
    select mr.customer_id
        ,running_total as closing_balance
    from mr
    left join c on mr.customer_id = c.customer_id and mr.max_rnk = c.rnk
),

checks as (
    select ob.customer_id
        ,round((closing_balance - opening_balance) / opening_balance * 100,2) as percent_change
        ,iff(percent_change > 5, 1, 0) as greater_than_5_percent
    from ob
    left join cb on ob.customer_id = cb.customer_id
)

select round(sum(greater_than_5_percent) / count(customer_id) * 100,2) as percent_of_customers_who_increased_closing_balance
from checks;