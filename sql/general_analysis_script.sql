USE [HealthCareDB]

/*
EXEC sp_rename 'bronze.outpatientdata.specialty',  'Speciality', 'COLUMN';
*/

--Checking coulumn names

/*
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bronze'
  AND TABLE_NAME = 'outpatientdata'
ORDER BY ORDINAL_POSITION;
*/
--Remove a column
--ALTER TABLE bronze.outpatientdata
--DROP COLUMN case_type;

SELECT COUNT(*) FROM bronze.outpatientdata