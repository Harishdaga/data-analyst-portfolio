-- Table created to upload data to table
CREATE TABLE `datasets`.`top_1000_technology_companies` (
    `Ranking` INT,
    `Company` TEXT,
    `Market Cap` TEXT,
    `Stock` TEXT,
    `Country` TEXT,
    `Sector` TEXT,
    `Industry` TEXT
);


-- table name updated
ALTER TABLE `datasets`.`top_1000_technology_companies` 
RENAME TO  `datsets`.`companies`;


-- table column name updated
ALTER TABLE `datasets`.`companies` 
CHANGE COLUMN `Ranking` `ranking` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Company` `company` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Market Cap` `market_cap_in_million` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Stock` `stock` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Country` `country` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Sector` `sector` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Industry` `industry` TEXT NULL DEFAULT NULL ;


-- market_cap_in_million column updated for better understanding ex. ('$ 10B' to decimal(10000.00))
UPDATE companies 
SET 
    market_cap_in_million = REPLACE(market_cap_in_million, '$', '');
UPDATE companies 
SET market_cap_in_million = CASE    
	WHEN RIGHT(market_cap_in_million, 1) = 'T' THEN ROUND(CAST(REPLACE(market_cap_in_million, 'T', '') AS DECIMAL(10, 2)) * 1000000, 2)   
    WHEN RIGHT(market_cap_in_million, 1) = 'B' THEN ROUND(CAST(REPLACE(market_cap_in_million, 'B', '') AS DECIMAL(10, 2)) * 1000, 2)         
    WHEN RIGHT(market_cap_in_million, 1) = 'M' THEN ROUND(CAST(REPLACE(market_cap_in_million, 'M', '') AS DECIMAL(10, 2)), 2)   
    ELSE market_cap_in_million END;



-- Analysis Start

-- 1. Write a query to fetch all columns and rows from the table.
SELECT 
    *
FROM
    companies;


-- 2. Write a query to count the number of companies in each industry.
SELECT 
    industry, COUNT(*) AS total_companies
FROM
    companies
GROUP BY industry
ORDER BY total_companies DESC;


-- 3. Write a query to list all companies that are based in the United States.
SELECT 
    *
FROM
    companies
WHERE
    country = 'United States';


-- 4. Write a query to find all companies with a market cap greater than $1 billion.
SELECT 
    *
FROM
    companies
WHERE
    market_cap_in_million >= 1000;


-- 5. Write a query to list all companies in country.
SELECT 
    country, COUNT(*) AS total_companies
FROM
    companies
GROUP BY country
ORDER BY total_companies DESC;


-- 6. Write a query to retrieve the top 10 companies based on their ranking.
SELECT 
    *
FROM
    companies
WHERE
    ranking <= 10;

-- 7. Write a query to find all companies in the "Software—Infrastructure" or "Software—Application" industry.
SELECT 
    *
FROM
    companies
WHERE
    industry IN ('Software—Application' , 'Software—Infrastructure');


-- 8. Write a query to calculate the average market cap for each industry.
SELECT 
    industry,
    ROUND(AVG(market_cap_in_million), 2) AS avg_market_cap
FROM
    companies
GROUP BY industry
ORDER BY avg_market_cap DESC;


-- 9. Write a query to list the top 5 companies by ranking within a specific country, such as "Germany."
SELECT 
    company, market_cap_in_million
FROM
    companies
WHERE
    country = 'Germany'
ORDER BY market_cap_in_million DESC
LIMIT 5;


-- 10. Write a query to count the number of companies in each industry for each country.
SELECT 
    industry, country, COUNT(*) AS total_companies
FROM
    companies
GROUP BY industry , country
ORDER BY industry , country, total_companies DESC;


-- 11. Write a query to find the company with the highest market cap in each industry.
SELECT 
	industry,
    company,
    market_cap_in_million
FROM (
	SELECT 
		industry, 
        company, 
        market_cap_in_million, 
        RANK() OVER(PARTITION BY industry ORDER BY market_cap_in_million DESC) AS rank_no 
	FROM companies) AS sub
WHERE 
	rank_no = 1
ORDER BY market_cap_in_million DESC;


-- 12. Write a query to list the top 3 industries with the highest total market cap.
SELECT 
    industry, SUM(market_cap_in_million) AS total_market_cap
FROM
    companies
GROUP BY industry
ORDER BY total_market_cap DESC
LIMIT 3;


-- 13. Write a query to find pairs of companies with market caps within 5% of each other.
SELECT 
    a.company,
    b.company,
    a.market_cap_in_million,
    b.market_cap_in_million
FROM
    companies AS a,
    companies AS b
WHERE
    a.company <> b.company
        AND ABS(a.market_cap_in_million - b.market_cap_in_million) <= 0.05 * a.market_cap_in_million;