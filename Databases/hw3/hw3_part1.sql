-- Select ProductID, Name and ProductModel from 2 tables
SELECT 
[Production].[Product].ProductID, 
[Production].[Product].Name as ProductName, 
[Production].[ProductModel].Name as ProductModel
FROM [Production].[Product]
LEFT JOIN [Production].[ProductModel]
ON [Production].[Product].ProductModelID = [Production].[ProductModel].ProductModelID
ORDER BY ProductID ASC

-- how much and what languages do we have in the table
SELECT CultureID, COUNT(CultureID) AS RecordCount
FROM [Production].[ProductModelProductDescriptionCulture]
GROUP BY CultureID
ORDER BY RecordCount DESC;

-- to be sure that each product model has all represented languages
SELECT 
    ProductModelID,
    COUNT(DISTINCT CultureID) AS UniqueLanguages
FROM [Production].[ProductModelProductDescriptionCulture]
GROUP BY ProductModelID
ORDER BY ProductModelID;

-- add culture to the 1st excersice
SELECT 
[Production].[Product].ProductID, 
[Production].[Product].Name as ProductName, 
[Production].[ProductModel].Name as ProductModel,
[Production].[ProductModelProductDescriptionCulture].CultureID as Language,
[Production].[ProductDescription].Description as ProductDescription
FROM [Production].[Product]
LEFT JOIN [Production].[ProductModel]
ON [Production].[Product].ProductModelID = [Production].[ProductModel].ProductModelID
INNER JOIN [Production].[ProductModelProductDescriptionCulture]
ON [Production].[ProductModel].ProductModelID = [Production].[ProductModelProductDescriptionCulture].ProductModelID
LEFT JOIN [Production].[ProductDescription]
ON [Production].[ProductModelProductDescriptionCulture].ProductDescriptionID = [Production].[ProductDescription].ProductDescriptionID
ORDER By ProductID