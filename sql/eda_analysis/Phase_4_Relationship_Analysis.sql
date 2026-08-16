USE HealthCareDB
---------------------------------------
--Phase 9 — Relationship Analysis
---------------------------------------

/*
The most useful relationships for this dataset are:

adult_child ↔ age_profile — already validated and transformed.
speciality_hipe ↔ speciality_name — already validated.
data_category ↔ case_type — important because we introduced Outpatient.
data_category ↔ speciality / waitlist volume — useful for understanding the combined dataset.
*/

--Let's start with 9.1 — data_category ↔ case_type.
SELECT
    data_category,
    case_type,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM silver.patientwaitlistdata
GROUP BY
    data_category,
    case_type
ORDER BY
    data_category,
    case_type;
/*
No issue here.
*/


--Phase 9.2 — data_category ↔ adult_child
SELECT
    data_category,
    age_profile,
    adult_child,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM silver.patientwaitlistdata
GROUP BY
    data_category,
    age_profile,
    adult_child
ORDER BY
    data_category,
    age_profile,
    adult_child;

/*
No issue here.
*/

