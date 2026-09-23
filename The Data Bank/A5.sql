--5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region? 
with a as (
select region_id
    ,datediff('day', start_date, end_date) as days
from customer_nodes
where year(end_date) != '9999'
)

select median(days) as median_days
    ,PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY days) AS p80_days
    ,PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY days) AS p95_days
from a
group by region_id;