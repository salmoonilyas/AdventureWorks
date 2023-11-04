-- SQL Script for cleaning DIM_Customer and left joining it with DIM_Geogrpahy
SELECT 
  [CustomerKey], 
  --[GeographyKey],
  --[CustomerAlternateKey],
  --[Title],
  [FirstName], 
  --[MiddleName]
  [LastName], 
  [FirstName] + ' ' + [LastName] As [FullName], 
  --[NameStyle],
  --[BirthDate],
  --[MaritalStatus],
  --[Suffix],
  Case [Gender] when 'M' then 'Male' when 'F' then 'Female' else 'N.A.' end as 'Gender',
  --[EmailAddress],
  --[YearlyIncome],
  --[TotalChildren],
  --[NumberChildrenAtHome],
  --[EnglishEducation],
  --[SpanishEducation],
  --[FrenchEducation],
  --[EnglishOccupation],
  --[SpanishOccupation],
  --[FrenchOccupation],
  --[HouseOwnerFlag],
  --[NumberCarsOwned],
  --[AddressLine1],
  --[AddressLine2],
  --[Phone],
  [DateFirstPurchase], 
  --[CommuteDistance],
  Geo.City as [Customer City] 
FROM 
  [AdventureWorksDW2022].[dbo].[DimCustomer] as Cust 
  left join dbo.DimGeography as Geo on Geo.GeographyKey = Cust.GeographyKey 
order by 
  CustomerKey
