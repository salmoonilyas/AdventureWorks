-- SQL Script for cleaning DIM_Products and left join it with DIM_ProductCategory and DIM_ProductSubCategory
SELECT 
    [ProductKey],
    [ProductAlternateKey] AS [ProductItemCode],
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
    [EnglishDescription] AS [ProductDescription],
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
