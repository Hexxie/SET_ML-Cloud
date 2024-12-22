SELECT *
FROM 
    [AdventureWorks2022].[Sales].[SalesOrderHeader]


SELECT 
    TerritoryID,
    COUNT(*) AS OrderCount
FROM 
    [AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
    TerritoryID
ORDER BY 
    TerritoryID;

SELECT 
    SalesPersonID,
    COUNT(*) AS OrderCount
FROM 
    [AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
    SalesPersonID
ORDER BY 
    SalesPersonID;

SELECT 
    ShipMethodID,
    COUNT(*) AS OrderCount
FROM 
    [AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
    SalesPersonID
ORDER BY 
    SalesPersonID;

SELECT 
    YEAR(DueDate) AS DueYear,
    MONTH(DueDate) AS DueMonth,
	YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    COUNT(*) AS OrderCount
FROM 
    [AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
    YEAR(DueDate), 
    MONTH(DueDate),
	YEAR(OrderDate), 
    MONTH(OrderDate)
ORDER BY 
    DueYear, 
    DueMonth;

SELECT 
    YEAR(ShipDate) AS ShipYear,
    MONTH(ShipDate) AS ShipMonth,
    COUNT(*) AS OrderCount
FROM 
    [AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
    YEAR(ShipDate), 
    MONTH(ShipDate)
ORDER BY 
    ShipYear, 
    ShipMonth;

-- Create partition function
CREATE PARTITION FUNCTION ShipDatePartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2011-12-31', '2012-12-31', '2013-12-31', '2014-12-31')

-- Check that partition function created
SELECT
name, function_id, type, type_desc, boundary_value_on_right 
FROM sys.partition_functions

-- Create Filegroups
ALTER DATABASE AdventureWorks2022 ADD FILEGROUP FG_2011;
ALTER DATABASE AdventureWorks2022 ADD FILEGROUP FG_2012;
ALTER DATABASE AdventureWorks2022 ADD FILEGROUP FG_2013;
ALTER DATABASE AdventureWorks2022 ADD FILEGROUP FG_2014;
ALTER DATABASE AdventureWorks2022 ADD FILEGROUP FG_2015;

-- Check that filegroups created
SELECT *
FROM sys.filegroups
WHERE type = 'FG'

-- Create datafiles
ALTER DATABASE AdventureWorks2022 ADD FILE 
(
	NAME = P_2011,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2011.ndf'
) TO FILEGROUP FG_2011;

ALTER DATABASE AdventureWorks2022 ADD FILE 
(
	NAME = P_2012,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2012.ndf'
) TO FILEGROUP FG_2012;

ALTER DATABASE AdventureWorks2022 ADD FILE 
(
	NAME = P_2013,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2013.ndf'
) TO FILEGROUP FG_2013;

ALTER DATABASE AdventureWorks2022 ADD FILE 
(
	NAME = P_2014,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2014.ndf'
) TO FILEGROUP FG_2014;

ALTER DATABASE AdventureWorks2022 ADD FILE 
(
	NAME = P_2015,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2015.ndf'
) TO FILEGROUP FG_2015;

-- Check the files
SELECT
	fg.name  AS FilegroupName,
	mf.name AS LogicalFileName,
	mf.physical_name AS PhysicalFilePath,
	mf.size / 128 AS SizeInMB
From
	sys.filegroups fg
JOIN
	sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE
	mf.database_id = DB_ID('AdventureWorks2022')

-- Define a function scheme
CREATE PARTITION SCHEME SchemeShipDatePartitionByYear
AS PARTITION ShipDatePartitionByYear
TO (FG_2011, FG_2012, FG_2013, FG_2014, FG_2015)

-- Create the partitioned table
CREATE TABLE [AdventureWorks2022].[Sales].[SalesOrderHeader_Partitioned] (
    [SalesOrderID] INT NOT NULL,
    [ShipDate] DATE NOT NULL,
    [OrderDate] DATE NOT NULL,
    [DueDate] DATE NOT NULL,
    [TerritoryID] INT NOT NULL,
    [CustomerID] INT NOT NULL,
    [TotalDue] MONEY NOT NULL,
    [ShipMethodID] INT NOT NULL,
    [BillToAddressID] INT NOT NULL,
    [ShipToAddressID] INT NOT NULL
)
ON SchemeShipDatePartitionByYear(ShipDate);

INSERT INTO [AdventureWorks2022].[Sales].[SalesOrderHeader_Partitioned]
SELECT 
    [SalesOrderID],
    [ShipDate],
    [OrderDate],
    [DueDate],
    [TerritoryID],
    [CustomerID],
    [TotalDue],
    [ShipMethodID],
    [BillToAddressID],
    [ShipToAddressID]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader];

-- Check that records fall into the correct partitions
SELECT
	p.partition_number AS PartitionNumber,
	f.name AS PartitionFilegroup,
	p.rows AS NumberOfRows
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'SalesOrderHeader_Partitioned';

SELECT 
    YEAR(ShipDate) AS OrderYear,
    COUNT(*) AS OrderCount
FROM 
    [AdventureWorks2022].[Sales].[SalesOrderHeader]
WHERE 
    YEAR(ShipDate) = 2014
GROUP BY 
    YEAR(ShipDate)
ORDER BY 
    OrderYear;