--1. How many customers has Foodie-Fi ever had?
select COUNT(distinct customer_id) as total_customers
from subscriptions;
