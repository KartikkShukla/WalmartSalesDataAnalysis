
CREATE DATABASE IF NOT EXISTS walmartSales;


CREATE TABLE IF NOT EXISTS sales(
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT NOT NULL,
    gross_income DECIMAL(12, 4),
    rating FLOAT
);
SELECT * FROM walmartsales.sales;
SELECT COUNT(*) FROM sales;

/* ------------------------------------------------------------------------------
-------------------------------FEATURE ENGINEERING-------------------------------
--------------------------------------------------------------------------------*/

-- TIME OF DAY

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

 
 
 ALTER TABLE SALES ADD COLUMN TIME_OF_DAY VARCHAR(20);
 UPDATE  SALES
 SET TIME_OF_DAY=
 ( CASE
WHEN `TIME` BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
WHEN `TIME` BETWEEN "12:00:01" AND "16:00:00" THEN "AFTERNOON"
ELSE "EVENING"
END
 );
 
 
 
 -- DAY NAME
 SELECT 
 DATE,
 DAYNAME(DATE) 
 FROM SALES;
 
  ALTER TABLE SALES ADD COLUMN DAY_NAME VARCHAR(10);
  UPDATE  SALES
 SET DAY_NAME = DAYNAME(DATE) 
;


-- MONTH NAME
SELECT DATE, monthname(DATE) FROM SALES;
ALTER TABLE SALES ADD COLUMN MONTH_NAME VARCHAR(10) ;

UPDATE SALES 
SET MONTH_NAME= MONTHNAME(date);
-- -----------------------------------------------------------------------------------------------------------------


                 /* --------------------------------------
                    ----------GENERIC QUESTIONS-------------
                       -------------------------------------*/
                       
	-- How many unique cities does the data have?
    SELECT  COUNT(DISTINCT CITY) AS COUNT_OF_DISTICT_CITIES FROM SALES;
    -- NAMES OF UNIQUE CITIES
    SELECT DISTINCT CITY FROM SALES;
    -- In which city is each branch?
    SELECT DISTINCT CITY , BRANCH FROM SALES;
    
    
    /* ----------------------------------------------------
    -----------------------PRODUCT-------------------------
    ------------------------------------------------------*/
    -- How many unique product lines does the data have?
    SELECT COUNT(DISTINCT PRODUCT_LINE) FROM SALES;
    
    -- What is the most common payment method?
    SELECT PAYMENT,
    COUNT(PAYMENT) AS TOTAL_COUNT
    FROM SALES
    GROUP BY PAYMENT 
    ORDER BY TOTAL_COUNT DESC
    LIMIT 1;
    
    -- What is the most selling product line?
    SELECT PRODUCT_LINE, COUNT(PRODUCT_LINE) AS TTL
    FROM SALES
    GROUP BY PRODUCT_LINE
    ORDER BY TTL DESC
    LIMIT 1;
    
    -- What is the total revenue by month?
    SELECT SUM(TOTAL) AS TTL, MONTH_NAME AS MONTH
    FROM SALES
    GROUP BY MONTH_NAME 
    ORDER BY TTL;
    
    -- What month had the largest COGS?
    SELECT SUM(COGS) AS TTL , MONTH_NAME AS MONTH
    FROM SALES
    GROUP BY month
    ORDER BY TTL DESC
    LIMIT 1;
    
    -- What product line had the largest revenue?
    SELECT SUM(TOTAL) AS TTL, PRODUCT_LINE
    FROM SALES
    GROUP BY PRODUCT_LINE
    ORDER BY TTL DESC
    LIMIT 1;
    
    -- What is the city with the largest revenue?
    SELECT CITY, SUM(TOTAL) AS REVENUE
    FROM SALES
    GROUP BY CITY
    ORDER BY REVENUE DESC
    LIMIT 1;
    
    -- What product line had the largest VAT?
    SELECT PRODUCT_LINE, AVG(TAX_PCT) AS TAX 
    FROM SALES
    GROUP BY PRODUCT_LINE
    ORDER BY TAX DESC;
    
    
    -- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
    SELECT 
    PRODUCT_LINE AS PL,
    AVG(TOTAL) AS SALE,
    CASE WHEN AVG(TOTAL) > (SELECT AVG(TOTAL) FROM SALES) THEN 'GOOD' ELSE 'BAD' END AS SALESPERFORMANCE
FROM SALES
GROUP BY PL;

 
 -- Which branch sold more products than average product sold?
 SELECT BRANCH,SUM(QUANTITY) AS TOTAL_QUANT
 FROM SALES
 GROUP BY BRANCH
 HAVING SUM(QUANTITY)>(SELECT AVG(QUANTITY));
 
 -- What is the most common product line by gender?
 SELECT PRODUCT_LINE , GENDER, COUNT(GENDER) AS TOTAL_COUNT
 FROM SALES
 GROUP BY GENDER, PRODUCT_LINE
 ORDER BY TOTAL_COUNT;
 
 -- What is the average rating of each product line?
 SELECT ROUND(AVG(RATING),2) AS AVG_RATING, PRODUCT_LINE
 FROM SALES
 GROUP BY PRODUCT_LINE
 ORDER BY AVG_RATING;
 
 
 
 /*--------------------------------------------------
 -------------------------SALES---------------------
 --------------------------------------------------*/
 
 -- Number of sales made in each time of the day per weekday
 SELECT COUNT(*) AS NUM, TIME_OF_DAY
 FROM SALES
 WHERE DAY_NAME='MONDAY'
 GROUP BY TIME_OF_DAY
 ORDER BY NUM;
 
 -- Which of the customer types brings the most revenue?
 SELECT CUSTOMER_TYPE, SUM(TOTAL) AS REVENUE
 FROM SALES
 GROUP BY CUSTOMER_TYPE
 ORDER BY REVENUE DESC
 LIMIT 1;
 
 -- Which city has the largest tax percent/ VAT (Value Added Tax)?
 SELECT CITY, SUM(TAX_PCT) AS TOTAL_TAX
 FROM SALES
 GROUP BY CITY
 ORDER BY TOTAL_TAX;
   
  -- Which customer type pays the most in VAT?
  SELECT CUSTOMER_TYPE, AVG(TAX_PCT) AS AVGTAX
  FROM SALES
  GROUP BY CUSTOMER_TYPE
  ORDER BY AVGTAX;
  
  
  
  /*---------------------------------------------
  -------------------CUSTOMER---------------------
  -------------------------------------------------*/
  -- How many unique customer types does the data have?
  SELECT COUNT(DISTINCT(CUSTOMER_TYPE)) AS 'UNIQUE' FROM SALES;
  
  -- How many unique payment methods does the data have?
  SELECT COUNT(DISTINCT(PAYMENT)) AS PAYMENT_METHOD_NUMBER FROM SALES;


-- What is the most common customer type?
SELECT COUNT(CUSTOMER_TYPE)AS CT, CUSTOMER_TYPE
FROM SALES
GROUP BY CUSTOMER_TYPE
ORDER BY  CT ;

-- Which customer type buys the most?
SELECT CUSTOMER_TYPE, SUM(QUANTITY) AS TOTAL
FROM SALES
GROUP BY CUSTOMER_TYPE
ORDER BY TOTAL;
-- What is the gender of most of the customers?
SELECT GENDER, COUNT(GENDER) AS 'COUNT'
FROM SALES
GROUP BY GENDER
ORDER BY COUNT DESC
LIMIT 1;

-- What is the gender distribution per branch?
SELECT BRANCH, GENDER, COUNT(*) AS DISTRIBUTION
FROM SALES
GROUP BY BRANCH, GENDER
ORDER BY DISTRIBUTION;

-- Which time of the day do customers give most ratings?
SELECT TIME_OF_DAY,AVG(RATING) AS RATING_AVG
FROM SALES
GROUP BY TIME_OF_DAY
ORDER BY RATING_AVG DESC
LIMIT 1;


-- Which time of the day do customers give most ratings per branch?
SELECT BRANCH, TIME_OF_DAY, COUNT(*) AS RATING_COUNT
FROM SALES
GROUP BY BRANCH, TIME_OF_DAY
ORDER BY BRANCH, RATING_COUNT DESC;


-- Which day for the week has the best avg ratings?
SELECT DAY_NAME,AVG(RATING) AS AVG_RATING 
FROM SALES
GROUP BY DAY_NAME
ORDER BY AVG_RATING DESC
LIMIT 1;

-- Which day of the week has the best average ratings per branch?
SELECT DAY_NAME,AVG(RATING) AS AVG_RATING 
FROM SALES
WHERE BRANCH="A"
GROUP BY DAY_NAME
ORDER BY AVG_RATING DESC;