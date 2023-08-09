SELECT 
    [CustomerKey], 
  --[GeographyKey], 
  --[CustomerAlternateKey], 
  --[Title], 
  [FirstName] AS [First Name], 
  --[MiddleName], 
  [LastName] AS [Last Name], 
  [FirstName] + ' ' + [LastName] AS [Full Name], 
  --[NameStyle], 
  --[BirthDate], 
  --[MaritalStatus], 
  --[Suffix], 
  --[Gender],
  CASE Gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS [Gender], 
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
  --[CommuteDistance] 

  g.City AS [Customer City] -- join in Customer City from Geography Table
FROM 
  [dbo].[DimCustomer] AS c 
  LEFT JOIN [dbo].[DimGeography] AS g ON c.GeographyKey = g.GeographyKey
ORDER BY 
  CustomerKey ASC -- Order list by CusmtomerKey

  
