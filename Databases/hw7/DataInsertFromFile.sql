USE Crimes;
GO

CREATE TABLE tbl_raw_data (
	ID BIGINT,
	CaseNumber CHAR(8),
	Date DATETIME,
	Block VARCHAR(50),
    IUCR VARCHAR(10),
    PrimaryType VARCHAR(50),
    Description VARCHAR(100),
    LocaLDescription VARCHAR(100),
    Arrest CHAR(5),
    Domestic CHAR(5),
    Beat SMALLINT,
    District TINYINT,
    Ward TINYINT,
    CommunityArea TINYINT,
    FBICode CHAR(3),
    XCoordinate INT,
    YCoordinate INT,
    Year DATE,
    UpdatedOn DATETIME,
    Latitude NUMERIC(12,9),
    Longitude NUMERIC(12,9),
    Location VARCHAR(50)
);
GO

BULK INSERT dbo.tbl_raw_data
FROM 'C:\Users\aliko\Documents\SET\SET_ML-Cloud\Databases\hw7\Crimes-2020_20240715.csv'
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'
);
GO

SELECT TOP 100 * FROM dbo.tbl_raw_data;

SELECT @@ROWCOUNT

TRUNCATE TABLE dbo.tbl_raw_data
GO

INSERT INTO Crimes.dbo.tbl_raw_data
SELECT crimes_insert.*
FROM OPENROWSET
(
	BULK 'C:\Users\aliko\Documents\SET\SET_ML-Cloud\Databases\hw7\Crimes-2020_20240715.csv',
	FORMATFILE = 'C:\Users\aliko\Documents\SET\SET_ML-Cloud\Databases\hw7\CrimesFormat.xml',
	FORMAT = 'CSV',
	CODEPAGE = '65001',
	FIRSTROW = 2
) AS crimes_insert
GO
