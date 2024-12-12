USE AdventureWorks2022
GO


--- Task 1 - Make queries in a loop to search for even ProductModelID

DECLARE @StartTime DATETIME = GETDATE();

DECLARE @counter int = 2
DECLARE @max_product_id int = (SELECT MAX(ProductModelID) FROM [Production].[Product])
DECLARE @idx int = 0

PRINT @max_product_id

WHILE  @counter <= @max_product_id
BEGIN
	IF EXISTS (SELECT 1 FROM [Production].[Product] WHERE ProductModelID = @counter)
		SELECT ProductModelID, *
        FROM [Production].[Product]
        WHERE ProductModelID = @counter;

	SET @counter = @counter + 2
	SET @idx = @idx + 1
	PRINT @idx
END

DECLARE @EndTime DATETIME = GETDATE();

SELECT DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS ExecutionTime_ms;

--- Task 2 - Search for even ProductModelID with default query

DECLARE @StartTime DATETIME = GETDATE();

SELECT ProductModelID, *
FROM [Production].[Product]
WHERE ProductModelID % 2 = 0
ORDER BY [Production].[Product].ProductModelID;

DECLARE @EndTime DATETIME = GETDATE();
SELECT DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS ExecutionTime_ms;

--- Task ? - Search for even ProductModelID with default query

DECLARE @StartTime DATETIME = GETDATE();

CREATE TABLE #EVEN_IDS (ProductModelID INT);
DECLARE @counter int = 2
DECLARE @max_product_id int = (SELECT MAX(ProductModelID) FROM [Production].[Product])

WHILE  @counter <= @max_product_id
BEGIN
	IF EXISTS (SELECT 1 FROM [Production].[Product] WHERE ProductModelID = @counter)
		INSERT INTO #EVEN_IDS (ProductModelID) VALUES (@counter)

	SET @counter = @counter + 2
END

SELECT p.ProductModelID, p.*
FROM [Production].[Product] p
INNER JOIN #EVEN_IDS e
ON p.ProductModelID = e.ProductModelID
ORDER BY p.ProductModelID;

-- Drop the temporary table
DROP TABLE #EVEN_IDS;

DECLARE @EndTime DATETIME = GETDATE();
SELECT DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS ExecutionTime_ms;