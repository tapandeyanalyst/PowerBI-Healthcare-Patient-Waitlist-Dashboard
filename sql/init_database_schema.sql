USE MASTER;
GO
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'HealthCareDB') --Drop and recreate the 'DataWarehouseDB' database if exist
BEGIN
	ALTER DATABASE HealthCareDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE HealthCareDB;
END;
GO
CREATE DATABASE HealthCareDB; -- Create the 'DataWarehouseDB' database
GO
USE HealthCareDB;
GO
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO

