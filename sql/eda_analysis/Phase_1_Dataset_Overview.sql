USE HealthCareDB

--Phase 1 — Dataset Overview
--Objective: Build a high-level understanding of each Bronze table before examining individual columns. 

/*
Findings:
1. inpatient and outpatient are fact table
2. spciality mapping table is a lookup table.
3. Inpatient table has 182136 record counts with 8 coloumns
4. Outpatient Table has 270983 record counts with 7 columns
5. speciality mapping table has 78 record counts with 3 columns
6. considered specialty_hipe as a dimension because in the Hospital In-Patient Enquiry (HIPE) system, 
   the specialty of a case is a code assigned based on the specialty assignment of the consultant 
   associated with the patient's principal diagnosis.
*/

Print '================================================'
Print 'Data Inventory'
Print '================================================'
-- Get the Table in Bronze Layer
SELECT 
    TABLE_SCHEMA AS [Schema],
    TABLE_NAME AS [Table Name],
    
    CASE 
    WHEN TABLE_NAME IN('inpatientdata','outpatientdata') THEN 'Fact'
    WHEN TABLE_NAME = 'speciality_mapping' THEN 'Lookup'
    ELSE NULL
    END AS [Table Role]
    
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bronze'
GROUP BY TABLE_SCHEMA, TABLE_NAME

/*
Schema	Table Name	        Table Role      Purpose
bronze	inpatientdata	    Fact            Stores monthly inpatient and day-case waiting list records
bronze	outpatientdata	    Fact            Stores monthly outpatient waiting list records.
bronze	speciality_mapping	Lookup          Maps each specialty to a business-friendly specialty group.
*/

--Understanding Grain
SELECT TOP 1 * FROM bronze.inpatientdata;
SELECT TOP 1 * FROM bronze.outpatientdata;
SELECT TOP 1 * FROM bronze.speciality_mapping;

--Counting Table Rows
SELECT COUNT(*) FROM bronze.inpatientdata;
SELECT COUNT(*) FROM bronze.outpatientdata;
SELECT COUNT(*) FROM bronze.speciality_mapping;
/*
Table Grain:
Schema	Table Name	        Table Role      Grain
bronze	inpatientdata	    Fact            One row represent the inpatient data for a particular date
bronze	outpatientdata	    Fact            One row represent the outpatient data for a particular date
bronze	speciality_mapping	Lookup          One row represent which speciality group a speciality belongs
*/
-- Counting Number of Columns
SELECT
    TABLE_NAME,
    COUNT(*) AS Total_Columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bronze'
GROUP BY TABLE_NAME;
/*
Schema	Table Name	            Counts     #Columns 
bronze	inpatientdata	        182136      8
bronze	outpatientdata	        270983      7
bronze	speciality_mapping	    78          2
*/

Print '================================================'
Print 'Column Inventory'
Print '================================================'

SELECT
    TABLE_NAME,
    ORDINAL_POSITION,
    COLUMN_NAME,
    DATA_TYPE,
    CASE
    WHEN DATA_TYPE = 'date' THEN 'Date'
    WHEN DATA_TYPE = 'nvarchar' THEN 'Dimensions'
    WHEN DATA_TYPE = 'int' AND COLUMN_NAME != 'specialty_hipe' THEN 'Measure'
    WHEN DATA_TYPE = 'int' AND COLUMN_NAME = 'specialty_hipe' THEN 'Dimension'
    ELSE NULL
    END AS column_role
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bronze'
ORDER BY TABLE_NAME, ORDINAL_POSITION;
/*
TABLE_NAME	        ORDINAL_POSITION    COLUMN_NAME	        DATA_TYPE	    column_role
inpatientdata	    1	                archive_date	    date	        Date
inpatientdata	    2	                specialty_hipe	    int	            Dimension
inpatientdata	    3	                specialty_name	    nvarchar	    Dimensions
inpatientdata	    4	                case_type	        nvarchar	    Dimensions
inpatientdata	    5	                adult_child	        nvarchar	    Dimensions
inpatientdata	    6	                age_profile	        nvarchar	    Dimensions
inpatientdata	    7	                time_bands	        nvarchar	    Dimensions
inpatientdata	    8	                total	            int	            Measure
outpatientdata	    1	                archive_date	    date	        Date
outpatientdata	    2	                specialty_hipe	    int	            Dimension
outpatientdata	    3	                Speciality	        nvarchar	    Dimensions
outpatientdata	    4	                adult_child	        nvarchar	    Dimensions
outpatientdata	    5	                age_profile	        nvarchar	    Dimensions
outpatientdata	    6	                time_bands	        nvarchar	    Dimensions
outpatientdata	    7	                total	            int	            Measure
speciality_mapping	1	                specialty	        nvarchar	    Dimensions
speciality_mapping	2	                specialty_group	    nvarchar	    Dimensions
*/












USE HealthCareDB

--Phase 1  : Dataset Overview

--Bronze Table Inventory
SELECT 
    TABLE_SCHEMA AS [Schema],
    TABLE_NAME AS [Table Name],
    ORDINAL_POSITION as [Ordinal Position],

    COLUMN_NAME AS [Column Name],
    DATA_TYPE AS [Data Type],
    '' AS Category,
    '' AS [Business Meaning]

   FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bronze'
ORDER BY TABLE_NAME, ORDINAL_POSITION;