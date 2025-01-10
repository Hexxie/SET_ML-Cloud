SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; --ListPrice=2
SELECT * 
FROM [Production].Product
WHERE ProductID=1
ORDER BY ListPrice ASC

--READ COMMITTED
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * 
FROM [Production].Product
WHERE ProductID=1
ORDER BY ListPrice ASC

--REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * 
FROM [Production].Product
WHERE ProductID=1
ORDER BY ListPrice ASC

--SNAPSHOT
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;  --Transaction Failed
SELECT * 
FROM [Production].Product
WHERE ProductID=1
ORDER BY ListPrice ASC

--SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * 
FROM [Production].Product
WHERE ProductID=1
ORDER BY ListPrice ASC
