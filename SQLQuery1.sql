/*Data Source: The data was taken from the PricePaid dataset (2022)
available on the gov.uk website */ 

-- Display Data 
SELECT *
FROM [dbo].[price_sold]

 -- I note that the column called 'city' includes towns. Changed column name from city to city_or_town
 USE PortfolioProjectProperty
 EXEC sp_rename 'price_sold.city',
 'city_or_town'

-- Checking for null values within each field. 
SELECT * 
FROM [dbo].[price_sold]
WHERE unique_id IS NULL OR price_paid IS NULL OR deed_date IS NULL 
OR postcode IS NULL OR property_type IS NULL OR new_build IS NULL OR estate_type IS NULL
OR city_or_town IS NULL

-- NULL values were only present in the postcode field

-- Verified that all fields were the correct data type 

-- Query Data 

-- Query 1: What are the top 25 cities with the highest average price paid in 2022?

SELECT TOP 25 AVG(price_paid) AS average_price, city_or_town
FROM [dbo].[price_sold]
GROUP BY city_or_town 
ORDER BY average_price DESC

-- Query 2: How many properties were sold in London (year = 2022)?

SELECT COUNT(city_or_town) AS number_sold, city_or_town
FROM [dbo].[price_sold]
GROUP BY city_or_town 
HAVING LOWER(city_or_town) = 'london'


-- Query 3: Can you create a list of all the properties that were sold for less than or equal to £200k in 2022?
SELECT *
FROM [dbo].[price_sold]
WHERE price_paid <= 200000
ORDER BY price_paid


-- Query 4: Update records to show what property type means

-- Firstly, isolate all distinct values within the property type field to see how many records need changing
SELECT DISTINCT property_type
FROM [dbo].[price_sold]

--Changing records in property_type column to be more readable
UPDATE [dbo].[price_sold]
SET property_type = 'Semi-Detached'
WHERE property_type = 'S';

UPDATE [dbo].[price_sold]
SET property_type = 'Detached'
WHERE property_type = 'D';

UPDATE [dbo].[price_sold]
SET property_type = 'Terrace'
WHERE property_type = 'T';

UPDATE [dbo].[price_sold]
SET property_type = 'Flat'
WHERE property_type = 'F';

UPDATE [dbo].[price_sold]
SET property_type = 'Other'
WHERE property_type = 'O';

--Query 5:what is the Lowest and highest price for each property type?

SELECT MIN(price_paid) AS lowest_price,MAX(price_paid) AS highest_price, property_type
FROM [dbo].[price_sold]
GROUP BY property_type 

--Query 6: What is the average price paid by quarter?

-- First I created a view and added a column to sort the dates into quarter
CREATE VIEW price_sold_view 
AS 
SELECT *,
CASE WHEN deed_date BETWEEN '2022-01-01' AND '2022-03-31' THEN '1'
WHEN deed_date BETWEEN '2022-04-01' AND '2022-06-30' THEN '2'
WHEN deed_date BETWEEN '2022-07-01' AND '2022-09-30' THEN '3'
WHEN deed_date BETWEEN '2022-10-01' AND '2022-12-31' THEN '4'
ELSE 0
END AS quarter
FROM [dbo].[price_sold]

-- Used view and new column added to group data by quarter and aggregate
SELECT AVG(price_paid) AS average_price_paid, quarter
FROM price_sold_view 
GROUP BY quarter
ORDER BY quarter ASC
