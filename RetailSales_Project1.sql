-------------------------------------------------------------------------------
-- Project: Retail Sales Data Analysis
-- Author: Karanam Roja
-- Date: 19/10/2026
-- Description: Core queries executing business logic on the Kaggle Retail dataset.
--              Covers data definition, retrieval, aggregation, joins, and subqueries.
-- Data Source: https://github.com/rojakaranam1996-gif/retail-sales-sql-analysis/blob/main/retail_sales_dataset.csv
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Phase 1: Data Definition (The Setup)
-- Creating the core 'retailsales' table to house the imported Kaggle dataset.
-- transactionID is set as the Primary Key to uniquely identify each sale.
-- Data types reflect the integer-based currency values in the source file.
-------------------------------------------------------------------------------

CREATE TABLE retailsales (
    transactionID BIGSERIAL PRIMARY KEY,
    transaction_date DATE,
    customerID INTEGER,
    gender CHAR(6),
    age INTEGER,
    productcategory VARCHAR(200),
    Quantity INTEGER,
    priceperunit INTEGER,
    totalamount INTEGER
);
-- Importing the Kaggle CSV dataset into the newly created retailsales table
COPY retailsales
FROM 'C:\SQL Data\retail_sales_dataset.csv'
WITH (FORMAT CSV, HEADER);

-- Phase 2, Question 1: Retrieving the 20 most recent transactions to review latest activity
SELECT * 
FROM retailsales
ORDER BY transaction_date DESC
LIMIT 20;

-- Phase 2, Question 2: Identifying high-value, single-item purchases
SELECT 
    transactionid, 
    quantity, 
    totalamount 
FROM retailsales
WHERE quantity = 1 AND totalamount > 100;

-- Phase 2, Question 3: Filtering for specific product categories using partial text matching
SELECT 
    transactionid, 
    productcategory, 
    totalamount 
FROM retailsales
WHERE productcategory LIKE '%Shirt%' 
   OR productcategory LIKE '%Electronics%';

-- Phase 3, Question 4: Aggregating total revenue and quantity sold by product category
SELECT 
    productcategory, 
    SUM(totalamount) AS totalrevenue,
    SUM(quantity) AS totalquantity 
FROM retailsales
GROUP BY productcategory;

-- Phase 3, Question 5: Identifying high-traffic days with more than 10 transactions
SELECT 
    transaction_date, 
    COUNT(transactionid) AS totaltransactions 
FROM retailsales
GROUP BY transaction_date
HAVING COUNT(transactionid) > 10;

-- Phase 4, Question 6: Retrieving transactions that are higher than the overall average
SELECT 
    transactionid, 
    totalamount 
FROM retailsales
WHERE totalamount > (SELECT AVG(totalamount) FROM retailsales);
