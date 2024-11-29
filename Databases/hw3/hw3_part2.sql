SELECT *
FROM [AdventureWorks2022].[Sales].[vSalesPerson]

-- Overall statistic
SELECT
BusinessEntityID,
FirstName + ' '  + LastName as Name, 
JobTitle, 
CountryRegionName, 
PhoneNumber, 
PhoneNumberType,
SalesYTD,
FORMAT((SalesYTD * 1.0) / SUM(SalesYTD) OVER (), 'P2') AS SalesYTDPercentage,
SUM(SalesYTD) OVER () AS TotalSalesYTD
FROM [AdventureWorks2022].[Sales].[vSalesPerson]

-- If we want to get a statistic by country
SELECT
BusinessEntityID,
FirstName + ' '  + LastName as Name, 
JobTitle, 
CountryRegionName, 
PhoneNumber, 
PhoneNumberType,
SalesYTD,
FORMAT((SalesYTD * 1.0) / SUM(SalesYTD) OVER (PARTITION BY CountryRegionName), 'P2') AS SalesYTDPercentage,
SUM(SalesYTD) OVER (PARTITION BY CountryRegionName ORDER BY BusinessEntityID) AS TotalSalesYTD
FROM [AdventureWorks2022].[Sales].[vSalesPerson]