CREATE DATABASE sql_project_2;

CREATE TABLE retail_sales 
			( 
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,	
				sale_time TIME,	
				customer_id INT,	
				gender	VARCHAR(15),
				age	INT,
				category VARCHAR(15),	
				quantity	INT,
				price_per_unit FLOAT,	
				cogs FLOAT,
				total_sale FLOAT
			);
SELECT * FROM retail_sales
SELECT COUNT(*) FROM retail_sales

-- DATA Cleaning

SELECT * FROM retail_sales
WHERE 
transactions_id IS NULL
OR 
sale_date IS NULL	
OR
sale_time IS NULL	
OR
customer_id IS NULL	
OR
gender IS NULL
OR
category IS NULL	
OR
quantiy	IS NULL
OR 
price_per_unit IS NULL	
OR
cogs IS NULL
OR
total_sale IS NULL
;

DELETE FROM retail_sales
WHERE 
transactions_id IS NULL
OR 
sale_date IS NULL	
OR
sale_time IS NULL	
OR
customer_id IS NULL	
OR
gender IS NULL
OR
category IS NULL	
OR
quantiy	IS NULL
OR 
price_per_unit IS NULL	
OR
cogs IS NULL
OR
total_sale IS NULL
;

-- DATA exploration
-- How many sales we have
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many unique customers we have
SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales

-- How many categories do we have
SELECT DISTINCT category FROM retail_sales

-- DATA analysis & Business Key problems
-- Q1. Write a sql query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Q2. Write a SQL query to retreive all transactions where the category is clothing and the quantity sold is 
-- more than 10 in the month of Nov-2022
SELECT * FROM retail_sales
where 
	category = 'Clothing'
	AND 
	quantity >= 2
	AND 
	to_char(sale_date, 'YYYY-MM') = '2022-11'

-- 	Q3. Write a sql query to calculate the total sales (total_sale) for each category
SELECT 
	category,
	SUM(total_sale) as net_sale
FROM retail_sales
GROUP BY category


-- Q4. Write a sql query to find the average age of customers who purchased items from the "Beauty" category.
SELECT ROUND(AVG(age),2) FROM retail_sales
WHERE category = 'Beauty'

--Q5. Write a sql query to find all the transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000

--Q5. Write a sql query to find out the total number transactions made by each gender in each category
SELECT 
	category, 
	gender,
COUNT(*) as total_transactions FROM retail_sales
GROUP BY category, gender
ORDER BY category

-- Q7. Write a sql query to calculate the average sale for each month. Find out best selling month in each 
-- year
SELECT 
	year,
	month,
	avg_sale
FROM 
(	SELECT 
		EXTRACT (YEAR FROM sale_date) as year,
		EXTRACT (MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY year, month
) as t1
WHERE rank = 1

-- Q8. 	Write a sql query to find the top 5 customers based on the highest total sales
SELECT 
	customer_id, 
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5

-- Q9. Write a sql query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id) as count_of_customers
	FROM retail_sales
GROUP BY category

-- Q10. Write a sql query to create each shift and number of orders (Example Morning<12, Afternoon between 12 to 17, Evening > 17)
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)  < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

-- END OF PROJECT

	