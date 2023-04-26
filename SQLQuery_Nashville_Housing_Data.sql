--cleaning Data in SQL Queries

Select *
from PortfolioProject.dbo.NashvilleHousing

--Date formats are not the same and has too many digits


Select SaleDateConverted, convert(date,saledate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date,SaleDate)

--execute alter table first then execute update

alter table NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
set SaleDateconverted = convert(date,SaleDate)

Select SaleDateConverted, convert(date,saledate)
from PortfolioProject.dbo.NashvilleHousing

--populate property address data
--parcel id and property address is the same on both tables (unless it's missig but this is how we are populating the data) BUT UNIQUE ID is unique 
-- then jopiun the tables to itself (self join)
select PropertyAddress
from PortfolioProject.dbo.Nashvillehousing
where propertyAddress is null

select *
from PortfolioProject.dbo.Nashvillehousing
--where propertyAddress is null
order by parcelid

-- <> means not equal
select *
from PortfolioProject.dbo.Nashvillehousing a
Join PortfolioProject.dbo.Nashvillehousing b
	on a.parcelid = b.parcelid
	and a.[uniqueid ] <> b.[uniqueid ]

select a.parcelid, a.propertyaddress, b.parcelid, b.Propertyaddress, isnull(a.propertyaddress,b.propertyaddress)
from PortfolioProject.dbo.Nashvillehousing a
Join PortfolioProject.dbo.Nashvillehousing b
	on a.parcelid = b.parcelid
	and a.[uniqueid ] <> b.[uniqueid ]
where a.propertyaddress is null

select propertyaddress
from PortfolioProject.dbo.Nashvillehousing
where propertyAddress is null
--order by parcelid

-- use alias (a) 
-- run update 1st then the querry above again to see if it worked (you should get nothing back)
update a
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from PortfolioProject.dbo.Nashvillehousing a
Join PortfolioProject.dbo.Nashvillehousing b
	on a.parcelid = b.parcelid
	and a.[uniqueid ] <> b.[uniqueid ]
where a.propertyaddress is null


--breaking the address down into sepereate columns

select *
from PortfolioProject.dbo.NashvilleHousing

 select
 substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as address
 , substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress)) as address

 from PortfolioProject.dbo.NashvilleHousing

 alter table NashvilleHousing
 add PropertySplitAddress nvarchar(255);

 update NashvilleHousing
 set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1)

 alter table NashvilleHousing
 add PropertySplitCity nvarchar(255);

 update NashvilleHousing
 set PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress))

 select*
 from PortfolioProject.dbo.NashvilleHousing

 select OwnerAddress
 from PortfolioProject.dbo.NashvilleHousing

  select 
  parsename(replace(OwnerAddress,',','.'),3)
  ,parsename(replace(OwnerAddress,',','.'),2)
  ,parsename(replace(OwnerAddress,',','.'),1)
  from PortfolioProject.dbo.NashvilleHousing

 alter table NashvilleHousing
 add OwnerSplitAddress nvarchar(255);

 update NashvilleHousing
 set OwnerSplitAddress = parsename(replace(OwnerAddress,',','.'),3)

 alter table NashvilleHousing
 add OwnerSplitCity nvarchar(255);

 update NashvilleHousing
 set OwnerSplitCity = parsename(replace(OwnerAddress,',','.'),2)

 alter table NashvilleHousing
 add OwnerSplitState nvarchar(255);

 update NashvilleHousing
 set OwnerSplitState = parsename(replace(OwnerAddress,',','.'),1)

 select *
 from PortfolioProject.dbo.NashvilleHousing

  select 
  parsename(replace(OwnerAddress,',','.'),3)
  ,parsename(replace(OwnerAddress,',','.'),2)
  ,parsename(replace(OwnerAddress,',','.'),1)
  from PortfolioProject.dbo.NashvilleHousing

  --Change Y to yes and N to No

  select distinct(SoldAsVacant), count(SoldAsVacant)
  from PortfolioProject.dbo.NashvilleHousing
  group by SoldAsVacant
  order by 2
  
select SoldAsVacant
 , Case when SoldAsVacant = 'Y' then 'Yes' 
	    when SoldAsVacant = 'N' then 'No'
		ELSE SoldAsVacant
		END
from PortfolioProject.dbo.NashvilleHousing




update PortfolioProject.dbo.NashvilleHousing
set SoldAsVacant =  Case when SoldAsVacant = 'Y' then 'Yes' 
	   when SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
	   END
from PortfolioProject.dbo.NashvilleHousing

--Remove dups

with RowNumCTE as(
select*,
   ROW_NUMBER() over (
   partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
			    LegalReference
				order by
					UniqueID
					) row_num

from PortfolioProject.dbo.NashvilleHousing
)
--select *
delete
from RowNumCTE
where row_num > 1
--order by PropertyAddress

select*
from PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress, PropertyAddress

alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate