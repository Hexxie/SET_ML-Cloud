-- Перевірити чи є записи де відсутній вендор
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE VendorID IS NULL

-- Перевірити чи є записи де вендор не відповідає документації
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE VendorID <> '1' AND VendorID <> '2'

-- Перевірка дат
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE PickupDatetime IS NULL

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE DropoffDatetime IS NULL

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE DropoffDatetime = PickupDatetime


-- Пошук дублікатів по датам
SELECT PickupDatetime, DropoffDatetime, COUNT(*) AS Count
FROM NYCTaxiService.dbo.tbl_raw_data
GROUP BY PickupDatetime, DropoffDatetime
ORDER BY PickupDatetime, DropoffDatetime;

-- Перегляд повних записів по знайденій даті за 2002 рік
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE YEAR(PickupDatetime) = 2002;

-- Перевірка кількості пасажирів
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE PassengerCount IS NULL

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE PassengerCount > 8

-- Перевірка відстані
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE TripDistance IS NULL

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE TripDistance = 0

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE TripDistance < 0

-- Перевірка rate_code_id
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE RateCodeID <= 0 OR RateCodeID > 6

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE RateCodeID IS NULL

-- Перевірка StoreAndFwdFlag
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE StoreAndFwdFlag IS NULL AND RateCodeID IS NOT NULL

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE StoreAndFwdFlag <> 'Y' AND StoreAndFwdFlag <> 'N'

-- Перевірка LocationID
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE PULocationID IS NULL

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE DOLocationID IS NULL

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE DOLocationID = PULocationID

-- Перевірка PaymentType 
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE PaymentType IS NULL

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE PaymentType <= 0 OR PaymentType > 6

-- Перевірка FareAmount
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE FareAmount IS NULL

--тут видно що є негативні значення у інших колонках, які не будемо додатково перевіряти на негативні значення
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE FareAmount < 0

-- Перевірка інших факт полів на NULL
SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE FareAmount IS NULL OR 
	  Extra IS NULL OR 
	  MTATax IS NULL OR 
	  TipAmount IS NULL OR 
	  TollsAmount IS NULL OR 
	  ImprovementSupercharge IS NULL OR 
	  TotalAmount IS NULL OR
	  CongestionSurcharge IS NULL OR 
	  AirportFee IS NULL

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE ImprovementSupercharge <> 0.3
ORDER BY PickupDatetime

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE ImprovementSupercharge = 0.3

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE TipAmount < 0

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE TollsAmount < 0

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE TotalAmount < 0

SELECT *
FROM NYCTaxiService.dbo.tbl_raw_data
WHERE AirportFee <> 1.25

-- Пошук дублікованих записів за Case_Number
SELECT ImprovementSupercharge, COUNT(*) AS Duplicate_Count
FROM NYCTaxiService.dbo.tbl_raw_data
GROUP BY ImprovementSupercharge
HAVING COUNT(*) > 1;

-- Пошук дублікатів де ImprovementSupercharge - негативне
SELECT 
    a.PickupDatetime AS PickupDatetime_A,
    a.DropoffDatetime AS DropoffDatetime_A,
    a.PassengerCount AS PassengerCount_A,
    a.TripDistance AS TripDistance_A,
    a.ImprovementSupercharge AS ImprovementSupercharge_A,
    b.PickupDatetime AS PickupDatetime_B,
    b.DropoffDatetime AS DropoffDatetime_B,
    b.PassengerCount AS PassengerCount_B,
    b.TripDistance AS TripDistance_B,
    b.ImprovementSupercharge AS ImprovementSupercharge_B
FROM NYCTaxiService.dbo.tbl_raw_data a
INNER JOIN NYCTaxiService.dbo.tbl_raw_data b
ON a.PickupDatetime = b.PickupDatetime
   AND a.DropoffDatetime = b.DropoffDatetime
   AND a.TripDistance = b.TripDistance
   AND a.PassengerCount = b.PassengerCount
   AND a.ImprovementSupercharge = -b.ImprovementSupercharge
ORDER BY a.PickupDatetime;