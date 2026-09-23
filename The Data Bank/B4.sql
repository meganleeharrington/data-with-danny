--4. What is the closing balance for each customer at the end of the month? 
--It wasn't clear which month was being referred to so I did the end of every month.
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
        ,txn_date
        ,rnk
        ,sum(txn_amount) as daily_total
    from a
    group by all
    order by rnk
),

c as (
    select customer_id
        ,txn_date
        ,rnk
        ,daily_total
        ,sum(daily_total) over (partition by customer_id order by rnk) as running_total
    from b
    order by rnk
),

dates as (
    SELECT DATEADD(day, SEQ4(), '2020-01-01'::date) AS date
    FROM TABLE(GENERATOR(ROWCOUNT => 124))
    WHERE date < DATEADD(month, 4, '2020-01-01'::date)
),

customers as (
    select distinct customer_id 
    from customer_transactions
),

cj as (
    select date
        ,customer_id
    from dates
    cross join customers
),

lj as (
    select cj.date
        ,cj.customer_id
        ,c.txn_date
        ,rnk
        ,daily_total
        ,running_total
    from cj
    left join c
    on cj.date = c.txn_date and cj.customer_id = c.customer_id
),

semifinal as (
    select date
        ,customer_id
        ,daily_total
        ,last_value(running_total) ignore nulls over (partition by customer_id order by date rows between unbounded preceding and current row) as running_total
    from lj
)

select date
    ,customer_id
    ,running_total as balance
from semifinal
where date = last_day(date)
;

select distinct txn_date
from customer_transactions;