USE NYCTaxiService
GO

DROP TABLE IF EXISTS NYCTaxiService.dbo.logETL
   
CREATE TABLE NYCTaxiService.dbo.logETL
(
   RowID BIGINT IDENTITY(1, 1) NOT NULL,
   OperationName VARCHAR(100),
   LogTime DATETIME,
   [Source] VARCHAR(MAX),
   RowsAffected BIGINT,
   ErrorCode SMALLINT,
   ErrorLevel VARCHAR(10)
)
GO

DROP PROCEDURE IF EXISTS dbo.usp_log_etl
GO

CREATE PROCEDURE dbo.usp_log_etl 
	@operation_name VARCHAR(100),
	@error_level VARCHAR(10),
	@error_code SMALLINT, 
	@path_to_file VARCHAR(MAX),
	@rows_affected BIGINT
AS
BEGIN
	DECLARE @log_time AS DATETIME = GETDATE()

   INSERT INTO NYCTaxiService.dbo.logETL(OperationName, LogTime, [Source], RowsAffected, ErrorCode, ErrorLevel)
   VALUES (@operation_name, @log_time, @path_to_file, @rows_affected, @error_code, @error_level)
  
END
GO

DROP PROCEDURE IF EXISTS dbo.usp_upload_file
GO

CREATE PROCEDURE dbo.usp_upload_file @filename VARCHAR(100)
AS
BEGIN
   DECLARE @data_file_path NVARCHAR(255),
           @field_separator NVARCHAR(10),
           @row_separator NVARCHAR(10),
		   @row_count INT;

	EXEC dbo.usp_log_etl 
        @operation_name = 'START PROCEDURE usp_upload_file',
		@error_level = 'INFO',
		@error_code = 0, 
		@path_to_file = '',
		@rows_affected = 0;

	SET @data_file_path = 'C:\Users\aliko\Documents\SET\SET_ML-Cloud\Databases\Data\';
	SET @field_separator = ',';
	SET @row_separator = '0x0a';

	DROP TABLE IF EXISTS dbo.tbl_raw_data;

	CREATE TABLE dbo.tbl_raw_data (
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

	EXEC dbo.usp_log_etl 
        @operation_name = 'CREATE TABLE tbl_raw_data',
		@error_level = 'INFO',
		@error_code = 0, 
		@path_to_file = '',
		@rows_affected = 0;

    DECLARE @bulk_insert NVARCHAR(MAX);
    SET @bulk_insert = N'
    BULK INSERT dbo.tbl_raw_data
    FROM ''' + @data_file_path + @filename + '''
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ''' + @field_separator + ''',
        ROWTERMINATOR = ''' + @row_separator + '''
    )';

	-- Виконання BULK INSERT
	BEGIN TRY
		EXEC sp_executesql @bulk_insert;
		SET @row_count = @@ROWCOUNT; -- Підрахунок кількості рядків
		PRINT CONCAT('Rows Extracted: ', @row_count);
		EXEC dbo.usp_log_etl 
			@operation_name = 'BULK INSERT',
			@error_level = 'INFO',
			@error_code = 0, 
			@path_to_file = @filename,
			@rows_affected = @row_count;
	END TRY
	BEGIN CATCH
		PRINT 'Error during BULK INSERT: ' + ERROR_MESSAGE();
		EXEC dbo.usp_log_etl 
			@operation_name = 'BULK INSERT',
			@error_level = 'ERROR',
			@error_code = @@ERROR, 
			@path_to_file = @filename,
			@rows_affected = 0;
	END CATCH;

  	EXEC dbo.usp_log_etl 
			@operation_name = 'END PROCEDURE usp_upload_file',
			@error_level = 'INFO',
			@error_code = 0, 
			@path_to_file = 0,
			@rows_affected = 0;
END
GO

DROP PROCEDURE IF EXISTS dbo.usp_transformation
GO

CREATE PROCEDURE dbo.usp_transformation
AS
BEGIN

  	EXEC dbo.usp_log_etl 
			@operation_name = 'START PROCEDURE usp_transformation',
			@error_level = 'INFO',
			@error_code = 0, 
			@path_to_file = 0,
			@rows_affected = 0;

  DELETE FROM dbo.tbl_raw_data
	WHERE RateCodeID IS NULL OR RateCodeID > 6 OR RateCodeID <= 0

	EXEC dbo.usp_log_etl 
			@operation_name = 'CLEAN tbl_raw_data',
			@error_level = 'INFO',
			@error_code = @@ERROR, 
			@path_to_file = 0,
			@rows_affected = @@ROWCOUNT;

  	EXEC dbo.usp_log_etl 
			@operation_name = 'END PROCEDURE usp_transformation',
			@error_level = 'INFO',
			@error_code = 0, 
			@path_to_file = 0,
			@rows_affected = 0;
  
END
GO

DROP PROCEDURE IF EXISTS dbo.usp_load
GO

CREATE PROCEDURE dbo.usp_load
AS
BEGIN

  	EXEC dbo.usp_log_etl 
			@operation_name = 'START PROCEDURE usp_load',
			@error_level = 'INFO',
			@error_code = 0, 
			@path_to_file = 0,
			@rows_affected = 0;
  
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
        FROM dbo.tbl_raw_data
        WHERE CONVERT(BIGINT, FORMAT(PickupDatetime, 'ddMMyyyyHHmmss')) NOT IN (SELECT datetime_id FROM datetime_dim);

	EXEC dbo.usp_log_etl 
			@operation_name = 'INSERT INTO datetime_dim',
			@error_level = 'INFO',
			@error_code = @@ERROR, 
			@path_to_file = 0,
			@rows_affected = @@ROWCOUNT;

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
        FROM dbo.tbl_raw_data
        WHERE CONVERT(BIGINT, FORMAT(DropoffDatetime, 'ddMMyyyyHHmmss')) NOT IN (SELECT datetime_id FROM datetime_dim);

	EXEC dbo.usp_log_etl 
			@operation_name = 'INSERT INTO datetime_dim',
			@error_level = 'INFO',
			@error_code = @@ERROR, 
			@path_to_file = 0,
			@rows_affected = @@ROWCOUNT;

	-- Fill the fact table
	MERGE INTO taxi_trip_fact AS target
	USING (
		SELECT
			VendorID,
			CONVERT(BIGINT, FORMAT(PickupDatetime, 'ddMMyyyyHHmmss')) AS PickupDatetimeId,
			CONVERT(BIGINT, FORMAT(DropoffDatetime, 'ddMMyyyyHHmmss')) AS DropoffDatetimeId,
			PULocationID,
			DOLocationID,
			COALESCE(PassengerCount, 0) AS PassengerCount,
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
			END AS StoreFlagId
		FROM dbo.tbl_raw_data
	) AS source
	ON target.pickup_datetime_id = source.PickupDatetimeId
	   AND target.dropoff_datetime_id = source.DropoffDatetimeId
	   AND target.trip_distance = source.TripDistance -- Ensures uniqueness

	WHEN NOT MATCHED THEN
    INSERT (
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
    VALUES (
        source.VendorID,
        source.PickupDatetimeId,
        source.DropoffDatetimeId,
        source.PULocationID,
        source.DOLocationID,
        source.PassengerCount,
        source.TripDistance,
        source.RateCodeID,
        source.PaymentType,
        source.FareAmount,
        source.Extra,
        source.MTATax,
        source.ImprovementSupercharge,
        source.TipAmount,
        source.TollsAmount,
        source.TotalAmount,
        source.CongestionSurcharge,
        source.AirportFee,
        source.StoreFlagId
    );

	EXEC dbo.usp_log_etl 
			@operation_name = 'INSERT INTO fact',
			@error_level = 'INFO',
			@error_code = @@ERROR, 
			@path_to_file = 0,
			@rows_affected = @@ROWCOUNT;

  	EXEC dbo.usp_log_etl 
			@operation_name = 'END PROCEDURE usp_load',
			@error_level = 'INFO',
			@error_code = 0, 
			@path_to_file = 0,
			@rows_affected = 0;
END
GO

DROP PROCEDURE IF EXISTS dbo.usp_etl
GO

CREATE PROCEDURE dbo.usp_etl @filename VARCHAR(100)
AS
BEGIN
	PRINT 'ETL process Started';

	BEGIN TRANSACTION;

	BEGIN TRY
	  
		EXEC usp_upload_file @filename;
		EXEC usp_transformation;
		EXEC usp_load;

	  COMMIT TRANSACTION;
	  PRINT 'ETL process Finished Successfully';
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Error in ETL process: ' + ERROR_MESSAGE();
		EXEC dbo.usp_log_etl 
            @operation_name = 'ETL_PROCESS',
            @error_level = 'ERROR',
            @error_code = @@ERROR, 
            @path_to_file = @filename,
            @rows_affected = 0;
			PRINT 'ETL process Failed and Rolled Back';
	END CATCH;
END
GO