

--- Cleaning data


select *
from NashvilleHousing

--- Change data type of saleDate and store in a new column Sale_Date
alter table NashvilleHousing
add Sale_Date date;

update NashvilleHousing
set Sale_Date = cast( saleDate as date )

--- Remove old SaleDate column
alter table NashvilleHousing
drop column SaleDate;



--- Perform self-join to fill out Null values 
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress 
from NashvilleHousing a
Inner join NashvilleHousing b
on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set a.PropertyAddress = ISNULL ( a.propertyAddress, b.PropertyAddress )
from NashvilleHousing a
Inner join NashvilleHousing b
on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]



--- Breaking out propertyAddress into Individual Columns 
select propertyAddress, SUBSTRING ( propertyAddress, 1, CHARINDEX (',', propertyAddress ) - 1 ) as Address,
Right( propertyAddress, LEN ( propertyAddress ) - CHARINDEX (',', propertyAddress ) ) as City
from NashvilleHousing


alter table NashvilleHousing
add property_address nvarchar(255);

update NashvilleHousing
set property_address = SUBSTRING ( propertyAddress, 1, CHARINDEX (',', propertyAddress ) - 1 )



alter table NashvilleHousing
add property_city nvarchar(255);

update NashvilleHousing
set property_city = Right( propertyAddress, LEN ( propertyAddress ) - CHARINDEX (',', propertyAddress ) )

alter table NashvilleHousing
drop column propertyaddress;



--- Breaking out owneraddress into Individual Columns
select owneraddress, PARSENAME ( replace ( owneraddress, ',', '.') , 3 ), 
                     PARSENAME ( replace ( owneraddress, ',', '.') , 2 ), 
                     PARSENAME ( replace ( owneraddress, ',', '.') , 1 )
from NashvilleHousing



alter table NashvilleHousing
add owner_address nvarchar(255);

update NashvilleHousing
set owner_address = PARSENAME ( replace ( owneraddress, ',', '.') , 3 )


alter table NashvilleHousing
add owner_city nvarchar(255);

update NashvilleHousing
set owner_city = PARSENAME ( replace ( owneraddress, ',', '.') , 2 )


alter table NashvilleHousing
add owner_state nvarchar(255);

update NashvilleHousing
set owner_state = PARSENAME ( replace ( owneraddress, ',', '.') , 1 )



--- Change Y and N to Yes and No in "soldasvacant" field
select soldasvacant, case when soldasvacant = 'N' then 'No'
                          when soldasvacant = 'Y' then 'Yes'
						  else soldasvacant
			              end
from NashvilleHousing

update NashvilleHousing
set soldasvacant = case when soldasvacant = 'N' then 'No'
                          when soldasvacant = 'Y' then 'Yes'
						  else soldasvacant
			              end




--- Remove duplicate rows
with t1 as 

(select *, ROW_NUMBER () over (partition by parcelID, LandUse, SalePrice, LegalReference, sale_date order by uniqueID ) as row_num
from NashvilleHousing)

delete
from t1
where row_num > 1


