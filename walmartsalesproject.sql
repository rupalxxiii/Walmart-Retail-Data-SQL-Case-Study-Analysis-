-- Create the database if it does not exist
CREATE DATABASE IF NOT EXISTS WalmartSales;

-- Use DataBase
USE WalmartSales;

-- Select all records from the Sales table to verify the data load
SELECT * FROM Sales;


-- update time column datatype text to time
Alter table Sales
Modify column Time TIME;

Alter table Sales
Modify column Date DATE;
 
-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;    

ALTER TABLE Sales ADD COLUMN Time_of_day varchar(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server

UPDATE sales
SET time_of_day = (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END);
       
-- Add day_name column

SELECT
      date,
      DAYNAME(date)
from sales;      
SELECT * FROM Sales;

ALTER TABLE Sales ADD COLUMN day_name varchar(12);

UPDATE Sales
SET day_name = DAYNAME(date);

-- Add month_name column

SELECT
      date,
      MONTHNAME(date)
from sales; 

ALTER TABLE Sales ADD COLUMN month_name varchar(12);

UPDATE Sales
SET month_name = MONTHNAME(date);

SELECT * FROM Sales;

----------------------------------------- Generic ---------------------------------------------------

-- How many unique cities does the data have?

SELECT 
      DISTINCT city
from sales;      

-- In which city is each branch?

SELECT 
	DISTINCT city,
    branch
FROM Sales;

---------------------------------------------- Product -----------------------------------------------
select * from Sales;

-- How many unique product lines does the data have?

SELECT
      COUNT(DISTINCT 'Product line')
FROM Sales; 

-- What is the most selling product line    

SELECT 
      SUM(quantity) AS qty,
      'Product line'
FROM Sales  
GROUP BY 'Product line'
ORDER BY qty DESC;    

-- What is the total revenue by month

SELECT
      sum(total) as total_revenue,
      month_name as month
FROM Sales      
GROUP BY month
ORDER BY total_revenue DESC;      

-- What month had the largest COGS?

SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs;

-- What product line had the largest revenue?

SELECT
	'Product line',
	SUM(total) as total_revenue
FROM sales
GROUP BY 'Product line'
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?

SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;

-- What product line had the largest TAX?
SELECT
	'Product line',
	AVG('tax 5%' ) as avg_tax
FROM sales
GROUP BY 'Product line'
ORDER BY avg_tax DESC;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT
      AVG(quantity) as avg_qnty
FROM Sales;    

SELECT
      'Product line',
      case
           when AVG(quantity) > 5.5100 then "Good"
           else "Bad"
      end as remark   
from Sales     
group by 'Product line'; 
        
-- Which branch sold more products than average product sold?

SELECT 
    branch,
    SUM(quantity) AS qty
FROM Sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) AS avg_quantity FROM Sales);
      
-- What is the most common product line by gender

SELECT
	gender,
    'Product line',
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, 'Product line'
ORDER BY total_cnt DESC;

-- What is the average rating of each product line

SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    'Product line'
FROM sales
GROUP BY 'Product line'
ORDER BY avg_rating DESC;


------------------------------------------- Customers -------------------------------------------------


-- How many unique customer types does the data have?
SELECT
	DISTINCT 'Customer type'
FROM sales;

-- How many unique payment methods does the data have?
SELECT 
      DISTINCT payment
FROM Sales;    

-- What is the most common customer type?
SELECT
	'Customer type',
	count(*) as count
FROM sales
GROUP BY 'Customer type'
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	'Customer type',
    COUNT(*)
FROM sales
GROUP BY 'Customer type';

-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter

-- Which time of the day do customers give most ratings per branch?
SELECT
    time_of_day,
    branch,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch IN ("A", "B", "C")
GROUP BY time_of_day, branch
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.

-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?

-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
    branch,
	COUNT(day_name) total_sales
FROM sales
WHERE branch in ("A","B","C")
GROUP BY day_name, branch
ORDER BY total_sales DESC;

--------------------------------------------------- Sales ------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
	'Customer type',
	SUM(total) AS total_revenue
FROM sales
GROUP BY 'Customer type'
ORDER BY total_revenue;


-- Which city has the largest tax/VAT percent?
SELECT
	City,
    ROUND(AVG('Tax 5%'), 2) AS avg_tax_pct
FROM sales
GROUP BY City 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	'Customer type',
	AVG('Tax 5%') AS total_tax
FROM sales
GROUP BY 'Customer type'
ORDER by total_tax;

------------------------------------------------------------------------------------------------------------------------



