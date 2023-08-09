SELECT 
  [ProductKey], 
  [ProductAlternateKey] AS ProducItemCode, 
  --[ProductSubcategoryKey],
  --[WeightUnitMeasureCode], 
  --[SizeUnitMeasureCode], 
  [EnglishProductName] AS [Product Name], 
   pc.[EnglishProductCategoryName] AS [Product Category],	-- join in Category from Product Category Table
   ps.[EnglishProductSubcategoryName] AS [Sub Category],	-- join in SubCategory from Product SubCategory Table
  --[SpanishProductName], 
  --[FrenchProductName], 
  --[StandardCost], 
  --[FinishedGoodsFlag], 
  [Color] AS [Product Color], 
  --[SafetyStockLevel], 
  --[ReorderPoint], 
  --[ListPrice], 
  [Size] AS [Product Size], 
  --[SizeRange], 
  --[Weight], 
  --[DaysToManufacture], 
  [ProductLine] AS [Product Line], 
  --[DealerPrice], 
  --[Class], 
  --[Style], 
  [ModelName] AS [Product Model Name], 
  --[LargePhoto], 
  [EnglishDescription] AS [Product Description], 
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
  --[Status]
  ISNULL ([Status], 'Outdated') AS [Product Status]
FROM 
  [dbo].[DimProduct] AS p
  LEFT JOIN dbo.DimProductSubcategory AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
  LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
  ORDER BY 
  ProductKey ASC -- Order list by ProductKey