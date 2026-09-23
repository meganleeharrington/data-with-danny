--10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc) 
--To answer this question, I broke the customer-to-annual-plan metric into 30 day periods, and found both count of customers and percent of customers for the given period

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

select case
    when time_to_annual >= 30 then '0-30 days'
    when time_to_annual >= 60 then '31-60 days'
    when time_to_annual >= 90 then '61-90 days'
    when time_to_annual >= 120 then '91-120 days'
    when time_to_annual >= 150 then '120-150 days'
    else 'more than 150 days'
    end as day_breakdown
    ,count(*) as num_of_people
    ,round(num_of_people / sum(num_of_people) over () * 100, 1) as percent_of_total
from a
group by 1;
