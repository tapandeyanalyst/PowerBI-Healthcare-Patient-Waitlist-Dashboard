SELECT
    COUNT(*) AS total_rows,
    COUNT(speciality_group) AS mapped_rows,
    COUNT(*) - COUNT(speciality_group) AS unmapped_rows
FROM gold.patientwaitlistdata;

/*
If all rows mapped for speciality_group then unmapped_rows should be 0, else we need to investigate

total_rows	mapped_rows	unmapped_rows
453119	    453119	    0
*/

-- Investigate unmapped_rows
SELECT DISTINCT
    pwl.speciality_name
FROM silver.patientwaitlistdata AS pwl
LEFT JOIN silver.speciality_mapping AS sm
    ON pwl.speciality_name = sm.speciality
WHERE sm.speciality IS NULL
ORDER BY pwl.speciality_name;

--checking duplicate 
SELECT
    speciality,
    COUNT(*) AS occurrence_count
FROM silver.speciality_mapping
GROUP BY speciality
HAVING COUNT(*) > 1;



--Final row count check:
SELECT COUNT(*) AS silver_rows
FROM silver.patientwaitlistdata;

SELECT COUNT(*) AS gold_rows
FROM gold.patientwaitlistdata;
