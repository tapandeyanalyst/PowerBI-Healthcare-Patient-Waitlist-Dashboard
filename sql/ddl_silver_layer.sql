/*
========================================================
DDL Scripts: Create Silver Tables
========================================================
Script Purpose:
  This script creates tables in the 'silver' schema, dropping any existing tables if they already exist. 
  Run this script to re-defind the DDL Structure of 'silver' Tables.
 */

USE HealthCareDB;
GO

--Mapping Table
IF OBJECT_ID ('silver.[speciality_mapping]', 'U') IS NOT NULL
	DROP TABLE silver.[speciality_mapping];
CREATE TABLE silver.[speciality_mapping] 
(
	speciality			NVARCHAR(100),
	speciality_group	NVARCHAR(100),
	dwh_create_date DATETIME2 DEFAULT GETDATE() -- This is added to record when the data was last added.
);
GO


