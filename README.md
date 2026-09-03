# MySQL Data Analysis Project

##  Project Overview

This project analyzes an e-commerce sales database using **MySQL** to
generate meaningful business insights.

The analysis covers customers, orders, products, order items, employees,
and payments. SQL queries are used to calculate business KPIs and
analyze revenue, customers, products, orders, payments, and employee
performance.

##  Database Tables

The project uses 6 main tables:

-   customers --- Customer information
-   orders --- Order details and order status
-   order_items --- Products and quantities included in each order
-   products --- Product, category, price, and cost information
-   employees --- Employee information and performance
-   payments --- Payment method, amount, and payment status

##  Analysis Performed

### Business KPIs

-   Total Orders
-   Total Customers
-   Total Products
-   Total Quantity Sold
-   Total Revenue
-   Average Order Value (AOV)

### Product Analysis

-   Top 10 Products by Revenue
-   Category-wise Revenue
-   Category-wise Quantity Sold
-   Most Profitable Product
-   Products Never Ordered
-   Product Revenue Ranking
-   Second Highest Revenue Product
-   Top-Selling Product in Each Category

### Customer Analysis

-   Top 10 Customers by Spending
-   Customer Order Frequency
-   Repeat Customers
-   City-wise Revenue
-   Highest-Spending Customer in Each City
-   Customer First and Last Order Analysis

### Order & Time Analysis

-   Monthly Revenue
-   Monthly Order Count
-   Order Status Analysis
-   Monthly Average Order Value
-   Month-over-Month Revenue Growth
-   Running Total Revenue
-   Highest Value Order

### Payment Analysis

-   Payment Method Performance
-   Payment Status Analysis
-   Most Preferred Payment Method
-   Payment Success Rate
-   Payment Amount vs Order Revenue

### Employee Analysis

-   Employee-wise Order Count
-   Top 5 Employees by Revenue
-   Employee Average Order Value
-   Employee Revenue Ranking
-   Best Performing Employee in Each City

## 🛠️ SQL Concepts Used

-   SELECT, WHERE, GROUP BY, HAVING, ORDER BY, LIMIT
-   Aggregate Functions: SUM, COUNT, AVG, MIN, MAX
-   INNER JOIN and LEFT JOIN
-   Subqueries
-   Common Table Expressions (CTEs)
-   Window Functions
-   RANK, DENSE_RANK, ROW_NUMBER
-   LAG
-   Date Functions
-   Percentage Calculations
-   Business KPI Analysis

## 💡 Business Questions Answered

-   Which products and categories generate the most revenue?
-   Which customers contribute the most revenue?
-   Which months perform best?
-   Which employees generate the highest revenue?
-   Which payment methods are most preferred?
-   Which orders have the highest value?
-   How does revenue change month over month?
-   Which products lead their respective categories?

## 📌 Revenue Logic

For completed orders, revenue is calculated as:

**Product Price × Quantity × (1 − Discount)**

Only orders with `order_status = 'Completed'` are considered for
completed-order revenue analysis.

## 🎯 Project Objective

The objective of this project is to demonstrate practical **SQL and data
analysis skills** by transforming relational e-commerce data into
actionable business insights.

## 🚀 Tools Used

-   **MySQL**
-   **SQL**
-   **GitHub**

## 👨‍💻 Author

**Ansh Yadav**

BCA Graduate \| Aspiring Data Analyst
