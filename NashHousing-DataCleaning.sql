SELECT * FROM [Nashville-DataCleaning]..NashHousing

--FIX SALE DATE TO EASIER FORMAT
--
SELECT SaleDateConvert, CONVERT(Date, SaleDate)
FROM [Nashville-DataCleaning]..NashHousing

UPDATE NashHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashHousing
ADD SaleDateConvert Date;

UPDATE NashHousing
SET SaleDateConvert = CONVERT(Date, SaleDate)

--Address Data
--
SELECT *
FROM [Nashville-DataCleaning]..NashHousing
ORDER BY ParcelID

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress FROM [Nashville-DataCleaning]..NashHousing A 
JOIN [Nashville-DataCleaning]..NashHousing B 
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL 

UPDATE A SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [Nashville-DataCleaning]..NashHousing A
JOIN [Nashville-DataCleaning]..NashHousing B 
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

--Address into Separate Columns(Including Address, State, City)
SELECT PropertyAddress 
FROM [Nashville-DataCleaning]..NashHousing

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM [Nashville-DataCleaning]..NashHousing

ALTER TABLE NashHousing
ADD PropSplitAddress NVARCHAR(255);

UPDATE NashHousing
SET PropSplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

ALTER TABLE NashHousing
ADD PropSplitCity NVARCHAR(255);

UPDATE NashHousing
SET PropSplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT * FROM [Nashville-DataCleaning]..NashHousing

--Changing Y and N to a more noticable text in the "Sold as Vacant" field
--Easier to see and acknowledge

SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM [Nashville-DataCleaning]..NashHousing

UPDATE NashHousing 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM [Nashville-DataCleaning]..NashHousing

--Removing any extra duplicates. Aesthetic purpose and to clean up data.
--Not standard to delete data. Just practice.

WITH RowNumCTE AS(
SELECT *, ROW_NUMBER()
	OVER (PARTITION BY ParcelID,
					   PropertyAddress,
					   SalePrice,
					   SaleDate,
					   LegalReference
					   ORDER BY 
							UniqueID) AS Row_Num
FROM [Nashville-DataCleaning]..NashHousing
)
DELETE FROM RowNumCTE
WHERE Row_Num > 1 


--Removing those unused columns for clean tables
--Includes most that have been reworked

SELECT * FROM [Nashville-DataCleaning]..NashHousing

ALTER TABLE NashHousing DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
ALTER TABLE NashHousing DROP COLUMN SaleDate