USE HealthCareDB
GO
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    TRUNCATE TABLE silver.patientwaitlistdata;
    INSERT INTO silver.patientwaitlistdata
    (
        data_category,
        archive_date,
        speciality_hipe,
        speciality_name,
        case_type,
        adult_child,
        age_profile,
        time_bands,
        total
    )
    SELECT
        data_category,
        archive_date,
        speciality_hipe,
        speciality_name,
        case_type,
        CASE
           WHEN TRIM(age_profile) = '1-16' THEN 'Child'
           WHEN TRIM(age_profile) = '17-59' THEN 'Adult'
           WHEN TRIM(age_profile) = '60+' THEN 'Senior Citizens'
           ELSE adult_child END AS adult_child,
        age_profile,
        time_bands,
        total
    FROM(

    -----------------------------------Transformation Script Starts

            SELECT
                data_category,          -- Transformation Not Required
                archive_date,           -- Transformation Not Required
                speciality_hipe,
                TRIM(speciality_name)   AS speciality_name,       
                TRIM(case_type)         AS case_type,
                TRIM(adult_child)       AS adult_child,
                CASE
                    WHEN TRIM(age_profile) = '0-15' THEN '1-16'
                    WHEN TRIM(age_profile) = '16-64' THEN '17-59'
                    WHEN TRIM(age_profile) = '65+' THEN '60+'
                    ELSE age_profile END AS age_profile,
                CASE
                WHEN TRIM(time_bands) = '18 Months +' THEN '18+ Months'
                ELSE TRIM(time_bands)
                END AS time_bands,
                total                       -- Transformation Not Required

    -----------------------------------Transformation Script Ends

    FROM (
       SELECT 
          'InPatientData' AS data_category,
          archive_date,
          specialty_hipe  AS speciality_hipe,
          specialty_name  AS speciality_name,
          case_type,
          adult_child,
          age_profile,
          time_bands,
          total
        FROM bronze.inpatientdata
        UNION ALL
        SELECT 
          'OutPatientData' AS data_category,
          archive_date,
          specialty_hipe  AS speciality_hipe,
          Speciality      AS speciality_name,
          'Outpatient'    AS case_type,
          adult_child,
          age_profile,
          time_bands,
          total
        FROM bronze.outpatientdata
    ) as inner_select
    ) as outer_select;


    ----------Loading Speciality Mapping Data
    TRUNCATE TABLE silver.speciality_mapping;
    INSERT INTO silver.speciality_mapping
    (
        speciality,
        speciality_group
    )
    SELECT

        TRIM(specialty)         AS speciality,
        TRIM(specialty_group)   AS speciality_group
        FROM bronze.speciality_mapping
        GROUP BY 
        TRIM(specialty),
        TRIM(specialty_group);

 END;