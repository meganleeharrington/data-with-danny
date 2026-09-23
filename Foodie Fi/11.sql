--11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

with c as (
select customer_id
    ,plan_name
    ,start_date
    ,rank() over (partition by customer_id order by start_date) as rnk
    ,count(*) over (partition by customer_id) as plan_count
from subscriptions as s
left join plans as p
on s.plan_id = p.plan_id
where plan_name in ('basic monthly', 'pro monthly') and year(start_date) = '2020'
qualify plan_count = 2
)

select 'upgrade_to_pro' as change_type
    ,COUNT(CASE WHEN plan_name = 'basic monthly' THEN 1 END) AS count
from c
where rnk = 1

union all

select 'downgrade_to_basic' as change_type
    ,COUNT(CASE WHEN plan_name = 'pro monthly' THEN 1 END) AS count
from c
where rnk = 1;
