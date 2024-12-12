DECLARE @filename AS NVARCHAR(255) = N'C:\Users\aliko\Dropbox\Збірник рецептур нац. страв. Шалимінов О.В. 2007\Страви з картоплі овочів грибів.pdf';

SELECT 
	type = CASE
	WHEN PATINDEX('%:%', value) > 0 THEN 'Drive ->'
	WHEN PATINDEX('%.%', value) > 0 THEN 'File -> '
	ELSE 'Folder ->'
	END,
	value FROM string_split(@filename, '\')