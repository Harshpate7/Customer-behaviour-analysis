SELECT * FROM purchases

-- Data Cleaning
-- Total Null Values 

SELECT 
	count(CASE WHEN age is null then 1 end) age_null_count,
	count(CASE WHEN gender is null then 1 end) gender_null_count,
	count(CASE WHEN country is null then 1 end) country_null_count,
	count(CASE WHEN purchaseamount is null then 1 end) purchaseamount_null_count,
	count(CASE WHEN purchasedate is null then 1 end) purchasedate_null_count,
	count(CASE WHEN productcategory is null then 1 end) productcategory_null_count	
FROM purchases;

-- DELETING NULL VALUES WILL REDUCE THE DATA BY 35% 
-- DROPING NULL VALUES OF AGE AND PURCHASEDATE

DELETE FROM purchases
WHEN 
	age IS NULL OR
	purchasedate IS NULL;

-- TAKING AVERAGE OF PURCHASE TO REPLACE NULL VALUES 
-- WHILE REPLACING OTHER WITH "UNKNOWN" 

UPDATE purchases 
SET Purchaseamount = CASE WHEN Purchaseamount IS NULL THEN (SELECT AVG(Purchaseamount) FROM purchases WHERE Purchaseamount IS NOT NULL)
						ELSE Purchaseamount
					 END,
gender = CASE WHEN gender IS NULL THEN 'Unknown' ELSE gender END,
country = CASE WHEN country IS NULL THEN 'Unknown' ELSE country END,
productcategory = CASE WHEN productcategory IS NULL THEN 'Unknown' ELSE productcategory END;

--1)

WITH data AS (
    SELECT 
        purchasedate,
        SUM(purchaseamount) AS Purchase_Amount	
    FROM 
        purchases
    GROUP BY 
        purchasedate
    ORDER BY
        purchasedate
)
SELECT
    purchasedate,
    Purchase_Amount,
    ROUND(
        AVG(Purchase_Amount) OVER (
            ORDER BY purchasedate 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 
        2
    ) AS Moving_Avg_7_Days,
	ROUND(
        AVG(Purchase_Amount) OVER (
            ORDER BY purchasedate 
            ROWS BETWEEN 30 PRECEDING AND CURRENT ROW
        ), 
        2
    ) AS Monthly_Moving_avg
FROM 
    data
ORDER BY
    purchasedate;

--2)
SELECT 
	age,
	productcategory,
	sum(purchaseamount) 
FROM 
	purchases
GROUP BY
	productcategory,age
ORDER BY 
	age



--3)

SELECT 
	Country,
	SUM(purchaseamount) AS Total_purchase,
	ROUND(AVG(purchaseamount),2) AS avg_purchase
FROM
	purchases
WHERE country != 'Unknown'
GROUP BY country
ORDER BY Total_purchase desc;

-- 4)
SELECT 
	country,
	productcategory,
	sum(purchaseamount) AS total_purchase
FROM 
	purchases
WHERE country != 'Unknown' and productcategory != 'Unknown'
GROUP BY
	productcategory,country
ORDER BY 
	country ,total_purchase;

--5)
with age_category AS (
SELECT 
	CASE 
		WHEN age BETWEEN 11 AND 20 THEN '11-20'
		WHEN age BETWEEN 21 AND 30 THEN '21-30'
		WHEN age BETWEEN 31 AND 40 THEN '31-40'
		WHEN age BETWEEN 41 AND 50 THEN '41-50'
		WHEN age BETWEEN 51 AND 60 THEN '51-60'
		WHEN age BETWEEN 61 AND 70 THEN '61-70'
		ELSE '71-80'
		END AS age,
	gender,
	country,
	productcategory,
	purchaseamount
From purchases
WHERE
	gender != 'Unknown' and country != 'Unknown')

SELECT 
	age,
	gender,
	country,
	productcategory,
	sum(purchaseamount)
FROM 
	age_category
GROUP BY 
	age,country,productcategory,gender
ORDER BY
	age,country

--6)

WITH data AS (
    SELECT 
        purchasedate,
        COUNT(userid) AS Daily_avg_orders	
    FROM 
        purchases
    GROUP BY 
        purchasedate
    ORDER BY
        purchasedate
),
data2 as (SELECT
    purchasedate,
	Daily_avg_orders,	
    
        SUM(Daily_avg_orders) OVER (
            ORDER BY purchasedate 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        
    ) AS weekly_avg_orders,
	
       	SUM(Daily_avg_orders) OVER (
            ORDER BY purchasedate 
            ROWS BETWEEN 30 PRECEDING AND CURRENT ROW
        
    ) AS monthly_avg_orders
FROM 
    data
ORDER BY
    purchasedate)

SELECT 
	CEIL(avg(daily_avg_orders)) AS daily_avg_orders,
	CEIL(avg(weekly_avg_orders)) AS weekly_avg_orders ,
	CEIL(avg(monthly_avg_orders)) AS monthly_avg_orders
FROM 
	data2

--7)
with Sales AS (SELECT 
     purchasedate,
     SUM(purchaseamount) AS Purchase_Amount	
FROM 
     purchases
GROUP BY 
     purchasedate
ORDER BY
     purchasedate)

SELECT 
	CEIL(SUM(purchase_amount)) AS total_sales,
	CEIL(AVG(purchase_amount)) AS Daily_sales
FROM
	sales;

with age_category AS (
SELECT 
	purchasedate,
	CASE 
		WHEN age BETWEEN 11 AND 20 THEN '11-20'
		WHEN age BETWEEN 21 AND 30 THEN '21-30'
		WHEN age BETWEEN 31 AND 40 THEN '31-40'
		WHEN age BETWEEN 41 AND 50 THEN '41-50'
		WHEN age BETWEEN 51 AND 60 THEN '51-60'
		WHEN age BETWEEN 61 AND 70 THEN '61-70'
		ELSE '71-80'
		END AS age,
	gender,
	country,
	productcategory,
	purchaseamount
From purchases
WHERE
	gender != 'Unknown' and country != 'Unknown')

SELECT 
	purchasedate,
	age,
	gender,
	country,
	productcategory,
	sum(purchaseamount)
FROM 
	age_category
GROUP BY 
	age,country,productcategory,gender,purchasedate
ORDER BY
	purchasedate

--10)

SELECT 
	purchasedate,
	CASE 
		WHEN age BETWEEN 11 AND 20 THEN '11-20'
		WHEN age BETWEEN 21 AND 30 THEN '21-30'
		WHEN age BETWEEN 31 AND 40 THEN '31-40'
		WHEN age BETWEEN 41 AND 50 THEN '41-50'
		WHEN age BETWEEN 51 AND 60 THEN '51-60'
		WHEN age BETWEEN 61 AND 70 THEN '61-70'
		ELSE '71-80'
		END AS age,
	gender,
	country,
	productcategory,
	purchaseamount
From purchases
order by
purchasedate
