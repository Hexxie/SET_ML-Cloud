## HW4: Create database based on previous design
 
For this homework were used Design from hw3 - Library ER-diagram.

Base Database is [AdventureWorks sample 2022](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms)

Before Scripts execution create Library Schema:
```
USE AdventureWorks2022;
CREATE SCHEMA Library;
```

1. Execute TableCreation.sql - for creating all tables
2. Execute ViewsCreation.sql - for creating useful views to check the business rules of database
3. Execute DataInsertion.sql - to insert example data and check it with basic queries
