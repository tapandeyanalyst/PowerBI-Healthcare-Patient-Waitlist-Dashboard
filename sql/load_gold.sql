
-- CREATE Dimensions : gold.patientwaitlistdata
USE HealthCareDB;
GO
IF OBJECT_ID('gold.patientwaitlistdata', 'V' ) IS NOT NULL 
DROP VIEW gold.patientwaitlistdata;
GO
CREATE OR ALTER VIEW gold.patientwaitlistdata AS 

SELECT

	pwl.data_category      AS data_category,
    pwl.archive_date       AS archive_date,
    pwl.speciality_hipe    AS speciality_hipe,
    pwl.speciality_name    AS speciality_name,
    pwl.case_type          AS case_type,
    pwl.adult_child        AS adult_child,
    pwl.age_profile        AS age_profile,
    pwl.time_bands         AS time_bands,
    pwl.total              AS total,
    sm.speciality_group    AS speciality_group

FROM silver.patientwaitlistdata AS pwl
LEFT JOIN silver.speciality_mapping	AS sm  ON pwl.speciality_name = sm.speciality