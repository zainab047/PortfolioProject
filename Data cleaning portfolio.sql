
-- Cleaning data in SQL queries
select * 
from NashvilleHousing

--Standarise date format.

select saledate
from NashvilleHousing;

alter table NashvilleHousing
alter column saledate date;

-- Populate property address data

/* 
select parcelid, PropertyAddress, [UniqueID ], count(ParcelID) over ( partition by parcelid) as count_of_p_id
from NashvilleHousing 
*/

-- check if all the property address are same
-- and PropertyAddress is null (there are 29 null entries that have count more than 1)
with dup as ( select parcelid, PropertyAddress, [UniqueID ], count(ParcelID) over ( partition by parcelid) as count_of_p_id
from NashvilleHousing)
select *
from dup
where count_of_p_id >1 

-- to check if there are any nulls in the unique entries of parcel id (there are none)
with dup as ( select parcelid, PropertyAddress, [UniqueID ], count(ParcelID) over ( partition by parcelid) as count_of_p_id
from NashvilleHousing)
select *
from dup
where count_of_p_id  = 1 and PropertyAddress is null

-- check if any unique id's are a duplicate
select *
from (
select [UniqueID ], COUNT([UniqueID ]) over (partition by uniqueid ) as t
from NashvilleHousing) as uniqueidcounts
where t >1
-- conclusion - no duplicates in unique 

-- checking if all property addresses are available
select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress
from NashvilleHousing a
join NashvilleHousing b on a.ParcelID = b.ParcelID
where a.PropertyAddress is null
and a.[UniqueID ]<> b.[UniqueID ]

-- now to the updating part

update a
set PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b on a.ParcelID = b.ParcelID
and  a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

-- check if all updated in the table

select *
from NashvilleHousing
where PropertyAddress is null



-- Breaking out address into individual columns (address, state, city)

select PropertyAddress
from NashvilleHousing

-- creating query to split the address

select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(propertyaddress)) as address2
from NashvilleHousing

-- alter the table and update the table

alter table nashvillehousing
add PropertySplitAddress nvarchar(255)

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)


alter table nashvillehousing
add PropertySplitCity nvarchar(255)

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(propertyaddress))


--split owneraddress; since this has 3 delimiters we will use parse name here.

select OwnerAddress, 
	PARSENAME(replace(OwnerAddress,',','.'),3) as citycode,
	PARSENAME(replace(OwnerAddress,',','.'),2) as city,
	PARSENAME(replace(OwnerAddress,',','.'),1) as owneraddress
from NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);
Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);
Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);
Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing;

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;

-- Removing duplicates

--first, finding duplicates & lastly to check if duplicates were removed
With RowNumCTE AS (
select *, 
	ROW_NUMBER() over(
		partition by parcelid,
		propertyaddress,
		saleprice,
		saledate,
		legalreference
	Order by uniqueID) as RowNum
from NashvilleHousing)

select *
from RowNumCTE
where RowNum >1
order by PropertyAddress

-- deleting duplicates
With RowNumCTE AS (
select *, 
	ROW_NUMBER() over(
		partition by parcelid,
		propertyaddress,
		saleprice,
		saledate,
		legalreference
	Order by uniqueID) as RowNum
from NashvilleHousing)

delete
from RowNumCTE
where RowNum >1
--order by PropertyAddress no orderby clause here

-- Delete unused columns
select *
from NashvilleHousing

alter table nashvillehousing
drop column owneraddress, taxdistrict,propertyaddress,saledate