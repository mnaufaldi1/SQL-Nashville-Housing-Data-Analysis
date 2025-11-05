# 🏡 Nashville Housing Data Project

This project focuses on cleaning and analyzing the **Nashville Housing dataset** (available online) using **SQL (PostgreSQL)**.
The goal is to transform messy property data into clean, usable information and uncover real estate insights through data exploration.

---

## 🔧 Tech Stack
| Category | Tools/Methods Used |
|-----|---------|
| Language | SQL (PostgreSQL) |
| Tools | pgAdmin |
| Data Cleaning Techniques | Standardization, Null Handling, Column Splitting, Deduplication |
| Data Processing | CTEs, Window Functions, String Functions, Joins |
| Analysis Techniques | Aggregation, Group-Level Comparison, Correlation Analysis |

---

## 📂 Project Overview

The project consists of two main parts:

1. **Data Cleaning** – Standardizing formats, handling nulls, splitting columns, removing duplicates, and enriching the dataset.
2. **Exploratory Data Analysis (EDA)** – Finding patterns and insights such as pricing trends, land use, and relationships between property features.

---

## 🧹 Part 1: Data Cleaning

### 🔧 Key Cleaning Steps
- Standardized date formats for `saledate`
- Populated missing property addresses using matching `parcelid`
- Split address fields into street, city, and state
- Converted `soldasvacant` values from `Y/N` to `Yes/No`
- Removed duplicate records using window functions
- Dropped unused columns (`propertyaddress`, `owneraddress`, `taxdistrict`)
- Added a new `property_age` column
- Fixed negative property ages and standardized text capitalization

### 🧠 Example Cleaning Query

```sql
-- Populate missing property addresses
UPDATE nashville_housing_clean t1
SET propertyaddress = t2.propertyaddress
FROM nashville_housing_clean t2
WHERE t1.parcelid = t2.parcelid
AND t1.uniqueid != t2.uniqueid
AND t1.propertyaddress IS NULL;
```
---

## 📊 Part 2: Exploratory Data Analysis (EDA)

After cleaning, the dataset was explored to understand **sales patterns, property characteristics, and pricing behavior** across different cities in Nashville.

### 🏠 1. Market Overview
- **Average sale price**: ~$327K | **Median**: ~$205K → indicates a **right-skewed** market driven by high-price outliers.
- **Single-family homes** dominate the market, followed by **residential condos** and **vacant residential land**, highlighting a strong focus on long-term residential development.  
- The highest-valued properties and their owners are all concentrated in **Nashville**, with values ranging up to $100M+, indicating strong local ownership and capital retention. 

📌 **Takeaway:** Nashville’s housing market is residential-driven and locally dominated, with prices reflecting a clear affordability structure and wealth concentrated among local property owners — suggesting stable, community-centered investment patterns.
<br><br>

### 📅 2. Sales Trends Over Time
- Property sales and average sale prices peaked in **2015**, with the strongest year-over-year growth occurring between 2013–2015 before slowing afterward.  
- Sales activity peaks during **April–September**, suggesting this period is optimal for **marketing new listings and closing deals**.  
- Interestingly, January and December show fewer transactions but **higher average prices**, implying that luxury buyers are more active off-season — a good window for targeting high-end segments.  
- Dataset coverage beyond 2016 is limited.

📌 **Takeaway:** Nashville’s housing sales follow a mid-year activity surge with a price peak in early and late months, reflecting seasonal buying behavior and selective high-end transactions during off-peak periods.
<br><br>

### 🌆 3. City-Level Insights

#### 🏙️ Market Activity (Volume of Sales)
- **Nashville leads significantly** with ~40,000 property sales.
- Antioch (~6,200) and Hermitage (~3,126) form secondary market clusters.
→ Indicates **Nashville is the primary real estate activity hub** in the region.

#### 💵 Average Sale Price (Market Value Index)
| City | Avg Sale Price |
|---|---|
| Nashville | $366K |
| Brentwood | $312K |
| Goodlettsville | $290K |

→ Suburban cities hold **competitive pricing bands** outside the core region (Nashville).

#### 🏗️ Building Value (Construction & Structural Investment)
- **Brentwood** stands at the **highest building value tier** (~$311K).
- **Nashville** follows at a **mid-high tier** (~$190K).
- Cities like **Goodlettsville and Hermitage** range from **$77K–$118K**, forming the **mid-market segment**.

→ Indicates a clear **tiered housing investment landscape**, from premium developments to more moderately built residential areas.

#### 🌱 Land Value (Pure Lot Valuation)
| City | Avg Land Value |
|---|---|
| Brentwood | $152K |
| Nashville | $78K |
| Old Hickory | **$35K |

→ Land scarcity and demand are **strongest in Brentwood and Nashville**.

#### 🌍 Price per Acre (Land Scarcity & Premium Index)
| City | Price per Acre |
|---|---|
| Nashville | $1,080,000 |
| Old Hickory | $675,000 |
| Brentwood | $580,000 |

→ Indicates **premium land market pressure** and **redevelopment opportunities** in these areas.

> **Note:** Cities with low sales counts (e.g., Nolensville, Mount Juliet) may show skewed averages — We may want to interpret it cautiously.

📌 **Takeaway**: Real estate activity and value are heavily concentrated in Nashville and select surrounding cities (e.g. Goodlettsville, Brentwood), signaling where investment focus, pricing strategy, and marketing efforts may yield the strongest returns.
<br><br>

### 🧱 4. Property Characteristics

#### 🕒 Property Age & Sale Price
- New homes (0 years): highest sale price (~$440K).
- Majority of sales come from homes aged **50–65 years** → core housing stock.
- Very old homes (100+ years): niche/historical market.

#### 🚪 Vacancy Status
- **Non-vacant homes** dominate sales (~51K vs ~4.6K vacant).
- Non-vacant homes sell at **slightly higher prices** → move-in-ready is more attractive.

📌 **Takeaway:** The Nashville market is driven by move-in-ready mid-century homes, with new builds attracting premium buyers. Renovation and infill projects represent strong investment opportunities.
<br><br>

### 💰 5. Value Drivers & Correlation
Relationship between land value, building value, and sale price shows:
 | Factor             | Correlation with Sale Price |
| ------------------ | --------------------------- |
| **Land Value**     | **0.60**                    |
| **Building Value** | **0.57**                    |

- Both factors meaningfully affect total property value, but this indicates that **location and lot desirability have a greater influence on pricing than the physical structure alone**.
- This aligns with urban market behavior, where property value is driven more by **where the home is located** rather than **what the home is built like**.

📌 **Takeaway:** Pricing strategy should prioritize land and location-based factors. For sellers and developers, improving lot appeal and targeting high-demand neighborhoods may yield greater returns than focusing solely on building upgrades.

---

### 🧠 Example Analysis Query

#### 1) Who Owns the Highest-Value Properties?
```sql
SELECT 
    ownername, 
    property_city,
    owner_city,
    totalvalue
FROM nashville_housing_clean
WHERE totalvalue IS NOT NULL
ORDER BY totalvalue DESC
LIMIT 10;
```
#### 2) How Do Sale Prices Vary Seasonally?
```sql
SELECT 
    EXTRACT(MONTH FROM saledate) AS month,
    ROUND(AVG(saleprice), 2) AS avg_saleprice
FROM nashville_housing_clean
GROUP BY month
ORDER BY avg_saleprice DESC;
```
#### 3) What Drives Property Value More: Land or Building?
```sql
SELECT 
    ROUND(CAST(CORR(landvalue, saleprice) AS numeric), 2) AS corr_land_sale,
    ROUND(CAST(CORR(buildingvalue, saleprice) AS numeric), 2) AS corr_building_sale
FROM nashville_housing_clean;
```

---

## ✅ Key Insights Summary
- Nashville is the core market, leading in both sales volume and overall pricing activity.
- Brentwood holds the highest land and building values, while Goodlettsville and Hermitage form stable, mid-tier suburban markets around the core city.
- Sales peak in mid-year (Apr–Sep), while high-end transactions occur more in Jan/Dec.
- Move-in-ready mid-century homes (45-65 years old) form the backbone of the market; new builds sell at premium prices.
- Land value has a slightly stronger impact on sale price than building value, showing that location and lot desirability matter more than the structure itself.

---

## 👤 About the Author
**Muhammad Naufaldi**  
Physics graduate with interest in technology, innovation, and data analysis.

### 🌐 Contact
- **LinkedIn:** https://www.linkedin.com/in/muhammad-naufaldi-608517246/
- **GitHub:** https://github.com/mnaufaldi1

