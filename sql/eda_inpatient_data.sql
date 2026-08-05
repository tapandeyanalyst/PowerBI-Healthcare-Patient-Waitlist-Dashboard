--EDA Inpatient Data - bronze.inpatientdata
/*
6 Types that we need to follow during exploratory data analysis
    1. Database exploration
    2. Dimension exploration
    3. Date exploration
    4. Measure exploration
    5. Magnitute
    6. Ranking

1. Dimensions and Measures
2. For all Dimensions check duplicates and Distinct values
*/
USE HealthCareDB
GO
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bronze'
  AND TABLE_NAME = 'outpatientdata'
ORDER BY ORDINAL_POSITION;
/*
COLUMN_NAME 	DATA_TYPE       Dimensions/Measures
archive_date	date            Dimensions
specialty_hipe	int             Dimensions
Speciality	    nvarchar        Dimensions
adult_child	    nvarchar        Dimensions
age_profile	    nvarchar        Dimensions
time_bands	    nvarchar        Dimensions
total	        int             Measures
*/

--1. Database exploration
    SELECT * FROM INFORMATION_SCHEMA.TABLES
    /*
    TABLE_CATALOG	TABLE_SCHEMA	TABLE_NAME	    TABLE_TYPE
    HealthCareDB	bronze	        inpatientdata	BASE TABLE
    HealthCareDB	bronze	        outpatientdata	BASE TABLE
    So, we have 2 tables for this database.
    */
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'inpatientdata'
    --The inpatientdata has 8 columns. 
    /*
    archive_date
    specialty_hipe
    specialty_name
    case_type
    adult_child
    age_profile
    time_bands
    total
    */

-- checking duplicates and distinct values for specialty_hipe
select Distinct specialty_hipe from bronze.inpatientdata
select specialty_hipe, count(*) as duplicate from bronze.inpatientdata
group by specialty_hipe
having count(*) > 1

