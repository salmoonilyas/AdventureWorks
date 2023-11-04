# AdventureWorks Sales Management Dashboard Project in PowerBI

## Business Case

The business request for project was creating an dashboard for sales manager and providing the overview of sales, overview of customers and over view of products sales. The overview is to be provided for the past three years and allowing the user to modify the filters wrt years and months.
The Dashboard should have the KPI and line charts along with the top ten sales for the products and for the customers.
An table(Piviot/Matix) is also requied sorted by top total sales, having all the sales data wrt. customer and product. Region in which sales are made would also be nice to have.

## Sales Management Project on AdventureWorks databases

The AdventureWorks databases are sample databases that were originally published by Microsoft to show how to design a SQL Server database using SQL Server 2008. AdventureWorksDW is the data warehouse sample.

Note that AdventureWorks has not seen any significant changes since the 2012 version. The only differences between the various versions of AdventureWorks are the name of the database and the database compatibility level.

Data Source:<https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/adventure-works>

As the calender and database is relitively old so to update the dates of database the script [Update_AdventureWorksDW_Data.sql](../AdventureWorks/sql_queries/Update_AdventureWorksDW_Data.sql) is used. This script do not modify any other data and only shift the dates by adding the years wrt current year and also adds the dates in theDIM_Dates table which is basically an calender table.

Note: The Microsoft AdventureWorks databases/data being used is under MIT license.

## Data Cleaning and Transformation using SQL

The data was filtered and transformed using SQL for the required tables and latter for the budget a spreadsheet was manually created having the budget values for the last three years.

Following are the SQL queries performed for cleansing and transforming the required data, having excluded fields as comments in the code:

### SQL Script for DIM_Calendar

[SQL script for DIM_Calendar](../AdventureWorks/sql_queries/DIM_Calender.sql)

```SQL
-- SQL Script for cleaning DIM_Date
SELECT
   [DateKey],
   [FullDateAlternateKey] AS Date,
   --[DayNumberOfWeek],
   [EnglishDayNameOfWeek] AS Day,
   --[SpanishDayNameOfWeek],
   --[FrenchDayNameOfWeek],
   --[DayNumberOfMonth],
   --[DayNumberOfYear],
   --[WeekNumberOfYear],

   [EnglishMonthName] AS Month,
   LEFT([EnglishMonthName], 3) AS MonthShort, -- Useful for front end date navigation and front end graphs.
   --[SpanishMonthName],
   --[FrenchMonthName],

   [MonthNumberOfYear] AS MonthNo,
   [CalendarQuarter] AS Quarter,
   [CalendarYear] AS Year
   --[CalendarSemester],
   --[FiscalQuarter],
   --[FiscalYear],
   --[FiscalSemester]
FROM
   [AdventureWorksDW2022].[dbo].[DimDate]
WHERE CalendarYear >=2020
```

### SQL script for DIM_Customer

[SQL script for DIM_Customer](../AdventureWorks/sql_queries/DIM_Customer.sql)

```SQL
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
```

### SQL script for DIM_Products

[SQL Script for DIM_Products](../AdventureWorks/sql_queries/DIM_Products.sql)

```SQL
-- SQL Script for cleaning DIM_Products and left join it with DIM_ProductCategory and DIM_ProductSubCategory
SELECT
    [ProductKey],
    [ProductAlternateKey] AS [ProdcuctItemCode],
    --[ProductSubcategoryKey],
    --[WeightUnitMeasureCode],
    --[SizeUnitMeasureCode],
    [EnglishProductName] AS [ProductName],
    ProdCat.EnglishProductCategoryName AS [ProductCategory],
    ProdSubCat.EnglishProductSubcategoryName AS [ProductSubcategory],
    --[SpanishProductName],
    --[FrenchProductName],
    --[StandardCost],
    --[FinishedGoodsFlag],
    [Color] AS [ProductColor],
    --[SafetyStockLevel],
    --[ReorderPoint],
    --[ListPrice],
    [Size] AS [ProductSize],
    --[SizeRange],
    --[Weight],
    --[DaysToManufacture],
    [ProductLine],
    --[DealerPrice],
    --[Class],
    --[Style],
    [ModelName] AS [ProductModel],
    --[LargePhoto],
    [EnglishDescription] AS [ProdcuctDescription],
    --[FrenchDescription],
    --[ChineseDescription],
    --[ArabicDescription],
    --[HebrewDescription],
    --[ThaiDescription],
    --[GermanDescription],
    --[JapaneseDescription],
    --[TurkishDescription],
    --[StartDate],
    --[EndDate],
    CASE
        WHEN [Status] IS NULL THEN 'Outdated'
        ELSE [Status]
    END AS [ProductStatus]
FROM
    [AdventureWorksDW2022].[dbo].[DimProduct] AS Prod
LEFT JOIN
    dbo.DimProductSubcategory AS ProdSubCat ON Prod.ProductSubcategoryKey = ProdSubCat.ProductSubcategoryKey
LEFT JOIN
    dbo.DimProductCategory AS ProdCat ON ProdCat.ProductCategoryKey = ProdSubCat.ProductCategoryKey
ORDER BY
    ProductKey ASC;
```

### SQL script for Fact_InternetSales

[SQL script for Fact_InternetSales](../AdventureWorks/sql_queries/Fact_InternetSales.sql)

```SQL
-- SQL Script for cleaning Fact_InternetSales
SELECT
    [ProductKey],
    [OrderDateKey],
    [DueDateKey],
    [ShipDateKey],
    [CustomerKey],
    --[PromotionKey],
    --[CurrencyKey],
    --[SalesTerritoryKey],
    [SalesOrderNumber],
    --[SalesOrderLineNumber],
    --[RevisionNumber],
    --[OrderQuantity],
    --[UnitPrice],
    --[ExtendedAmount],
    --[UnitPriceDiscountPct],
    --[DiscountAmount],
    --[ProductStandardCost],
    --[TotalProductCost],
    [SalesAmount]
    --[TaxAmt],
    --[Freight],
    --[CarrierTrackingNumber],
    --[CustomerPONumber],
    --[OrderDate],
    --[DueDate],
    --[ShipDate]
FROM [AdventureWorksDW2022].[dbo].[FactInternetSales]
WHERE LEFT(OrderDateKey, 4) >= YEAR(GETDATE()) - 2 -- Taking into account only the last two years
ORDER BY OrderDateKey ASC;
```

## Model view of the Data

Below is Model view of the dat after importing it into Power BI.

![model_view](/dashboards/model_view.png "Model view of the Data")

## Sales Management Dashboards

The three created sales manangent dashboards are shown below.

### Sales overview dashboard

![sales_overview](/dashboards/sales_overview.png "Sales overview Dashboard")

### Customer details dashboard

![customer_details](/dashboards/product_details.png "Customer details Dashboard")

### Product details dashboard

![product_details](/dashboards/product_details.png "Product details Dashboard")

[Click here Download to view it in PowerBI](/sales_report.pbix "Open in PowerBI").

---
