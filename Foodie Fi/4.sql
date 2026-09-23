--4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

--test if someone left then returned
with c as (
select customer_id
    ,SUM(iff(plan_id = 4, 1, 0)) as churn
    ,MAX(START_DATE) as latest_date
from subscriptions
group by 1
)

select c.customer_id
    ,churn
    ,latest_date
    ,plan_id as latest_subscription
    ,case when churn = 1 and plan_id != 4 then 1 else 0 end as churn_return
from c 
left join subscriptions s
on c.customer_id = s.customer_id and c.latest_date = s.start_date;

--customer count
with c as (
select customer_id
    ,SUM(iff(plan_id = 4, 1, 0)) as churn
from subscriptions
group by customer_id
)

select sum(churn) as churned_customers
    ,ROUND(churned_customers / count(distinct customer_id) * 100,1) as percent_churn
from c;
