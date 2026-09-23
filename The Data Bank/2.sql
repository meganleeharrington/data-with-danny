--2. What is the number of nodes per region?
select region_name
    ,count(distinct node_id)
from customer_nodes as cn
left join regions as r
on cn.region_id = r.region_id
group by 1;