--7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

with t as (
    select customer_id
        ,plan_id
        ,rank() over (partition by customer_id order by start_date desc) as rnk
    from subscriptions
    where start_date <= '2020-12-31'
    qualify rnk = 1
)

select plan_name
    ,count(customer_id) as customer_count
    ,round(customer_count / SUM(customer_count) over () * 100, 2) as percent_breakdown
from t
left join plans as p
on t.plan_id = p.plan_id
group by plan_name;
