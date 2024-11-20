-- All values from vSalesPerson
SELECT *
FROM [AdventureWorks2022].[Sales].[vSalesPerson]

-- All Sales Representatives from the USA and their Cell phones
SELECT FirstName + ' ' + MiddleName + ' ' + LastName as Name , JobTitle, CountryRegionName, PhoneNumber, PhoneNumberType
FROM [AdventureWorks2022].[Sales].[vSalesPerson]
WHERE CountryRegionName = 'United States' AND JobTitle = 'Sales Representative' AND PhoneNumberType <> 'Work'

-- All Sales Representatives from other than the USA contries and their Cell phones
SELECT FirstName + ' ' + MiddleName + ' ' + LastName as Name, JobTitle, CountryRegionName, PhoneNumber, PhoneNumberType
FROM [AdventureWorks2022].[Sales].[vSalesPerson]
WHERE CountryRegionName <> 'United States' AND JobTitle = 'Sales Representative' AND PhoneNumberType <> 'Work'

-- For each country count nr of workers, sum of SalesYTD and Sales YTD average
SELECT CountryRegionName, count(FirstName) as NrOfWorkers, sum(SalesYTD) as SalesYTD, avg(SalesYTD) as SalesYTDInAverage
FROM [AdventureWorks2022].[Sales].[vSalesPerson]
GROUP BY CountryRegionName ORDER BY NrOfWorkers ASC
