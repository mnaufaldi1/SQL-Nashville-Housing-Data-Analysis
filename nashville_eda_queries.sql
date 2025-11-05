-- ============================================================
-- 📊 NASHVILLE HOUSING PROJECT — ANALYSIS QUERIES
-- Author: Muhammad Naufaldi
-- ============================================================

-- ============================================================
-- 🏠 1. MARKET OVERVIEW
-- ============================================================

-- Q1: What is the average and median sale price of properties?
SELECT 
    ROUND(AVG(saleprice), 2) AS avg_price,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY saleprice) AS median_price
FROM nashville_housing_clean;

-- Q2: What are the most common land use types?
SELECT 
    landuse, 
    COUNT(*) AS total_properties
FROM nashville_housing_clean
GROUP BY landuse
ORDER BY total_properties DESC;

-- Q3: Who owns the top 10 most expensive properties?
SELECT 
    ownername, 
    property_city,
	owner_city,
    totalvalue
FROM nashville_housing_clean
WHERE totalvalue IS NOT NULL
ORDER BY totalvalue DESC
LIMIT 10;


-- ============================================================
-- 📅 2. SALES TRENDS OVER TIME
-- ============================================================

-- Q4: How many properties were sold each year?
SELECT 
    EXTRACT(YEAR FROM saledate) AS year, 
    COUNT(*) AS total_sales
FROM nashville_housing_clean
GROUP BY year
ORDER BY year;
	-- Year-over-year growth percent
	SELECT 
	    year,
	    total_sales,
	    ROUND(
	        (total_sales - LAG(total_sales) OVER (ORDER BY year))::numeric /
	        LAG(total_sales) OVER (ORDER BY year) * 100, 2
	    ) AS yoy_growth_percent
	FROM (
	    SELECT 
	        EXTRACT(YEAR FROM saledate) AS year, 
	        COUNT(*) AS total_sales
	    FROM nashville_housing_clean
	    GROUP BY year
	) AS yearly_sales
	ORDER BY year;

-- Q5: What is the average sale price per year? (to see price trends)
SELECT 
    EXTRACT(YEAR FROM saledate) AS year,
    ROUND(AVG(saleprice), 2) AS avg_saleprice
FROM nashville_housing_clean
GROUP BY year
ORDER BY year;

-- Q6: How does the number of sales vary by month? (to find seasonality)
SELECT 
    EXTRACT(MONTH FROM saledate) AS month,
    COUNT(*) AS total_sales
FROM nashville_housing_clean
GROUP BY month
ORDER BY total_sales DESC;

-- Q7: What is the average sale price by month across all years?
SELECT 
    EXTRACT(MONTH FROM saledate) AS month,
    ROUND(AVG(saleprice), 2) AS avg_saleprice
FROM nashville_housing_clean
GROUP BY month
ORDER BY avg_saleprice DESC;


-- ============================================================
-- 🌆 3. CITY-LEVEL INSIGHTS
-- ============================================================

-- Q8: Which cities recorded the highest number of property sales?
SELECT 
    property_city, 
    COUNT(*) AS total_sales
FROM nashville_housing_clean
GROUP BY property_city
ORDER BY total_sales DESC
LIMIT 10;

-- Q9: What is the average sale price per city?
SELECT 
    property_city, 
    ROUND(AVG(saleprice), 2) AS avg_price
FROM nashville_housing_clean
GROUP BY property_city
ORDER BY avg_price DESC;

-- Q10: Which cities have the highest average building value?
SELECT 
    property_city, 
    ROUND(AVG(buildingvalue), 2) AS avg_building_value, COUNT(*)
FROM nashville_housing_clean
WHERE buildingvalue > 0
GROUP BY property_city
ORDER BY avg_building_value DESC
LIMIT 10;

-- Q11: Which cities have the highest average land value?
SELECT 
    property_city, 
    ROUND(AVG(landvalue), 2) AS avg_land_value,
	COUNT(*)
FROM nashville_housing_clean
WHERE landvalue > 0 AND saleprice > 0
GROUP BY property_city
ORDER BY avg_land_value DESC
LIMIT 10;

-- Q12: What is the average price per acreage per city?
SELECT 
    property_city,
    ROUND(AVG(saleprice / NULLIF(acreage,0)), 2) AS price_per_acre,
	COUNT(*)
FROM nashville_housing_clean
GROUP BY property_city
HAVING ROUND(AVG(saleprice / NULLIF(acreage,0)), 2) IS NOT NULL
ORDER BY price_per_acre DESC;


-- ============================================================
-- 🧱 4. PROPERTY CHARACTERISTICS
-- ============================================================

-- Q13: How does property age influence sale price?
SELECT 
    property_age,
    ROUND(AVG(saleprice), 2) AS avg_price,
    COUNT(*) AS total_sales
FROM nashville_housing_clean
WHERE property_age IS NOT NULL
GROUP BY property_age
ORDER BY total_sales DESC;

-- Q14: Do vacant properties sell for less or more compared to non-vacant ones?
SELECT 
    soldasvacant,
    COUNT(*) AS total_sales,
    ROUND(AVG(saleprice), 2) AS avg_price
FROM nashville_housing_clean
GROUP BY soldasvacant
ORDER BY soldasvacant;


-- ============================================================
-- 💰 5. VALUE DRIVERS & CORRELATION
-- ============================================================

-- Q15: Which contributes more to property value — building or land?
SELECT 
    ROUND(CAST(CORR(landvalue, saleprice) AS numeric), 2) AS corr_land_sale,
    ROUND(CAST(CORR(buildingvalue, saleprice) AS numeric), 2) AS corr_building_sale
FROM nashville_housing_clean;

