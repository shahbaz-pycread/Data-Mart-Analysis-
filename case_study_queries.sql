SELECT TOP 10 *
    FROM dbo.weekly_sales;


-------------------------- Data Cleaning---------------------------------

/*
    Creating a new table 'clean_weekly_sales with new columns and 
    inserting data into it from the 'weekly_sales' table
*/


SELECT week_date, 
        DATEPART(WEEK, week_date) week_number,
        MONTH(week_date) month_number,
        YEAR(week_date) calender_year,
        region, platform,
        CASE 
            WHEN segment = null THEN 'Unknow'
            ELSE segment
        END AS segment,
        CASE 
            WHEN RIGHT(segment, 1) ='1' THEN 'Young Adults'
            WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'
            WHEN RIGHT(segment,1) IN ('3','4') THEN 'Retirees'
            ELSE 'Unknown'
        END AS age_band,
        CASE 
            WHEN LEFT(segment,1) = 'C' THEN 'Couples'
            WHEN LEFT(segment,1) = 'F' THEN 'Families'
            ELSE 'Unkown'
        END AS demographic,
        customer_type,transactions,sales,ROUND(sales/transactions,2) avg_transaction

        INTO dbo.clean_weekly_sales

        FROM dbo.weekly_sales;


-- Looking the data

SELECT top 30 *
    FROM dbo.clean_weekly_sales;


------------------------------------ Data Exploration ----------------------------

-- 1. How many total transactions were there for each year in the dataset?

SELECT calender_year, SUM(transactions) Total_Transactions
    FROM dbo.clean_weekly_sales
    GROUP BY calender_year;

--2. What are the total sales for each region for each month?

SELECT region, month_number, SUM(sales) Total_Sales
    FROM dbo.clean_weekly_sales
    GROUP BY region, month_number
    ORDER BY region, month_number;

--3. What is the total count of transactions for each platform

SELECT platform, COUNT(transactions) No_Of_Transactions
    FROM dbo.clean_weekly_sales
    GROUP BY platform;


--4. Which age_band and demographic values contribute the most to Retail sales?

    SELECT  age_band, demographic, SUM(sales) Total_Sales
        FROM dbo.clean_weekly_sales
        WHERE platform='Retail'
        GROUP BY age_band, demographic
        ORDER BY Total_Sales DESC;







