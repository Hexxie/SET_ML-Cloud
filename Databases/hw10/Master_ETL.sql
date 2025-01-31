USE NYCTaxiService
GO

EXEC dbo.usp_etl 'yellow_tripdata_2024-01.csv';
EXEC dbo.usp_etl 'yellow_tripdata_2024-02.csv';

SELECT * 
FROM NYCTaxiService.dbo.logETL