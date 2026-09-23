--1. How many unique nodes are there on the Data Bank system?
select SUM(nodes) as nodes
from (select count(distinct node_id) as nodes
    from customer_nodes
    group by region_id) as t;