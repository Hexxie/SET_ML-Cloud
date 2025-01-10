USE AdventureWorks2022;
GO

SELECT * 
FROM [Production].Product
ORDER BY ListPrice ASC

BEGIN TRAN

UPDATE price
SET ListPrice=1
FROM [Production].Product price
WHERE ProductID=1

COMMIT TRAN


SELECT * 
FROM [Production].Product
WHERE ProductID=1
ORDER BY ListPrice ASC

BEGIN TRAN

UPDATE price
SET ListPrice=2
FROM [Production].Product price
WHERE ProductID=1




