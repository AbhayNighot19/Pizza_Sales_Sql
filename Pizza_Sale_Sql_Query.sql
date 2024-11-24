select * from [dbo].[pizzas] ;
select * from [dbo].[order_details];
select * from [dbo].[pizza_types];
select * from [dbo].[orders]; 

use [pizzahut];

-------Retrieve the total number of orders placed.
select count(order_id)as total_order from [dbo].[orders];

-----Calculate the total revenue generated from pizza sales.

select ROUND(sum([dbo].[order_details].[quantity] * [dbo].[pizzas].[price]),2) as total_sale from [dbo].[order_details]
inner join [dbo].[pizzas] on [dbo].[pizzas].pizza_id=[dbo].[order_details].[pizza_id] ;

----Identify the highest-priced pizza.

select [dbo].[pizza_types].[name], [dbo].[pizzas].[price] from [dbo].[pizza_types]
inner join [dbo].[pizzas] on [dbo].[pizzas].[pizza_type_id]=[dbo].[pizza_types].[pizza_type_id]
order by [dbo].[pizzas].[price] desc ;

----Identify the most common pizza size ordered.

select pizzas.size, count(order_details.order_details_id)

from pizzas join order_details

on pizzas.pizza_id = order_details.pizza_id

group by pizzas.size;

-----List the top 5 most ordered pizza types along with their quantities.

select * from [dbo].[order_details];
select * from [dbo].[pizza_types];
select * from [dbo].[pizzas] ;

SELECT
pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
pizza_types
JOIN
pizzas ON pizza_types.pizza_type_id= pizzas.pizza_type_id 
JOIN
 order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

----Join the necessary tables to find the total quantity of each pizza category ordered.

select * from [dbo].[pizzas] ;
select * from [dbo].[order_details];  
select * from [dbo].[orders]; 
 
 select [dbo].[pizza_types].category,  sum([dbo].[order_details].[quantity]) as quantity from [dbo].[pizza_types]
 inner join [dbo].[pizzas] on [dbo].[pizza_types].[pizza_type_id]=[dbo].[pizzas].[pizza_type_id]
 inner join [dbo].[order_details] on [dbo].[order_details].[pizza_id]=[dbo].[pizzas].[pizza_id]
 group by [dbo].[pizza_types].[category]
 order by quantity desc;

------Determine the distribution of orders by hour of the day.

select * from [dbo].[orders];
SELECT
HOUR(order_time) AS hour, COUNT (order_id) AS order_count
 FROM
 orders
GROUP BY HOUR (order_time);

-------Join relevant tables to find the category-wise distribution of pizzas.

select * from [dbo].[pizzas] ;
select * from [dbo].[order_details];
select * from [dbo].[pizza_types];
select * from [dbo].[orders]; 

select [dbo].[pizza_types].category,count([name]) from [dbo].[pizza_types]
group by [dbo].[pizza_types].category;

--Group the orders by date and calculate the average number of pizzas ordered per day.

select * from [dbo].[orders];
select * from [dbo].[order_details];

select [dbo].[orders].[date],sum([dbo].[order_details].[quantity]) as total_order from [dbo].[orders]
inner join [dbo].[order_details] on [dbo].[order_details].[order_id]=[dbo].[orders].order_id
group by [dbo].[orders].[date];


----Determine the top 3 most ordered pizza types based on revenue.

select * from [dbo].[order_details];
select * from [dbo].[pizzas] ;
select * from [dbo].[pizza_types];

select [dbo].[pizza_types].[name], sum([dbo].[order_details].[quantity]*[dbo].[pizzas].[price]) as revenue from [dbo].[pizza_types]
inner join [dbo].[pizzas] on [dbo].[pizzas].[pizza_type_id]=[dbo].[pizza_types].[pizza_type_id]
inner join [dbo].[order_details] on [dbo].[order_details].[pizza_id]=[dbo].[pizzas].[pizza_id]
group by [dbo].[pizza_types].[name]
order by revenue desc
LIMIT 3;

---Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category,
round(sum(order_details.quantity*pizzas.price)/(SELECT
ROUND(SUM(order_details.quantity * pizzas.price)
AS total_sales from [dbo].[order_details]
JOIN
pizzas ON pizzas.pizza_id = order_details.pizza_id) *100,2) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc;

-----Analyze the cumulative revenue generated over time.

select order_date, sum(revenue) over(order by order_date) as cum_revenue
 from ( orders.order_date,
sum(order_details.quantity * pizzas.price) as revenue from order_details join pizzas
 on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.order_date) as sales;

----Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name, revenue from
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name, sum((order_details.quantity) * pizzas.price) as revenue from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b where rn <= 3;