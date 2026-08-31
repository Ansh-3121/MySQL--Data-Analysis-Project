use sales_analytics;
show tables;
show tables;
desc customers;

-- Section 1 : Overall Business Kpis

-- Q1. Total orders
select count(order_id) 'Total_Order' from  orders;

-- Q2 Total customers
select count(customer_id) 'Total_Customers' from customers;

-- Q3 Total Products
select count(product_id) 'Total_Product' from products;

-- Q4 Total Quantity Sold
select sum(quantity) 'Total_Quantity_Sold' from order_items;

-- Q5 Total Revenue
select sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Revenue' from orders o  join order_items oi on oi.order_id=o.order_id 
join products p on oi.product_id=p.product_id where order_status='Completed';

-- Q6 Average order Value (AOV)
select  p.product_name,avg(p.price*oi.quantity*(1-oi.discount)) 'Total_Revenue'  from orders o  join order_items oi on oi.order_id=o.order_id 
join products p on oi.product_id=p.product_id where order_status='Completed' group by p.product_name order by Total_Revenue desc limit 10;
 
-- Section 2 : Product Analysis 
-- Q7 Top 10 Product by Revenue
 select  p.product_name,sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Revenue'  from orders o  join order_items oi on oi.order_id=o.order_id 
join products p on oi.product_id=p.product_id where order_status='Completed' group by p.product_name order by Total_Revenue desc limit 10;

-- Q8
select p.category, p.product_name,sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Revenue' 
 from orders o  join order_items oi on oi.order_id=o.order_id 
join products p on oi.product_id=p.product_id where order_status='Completed' group by p.category,p.product_name order by total_revenue desc;

-- Q9 Category Wise Quantity Sold
select p.category,sum(oi.quantity)'Total_Quantity',sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Revenue' 
 from orders o  join order_items oi on oi.order_id=o.order_id 
join products p on oi.product_id=p.product_id where order_status='Completed' group by p.category;

-- Q10 Most Profitable Product
select p.category,sum(oi.quantity)'Total_Quantity', sum((price-cost)*oi.quantity) 'Profit' ,sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Revenue' 
 from orders o  join order_items oi on oi.order_id=o.order_id
join products p on oi.product_id=p.product_id where order_status='Completed'  group by p.category;

-- Q11 Product Never Ordered
select p.product_id,p.product_name from products p left join order_items oi on p.product_id=oi.product_id where oi.product_id is null;

-- Section 3 - Customer Analysis
-- Q12 Top 10 Customer By Spending
select   c.customer_name ,sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Spending'  from customers c 
 join orders o on c.customer_id=o.customer_id
   join order_items oi on o.order_id=oi.order_id join products p on oi.product_id=p.product_id
  where o.order_status='Completed' group by c.customer_name,c.customer_id order by Total_Spending desc limit 10;

-- Q13 Customer Order Frequency
 select  c.customer_id,count(o.order_id) 'Order_Count'  from customers c 
 join orders o on c.customer_id=o.customer_id where order_status='Completed' group by c.customer_id;
 
 -- Q14 Repeat customers
 select  c.customer_id,count(o.order_id) 'Order_Count'  from customers c 
 join orders o on c.customer_id=o.customer_id where order_status='Completed' group by c.customer_id having order_count>=2;
 
 -- Q15 City Wise Revenue
select  c.city,sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Spending'  from customers c 
 join orders o on c.customer_id=o.customer_id
   join order_items oi on o.order_id=oi.order_id join products p on oi.product_id=p.product_id
  where o.order_status='Completed' group by c.city;
  
  -- Q16
with customer_spending as(select c.customer_name, c.city ,sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Spending' 
 from customers c 
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id join products p on oi.product_id=p.product_id
where o.order_status='Completed' group by c.customer_name, c.city), Customer_Rank as (select  customer_name,city,total_spending,dense_rank()
over (partition by city order by Total_spending desc) 'High_Spending_Rank' from customer_spending) 
select customer_name,city,total_spending from customer_rank where High_Spending_Rank=1 ; 

-- section 4 Order & Time analysis
-- Q17 
select  monthname(o.order_date) 'Month', sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Revenue', o.order_status from orders o join order_items oi
on oi.order_id=o.order_id join products p on p.product_id=oi.product_id  group by o.order_status , month having o.order_status='completed';

-- Q18 Monthly Order Count
select monthname(order_date) 'month' ,count(order_status) 'No_order' 
from orders where order_status='completed' group by order_status,month;

-- Q19 Oorder Status Analysis
select order_status,concat(round(count(*), count(*)* 100/(select count(*) from orders),2),'%' )'No_order' from orders group by order_status;
show tables;
select *from orders;

select order_status,count(*), count(*)* 100/(select count(*) from orders) 'No_order' from orders group by order_status;

