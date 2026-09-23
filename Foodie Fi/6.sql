--6. What is the number and percentage of customer plans after their initial free trial?

with c as (
select customer_id
    ,plan_name
    ,rank() over (partition by customer_id order by start_date) as rnk
from subscriptions as s
left join plans as p
on s.plan_id = p.plan_id
),

t as (
    select COUNT(distinct customer_id) as total_customers
    from subscriptions
)

select plan_name
    ,count(customer_id) as num_of_customers
    ,ROUND(num_of_customers / MAX(total_customers) * 100,1) as percent_of_customers
from c
cross join t
where rnk = 2
group by plan_name
having plan_name != 'trial';
