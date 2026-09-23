--2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
select to_char(start_date, 'MMMM YYYY') as month_date
    ,SUM(iff(plan_id = 0, 1, 0)) as trials
from subscriptions
group by 1;
