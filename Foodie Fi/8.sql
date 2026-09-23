--8. How many customers have upgraded to an annual plan in 2020?

select COUNT(distinct (case when plan_name = 'pro annual' then customer_id else null end)) as customers_on_pro_plans
from subscriptions as s
left join plans as p
  on s.plan_id = p.plan_id
where year(start_date) = '2020';
