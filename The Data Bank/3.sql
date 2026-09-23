--3. How many customers are allocated to each region?
select region_name
    ,count(distinct customer_id) as num_of_customers
from customer_nodes as cn
left join regions as r
on cn.region_id = r.region_id
group by 1;