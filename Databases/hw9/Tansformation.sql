USE NYCTaxiService;
GO

-- Remove records where rate code is empty or 99
DELETE FROM NYCTaxiService.dbo.tbl_raw_data
WHERE RateCodeID IS NULL OR RateCodeID > 6 OR RateCodeID <= 0

-- Transform pickup dates from raw table into date dim
INSERT INTO datetime_dim (datetime_id, full_datetime, day, month, year, hour, minute, second, day_of_week, day_name)
        SELECT DISTINCT 
            CONVERT(BIGINT, FORMAT(PickupDatetime, 'ddMMyyyyHHmmss')) AS datetime_id,
            PickupDatetime AS full_datetime,
            DATEPART(DAY, PickupDatetime) AS day,
            DATEPART(MONTH, PickupDatetime) AS month,
            DATEPART(YEAR, PickupDatetime) AS year,
            DATEPART(HOUR, PickupDatetime) AS hour,
            DATEPART(MINUTE, PickupDatetime) AS minute,
            DATEPART(SECOND, PickupDatetime) AS second,
            DATEPART(WEEKDAY, PickupDatetime) AS day_of_week,
            DATENAME(WEEKDAY, PickupDatetime) AS day_name
        FROM NYCTaxiService.dbo.tbl_raw_data
        WHERE CONVERT(BIGINT, FORMAT(PickupDatetime, 'ddMMyyyyHHmmss')) NOT IN (SELECT datetime_id FROM datetime_dim);

-- Transform dropoff dates from raw table into date dim
INSERT INTO datetime_dim (datetime_id, full_datetime, day, month, year, hour, minute, second, day_of_week, day_name)
        SELECT DISTINCT 
            CONVERT(BIGINT, FORMAT(DropoffDatetime, 'ddMMyyyyHHmmss')) AS datetime_id,
            DropoffDatetime AS full_datetime,
            DATEPART(DAY, DropoffDatetime) AS day,
            DATEPART(MONTH, DropoffDatetime) AS month,
            DATEPART(YEAR, DropoffDatetime) AS year,
            DATEPART(HOUR, DropoffDatetime) AS hour,
            DATEPART(MINUTE, DropoffDatetime) AS minute,
            DATEPART(SECOND, DropoffDatetime) AS second,
            DATEPART(WEEKDAY, DropoffDatetime) AS day_of_week,
            DATENAME(WEEKDAY, DropoffDatetime) AS day_name
        FROM NYCTaxiService.dbo.tbl_raw_data
        WHERE CONVERT(BIGINT, FORMAT(DropoffDatetime, 'ddMMyyyyHHmmss')) NOT IN (SELECT datetime_id FROM datetime_dim);

-- Fill the fact table
 INSERT INTO taxi_trip_fact (
            trip_id,
            vendor_id,
            pickup_datetime_id,
            dropoff_datetime_id,
			pickup_loc_id,
			dropoff_loc_id,
            passenger_count,
            trip_distance,
            rate_code_id,
            payment_type_id,
            fare_amount,
            extra,
            mta_tax,
            improvement_supercharge,
            tip_amount,
            tolls_amount,
            total_amount,
            congestion_supercharge,
            airport_fee,
            flag_id
        )
        SELECT 
            ROW_NUMBER() OVER (ORDER BY PickupDatetime) AS trip_id,
            VendorID,
            CONVERT(bigint, FORMAT(PickupDatetime, 'ddMMyyyyHHmmss')) AS pickup_datetime_id,
            CONVERT(bigint, FORMAT(DropoffDatetime, 'ddMMyyyyHHmmss')) AS dropoff_datetime_id,
			PULocationID,
			DOLocationID,
            COALESCE(PassengerCount, 0) AS passenger_count,
            TripDistance,
            RateCodeID,
            PaymentType,
            FareAmount,
            Extra,
            MTATax,
            ImprovementSupercharge,
            TipAmount,
            TollsAmount,
            TotalAmount,
            CongestionSurcharge,
            AirportFee,
            CASE 
                WHEN StoreAndFwdFlag = 'Y' THEN 1
                ELSE 0
			END AS store_flag_id
        FROM NYCTaxiService.dbo.tbl_raw_data

-- Check that number of raw rows were same as for fact
SELECT COUNT(*) AS RawDataCount
FROM NYCTaxiService.dbo.tbl_raw_data;

SELECT COUNT(*) AS FactTableCount
FROM taxi_trip_fact;

-- Check that data filled correctly
SELECT TOP 10 *
FROM taxi_trip_fact
ORDER BY total_amount DESC;

-- Check that dimentions works correctly
-- by printing date and zones
SELECT TOP 10
    taxi_fact.trip_id,
    taxi_fact.pickup_datetime_id,
    date_dim.full_datetime AS pickup_datetime,
    date_dim.day_name AS day_of_week,
    zone_pickup.borough AS pickup_borough,
    zone_pickup.zone AS pickup_zone,
    zone_pickup.service_zone AS pickup_service_zone,
    zone_dropoff.borough AS dropoff_borough,
    zone_dropoff.zone AS dropoff_zone,
    zone_dropoff.service_zone AS dropoff_service_zone,
    taxi_fact.passenger_count,
    taxi_fact.trip_distance,
    taxi_fact.total_amount
FROM 
    taxi_trip_fact taxi_fact
INNER JOIN 
    datetime_dim date_dim
ON 
    taxi_fact.pickup_datetime_id = date_dim.datetime_id
LEFT JOIN 
    taxi_zone_dim zone_pickup
ON 
    taxi_fact.pickup_loc_id = zone_pickup.taxi_zone_id
LEFT JOIN 
    taxi_zone_dim zone_dropoff
ON 
    taxi_fact.dropoff_loc_id = zone_dropoff.taxi_zone_id
ORDER BY 
    date_dim.full_datetime;
