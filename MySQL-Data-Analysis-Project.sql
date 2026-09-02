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
WITH order_revenue AS (SELECT o.order_id,SUM(p.price * oi.quantity * (1 - oi.discount)) AS order_total FROM orders o JOIN order_items oi
ON o.order_id = oi.order_id JOIN products p ON oi.product_id = p.product_id WHERE o.order_status = 'Completed' GROUP BY o.order_id)
SELECT ROUND(AVG(order_total), 2) AS Average_Order_Value FROM order_revenue; 

-- Section 2 : Product Analysis 

-- Q7 Top 10 Products by Revenue
 select  p.product_name,sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Revenue'  from orders o  join order_items oi on oi.order_id=o.order_id 
join products p on oi.product_id=p.product_id where order_status='Completed' group by p.product_name order by Total_Revenue desc limit 10;

-- Q8 Category-Wise Revenue
select p.category,sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Revenue' 
 from orders o  join order_items oi on oi.order_id=o.order_id 
join products p on oi.product_id=p.product_id where order_status='Completed' group by p.category order by total_revenue desc;

-- Q9 Category-Wise Quantity Sold
select p.category,sum(oi.quantity)'Total_Quantity',sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Revenue' 
 from orders o  join order_items oi on oi.order_id=o.order_id 
join products p on oi.product_id=p.product_id where order_status='Completed' group by p.category;

-- Q10 Most Profitable Product
select p.product_id,p.product_name,p.category, sum((price-cost)*oi.quantity) 'Profit'  
 from orders o  join order_items oi on oi.order_id=o.order_id
join products p on oi.product_id=p.product_id where order_status='Completed'  group by p.product_id, p.product_name,p.category order by profit desc limit 1;

-- Q11 Products Never Ordered
select p.product_id,p.product_name from products p left join order_items oi on p.product_id=oi.product_id where oi.product_id is null;

-- Section 3 - Customer Analysis

-- Q12 Top 10 Customers By Spending
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
 
 -- Q15 City-Wise Revenue
select  c.city,sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Spending'  from customers c 
 join orders o on c.customer_id=o.customer_id
   join order_items oi on o.order_id=oi.order_id join products p on oi.product_id=p.product_id
  where o.order_status='Completed' group by c.city;
  
  -- Q16 Highest-Spending Customer in Each City
with customer_spending as(select c.customer_name, c.city ,sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Spending' 
 from customers c 
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id join products p on oi.product_id=p.product_id
where o.order_status='Completed' group by c.customer_name, c.city), Customer_Rank as (select  customer_name,city,total_spending,dense_rank()
over (partition by city order by Total_spending desc) 'High_Spending_Rank' from customer_spending) 
select customer_name,city,total_spending from customer_rank where High_Spending_Rank=1 ; 

-- section 4 Order & Time analysis

-- Q17  Monthly Revenue
select  date_format(o.order_date,'%Y-%M') 'Month', sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Revenue' from orders o join order_items oi
on oi.order_id=o.order_id join products p on p.product_id=oi.product_id where o.order_status='Completed'
 group by  date_format(o.order_date,'%Y-%M') order by month ;

-- Q18 Monthly Order Count
select date_format(order_date,'%Y-%M') 'month' ,count(order_id) 'total_ordere' 
from orders where order_status='completed' group by date_format(order_date,'%Y-%M') order by month;

-- Q19 Order Status Analysis
select order_status,count(*) 'Total_Orders',round(count(*)*100.0 /(select count(*) from orders),2) 'order_Percentage'
from orders group by order_status;

-- Q20 Average Order Value by Month
with monthly_data as (select date_format(o.order_date,'%Y-%M') 'Month',sum(p.price*oi.quantity*(1-oi.discount)) 'Total_revenue',
count(distinct o.order_id)'Total_order' from orders o
join order_items oi on o.order_id=oi.order_id
join products p on oi.product_id=p.product_id 
where order_status='Completed' group by date_format(o.order_date,'%Y-%M')) 
select Month,total_revenue,Total_order, round(Total_revenue/Total_order,2) 'Average_order_value' from monthly_data order by month;

-- Section 5 - Payment Analysis

-- Q21 Payment Method Performance
select  payment_method,sum(amount) 'Total_amount' ,count(*) 'Total_Transaction' from payments group by payment_method;

-- Q22 Payment Status Analysis
select  payment_status,sum(amount) 'Total_amount' ,count(*) 'Total_Transaction' from payments group by payment_status;

-- Q23 Most Preferred Payment Method
select  payment_method,sum(amount) 'Total_amount' ,count(*) 'Total_Transaction' from payments group by payment_method 
order by Total_transaction desc limit 1;

-- Q24 Payment Success Rate
select concat(round(count(*)*100/(select count(*) from payments),2),'%') 'Payment_Percentage',payment_status from payments  where payment_status='Paid' group by payment_status;

-- Q25 Payment Amount VS Order Revenue
with compare_table as (select o.order_id,p.amount,sum(pr.price*oi.Quantity*(1-oi.discount)) 'Revenue' from orders o join order_items oi on o.order_id=oi.order_id
join payments p on o.order_id=p.order_id join products pr on oi.product_id=pr.product_id group by o.order_id,p.amount)
select order_id,amount,revenue from compare_table where amount != Revenue;

-- Section 6 Employee Performance

-- Q26 Employee-Wise Order Count
select  e.employee_id,e.employee_name,count(o.order_status) 'Total_Order' from Employees e join orders o on e.employee_id=o.employee_id where o.order_status='Completed'
group by e.employee_id,e.employee_name;

-- Q27 Top 5 Employee by Revenue
select e.employee_name,sum(p.price*oi.quantity*(1-oi.discount)) 'Revenue' from orders o join order_items oi on oi.order_id=o.order_id
join products p on oi.product_id=p.product_id 
join employees e on o.employee_id=e.employee_id
where order_status='completed' 
group by e.employee_name order by revenue desc limit 5;

-- Q28 Employee Average Order Values
with employee_orders as(select e.employee_id, e.employee_name,o.order_id ,sum(p.price*oi.quantity*(1-oi.discount)) 'Order_Revenue'
 from employees e join orders o on e.employee_id=o.employee_id
 join order_items oi on o.order_id=oi.order_id
 join products p on oi.product_id=p.product_id
 where order_status='Completed' group by e.employee_id, e.employee_name,o.order_id)
 select employee_id,employee_name,round(avg(order_revenue),2) 'Average_order_value' from employee_orders
 group by employee_id,employee_name order by Average_order_value desc ;
 
 -- Q29  Employee Revenue Ranking
 with Employee_Revenue as(select e.employee_name,sum(p.price*oi.quantity*(1-oi.discount)) 'Revenue'  from 
 orders o join order_items oi on oi.order_id=o.order_id
join products p on oi.product_id=p.product_id 
join employees e on o.employee_id=e.employee_id 
 where order_status='Completed' group by e.employee_name)
 select employee_name,revenue,rank() over ( order by revenue desc) 'Rank' from employee_revenue;
 
-- Q30 Best Performing Employee in Each City
 with Employee_Revenue as(select e.employee_id, e.employee_name ,e.city,sum(p.price*oi.quantity*(1-oi.discount)) 'Revenue'  from 
employees e join orders o on e.employee_id=o.employee_id
join order_items oi on o.order_id=oi.order_id
join products p on oi.product_id=p.product_id
 where order_status='Completed' group by e.employee_id, e.employee_name,e.city),
 ranked_employee as( select employee_id,employee_name,city,revenue,rank() over (partition by city order by revenue desc) 'Employee_Rank'
 from employee_revenue)
 select employee_id,employee_name,city,revenue from ranked_employee where employee_rank=1;
 
-- Section 7 - Advanced SQL
-- Q31 Product Revenue Ranking
with trevenue as(select p.product_id, p.product_name,sum(p.price*oi.quantity*(1-oi.discount)) 'Revenue' from orders o 
join order_items oi on o.order_id=oi.order_id
join products p on p.product_id=oi.product_id where o.order_status='Completed' group by p.product_id,p.product_name)
select product_id,product_name,revenue,rank()over(order by revenue desc) 'Revenue_rank' from trevenue;

-- Q32 Customer Spending Ranking
with Customer_spending as(select c.customer_id, c.customer_name,sum(p.price*oi.quantity*(1-oi.discount))'Revenue'  from customers c join orders o on
c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id
join products p on oi.product_id=p.product_id where order_status='completed'
group by c.customer_id, c.customer_name)
select customer_id, customer_name,Revenue,dense_rank() over(order by Revenue desc) from customer_spending ;

-- Q33 Second highest revenue product
with Customer_spending as(select p.product_id,p.product_name,sum(p.price*oi.quantity*(1-oi.discount))'Revenue'  from  orders o 
join order_items oi on o.order_id=oi.order_id
join products p on oi.product_id=p.product_id
where order_status='Completed' group by p.product_id,p.product_name),
ranking as(select product_id,product_name,Revenue,dense_rank() over(order by Revenue desc )'Ranks' from customer_spending)
select * from ranking where ranks =2;

-- Q34 Month-Wise Revenue
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, SUM(p.price * oi.quantity * (1 - oi.discount)) AS revenue FROM orders o JOIN order_items oi
ON o.order_id = oi.order_id JOIN products p ON oi.product_id = p.product_id WHERE o.order_status = 'Completed' GROUP BY 
DATE_FORMAT(o.order_date, '%Y-%m') ORDER BY month;

-- Q35 Month-Over-Month Revenue
WITH monthly_revenue AS (SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,SUM(p.price * oi.quantity * (1 - oi.discount)) AS revenue 
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id JOIN products p ON oi.product_id = p.product_id WHERE o.order_status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')) SELECT month,revenue,LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
ROUND((revenue - LAG(revenue) OVER (ORDER BY month))* 100.0/ LAG(revenue) OVER (ORDER BY month),2) AS revenue_growth_percentage
FROM monthly_revenue ORDER BY month;

-- Q36 Customer First & Last Order Analysis
select C.customer_id,c.Customer_name,min(o.order_date)'First_Order_Date',max(o.order_date)'Last_Order_Date' from customers c join orders o  on
c.customer_id=o.customer_id group by C.customer_id,c.Customer_name;

-- Q37 Customer Lifetime Spending
Select c.customer_id,customer_name,sum(p.price*oi.quantity*(1-oi.discount)) 'Total_Revenue' from customers c join orders o on c.customer_id
=o.customer_id join order_items oi on  oi.order_id=o.order_id join products p on  p.product_id=oi.product_id where o.order_status='Completed'
group by c.customer_id,customer_name order by Total_revenue desc ;

-- Q38 Running Total Revenue
with Month_Revenue as(select Date_format(o.order_date,'%Y-%M') 'Month',sum(p.price*oi.quantity*(1-Oi.discount))'Monthly_Revenue' from orders o
join order_items oi on o.order_id=oi.order_id join products p on p.product_id=oi.product_id group by month order by Monthly_Revenue)
select month,monthly_revenue,sum(monthly_revenue)over(order by monthly_revenue ) 
 from month_revenue group by month,monthly_revenue order by Monthly_Revenue;

-- Q39  Top-selling Product In Each Category
with joins as(select p.category,p.product_id,p.product_name,sum(p.price*oi.quantity*(1-oi.discount))'Total_Revenue' 
from order_items oi join products p on oi.product_id=p.product_id group by p.category,p.product_id,p.product_name ),
Category_order as(select category,product_id,product_name,total_revenue ,dense_rank() over(partition by category order by total_revenue desc)
'ranks' from joins  group by category,product_name,product_id )
select category,product_id,product_name,total_revenue from category_order where ranks=1;

-- Q40 Category Revenue Contribution
with Category_revenue as (select p.category,sum(p.price*oi.quantity*(1-oi.discount))'Total_Revenue' 
from products p join order_items oi on p.product_id=oi.product_id join orders o on oi.order_id=o.order_id where order_status='completed' 
group by p.category)
select category,total_revenue,total_revenue*100/(select sum(total_revenue) from Category_revenue ) 'Percentage' from Category_revenue;

-- Q41 Highest value Order
select o.order_id,o.customer_id,o.order_date,sum(p.price*oi.quantity*(1-oi.discount))'order_value'
from orders o join order_items oi on o.order_id=oi.order_id join products p on oi.product_id=p.product_id where order_status='Completed'
group by 
o.order_id,o.customer_id,o.order_date order by Order_value desc limit 1;

