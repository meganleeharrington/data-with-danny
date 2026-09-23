--9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
with t as (
select customer_id
    ,start_date as annual_plan_start
from subscriptions
where plan_id = 3
),

m as (
select customer_id
    ,min(start_date) as start_date
from subscriptions
group by all
),

a as (
select t.customer_id
    ,min(m.start_date) as start_date
    ,t.annual_plan_start
    ,datediff(day, start_date, annual_plan_start) as time_to_annual
from t
left join m
on t.customer_id = m.customer_id
group by all
)

select avg(time_to_annual) as days_to_annual_plan
from a;
