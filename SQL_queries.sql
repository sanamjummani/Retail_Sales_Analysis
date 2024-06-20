CREATE DATABASE wallmart; 
CREATE TABLE sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(10) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    vat FLOAT(6 , 4 ) NOT NULL,
    total DECIMAL(10 , 2 ) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin FLOAT(11 , 9 ) NOT NULL,
    gross_income DECIMAL(10 , 2 ) NOT NULL,
    rating FLOAT(2 , 1 ) NOT NULL
);
SELECT * FROM sales; 

-- FEATURE ENGINEERING- ADDING NEW COLUMNS --

-- ADD time_of_day COLUMN: 
SELECT 
    time,
    (CASE
        WHEN time BETWEEN '00:00:00' AND '05:00:00' THEN 'Midnight'
        WHEN time BETWEEN '05:01:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE "Evening"
	END
	) AS time_of_day
FROM
    sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(30);
SELECT * FROM sales;
UPDATE sales 
SET 
    time_of_day = (CASE
        WHEN time BETWEEN '00:00:00' AND '05:00:00' THEN 'Midnight'
        WHEN time BETWEEN '05:01:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);

-- ADD day_name COLUMN: 
SELECT date, DAYNAME(date) AS day_name FROM sales; 
ALTER TABLE sales ADD COLUMN day_name VARCHAR(50) NOT NULL;
SELECT * FROM sales;
UPDATE sales SET day_name = DAYNAME(date);

-- ADD month_name COLUMN: 
SELECT date, MONTHNAME(date) FROM sales; 
ALTER TABLE sales ADD COLUMN month_name VARCHAR(50);
SELECT * FROM sales; 
UPDATE sales SET month_name = MONTHNAME(date); 

-- -- ADD season_name COLUMN: 
SELECT 
    month_name,
    (CASE
        WHEN month_name BETWEEN 'March' AND 'May' THEN 'Spring'
        WHEN month_name BETWEEN 'June' AND 'August' THEN 'Summer'
        WHEN month_name BETWEEN 'September' AND 'November' THEN 'Autumn'
        ELSE 'Winter'
    END) AS season_name
FROM
    sales;
ALTER TABLE sales ADD COLUMN season_name VARCHAR(50);
SELECT * FROM sales; 
UPDATE sales SET season_name = (case 
						when month_name between "March" and "May" then "Spring"
						when month_name between "June" and "August" then "Summer"
                        when month_name between "September" and "November" then "Autumn"
                        else "Winter" 
					end
				    ); 
                    

-- EDA
-- GENERIC BUSINESS QUESTIONS: 
-- 1) How many unique cities does the data have?
SELECT DISTINCT city FROM sales; 

-- 2) In which city is each branch?
SELECT DISTINCT branch, city FROM sales; 

-- PRODUCT RELATED QUESTIONS: 
-- 1) How many unique product lines does the data have?
SELECT DISTINCT product_line FROM sales; 
SELECT * FROM sales; 

-- 2) What is the most common payment method?
SELECT 
    payment_method,
    COUNT(payment_method) AS count_payment_method
FROM
    sales
GROUP BY payment_method
ORDER BY count_payment_method DESC;

-- 3) What is the most selling product line?
SELECT 
    product_line, SUM(quantity) AS qty, SUM(total) AS revenue
FROM
    sales
GROUP BY product_line
ORDER BY qty DESC; 

-- 4) What is the total revenue by month?
SELECT 
    month_name, SUM(total) AS total_revenue
FROM
    sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- 5) What month had the largest COGS?
SELECT 
    month_name, SUM(cogs) AS total_cogs
FROM
    sales
GROUP BY month_name
ORDER BY total_cogs DESC; 

-- 6) What product line had the largest revenue?
SELECT 
    product_line, SUM(total) AS revenue
FROM
    sales
GROUP BY product_line
ORDER BY revenue DESC; 

-- 7) What is the city with the largest revenue?
SELECT 
    branch, city, SUM(total) AS revenue
FROM
    sales
GROUP BY branch , city
ORDER BY revenue DESC; 

-- 8) What product line had the largest VAT?
SELECT 
    product_line, AVG(vat) AS avg_vat
FROM
    sales
GROUP BY product_line
ORDER BY avg_vat DESC; 

-- 9) Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales. 
SELECT 
    product_line, SUM(total) AS total_sales
FROM
    sales
GROUP BY product_line;
SELECT 
    AVG(total_sales) AS total_avg_productline
FROM
    (SELECT 
        product_line, SUM(total) AS total_sales
    FROM
        sales
    GROUP BY product_line) A;
SELECT 
    product_line,
    total_sales,
    (CASE
        WHEN
            total_sales > (SELECT 
                    AVG(total_sales) AS total_avg_productline
                FROM
                    (SELECT 
                        product_line, SUM(total) AS total_sales
                    FROM
                        sales
                    GROUP BY product_line) A)
        THEN
            'Good'
        ELSE 'Bad'
    END) AS sales_status
FROM
    (SELECT 
        product_line, SUM(total) AS total_sales
    FROM
        sales
    GROUP BY product_line) B;

-- 10) Which branch sold more products than average product sold?
SELECT 
    branch, SUM(quantity) AS branch_qty
FROM
    sales
GROUP BY branch;-- SHOWING TOTAL BRANCH QTY 
SELECT 
    AVG(branch_qty) AS avg_branch_qty
FROM
    (SELECT 
        branch, SUM(quantity) AS branch_qty
    FROM
        sales
    GROUP BY branch) AS B;-- SHOWING AVERGAE QTY BRANCHWISE
SELECT 
    branch, branch_qty
FROM
    (SELECT 
        branch, SUM(quantity) AS branch_qty
    FROM
        sales
    GROUP BY branch) AS A
WHERE
    branch_qty > (SELECT 
            AVG(branch_qty)
        FROM
            (SELECT 
                branch, SUM(quantity) AS branch_qty
            FROM
                sales
            GROUP BY branch) AS B)
GROUP BY branch; 

-- 11) What is the most common product line by gender?
SELECT 
    gender, product_line, SUM(quantity) AS total_qty_sales
FROM
    sales
GROUP BY gender , product_line
ORDER BY total_qty_sales DESC; 

-- 12) What is the average rating of each product line?
SELECT 
    product_line, ROUND(AVG(rating), 2) AS avg_rating
FROM
    sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- 13) Top 10 Best-Selling Products by Quantity? 
SELECT 
    product_line, SUM(quantity) AS total_qty
FROM
    sales
GROUP BY product_line
ORDER BY total_qty DESC
LIMIT 10;

-- 14) Top 3 Product Lines Generating the Most Revenue? 
SELECT 
    product_line, SUM(total) AS total_revenue
FROM
    sales
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 3; 

-- 15) Average Price of Products Sold in Each Product Line?
SELECT 
    product_line, ROUND(AVG(unit_price), 2) AS avg_price
FROM
    sales
GROUP BY product_line
ORDER BY avg_price DESC;

-- 16) Top 3 Product Lines with Highest Gross Margin?
SELECT 
    *
FROM
    sales;
SELECT 
    product_line, ROUND(AVG(gross_margin), 2) AS avg_margin
FROM
    sales
GROUP BY product_line
ORDER BY avg_margin DESC
LIMIT 3; 

-- 17) Monthly Sales Trends for Each Product Line? 
SELECT 
    MONTH(date) AS month,
    month_name,
    product_line,
    SUM(total) AS total_sales
FROM
    sales
GROUP BY month , month_name , product_line
ORDER BY month , product_line , month_name; 

-- Sales-Related Questions: 
-- 1) Peak sales in each time of the day per weekday? 
SELECT 
    day_name, time_of_day, COUNT(*) AS total_orders
FROM
    sales
GROUP BY day_name , time_of_day
ORDER BY total_orders DESC; 

-- 2) Which of the customer types brings the most revenue?
SELECT 
    customer_type, SUM(total) AS revenue
FROM
    sales
GROUP BY customer_type
ORDER BY revenue DESC; 

-- 3) Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
    city, ROUND(AVG(vat), 2) AS avg_vat
FROM
    sales
GROUP BY city
ORDER BY avg_vat DESC;

-- 4) Which customer type pays the most in VAT?
SELECT 
    customer_type, ROUND(AVG(vat), 2) AS avg_vat
FROM
    sales
GROUP BY customer_type
ORDER BY avg_vat DESC;

-- 5) Total Sales Revenue for Each Month?
SELECT 
    month_name, SUM(total) AS revenue
FROM
    sales
GROUP BY month_name
ORDER BY revenue DESC; 

-- 6) Branches with the Highest Sales Revenue?
SELECT 
    branch, SUM(total) AS total_revenue
FROM
    sales
GROUP BY branch
ORDER BY total_revenue DESC;

-- 7) Peak Sales Hours Each Day?
 SELECT EXTRACT(HOUR FROM time) AS hour, SUM(total) AS total_sales
FROM sales
GROUP BY hour
ORDER BY total_sales DESC;

-- 8) Average Order Value?
SELECT 
    ROUND(AVG(total), 2) AS avg_order_value
FROM
    sales; 

-- Customer-Related Questions:
-- 1) How many unique customer types does the data have?
SELECT DISTINCT
    customer_type
FROM
    sales;
    
-- 2) How many unique payment methods does the data have?
SELECT DISTINCT
    payment_method
FROM
    sales;
    
-- 3) What is the most common customer type?
SELECT 
    customer_type, COUNT(*) AS total
FROM
    sales
GROUP BY customer_type
ORDER BY total DESC; 

-- 4) Which customer type buys the most?
SELECT 
    customer_type, SUM(quantity) AS qty
FROM
    sales
GROUP BY customer_type
ORDER BY qty DESC;

-- 5) What is the gender of most of the customers?
SELECT 
    gender, COUNT(*) AS total_orders
FROM
    sales
GROUP BY gender;

-- 6) What is the gender distribution per branch?
SELECT 
    branch, gender, COUNT(*) AS total_orders
FROM
    sales
GROUP BY branch , gender
ORDER BY branch , gender;

-- 7) Which time of the day do customers give most ratings?
SELECT 
    time_of_day, ROUND(AVG(rating), 2) AS avg_ratings
FROM
    sales
GROUP BY time_of_day
ORDER BY avg_ratings DESC; 

-- 8) Which time of the day do customers give most ratings per branch?
SELECT 
    branch, time_of_day, ROUND(AVG(rating), 2) AS avg_ratings
FROM
    sales
GROUP BY branch , time_of_day
ORDER BY avg_ratings DESC; 

-- 9) Which top 3 days for the week has the best avg ratings?
SELECT 
    day_name, ROUND(AVG(rating), 2) AS avg_ratings
FROM
    sales
GROUP BY day_name
ORDER BY avg_ratings DESC
LIMIT 3;

-- 10) Which is the top day of the week that has the best average ratings per branch?
SELECT 
    branch, day_name, ROUND(AVG(rating), 2) AS avg_ratings
FROM
    sales
GROUP BY branch , day_name
ORDER BY avg_ratings DESC , branch ASC , day_name ASC
LIMIT 3; 

-- 11) Top 10 Customers by Total Spend?
-- ASSUMING HERE EACH INVOICE IS A DIFFERENT CUSTOMER SINCE NO CUSTOMER_ID COLUMN IS MENTIONED HERE TO SPECIFY. 
SELECT 
    invoice_id, SUM(total) AS total_spend
FROM
    sales
GROUP BY invoice_id
ORDER BY total_spend DESC limit 10; 

-- 12) Most Common Customer Types for High-Value Purchases?
select distinct unit_price from sales order by unit_price desc limit 5;
-- HERE WE CAN PICK HIGH VALUE THRESHOLD AS 99 USD THEN! 
SELECT 
    customer_type, COUNT(*) AS high_val_purchases
FROM
    sales
WHERE
    unit_price >= 99
GROUP BY customer_type
ORDER BY high_val_purchases DESC; 

-- 13) Customer Repeat Purchase Frequency? 
-- ASSUMING IN THIS CASE EACH INVOICE IS A SEPARATE CUSTOMER- IN THIS EXAMPLE IT WONT MAKE SENSE AS INVOICE ID COLUMN IS UNIQUE PRIMARY KEY
-- HOWEVER I HAVE JUST DEMONSTRATED BELOW HOW TO DO IT INCASE WE HAD A "CUSTOMER_ID" COLUMN. 
SELECT customer_id, COUNT(*) AS purchase_count
FROM sales
GROUP BY customer_id
HAVING COUNT(*) > 0
ORDER BY purchase_count DESC;

-- 14) Average Customer-type Lifetime Value?
SELECT 
    customer_type, ROUND(AVG(total), 2) AS avg_order_amount
FROM
    sales
GROUP BY customer_type
ORDER BY avg_order_amount DESC; 

-- 15) Product Lines Preferred by Different Customer Types?
SELECT 
    customer_type,
    product_line,
    COUNT(quantity) AS total_cat_orderqty
FROM
    sales
GROUP BY customer_type , product_line
ORDER BY customer_type , total_cat_orderqty DESC , product_line; 

-- Unique Generic Business Questions: 
-- 1) Impact of Payment Method on Sales? 
SELECT 
    payment_method,
    COUNT(*) AS total_orders,
    SUM(total) AS total_sales
FROM
    sales
GROUP BY payment_method
ORDER BY total_orders DESC , total_sales DESC; 

-- 2) Correlation Between Gross Margin and Product Rating?
SELECT 
    product_line,
    ROUND(AVG(gross_margin), 2) AS avg_margin,
    ROUND(AVG(rating), 2) AS avg_rating
FROM
    sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- 3) Sales Distribution Across Cities?
SELECT city, COUNT(*) AS transaction_count, SUM(total) AS total_sales
FROM sales
GROUP BY city
ORDER BY total_sales DESC;

-- 4) Effect of Weekends on Sales?
SELECT 
    (CASE
        WHEN day_name = 'Saturday' OR 'Sunday' THEN 'Weekend'
        ELSE 'Weekday'
    END) AS day_type,
    SUM(total) AS total_sales
FROM
    sales
GROUP BY day_type
ORDER BY total_sales DESC;

-- 5) Customer Feedback Impact on Gross Income?
SELECT 
    rating, ROUND(AVG(gross_income), 2) AS avg_income
FROM
    sales
GROUP BY rating
ORDER BY rating DESC; 

-- ---------------------------- END ----------------------------------------------------------

 










