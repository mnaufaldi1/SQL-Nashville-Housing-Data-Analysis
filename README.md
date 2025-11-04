# 🏡 Nashville Housing Data Project

This project focuses on cleaning and analyzing the **Nashville Housing dataset** using **SQL (PostgreSQL)**.
The goal is to transform messy property data into clean, usable information and uncover real estate insights through data exploration.

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

### 🧠 Example SQL Snippet

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
- The **average sale price** is around \$327,000, while the **median** is about \$205,000 — showing a **right-skewed market** where a few luxury properties raise the mean.  
- **Single-family homes** dominate the market, followed by **residential condos** and **vacant residential land**, highlighting a strong focus on long-term residential development.  
- The **highest-valued properties** and their **owners** are all concentrated in Nashville, with total values ranging from **$3.29 million to $100 million**, indicating strong local ownership and capital retention. 

📌 **Takeaway:** Nashville’s housing market is residential-driven and locally dominated, with prices reflecting a clear affordability structure and wealth concentrated among local property owners — suggesting stable, community-centered investment patterns.
<br><br>

### 📅 2. Sales Trends Over Time
- Property sales peaked in **2015 (16,734 sales)**, with the strongest year-over-year growth occurring between 2013–2015 before slowing afterward.  
- Average sale prices were highest in **2015 ($400K)**, consistent with the market boom seen in total transactions that year.  
- Sales activity peaks during April–September, suggesting this period is optimal for **marketing new listings and closing deals**.  
- Interestingly, January and December show fewer transactions but **higher average prices**, implying that luxury buyers are more active off-season — a good window for targeting high-end segments.  
- The dataset shows minimal entries beyond 2016, suggesting limited data coverage for later years (2017–2019).  

📌 **Takeaway:** Nashville’s housing sales follow a mid-year activity surge with a price peak in early and late months, reflecting seasonal buying behavior and selective high-end transactions during off-peak periods.
<br><br>

### 🌆 3. City-Level Insights
- Nashville dominates in total sales with **~40,000 properties sold**, far ahead of Antioch (6,200) and Hermitage (3,126), indicating it’s the central hub of real estate activity.  
- Average sale prices vary significantly: **Nashville ($366K)**, **Brentwood ($312K)**, and **Goodlettsville ($290K)**, highlighting high-value markets outside the core city.  
- Building value peaks in **Brentwood ($311K)** while Nashville averages $190K. Goodlettsville and other cities show moderate building values ($118K–$77K), reflecting mid- to low-tier city markets.
- Land values are highest in **Brentwood ($152K), Nashville ($78K), Old Hickory ($35K)**, and some surrounding cities showing moderately strong land value markets.
- Price per acreage shows that **Nashville ($1,080,000)** and **Old Hickory ($675,000)** lead, suggesting premium property scarcity and high land demand in these areas.
- *Note: Some smaller cities (e.g., Nolensville, Mount Juliet) have very few sales, which may skew average building or land values. We may want to interpret those figures cautiously.*

📌 **Takeaway:** Real estate activity and value are heavily concentrated in Nashville and select surrounding cities (e.g. Goodlettsville, Brentwood), signaling where investment focus, pricing strategy, and marketing efforts may yield the strongest returns.
<br><br>

### 🧱 4. Property Characteristics
- Newer properties tend to sell for more — but only until a certain age before prices flatten or fall
- **Vacant vs. non-vacant** price differences suggest investor-driven purchases for redevelopment or flipping

📌 **Takeaway:** Building condition and occupancy play a direct role in profitability and risk.
<br><br>

### 💰 5. Value Drivers & Correlation
- **Building value** shows a stronger correlation with sale price than land value  
- Land still matters, but **improvements (home quality)** are what buyers pay for most

📌 **Takeaway:** Renovation and construction investments have more impact on resale price than the land alone.
