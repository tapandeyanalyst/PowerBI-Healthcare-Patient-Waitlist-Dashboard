USE HealthCareDB;
GO

--Healt Care Tables
IF OBJECT_ID ('bronze.inpatientdata', 'U') IS NOT NULL
	DROP TABLE bronze.inpatientdata;
-- schema.<sourcesystem>_<entity>
CREATE TABLE bronze.inpatientdata 
(
	archive_date	DATE,
	specialty_hipe	INT,
	specialty_name	NVARCHAR(100),
	case_type		NVARCHAR(50),
	adult_child		NVARCHAR(50),
	age_profile		NVARCHAR(50),
	time_bands		NVARCHAR(50),
	total			INT
);

GO

IF OBJECT_ID ('bronze.outpatientdata', 'U') IS NOT NULL
	DROP TABLE bronze.outpatientdata;
CREATE TABLE bronze.outpatientdata 
(
	archive_date	DATE,
	specialty_hipe	INT,
	specialty_name	NVARCHAR(100),
	case_type		NVARCHAR(50),
	adult_child		NVARCHAR(50),
	age_profile		NVARCHAR(50),
	time_bands		NVARCHAR(50),
	total			INT
);

IF OBJECT_ID ('bronze.specialty_mapping', 'U') IS NOT NULL
	DROP TABLE bronze.specialty_mapping;
CREATE TABLE bronze.specialty_mapping 
(
	specialty       NVARCHAR(100),
	specialty_group	NVARCHAR(100)
);