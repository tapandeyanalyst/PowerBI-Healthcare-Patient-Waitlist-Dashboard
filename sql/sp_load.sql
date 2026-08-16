USE HealthCareDB;
GO

CREATE OR ALTER PROCEDURE dbo.sp_load
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- Step 1: Load Silver Layer
        EXEC silver.load_silver;

        -- Step 2: Gold Layer
        -- Gold is a view, so no physical load is required.
        -- The view automatically reflects the latest Silver data.

    END TRY

    BEGIN CATCH

        THROW;

    END CATCH
END;
GO