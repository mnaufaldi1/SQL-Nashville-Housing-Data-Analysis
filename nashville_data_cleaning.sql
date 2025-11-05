/* ==========================================================
 🏠 NASHVILLE HOUSING DATA CLEANING PROJECT
 Author       : Muhammad Naufaldi
 Description  : Data cleaning and standardization of property records
 ========================================================== */

-- 🧩 Step 0: Duplicate the original table for cleaning
CREATE TABLE nashville_housing_clean AS
SELECT * FROM nashville_housing;


-- 🗓️ Step 1: Standardize date format
ALTER TABLE nashville_housing_clean
ALTER COLUMN saledate TYPE DATE
USING saledate::DATE;


-- 🏚️ Step 2: Populate missing PropertyAddress data
-- → Find NULL addresses
SELECT * FROM nashville_housing_clean
WHERE propertyaddress IS NULL
ORDER BY parcelid;

-- → Match records with same ParcelID to fill missing addresses
SELECT t1.parcelid, t1.propertyaddress, t2.propertyaddress
FROM nashville_housing_clean t1
JOIN nashville_housing_clean t2
  ON t1.parcelid = t2.parcelid
  AND t1.uniqueid != t2.uniqueid
WHERE t1.propertyaddress IS NULL;

-- → Update missing PropertyAddress values
UPDATE nashville_housing_clean t1
SET propertyaddress = t2.propertyaddress
FROM nashville_housing_clean t2
WHERE t1.parcelid = t2.parcelid
  AND t1.uniqueid != t2.uniqueid
  AND t1.propertyaddress IS NULL;


-- 🏡 Step 3: Split PropertyAddress into Street & City
ALTER TABLE nashville_housing_clean
ADD COLUMN address_street TEXT,
ADD COLUMN address_city TEXT;

UPDATE nashville_housing_clean
SET 
  address_street = NULLIF(TRIM(split_part(propertyaddress, ',', 1)), ''),
  address_city   = NULLIF(TRIM(split_part(propertyaddress, ',', 2)), '');


-- 👤 Step 4: Split OwnerAddress into Street, City & State
ALTER TABLE nashville_housing_clean
ADD COLUMN owner_street TEXT,
ADD COLUMN owner_city TEXT,
ADD COLUMN owner_state TEXT;

UPDATE nashville_housing_clean
SET 
  owner_street = NULLIF(TRIM(split_part(owneraddress, ',', 1)), ''),
  owner_city   = NULLIF(TRIM(split_part(owneraddress, ',', 2)), ''),
  owner_state  = NULLIF(TRIM(split_part(owneraddress, ',', 3)), '');


-- 🏷️ Step 5: Standardize SoldAsVacant column values (Y/N → Yes/No)
SELECT DISTINCT soldasvacant FROM nashville_housing_clean;

UPDATE nashville_housing_clean
SET soldasvacant = CASE
  WHEN soldasvacant = 'Y' THEN 'Yes'
  WHEN soldasvacant = 'N' THEN 'No'
  ELSE soldasvacant
END;


-- 🔁 Step 6: Remove duplicate rows
-- → Identify duplicates using window functions
SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference
           ORDER BY uniqueid
         ) AS row_num
  FROM nashville_housing_clean
) AS sub
WHERE row_num > 1;

-- → Delete duplicates using CTE
WITH duplicates AS (
  SELECT uniqueid,
         ROW_NUMBER() OVER (
           PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference
           ORDER BY uniqueid
         ) AS row_num
  FROM nashville_housing_clean
)
DELETE FROM nashville_housing_clean
WHERE uniqueid IN (SELECT uniqueid FROM duplicates WHERE row_num > 1);


-- 🧹 Step 7: Drop unused columns
ALTER TABLE nashville_housing_clean
DROP COLUMN propertyaddress,
DROP COLUMN owneraddress,
DROP COLUMN taxdistrict;


-- 🏗️ Step 8: Add Property Age column
ALTER TABLE nashville_housing_clean
ADD COLUMN property_age INT;

UPDATE nashville_housing_clean
SET property_age = EXTRACT(YEAR FROM saledate) - yearbuilt;

-- → Handle invalid negative ages
UPDATE nashville_housing_clean
SET property_age = NULL
WHERE property_age < 0;


-- 🧠 Step 9: Standardize text capitalization
UPDATE nashville_housing_clean
SET 
  ownername      = INITCAP(ownername),
  landuse        = INITCAP(landuse),
  address_street = INITCAP(address_street),
  address_city   = INITCAP(address_city),
  owner_street   = INITCAP(owner_street),
  owner_city     = INITCAP(owner_city),
  owner_state    = INITCAP(owner_state);


-- ✅ Step 10: View the final cleaned dataset
SELECT * FROM nashville_housing_clean;


