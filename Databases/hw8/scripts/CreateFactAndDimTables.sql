USE NYCTaxiService;
GO

CREATE TABLE vendor_dim (
	vendor_id TINYINT PRIMARY KEY,
	description VARCHAR(30)
);
GO

INSERT INTO vendor_dim (vendor_id, description)
VALUES 
    (1, 'Creative Mobile Technologies'),
    (2, 'VeriFone Inc'),
	(3, 'Unknown');

CREATE TABLE datetime_dim (
	datetime_id BIGINT PRIMARY KEY,
	full_datetime DATETIME NOT NULL,
	day TINYINT NOT NULL,
	month TINYINT NOT NULL,
	year SMALLINT NOT NULL,
	hour TINYINT NOT NULL,
	minute TINYINT NOT NULL,
	second TINYINT NOT NULL,
	day_of_week TINYINT NOT NULL,
	day_name VARCHAR(20) NOT NULL
);
GO

CREATE TABLE rate_dim (
	rate_code_id TINYINT PRIMARY KEY,
	description VARCHAR(25)
);
GO

INSERT INTO rate_dim (rate_code_id, description)
VALUES 
    (1, 'Standart rate'),
    (2, 'JFK'),
	(3, 'Newark'),
	(4, 'Nassau or Westchester'),
    (5, 'Negotiated fare'),
	(6, 'Group ride');

CREATE TABLE payment_type_dim (
	payment_type_id TINYINT PRIMARY KEY,
	description VARCHAR(15)
);
GO

INSERT INTO payment_type_dim (payment_type_id, description)
VALUES 
    (1, 'Credit card'),
    (2, 'Cash'),
	(3, 'No charge'),
	(4, 'Dispute'),
    (5, 'Unknown'),
	(6, 'Voided trip');

CREATE TABLE store_flag_dim (
	store_flag_id TINYINT PRIMARY KEY,
	flag CHAR(1),
	description VARCHAR(30)
);
GO

INSERT INTO store_flag_dim (store_flag_id, flag, description)
VALUES 
    (1, 'Y', 'Store and forward trip'),
    (0, 'N', 'Not a store and forward trip');

CREATE TABLE taxi_zone_dim (
	taxi_zone_id SMALLINT PRIMARY KEY,
	borough VARCHAR(15),
	zone VARCHAR(50),
	service_zone VARCHAR(15)
);
GO

BULK INSERT dbo.taxi_zone_dim
FROM 'C:\Users\aliko\Documents\SET\SET_ML-Cloud\Databases\hw8\taxi_zone_lookup.csv'
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);
GO

CREATE TABLE taxi_trip_fact (
	trip_id INT PRIMARY KEY,
	vendor_id TINYINT FOREIGN KEY REFERENCES vendor_dim(vendor_id),
	pickup_datetime_id BIGINT FOREIGN KEY REFERENCES datetime_dim(datetime_id),
	dropoff_datetime_id BIGINT FOREIGN KEY REFERENCES datetime_dim(datetime_id),
	passenger_count TINYINT,
	trip_distance NUMERIC(8,2),
	rate_code_id TINYINT FOREIGN KEY REFERENCES rate_dim(rate_code_id),
	flag_id TINYINT FOREIGN KEY REFERENCES store_flag_dim(store_flag_id),
	pickup_loc_id SMALLINT FOREIGN KEY REFERENCES taxi_zone_dim(taxi_zone_id),
	dropoff_loc_id SMALLINT FOREIGN KEY REFERENCES taxi_zone_dim(taxi_zone_id),
	payment_type_id TINYINT FOREIGN KEY REFERENCES payment_type_dim(payment_type_id),
	fare_amount NUMERIC(6,2),
	extra NUMERIC(4,2),
	mta_tax NUMERIC(4,2),
	tip_amount NUMERIC(5,2),
	tolls_amount NUMERIC(5,2),
	improvement_supercharge NUMERIC(5,2),
	total_amount NUMERIC(6,2),
	congestion_supercharge NUMERIC(4,2),
	airport_fee NUMERIC(3,2)
);
GO