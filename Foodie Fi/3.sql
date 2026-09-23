--3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
select plan_name
    ,COUNT(*)
from subscriptions as s
left join plans as p
on s.plan_id = p.plan_id
where start_date > '2020-12-31' and plan_name != 'churn'
group by plan_name;
