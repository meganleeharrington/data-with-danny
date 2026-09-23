--5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
with c as (
    select customer_id
        ,IFF(MIN(plan_id) = 0, 1, 0) as trial_start
        ,IFF(MAX(plan_id) = 4, 1, 0) as churn
        ,IFF(COUNT(plan_id) = 2, 1, 0) as two_plans
    from subscriptions
    group by customer_id
)

select SUM(IFF(trial_start = 1 and churn = 1 and two_plans = 1, 1, 0)) as churn_after_trial_number
    ,ROUND(churn_after_trial_number / COUNT(*) * 100,0) as percent_churn_after_trial
from c;
