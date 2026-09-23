--4. How many days on average are customers reallocated to a different node? 

--From this question, it isn't clear whether this means: 1) the average number of days a customer stays in any node (which is dramatically skewed due based on the last date for every customer), 2) the average number of days a customer is in a node different from their assumed "regular node" (the node they are in from 2020 to 9999) or 3) the number of days they are in a new node before they reach their "resting node" (the node they are in from 2020 to 9999). I have assumed option 3.

with a as (
select customer_id
    ,datediff('day', start_date, end_date) as days
from customer_nodes
where year(end_date) != '9999'
)

select round(avg(days),1) as num_of_days_per_node
from a;

select *
from customer_nodes
where customer_id = 1;