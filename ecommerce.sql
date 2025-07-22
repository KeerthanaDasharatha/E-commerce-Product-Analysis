create database e_commerce;
use e_commerce;

select * from ecommerce;


-- 1 What is the total revenue generated from each sales platform
select platform,
sum(Final_Amount) as Total_revenue from ecommerce
group by platform;

-- 2 Which product category has the highest average customer review rating?
select Product_Category,
avg(Review_Rating) as avg_rating  from ecommerce
group by Product_Category
order by avg_rating desc;

-- 3 Who are the top 5 customers based on their total purchase value?
select Customer_ID,
sum(Final_Amount) as total_revenue from ecommerce
group by Customer_ID
order by total_revenue desc
limit 5;

-- 4 For each product category, what is the average discount given, total number of items sold, total number of returns,
--  and the return rate percentage?
select Product_Category,
avg(Discount_Percent) avg_discount, 
count(*) as items_sold,
sum(Return_Flag) as total_returns, 
ROUND(SUM(Return_Flag) * 100.0 / COUNT(*), 2) AS return_rate_percent from ecommerce
group by Product_Category
ORDER BY return_rate_percent DESC;



-- 5 What is the percentage of orders returned by male vs. female customers?
SELECT 
    Gender,
    COUNT(*) AS total_orders,
    SUM(Return_Flag) AS total_returns,
    ROUND(SUM(Return_Flag) * 100.0 / COUNT(*), 2) AS return_percentage
FROM ecommerce
GROUP BY Gender;

-- 6 Total discount and coupon usage
SELECT 
    Product_Name,
    COUNT(*) AS total_orders,
    SUM(Coupon_Used) AS coupon_uses,
    SUM(Discount_Amount) AS total_discount
FROM ecommerce
GROUP BY Product_Name
ORDER BY coupon_uses DESC;


-- 7 What is the average final amount spent by customers grouped by age group (e.g., 18–25, 26–35, etc.)?
SELECT 
  CASE 
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age BETWEEN 46 AND 55 THEN '46-55'
    WHEN Age BETWEEN 56 AND 65 THEN '56-65'
    ELSE '65+'
  END AS Age_Group,
  AVG(Final_Amount) AS Avg_Spent
FROM ecommerce
GROUP BY Age_Group
ORDER BY Age_Group;

-- 8 How many orders has each customer placed, how many times have they used coupons, and what is their total spending?
SELECT 
    Customer_ID,
    COUNT(*) AS total_orders,
    SUM(Coupon_Used) AS coupon_used_count,
	SUM(Final_Amount) AS total_spent
FROM ecommerce
GROUP BY Customer_ID;


-- 9 Which are the top-selling products by quantity within each product category
SELECT 
    Product_Category,
    Product_Name,
    SUM(Quantity) AS total_quantity,
    RANK() OVER (PARTITION BY Product_Category ORDER BY SUM(Quantity) DESC) AS product_rank
FROM ecommerce
GROUP BY Product_Category, Product_Name;

-- 10 Who are the top 2 highest revenue-generating customers on each platform
WITH RevenueRank AS (
    SELECT 
        Platform,
        Customer_ID,
        SUM(Final_Amount) AS total_revenue,
        RANK() OVER (PARTITION BY Platform ORDER BY SUM(Final_Amount) DESC) AS revenue_rank
    FROM ecommerce
    GROUP BY Platform, Customer_ID
)
SELECT *
FROM RevenueRank
WHERE revenue_rank <= 2;


-- 11 What is the average quantity sold per product category (only those with more than 2 units on average)?
WITH AvgQty AS (
    SELECT Product_Category, AVG(Quantity) AS avg_quantity
    FROM ecommerce
    GROUP BY Product_Category
)
SELECT *
FROM AvgQty
WHERE avg_quantity > 2;

-- 12  Who are the top 3 customers by total spending in each location?
WITH LocationRank AS (
    SELECT Location, Customer_ID,
           SUM(Final_Amount) AS total_spent,
           RANK() OVER (PARTITION BY Location ORDER BY SUM(Final_Amount) DESC) AS rank_in_location
    FROM ecommerce
    GROUP BY Location, Customer_ID
)
SELECT *
FROM LocationRank
WHERE rank_in_location <= 3;

-- 13 What is the total number of orders and revenue for the given order date?"
SELECT Order_Date,
       COUNT(Order_ID) AS total_orders,
       SUM(Final_Amount) AS total_sales
FROM ecommerce
GROUP BY Order_Date
ORDER BY Order_Date;


-- 14  Which products have the highest unit price
SELECT Product_ID, Product_Name, MAX(Unit_Price) AS max_price
FROM ecommerce
GROUP BY Product_ID, Product_Name
ORDER BY max_price DESC
LIMIT 5;

-- 15  How many orders are delivered vs. pending vs. cancelled
SELECT Shipment_Status, COUNT(*) AS total_orders
FROM ecommerce
GROUP BY Shipment_Status;

-- 16  What's the average discount (%) applied across all orders
SELECT 
  ROUND(AVG(Discount_Amount / Total_Price) * 100, 2) AS avg_discount_percent
FROM ecommerce
WHERE Total_Price > 0;

-- 17 Identify orders with high quantity and high value
SELECT Order_ID, Customer_ID, Quantity, Final_Amount
FROM ecommerce
WHERE Quantity >= 5 AND Final_Amount >= 500
ORDER BY Final_Amount DESC;

-- 18 Show day‑wise total orders and revenue with date
SELECT 
    DATE_FORMAT(order_date, '%d-%m-%Y') AS date,
    COUNT(order_id) AS total_orders,
    SUM(Final_Amount) AS total_revenue
FROM ecommerce
GROUP BY DATE_FORMAT(order_date, '%d-%m-%Y'), YEAR(order_date)
ORDER BY STR_TO_DATE(date, '%d-%m-%Y') DESC;


--  19 total earnings (revenue) for each year
SELECT 
    YEAR(order_date) AS year,
    SUM(Final_Amount) AS total_earnings
FROM ecommerce
GROUP BY YEAR(order_date)
ORDER BY total_earnings DESC;

-- 20 busiest time of day (hour-wise)
SELECT 
    HOUR(order_time) AS hour_of_day,
    COUNT(order_id) AS total_orders,
    SUM(Final_Amount) AS total_revenue
FROM ecommerce
GROUP BY HOUR(order_time)
ORDER BY total_orders DESC;
