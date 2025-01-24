CREATE DATABASE NYCTaxiService;

USE NYCTaxiService;
GO


CREATE TABLE tbl_raw_data (
    VendorID TINYINT,
	PickupDatetime DATETIME,
	DropoffDatetime DATETIME,
	PassengerCount NUMERIC(2,1),
	TripDistance NUMERIC(8,2),
	RateCodeID NUMERIC(4,2),
	StoreAndFwdFlag CHAR(1),
	PULocationID SMALLINT,
	DOLocationID SMALLINT,
	PaymentType TINYINT,
	FareAmount NUMERIC(6,2),
	Extra NUMERIC(4,2),
	MTATax  NUMERIC(4,2),
	TipAmount NUMERIC(5,2),
	TollsAmount NUMERIC(5,2),
	ImprovementSupercharge NUMERIC(5,2),
	TotalAmount NUMERIC(6,2),
	CongestionSurcharge NUMERIC(4,2),
	AirportFee NUMERIC(3,2)
);
GO

BULK INSERT dbo.tbl_raw_data
FROM 'C:\Users\aliko\Documents\SET\SET_ML-Cloud\Databases\hw8\yellow_tripdata_2024-01.csv'
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);
GO