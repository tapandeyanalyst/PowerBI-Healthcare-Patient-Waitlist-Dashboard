USE HealthCareDB

/*
Data Quality Checks
In data quality checks we will validate each columns for: 
    - Duplicates
    - Missing / Null values
    - Blank strings/Whitespace
    - Inconsistencies/Invalid values
    - Standardization
    - Invalid numeric values
    - Invalid dates
    - Type casting
    - Derived New column

As we understand that both the inpatient and outpatient data table has similar columns, we would like to UNION them and then do 
the EDA analysis.

- Add 'Outpatient'    AS case_type in the outpatient table.
- Add 'InPatientData' AS data_category in inpatient table
- Add 'OutPatientData' AS data_category in outpatient table
- Then UNION both the table and create silver.patientwaitlistdata
- Perform all the EDA on silver.patientwaitlistdata
*/

--Getting the data fields
SELECT TOP 1 * FROM silver.patientwaitlistdata
/*
data_category	
archive_date	
speciality_hipe	
speciality_name	
case_type	
adult_child	
age_profile	
time_bands	
total	
dwh_create_date
*/

--data_category
SELECT 
SUM(CASE WHEN data_category IS NULL THEN 1 ELSE 0 END) AS null_data_category,
SUM(CASE WHEN LTRIM(RTRIM(data_category)) = '' THEN 1 ELSE 0 END) AS blank_data_category
FROM silver.patientwaitlistdata
/*
null_data_category	blank_data_category
0	                0
*/

--archive_date
SELECT
MIN(archive_date),
MAX(archive_date),
SUM(CASE WHEN archive_date IS NULL THEN 1 ELSE 0 END) AS null_date,
SUM(CASE WHEN LTRIM(RTRIM(archive_date)) = '' THEN 1 ELSE 0 END) AS blank_date
FROM silver.patientwaitlistdata
/*
(No column name)	(No column name)	null_data_category	blank_data_category
2018-01-31	        2021-03-31	        0	                0
*/

--speciality_hipe
select speciality_hipe from silver.patientwaitlistdata
select
MIN(speciality_hipe) AS Minimum_Total,
MAX(speciality_hipe) AS Maximum_Total,
SUM(CASE WHEN speciality_hipe < 0 THEN 1 ELSE 0 END) AS Negative_Total_Count,
SUM(CASE WHEN speciality_hipe = 0 THEN 1 ELSE 0 END) AS Zero_Total_Count,
SUM(CASE WHEN speciality_hipe IS NULL THEN 1 ELSE 0 END) AS null_total_count
FROM silver.patientwaitlistdata
/*
Minimum_Total	Maximum_Total	Negative_Total_Count	Zero_Total_Count    null_total_count
0	            9000	        0	                    2231                191
*/

--Checking where speciality_hipe = 0
select speciality_hipe, speciality_name, case_type, count(*) from silver.patientwaitlistdata
where speciality_hipe = 0
group by speciality_hipe, speciality_name,case_type
/*
speciality_hipe	speciality_name	            case_type	(No column name)
0	            Small Volume Specialities	Day Case	1213
0	            Small Volume Specialities	Inpatient	367
0	            Small Volume Specialities	Outpatient	651
*/

--checking where speciality_hipe is null
select *  from silver.patientwaitlistdata where speciality_hipe is null

select speciality_hipe, speciality_name, count(*)  as count
from silver.patientwaitlistdata 
where speciality_hipe is null
group by speciality_hipe, speciality_name
/*
speciality_hipe	speciality_name	count
NULL	        Other	        191
*/

--speciality_name
select speciality_name from silver.patientwaitlistdata 
group by speciality_name

select
SUM(CASE WHEN speciality_name IS NULL THEN 1 ELSE 0 END) AS null_speciality_name,
SUM(CASE WHEN LTRIM(RTRIM(speciality_name)) = '' THEN 1 ELSE 0 END) AS blank_speciality_name
FROM silver.patientwaitlistdata 
/*
null_speciality_name	blank_speciality_name
0	                    0
*/

--case_type
select case_type from silver.patientwaitlistdata 
group by case_type

select
SUM(CASE WHEN case_type IS NULL THEN 1 ELSE 0 END) AS null_case_type,
SUM(CASE WHEN LTRIM(RTRIM(case_type)) = '' THEN 1 ELSE 0 END) AS blank_case_type
FROM silver.patientwaitlistdata 
/*
null_case_type	blank_case_type
0	            0
*/

--adult_child
select adult_child, count(*) from silver.patientwaitlistdata 
group by adult_child
/*
adult_child	        (No column name)
Child	            79013
Senior Citizens	    170487
Adult	            203444
 	                175
*/
select
SUM(CASE WHEN adult_child IS NULL THEN 1 ELSE 0 END) AS null_adult_child,
SUM(CASE WHEN LTRIM(RTRIM(adult_child)) = '' THEN 1 ELSE 0 END) AS blank_adult_child
FROM silver.patientwaitlistdata 
/*
null_adult_child	blank_adult_child
0	                175
*/

--Investigating blank
select * from silver.patientwaitlistdata 
where adult_child = ''

--age_profile
/*
We have to derive age_profile as mentioned below and based on this age_profile, we have to derive adult_child
CASE
    WHEN TRIM(age_profile) = '0-15' THEN '1-16'
    WHEN TRIM(age_profile) = '16-64' THEN '17-59'
    WHEN TRIM(age_profile) = '65+' THEN '60+'
    ELSE age_profile END AS age_profile,
*/
select age_profile, count(*) from silver.patientwaitlistdata 
group by age_profile
/*
age_profile	    (No column name)
17-59	        203444
NULL	        175
60+	            170487
1-16	        79013
*/
select
SUM(CASE WHEN age_profile IS NULL THEN 1 ELSE 0 END) AS null_age_profile,
SUM(CASE WHEN LTRIM(RTRIM(age_profile)) = '' THEN 1 ELSE 0 END) AS blank_age_profile
FROM silver.patientwaitlistdata 
/*
null_age_profile	blank_age_profile
175	                0
*/

--time_bands
select time_bands, count(*) from silver.patientwaitlistdata 
group by time_bands
/*
time_bands	        (No column name)
6-9 Months	        71802
9-12 Months	        62876
12-15 Months	    53839
NULL	            2
0-3 Months	        93818
3-6 Months	        81510
15-18 Months	    45269
18+ Months	        44003
*/
select * from silver.patientwaitlistdata 
where time_bands is null


select
SUM(CASE WHEN time_bands IS NULL THEN 1 ELSE 0 END) AS null_time_bands,
SUM(CASE WHEN LTRIM(RTRIM(time_bands)) = '' THEN 1 ELSE 0 END) AS blank_time_bands
FROM silver.patientwaitlistdata 
/*
null_time_bands	    blank_time_bands
2	                0
*/

--total
select
MIN(total) AS Minimum_Total,
MAX(total) AS Maximum_Total,
SUM(CASE WHEN total < 0 THEN 1 ELSE 0 END) AS Negative_Total,
SUM(CASE WHEN total = 0 THEN 1 ELSE 0 END) AS Zero_Total,
SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END) AS null_total
FROM silver.patientwaitlistdata
/*
Minimum_Total	Maximum_Total	Negative_Total	Zero_Total	null_total
1	            4239	        0	            0	        0
*/











--Step 1C — Check NULLs in All Important Columns
--Although we'll perform a dedicated Missing Value Analysis in Phase 5, we want a baseline here.

SELECT
    SUM(CASE WHEN archive_date IS NULL THEN 1 ELSE 0 END) AS Null_Archive_Date,
    SUM(CASE WHEN specialty_hipe IS NULL THEN 1 ELSE 0 END) AS Null_Specialty_HIPE,
    SUM(CASE WHEN specialty_name IS NULL THEN 1 ELSE 0 END) AS Null_Specialty_Name,
    SUM(CASE WHEN case_type IS NULL THEN 1 ELSE 0 END) AS Null_Case_Type,
    SUM(CASE WHEN adult_child IS NULL THEN 1 ELSE 0 END) AS Null_Adult_Child,
    SUM(CASE WHEN age_profile IS NULL THEN 1 ELSE 0 END) AS Null_Age_Profile,
    SUM(CASE WHEN time_bands IS NULL THEN 1 ELSE 0 END) AS Null_Time_Bands,
    SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END) AS Null_Total
FROM bronze.inpatientdata;

SELECT
    SUM(CASE WHEN archive_date IS NULL THEN 1 ELSE 0 END) AS Null_Archive_Date,
    SUM(CASE WHEN specialty_hipe IS NULL THEN 1 ELSE 0 END) AS Null_Specialty_HIPE,
    SUM(CASE WHEN Speciality IS NULL THEN 1 ELSE 0 END) AS Null_Speciality,
    SUM(CASE WHEN adult_child IS NULL THEN 1 ELSE 0 END) AS Null_Adult_Child,
    SUM(CASE WHEN age_profile IS NULL THEN 1 ELSE 0 END) AS Null_Age_Profile,
    SUM(CASE WHEN time_bands IS NULL THEN 1 ELSE 0 END) AS Null_Time_Bands,
    SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END) AS Null_Total
FROM bronze.outpatientdata;

/*
We now have three confirmed NULL issues in outpatient:

specialty_hipe → 191
adult_child → 175
age_profile → 2

And remember, these are actual NULLs, separate from the 175 blank/whitespace adult_child values we found earlier.

Findings
- The inpatient dataset contains no NULL values across any column.
- The outpatient dataset contains NULL values in three columns:
    - `specialty_hipe`: 191 records
    - `adult_child`: 175 records
    - `age_profile`: 2 records
- `archive_date`, `Speciality`, `time_bands`, and `total` contain no NULL values in the outpatient dataset.
- The outpatient `adult_child` field has both NULL values and blank/whitespace-only values. These should be investigated separately during Phase 5: Missing Values.
*/

--Step 1D — Check Mapping Table Quality
--The mapping table is particularly important because we'll eventually use it to enrich the fact tables.

/*
Findings:
- The `specialty_mapping` table contains 78 records with no NULL values.
- No duplicate `specialty` values were identified.
- Each specialty can therefore be treated as a unique lookup key for the mapping table.
- The mapping table passes the basic completeness and uniqueness checks.
*/

--Step 1E — Check Text Consistency
SELECT DISTINCT specialty_name
FROM bronze.inpatientdata
ORDER BY specialty_name;

SELECT DISTINCT Speciality
FROM bronze.outpatientdata
ORDER BY Speciality;

SELECT DISTINCT specialty
FROM bronze.specialty_mapping
ORDER BY specialty;

/*
### Specialty Mapping Coverage

- The `specialty_mapping` table contains 78 unique specialties.
- All 62 inpatient specialties are present in the mapping table.
- All 75 outpatient specialties are present in the mapping table.
- No specialty values in either fact table are missing from the mapping table.
- The mapping table therefore provides complete specialty coverage for both inpatient and outpatient datasets.
- The mapping table contains 3 specialties that are not currently present in the outpatient dataset but are present in the inpatient dataset.
- This confirms that the specialty mapping table can be used as a reliable reference table for the planned Silver/Gold layer integration.
*/

--Step 1G — Categorical Value Validation

--1. adult_child
SELECT
    adult_child,
    COUNT(*) AS Record_Count
FROM bronze.inpatientdata
GROUP BY adult_child
ORDER BY Record_Count DESC;

SELECT
    adult_child,
    COUNT(*) AS Record_Count
FROM bronze.outpatientdata
GROUP BY adult_child
ORDER BY Record_Count DESC;

/*
### `adult_child` Validation

- The `adult_child` field contains two valid categories across both datasets: `Adult` and `Child`.
- The category labels are consistently represented with no apparent capitalization or spelling variations.
- Inpatient contains 153,820 Adult records and 28,316 Child records.
- Outpatient contains 214,452 Adult records and 56,356 Child records.
- Outpatient contains an additional 175 blank `adult_child` values. These will be investigated during Phase 5: Missing Values.
*/

--2. age_profile

SELECT
    age_profile,
    COUNT(*) AS Record_Count
FROM bronze.inpatientdata
GROUP BY age_profile
ORDER BY Record_Count DESC;

SELECT
    age_profile,
    COUNT(*) AS Record_Count
FROM bronze.outpatientdata
GROUP BY age_profile
ORDER BY Record_Count DESC;

/*
### `age_profile` Validation

- The inpatient `age_profile` field contains three expected categories: `0-15`, `16-64`, and `65+`.
- The outpatient dataset contains the same three expected age categories.
- However, 17,789 outpatient records contain ` 0-15` with a leading space instead of the standard `0-15` representation.
- This creates an inconsistent representation of the same age category and should be standardized during the Silver-layer transformation.
- Outpatient also contains 175 NULL values in `age_profile`, which will be investigated during Phase 5: Missing Values.
- The `age_profile` values `0-15` and ` 0-15` should be treated as the same business category after whitespace normalization.
*/

--3. time_bands
SELECT
    time_bands,
    COUNT(*) AS Record_Count
FROM bronze.inpatientdata
GROUP BY time_bands
ORDER BY Record_Count DESC;

SELECT
    time_bands,
    COUNT(*) AS Record_Count
FROM bronze.outpatientdata
GROUP BY time_bands
ORDER BY Record_Count DESC;

SELECT DISTINCT
    '[' + time_bands + ']' AS Time_Band_Check
FROM bronze.inpatientdata
ORDER BY Time_Band_Check;

/*
We now have three time_bands findings
Inpatient: leading spaces in 6 of the 7 categories.
Outpatient: 18 Months + vs 18+ Months — inconsistent representation.
Outpatient: 2 NULL values.

Findings
### `time_bands` Validation

- The inpatient dataset contains the expected seven waiting-time bands.
- Six inpatient `time_bands` values contain leading whitespace:
    - `0-3 Months`
    - `3-6 Months`
    - `6-9 Months`
    - `9-12 Months`
    - `12-15 Months`
    - `15-18 Months`
- The outpatient dataset contains an inconsistent representation of the longest waiting-time category: `18 Months +` and `18+ Months`.
- `18 Months +` and `18+ Months` appear to represent the same business category and should be standardized during the Silver-layer transformation.
- The outpatient dataset contains 2 NULL values in `time_bands`. These will be investigated during Phase 5: Missing Values.
- Leading and trailing whitespace should be normalized in the Silver layer using a whitespace-trimming transformation.
*/

--4. case_type
SELECT
    case_type,
    COUNT(*) AS Record_Count
FROM bronze.inpatientdata
GROUP BY case_type
ORDER BY Record_Count DESC;

/*
The inpatient dataset contains two case_type categories: Day Case and Inpatient.
Both values are consistently represented.
No unexpected category, blank, or NULL value was identified.

### `case_type` Validation

- The inpatient dataset contains two valid `case_type` categories: `Day Case` and `Inpatient`.
- `Day Case` contains 110,185 records, while `Inpatient` contains 71,951 records.
- The category labels are consistently represented.
- No unexpected, blank, or NULL `case_type` values were identified.
*/


-- Key Findings
/*
Key Phase 3 Findings

We uncovered several genuine issues that will matter later:

Outpatient specialty_hipe → 191 NULLs
Outpatient adult_child → 175 NULLs + 175 blank values
Outpatient age_profile → 175 NULLs + 17,789 values with a leading space
Inpatient time_bands → leading whitespace in six categories
Outpatient time_bands → 18 Months + vs 18+ Months
Outpatient time_bands → 2 NULLs
specialty_hipe = 0 → confirmed valid category: Small Volume Specialities
Specialty mapping → complete coverage with no duplicates or NULLs
*/



USE HealthCareDB

---Phase 6 — Column-wise Analysis

--------------
--Step 1 — archive_date
--------------
/*
We'll check:

Number of distinct dates
Minimum date
Maximum date
Whether dates are consistently month-end
Whether there are any gaps in the monthly reporting period
*/


SELECT
    MIN(archive_date) AS Start_Date,
    MAX(archive_date) AS End_Date,
    COUNT(DISTINCT archive_date) AS Distinct_Dates
FROM bronze.inpatientdata;

SELECT DISTINCT
    archive_date
FROM bronze.inpatientdata
ORDER BY archive_date;

/*
Step 1 — archive_date: Inpatient Finding

We have:

39 distinct reporting dates
From 31-Jan-2018 to 31-Mar-2021
Every month is present.
Every date is the last day of the month, including leap-year February 2020 (2020-02-29).
No gaps were identified in the monthly reporting period.

### `archive_date` — Inpatient

- The dataset contains 39 distinct reporting dates.
- The reporting period runs from 31-Jan-2018 to 31-Mar-2021.
- Reporting is monthly, with one month-end archive date for each month.
- All 39 expected monthly reporting periods are present.
- No gaps were identified in the reporting timeline.
- The `archive_date` column is therefore suitable for monthly trend and time-series analysis.
*/

--Outpatient Data
SELECT
    MIN(archive_date) AS Start_Date,
    MAX(archive_date) AS End_Date,
    COUNT(DISTINCT archive_date) AS Distinct_Dates
FROM bronze.outpatientdata;

SELECT DISTINCT
    archive_date
FROM bronze.outpatientdata
ORDER BY archive_date;

/*
Metric	            Inpatient	    Outpatient
Start Date	        2018-01-31	    2018-01-31
End Date	        2021-03-31	    2021-03-31
Distinct Dates	    39	            39
Reporting Frequency	Monthly	        Monthly
Month-end dates	    Yes	            Yes
Missing months	    None	        None
*/

/*
### `archive_date` — Column Analysis

- Both Inpatient and Outpatient contain 39 distinct reporting dates.
- Both datasets cover the same period: 31-Jan-2018 to 31-Mar-2021.
- Reporting is monthly, with each `archive_date` representing the final day of the month.
- All expected monthly periods are present in both datasets.
- February 2020 correctly uses 29-Feb-2020, confirming valid month-end dates for the leap year.
- No gaps were identified in the reporting timeline.
- The `archive_date` column is suitable for monthly trend analysis and time-based reporting in the Gold layer.
*/


--Step 2 — specialty_hipe
/*
We'll analyze:

Number of distinct HIPE codes
Minimum / maximum code
Frequency distribution
0 values
NULL values
Whether the same HIPE code maps consistently to one specialty

That last check is particularly important because we're planning to use specialty mapping later.
*/

SELECT
    COUNT(DISTINCT specialty_hipe) AS Distinct_HIPE_Codes,
    MIN(specialty_hipe) AS Min_HIPE,
    MAX(specialty_hipe) AS Max_HIPE
FROM bronze.inpatientdata;

/*
Important observation
We already know 0 is a valid identifier value, not a NULL:
    0 → Small Volume Specialities
So we should not treat 0 as missing in the column-wise analysis.
We also know there are no NULLs in Inpatient.
*/

SELECT
    COUNT(DISTINCT specialty_hipe) AS Distinct_HIPE_Codes,
    MIN(specialty_hipe) AS Min_HIPE,
    MAX(specialty_hipe) AS Max_HIPE
FROM bronze.outpatientdata;

/*
Step 2 — specialty_hipe Comparison
Metric	                Inpatient	    Outpatient
Distinct HIPE Codes	    62	            75
Minimum	                0	            0
Maximum	                8,800	        9,000
NULL values	            0	            191
*/

/*
However, there is an important point we should investigate before drawing conclusions:
Does each specialty_hipe consistently identify one specialty?
This is critical because you're planning to standardize the two datasets and eventually join them with the specialty mapping.
*/

--Step 2A — HIPE Code Consistency
SELECT
    specialty_hipe,
    COUNT(DISTINCT specialty_name) AS Distinct_Specialties
FROM bronze.inpatientdata
GROUP BY specialty_hipe
HAVING COUNT(DISTINCT specialty_name) > 1
ORDER BY specialty_hipe;

/*
### `specialty_hipe` — Inpatient Consistency

- Inpatient contains 62 distinct `specialty_hipe` codes.
- The codes range from 0 to 8,800.
- No NULL values are present.
- Each `specialty_hipe` code maps consistently to exactly one `specialty_name`.
- No HIPE code was found to represent multiple specialties.
- `specialty_hipe` can therefore be treated as a stable specialty identifier within the Inpatient dataset.
*/

--Step 2B — HIPE Code Consistency: Outpatient
SELECT
    specialty_hipe,
    COUNT(DISTINCT Speciality) AS Distinct_Specialties
FROM bronze.outpatientdata
WHERE specialty_hipe IS NOT NULL
GROUP BY specialty_hipe
HAVING COUNT(DISTINCT Speciality) > 1
ORDER BY specialty_hipe;

/*
### `specialty_hipe` — Outpatient Consistency

- Outpatient contains 75 distinct `specialty_hipe` codes.
- The codes range from 0 to 9,000.
- 191 records have NULL `specialty_hipe`.
- Among the non-NULL HIPE codes, each `specialty_hipe` consistently maps to exactly one `Speciality`.
- No HIPE code was found to represent multiple specialties.
- `specialty_hipe` can therefore be treated as a stable specialty identifier within the Outpatient dataset.
*/

--Step 2C — Check HIPE Code ↔ Specialty consistency across BOTH tables
    --Now we want to answer a slightly deeper question:
    --Does the same HIPE code represent the same specialty in both datasets?
    --This matters because you're planning to UNION ALL the two fact tables.

SELECT
    i.specialty_hipe,
    i.specialty_name AS Inpatient_Specialty,
    o.Speciality AS Outpatient_Speciality
FROM
(
    SELECT DISTINCT
        specialty_hipe,
        specialty_name
    FROM bronze.inpatientdata
    WHERE specialty_hipe IS NOT NULL
) i
INNER JOIN
(
    SELECT DISTINCT
        specialty_hipe,
        Speciality
    FROM bronze.outpatientdata
    WHERE specialty_hipe IS NOT NULL
) o
    ON i.specialty_hipe = o.specialty_hipe
WHERE i.specialty_name <> o.Speciality
ORDER BY i.specialty_hipe;
--Output No rows means the shared HIPE codes are consistent across both fact tables.

/*
We have now established:

Inpatient: 62 distinct HIPE codes.
Outpatient: 75 distinct HIPE codes.
Shared HIPE codes map to the same specialty in both datasets.
No cross-table specialty mismatch was found.
specialty_hipe = 0 consistently represents Small Volume Specialities.
Outpatient has 191 NULL HIPE values, which we've already decided to retain as NULL.

This is a strong validation for the planned UNION ALL in the Silver transformation. 🎯
*/

/*
### `specialty_hipe` — Cross-table Consistency

- Inpatient contains 62 distinct `specialty_hipe` codes, while Outpatient contains 75.
- Shared HIPE codes between the two fact tables consistently map to the same specialty.
- No cross-table specialty mismatch was identified.
- This confirms that `specialty_hipe` can be used as a consistent specialty identifier across the two datasets.
- The difference in the number of distinct codes is therefore attributable to the different specialty coverage of the two datasets rather than conflicting HIPE mappings.
- This supports the planned `UNION ALL` of the standardized Inpatient and Outpatient datasets in the Silver layer.
*/


-- Lets Check : specialty_name / Speciality

SELECT
    COUNT(DISTINCT specialty_name) AS Distinct_Specialties
FROM bronze.inpatientdata; 62 counts

SELECT
    COUNT(DISTINCT speciality) AS Distinct_Specialties
FROM bronze.outpatientdata; 75 counts
--inpatient 62
--outpatient 75
--This matches our earlier observation from the HIPE analysis.
--But the difference of 13 specialties is exactly what we need to investigate now.

--Step 2A — Find specialties present in Outpatient but not Inpatient
SELECT DISTINCT
    Speciality
FROM bronze.outpatientdata

EXCEPT

SELECT DISTINCT
    specialty_name
FROM bronze.inpatientdata

ORDER BY Speciality;
----------------------------------------

SELECT DISTINCT
    specialty_name
FROM bronze.inpatientdata

EXCEPT

SELECT DISTINCT
    Speciality
FROM bronze.outpatientdata

ORDER BY specialty_name;
/*
Category	            Count
Inpatient specialties	62
Outpatient specialties	75
Outpatient-only	        16
Inpatient-only	        3
Common to both	        59

The math checks:
59 common + 3 Inpatient-only = 62
59 common + 16 Outpatient-only = 75

Important Finding
The two datasets have different specialty coverage, but there is substantial overlap (59 specialties).
This is not a problem for the Silver UNION ALL. In fact, it reinforces the approach we're taking:
Standardize the specialty column name, preserve all records from both datasets, and use the mapping table to enrich the combined data.

### `specialty_name / Speciality` — Specialty Coverage

- Inpatient contains 62 distinct specialties.
- Outpatient contains 75 distinct specialties.
- 59 specialties are common to both datasets.
- Outpatient contains 16 specialties that do not appear in Inpatient.
- Inpatient contains 3 specialties that do not appear in Outpatient.
- The difference reflects different specialty coverage between the two service types.
- All specialties should be retained when the datasets are combined in the Silver layer.
- The specialty fields should be standardized to a common column name before the `UNION ALL`.
- The combined specialty field can then be enriched using the specialty mapping table.
*/


--Next — Mapping Table Coverage
    --Now we need to answer a very important question before the Silver JOIN:
    --Are all specialties appearing in the fact tables present in specialty_mapping?
    --We'll check Inpatient vs Mapping and Outpatient vs Mapping.


SELECT DISTINCT specialty_name FROM bronze.inpatientdata
EXCEPT
SELECT DISTINCT specialty FROM bronze.specialty_mapping
ORDER BY specialty_name;

SELECT DISTINCT Speciality FROM bronze.outpatientdata
EXCEPT
SELECT DISTINCT specialty FROM bronze.specialty_mapping
ORDER BY Speciality;

-----------------------------------------------------------
--Next: case_type
-----------------------------------------------------------

SELECT
    case_type,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.inpatientdata
GROUP BY case_type
ORDER BY Record_Count DESC;

----------------------------------------
--Next: adult_child
----------------------------------------
/*
We already know from Phase 5 that Outpatient has 175 blank adult_child values, while Inpatient has none.
*/
SELECT
    adult_child,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.inpatientdata
GROUP BY adult_child
ORDER BY Record_Count DESC;

/*
Step — adult_child: Inpatient
adult_child	    Record  Count	Total Waitlist
Adult	        153,820	        2,627,576
Child	        28,316	        277,654
Total	        182,136	        2,905,230

Findings
Adult records account for 84.46% of Inpatient records.
Child records account for 15.54%.
Adults contribute approximately 90.44% of the total Inpatient waitlist.
Children contribute approximately 9.56%.
There are no missing/blank adult_child values in Inpatient.

### `adult_child` — Inpatient

- Inpatient contains two categories: `Adult` and `Child`.
- Adult records: 153,820 (84.46%).
- Child records: 28,316 (15.54%).
- Adult total waitlist: 2,627,576 (90.44%).
- Child total waitlist: 277,654 (9.56%).
- No missing or blank `adult_child` values were identified in Inpatient.
- The Inpatient population is strongly Adult-dominant in both record volume and total waitlist.
*/


--Outpatient
SELECT
    adult_child,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.outpatientdata
GROUP BY adult_child
ORDER BY Record_Count DESC;

/*
adult_child	        Record Count	Total Waitlist
Adult	            214,452	        18,451,232
Child	            56,356	        3,284,029
Blank	            175	            478
Total	            270,983	        21,735,739

Findings
Adult records account for 79.14% of Outpatient records.
Child records account for 20.80%.
The 175 blank records represent only 0.065% of the dataset.
Those blank records contain only 478 total waitlist cases.
Adults contribute approximately 84.91% of the total Outpatient waitlist.
Children contribute approximately 15.11%.
The blank adult_child records contribute approximately 0.002% of the total waitlist.

### `adult_child` — Outpatient

- Outpatient contains `Adult`, `Child`, and 175 blank records.
- Adult records: 214,452 (79.14%).
- Child records: 56,356 (20.80%).
- Blank records: 175 (0.065%).
- Adult total waitlist: 18,451,232 (84.91%).
- Child total waitlist: 3,284,029 (15.11%).
- Blank records contribute only 478 to the total waitlist.
- The blank values represent a very small proportion of the dataset and should not be artificially classified.
- Blank `adult_child` values will be standardized to NULL in the Silver layer.

One useful observation
Notice the difference between the two datasets:

Inpatient
Adult → 84.46% of records
Child → 15.54%

Outpatient
Adult → 79.14%
Child → 20.80%

So Outpatient has a higher proportion of Child records than Inpatient. That's a meaningful business observation we'll be able to explore later in Phase 9 — Relationship Analysis.
*/

---------------------------------
--Next — age_profile
---------------------------------

/*
This one is particularly interesting because we've already identified:

Inpatient → no missing values
Outpatient → 175 NULL
Outpatient also has the unusual Child + 16-64 combinations we discovered earlier.

Let's analyze it carefully.
*/

SELECT
    age_profile,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.inpatientdata
GROUP BY age_profile
ORDER BY Record_Count DESC;

/*
age_profile	        Record Count	Total Waitlist
16-64	            87,396	        1,674,355
65+	69,             590	            963,254
0-15	            25,150	        267,621
Total	            182,136	        2,905,230

Findings
16-64 is the largest age group, representing 47.99% of Inpatient records.
65+ represents 38.21%.
0-15 represents 13.80%.
The 16-64 group contributes the largest share of the total waitlist: approximately 57.64%.
65+ contributes approximately 33.16%.
0-15 contributes approximately 9.21%.
No NULL or blank age_profile values exist in Inpatient.

### `age_profile` — Inpatient

- Inpatient contains three age-profile categories: `0-15`, `16-64`, and `65+`.
- `16-64`: 87,396 records (47.99%) and 1,674,355 total waitlist.
- `65+`: 69,590 records (38.21%) and 963,254 total waitlist.
- `0-15`: 25,150 records (13.80%) and 267,621 total waitlist.
- The `16-64` group is the largest category by both record count and total waitlist.
- No missing or blank `age_profile` values were identified in Inpatient.
*/


---------------------------------
--Next — Outpatient age_profile
---------------------------------

SELECT
    age_profile,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.outpatientdata
GROUP BY age_profile
ORDER BY Record_Count DESC;

/*
age_profile	        Record Count	Total Waitlist
16-64	            116,048	        13,423,242
65+	100,            897	            5,077,142
0-15	            36,074	        2,244,365
0-15	            17,789	        990,512
NULL	            175	            478
Total	            270,983	        21,735,739

Key finding: 0-15 inconsistency

We have two representations of the same apparent category:
`0-15`    → 36,074 records
` 0-15`   → 17,789 records

The second value contains a leading space.
This is a data-standardization issue, not two genuinely different age groups.
Therefore, in the Silver layer we should standardize whitespace:

Other findings
16-64 is the largest category by record count and waitlist.
65+ is the second-largest category.
0-15 becomes the third-largest category after whitespace normalization.
175 records have NULL age_profile.
Those 175 records correspond to the same 175 records where adult_child is blank and have a total waitlist of only 478.
We should not infer their age profile.

### `age_profile` — Outpatient

- Outpatient contains five observed values/groups: `16-64`, `65+`, `0-15`, ` 0-15`, and NULL.
- `16-64`: 116,048 records and 13,423,242 total waitlist.
- `65+`: 100,897 records and 5,077,142 total waitlist.
- `0-15`: 36,074 records and 2,244,365 total waitlist.
- ` 0-15`: 17,789 records and 990,512 total waitlist.
- ` 0-15` contains a leading whitespace and represents the same logical category as `0-15`.
- The leading whitespace should be removed during Silver-layer standardization using trimming.
- After normalization, the two `0-15` categories will be treated as one age group.
- 175 records have NULL `age_profile`; these values should be retained as NULL because no reliable age profile can be derived.
- The 175 NULL records have a total waitlist of only 478.
*/

-----------------------------------
--Next — time_bands
-----------------------------------
/*
This is another important one because we've already seen:

leading spaces
different representations of 18+ Months
2 NULL values in Outpatient

Let's analyze the Inpatient distribution first.
*/

SELECT
    time_bands,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.inpatientdata
GROUP BY time_bands
ORDER BY Record_Count DESC;
/*
time_bands	            Record Count	Total Waitlist
0-3 Months	            39,708	        1,043,892
3-6 Months	            33,818	        658,429
6-9 Months	            29,170	        412,539
9-12 Months	            24,984	        264,881
12-15 Months	        20,718	        171,944
18+ Months	            17,085	        242,091
15-18 Months	        16,653	        111,454
Total	                182,136	        2,905,230

Findings
Inpatient contains all 7 expected time-band categories.
The record count decreases as waiting time increases, from 0-3 Months through the longer bands.
0-3 Months has the largest volume: 39,708 records and 1,043,892 total waitlist.
15-18 Months has the lowest record count: 16,653.
18+ Months has 17,085 records.
Leading whitespace is present in the Bronze values and should be removed during Silver standardization.
No missing time_bands values were identified in Inpatient.

### `time_bands` — Inpatient

- Inpatient contains all seven expected time-band categories.
- The categories are:
  `0-3 Months`, `3-6 Months`, `6-9 Months`, `9-12 Months`,
  `12-15 Months`, `15-18 Months`, and `18+ Months`.
- `0-3 Months` has the highest record volume with 39,708 records and 1,043,892 total waitlist.
- `15-18 Months` has the lowest record volume with 16,653 records.
- Leading whitespace is present in the Bronze `time_bands` values.
- The values should be trimmed during Silver-layer transformation.
- No missing `time_bands` values were identified in Inpatient.
- The time-band categories are suitable for ordered waiting-time analysis after standardization.
*/


-----------------------------------
--Next — Outpatient time_bands
-----------------------------------

SELECT
    time_bands,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.outpatientdata
GROUP BY time_bands
ORDER BY Record_Count DESC;

/*
time_bands	        Record Count	Total Waitlist
0-3 Months	        54,110	        5,940,446
3-6 Months	        47,692	        3,660,530
6-9 Months	        42,632	        2,689,045
9-12 Months	        37,892	        2,131,600
12-15 Months	    33,121	        1,675,924
15-18 Months	    28,616	        1,298,012
18 Months +	        19,183	        3,362,358
18+ Months	        7,735	        977,822
NULL    	        2	            2
Total	            270,983	        21,735,739

Three important findings
1. 18 Months + vs 18+ Months

These are clearly two representations of the same logical category:

18 Months +
18+ Months

Leading whitespace
Several values contain leading spaces:
' 0-3 Months'
' 3-6 Months'
' 6-9 Months'
' 9-12 Months'
'12-15 Months'

Two NULL records
There are only 2 NULL time_bands records, with a combined total = 2.
We should retain them as NULL, rather than guessing the waiting-time band.

### `time_bands` — Outpatient

- Outpatient contains seven expected logical time-band categories plus two NULL records.
- The expected categories are:
  `0-3 Months`, `3-6 Months`, `6-9 Months`, `9-12 Months`,
  `12-15 Months`, `15-18 Months`, and `18+ Months`.
- Two different representations of the longest waiting-time category were identified:
  `18 Months +` and `18+ Months`.
- `18 Months +` contains 19,183 records and 3,362,358 total waitlist.
- `18+ Months` contains 7,735 records and 977,822 total waitlist.
- These values should be standardized to the single category `18+ Months` in the Silver layer.
- Leading whitespace should be removed using `TRIM()`.
- Two records contain NULL `time_bands`, with a combined total of 2.
- NULL values should be retained rather than imputed.
- After standardization, Outpatient will contain the same seven logical time-band categories as Inpatient.
*/

-------------------------------
--Next: total — numeric analysis.
-------------------------------

/*
We want to understand four things:

Minimum and maximum
Average / median
Zero values
Negative values

Since total is the actual waitlist quantity, this is an important column for the Silver layer
*/

SELECT
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist,
    MIN(total) AS Min_Total,
    MAX(total) AS Max_Total,
    AVG(CAST(total AS DECIMAL(18,2))) AS Avg_Total,
    SUM(CASE WHEN total = 0 THEN 1 ELSE 0 END) AS Zero_Count,
    SUM(CASE WHEN total < 0 THEN 1 ELSE 0 END) AS Negative_Count
FROM bronze.inpatientdata;
/*
Findings
Every Inpatient record has a positive total value.
The minimum is 1, so there are no zero-valued records.
There are no negative values, which is appropriate for a waitlist count.
The maximum value is 799.
The average waitlist count per record is approximately 15.95.
total is therefore numerically valid at a basic data-quality level.

One thing to keep in mind: the maximum of 799 doesn't automatically mean it's an error. We'll investigate unusually high values properly during Phase 8 — Outlier & Numeric Analysis.

### `total` — Inpatient

- Inpatient contains 182,136 records with a combined total waitlist of 2,905,230.
- Minimum `total`: 1.
- Maximum `total`: 799.
- Average `total`: 15.95.
- No zero values were identified.
- No negative values were identified.
- All Inpatient `total` values are positive.
- The `total` column passes basic numeric validity checks.
- The maximum value of 799 will be investigated further during Phase 8 — Outlier & Numeric Analysis.
*/

SELECT
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist,
    MIN(total) AS Min_Total,
    MAX(total) AS Max_Total,
    AVG(CAST(total AS DECIMAL(18,2))) AS Avg_Total,
    SUM(CASE WHEN total = 0 THEN 1 ELSE 0 END) AS Zero_Count,
    SUM(CASE WHEN total < 0 THEN 1 ELSE 0 END) AS Negative_Count
FROM bronze.outpatientdata;
/*
Outpatient Findings
Every Outpatient record has a positive total.
Minimum total is 1.
Maximum total is 4,239.
Average total is 80.21.
There are no zero values.
There are no negative values.
The Outpatient average is substantially higher than Inpatient:
80.21 vs 15.95.
The maximum of 4,239 is significantly higher than the Inpatient maximum of 799.
We should not classify 4,239 as an error yet. This is precisely what Phase 8 — Outlier & Numeric Analysis is for.

### `total` — Outpatient

- Outpatient contains 270,983 records with a combined total waitlist of 21,735,739.
- Minimum `total`: 1.
- Maximum `total`: 4,239.
- Average `total`: 80.21.
- No zero values were identified.
- No negative values were identified.
- All Outpatient `total` values are positive.
- The Outpatient average waitlist per record (80.21) is substantially higher than the Inpatient average (15.95).
- The maximum Outpatient value of 4,239 is considerably higher than the Inpatient maximum of 799.
- The value 4,239 should not be treated as an error solely because it is large; it will be investigated during Phase 8 — Outlier & Numeric Analysis.
*/


USE HealthCareDB
GO
-- Phase 4 — Duplicate Analysis
/*
Objective:
We want to determine:
1. Whether complete duplicate rows exist.
2. Whether the expected business grain has duplicates.
3. Whether the mapping table has duplicate keys.
4. Whether duplicates are legitimate repeated observations or actual data-quality issues.
*/

-- Step 1 — Exact Duplicate Rows
USE HealthCareDB
SELECT
    archive_date,
    specialty_hipe,
    specialty_name,
    case_type,
    adult_child,
    age_profile,
    time_bands,
    total,
    COUNT(*) AS Duplicate_Count
FROM bronze.inpatientdata
GROUP BY
    archive_date,
    specialty_hipe,
    specialty_name,
    case_type,
    adult_child,
    age_profile,
    time_bands,
    total
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC

--Step 2: Duplication Summary
SELECT
    COUNT(*) AS Duplicate_Groups,
    SUM(Duplicate_Count) AS Rows_In_Duplicate_Groups,
    SUM(Duplicate_Count - 1) AS Actual_Duplicate_Rows,
    MAX(Duplicate_Count) AS Max_Repetitions
FROM
(
SELECT
    archive_date,
    specialty_hipe,
    specialty_name,
    case_type,
    adult_child,
    age_profile,
    time_bands,
    total,
    COUNT(*) AS Duplicate_Count
FROM bronze.inpatientdata
GROUP BY
    archive_date,
    specialty_hipe,
    specialty_name,
    case_type,
    adult_child,
    age_profile,
    time_bands,
    total
HAVING COUNT(*) > 1
--ORDER BY Duplicate_Count DESC
) as in_duplicates;
/*
### Inpatient Duplicate Analysis

- The inpatient dataset contains 26,287 groups of exact duplicate rows.
- These duplicate groups contain 66,079 total rows.
- There are 39,792 rows beyond the first occurrence of each duplicate group.
- The maximum number of repetitions for a single identical row is 12.
- Exact duplicates are therefore present at a significant level in the inpatient Bronze dataset.
- These duplicates should not be removed automatically until the intended business grain of the dataset has been validated.
*/

SELECT
    archive_date,
    specialty_hipe,
    specialty_name,
    case_type,
    adult_child,
    age_profile,
    time_bands,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.inpatientdata
GROUP BY
    archive_date,
    specialty_hipe,
    specialty_name,
    case_type,
    adult_child,
    age_profile,
    time_bands
HAVING COUNT(*) > 1
ORDER BY Record_Count DESC;

--- Checking for one value
SELECT *
FROM bronze.inpatientdata
WHERE archive_date = '2019-10-31'
  AND specialty_hipe = 8003
  AND specialty_name = 'Pain Relief'
  AND case_type = 'Inpatient'
  AND adult_child = 'Adult'
  AND age_profile = '16-64'
  AND time_bands = '  3-6 Months';
 --2019-10-31	8003	Pain Relief	Inpatient	Adult	16-64	  3-6 Months	2	2

  /*
  ### Inpatient Business Grain Validation

- The inpatient dataset contains multiple records with the same dimensional attributes but different `total` values.
- Example: the combination of archive date, specialty, case type, adult/child, age profile, and time band can occur more than once.
- In the investigated example, two records contained `total` values of 8 and 20 for the same dimensional combination.
- These records should not be treated as exact duplicates because their measures are different.
- The appropriate Silver-layer approach is to aggregate `total` at the defined analytical grain using `SUM(total)`.
- Therefore, repeated dimensional combinations in Bronze should not be deleted automatically.
  */

  --Outpatient Data

  SELECT
    archive_date,
    specialty_hipe,
    Speciality,
    adult_child,
    age_profile,
    time_bands,
    total,
    COUNT(*) AS Duplicate_Count
FROM bronze.outpatientdata
GROUP BY
    archive_date,
    specialty_hipe,
    Speciality,
    adult_child,
    age_profile,
    time_bands,
    total
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;

--quantify the outpatient duplicate/grain pattern across the entire table
SELECT
    COUNT(*) AS Duplicate_Groups,
    SUM(Duplicate_Count) AS Rows_In_Duplicate_Groups,
    SUM(Duplicate_Count - 1) AS Actual_Duplicate_Rows,
    MAX(Duplicate_Count) AS Max_Repetitions
FROM
(
 SELECT
    archive_date,
    specialty_hipe,
    Speciality,
    adult_child,
    age_profile,
    time_bands,
    total,
    COUNT(*) AS Duplicate_Count
FROM bronze.outpatientdata
GROUP BY
    archive_date,
    specialty_hipe,
    Speciality,
    adult_child,
    age_profile,
    time_bands,
    total
HAVING COUNT(*) > 1
--ORDER BY Duplicate_Count DESC
) AS out_duplicates;

SELECT
    archive_date,
    specialty_hipe,
    adult_child,
    age_profile,
    time_bands,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.outpatientdata
GROUP BY
    archive_date,
    specialty_hipe,
    adult_child,
    age_profile,
    time_bands
HAVING COUNT(*) > 1
ORDER BY Record_Count DESC;

SELECT *
FROM bronze.outpatientdata
WHERE archive_date = '2018-05-31'
  AND specialty_hipe = 2600
  AND adult_child = 'Child'
  AND age_profile = '16-64'
  AND time_bands = ' 6-9 Months';

  /*
archive_date	specialty_hipe	Speciality	adult_child	age_profile	time_bands	total
2018-05-31	2600	General Surgery	Child	16-64	 6-9 Months	4
2018-05-31	2600	General Surgery	Child	16-64	 6-9 Months	1
/*

/*
Findings:
### Outpatient Business Grain Validation

- The outpatient dataset also contains multiple records with the same dimensional attributes but different `total` values.
- Example: two records for General Surgery on 31-May-2018, with `Child`, `16-64`, and `6-9 Months`, contain `total` values of 4 and 1.
- These records are not exact duplicates because their measure values differ.
- The records should therefore be aggregated using `SUM(total)` at the defined analytical grain rather than deleted as duplicates.
- This confirms that repeated dimensional combinations are present in both inpatient and outpatient datasets.
*/



--Overall Findings:

/*
### Outpatient Business Grain Validation

- The outpatient dataset contains 21,654 groups with repeated dimensional combinations.
- These groups contain 50,354 rows in total.
- There are 28,700 additional rows beyond the first occurrence within each repeated group.
- The maximum number of repetitions for a single dimensional combination is 11.
- Repeated dimensional combinations are therefore common in the outpatient Bronze dataset.
- These repeated records should not be automatically treated as erroneous duplicates.
- The evidence from both inpatient and outpatient datasets indicates that `total` should be aggregated using `SUM(total)` at the standardized analytical grain in the Silver layer.

### Phase 4 Duplicate Analysis — Overall Finding

- Both fact tables contain significant numbers of repeated dimensional combinations.
- Investigation of individual examples confirmed that repeated records can contain different `total` values.
- Therefore, the repeated records represent source-level observations that require aggregation rather than simple duplicate deletion.
- Exact duplicate rows, where all dimensions and the measure are identical, should still be monitored separately.
- The final Silver transformation should standardize the dimensional columns and aggregate `total` at the agreed analytical grain.

*/

/*
Combined Finding
Dataset	    Duplicate Groups	Additional Rows	    Max Repetitions
Inpatient	26,287	        39,792	                12
Outpatient	21,654	        28,700	                11

*/


USE HealthCareDB
GO

--- Phase 5 — Missing Values
/*
Objective:
For every missing value identified in Phase 3, we now determine:

How many records are affected?
What other information exists in those records?
Can the missing value be reliably derived?
What should happen to it in the Silver layer?
*/

--Step 1 — Investigate specialty_hipe NULLs
SELECT
	Speciality,
	COUNT(*) AS Record_Count
FROM bronze.outpatientdata
WHERE specialty_hipe IS NULL
GROUP BY Speciality
ORDER BY Record_Count DESC;

--whether Other has a consistent specialty_hipe
SELECT
    specialty_hipe,
    COUNT(*) AS Record_Count
FROM bronze.outpatientdata
WHERE Speciality = 'Other'
GROUP BY specialty_hipe
ORDER BY Record_Count DESC;

--- How is data distributed when specialty_hipe IS NULL
SELECT
    archive_date,
    Speciality,
    adult_child,
    age_profile,
    time_bands,
    COUNT(*) AS Record_Count
FROM bronze.outpatientdata
WHERE specialty_hipe IS NULL
GROUP BY
    archive_date,
    Speciality,
    adult_child,
    age_profile,
    time_bands
ORDER BY archive_date, Record_Count DESC;

--Lets 
SELECT *
FROM bronze.specialty_mapping
WHERE specialty = 'Other';

/*
Final decision: specialty_hipe IS NULL

### `specialty_hipe` Missing Values

- The outpatient dataset contains 191 NULL values in `specialty_hipe`.
- All 191 NULL records belong to the `Other` specialty.
- The `Other` specialty also has 53 records with `specialty_hipe = 9000`, but this is insufficient evidence to assign 9000 to the NULL records.
- The specialty mapping table contains `Other → Other` but does not provide a HIPE identifier.
- Therefore, the 191 NULL `specialty_hipe` values cannot be reliably derived from the available source data.
- The NULL values should be retained in the Silver layer rather than replaced with an assumed identifier.
- The corresponding `speciality_group` can still be populated through the specialty mapping join.

specialty_hipe NULL
        ↓
No reliable source to derive value
        ↓
Retain NULL in Silver

191 NULL specialty_hipe → Retain NULL in Silver.

*/

-- Step 2: Outpatient adult_child — 175 NULL + 175 blank values.
--Step 2 — adult_child Missing Values

/*
We know from Phase 3 that Outpatient has:

175 NULL values
175 blank/whitespace values

First, let's verify whether these are two separate sets of records or the same 175 records.

*/

SELECT
    COUNT(*) AS Total_Missing_Adult_Child,
    SUM(CASE WHEN adult_child IS NULL THEN 1 ELSE 0 END) AS Null_Count,
    SUM(CASE WHEN adult_child IS NOT NULL
              AND LTRIM(RTRIM(adult_child)) = '' THEN 1 ELSE 0 END) AS Blank_Count
FROM bronze.outpatientdata
WHERE ( adult_child IS NULL OR LTRIM(RTRIM(adult_child)) = '');

--So we do not have NULL adult_child values. We have 175 blank/whitespace values.
--Now we need to determine whether these 175 blanks can be reliably derived from age_profile.

-- Step 2A — Check the 175 blank records
SELECT
    age_profile,
    COUNT(*) AS Record_Count
FROM bronze.outpatientdata
WHERE adult_child IS NOT NULL
  AND LTRIM(RTRIM(adult_child)) = ''
GROUP BY age_profile
ORDER BY Record_Count DESC;

--Step 2B — Investigate the 175 records
SELECT
    Speciality,
    COUNT(*) AS Record_Count
FROM bronze.outpatientdata
WHERE LTRIM(RTRIM(adult_child)) = ''
  AND age_profile IS NULL
GROUP BY Speciality
ORDER BY Record_Count DESC;

--150 of the 175 records (85.7%) are Clinical (Medical) Genetics.

SELECT
    Speciality,
    MIN(total) AS Min_Total,
    MAX(total) AS Max_Total,
    SUM(total) AS Total_Waitlist,
    COUNT(*) AS Record_Count
FROM bronze.outpatientdata
WHERE LTRIM(RTRIM(adult_child)) = ''
  AND age_profile IS NULL
GROUP BY Speciality
ORDER BY Record_Count DESC;

/*
For the 175 records:

adult_child → blank
age_profile → NULL
total → valid values (1–10)
Records are distributed across multiple specialties.
Clinical (Medical) Genetics accounts for 150 of 175 records.

There is no reliable source column from which we can derive the missing demographic classifications.

Therefore, we should retain the missing values rather than inventing Adult, Child, or an age group.
*/

/*
Silver-layer decision
adult_child = blank
age_profile  = NULL
        ↓
No reliable derivation rule
        ↓
Standardize blank → NULL
        ↓
Retain NULL in Silver
*/

/*
### `adult_child` and `age_profile` Missing Values

- The outpatient dataset contains 175 records where `adult_child` is blank.
- The 175 records also have `age_profile` as NULL.
- Therefore, `adult_child` cannot be reliably derived from `age_profile`.
- The records contain valid `total` values, confirming that they represent legitimate observations rather than empty records.
- Clinical (Medical) Genetics accounts for 150 of the 175 affected records.
- The remaining records are distributed across several other specialties.
- No reliable derivation rule was identified from the available columns.
- The blank `adult_child` values should therefore be standardized to NULL and retained in the Silver layer.
- The NULL `age_profile` values should also be retained.
*/


--Step 3 — time_bands Missing Values

SELECT *
FROM bronze.outpatientdata
WHERE time_bands IS NULL;
/*
time_bands = NULL
        ↓
No reliable derivation rule
        ↓
Retain NULL in Silver
*/

/*
### `time_bands` Missing Values

- The outpatient dataset contains 2 records with NULL `time_bands`.
- Both records contain valid `total` values of 1.
- The records belong to Small Volume Specialities and Geriatric Medicine respectively.
- No deterministic relationship was identified that would allow `time_bands` to be reliably derived from the other available columns.
- The NULL values should therefore be retained in the Silver layer rather than being assigned an assumed time band.
*/

SELECT
    COUNT(*) AS Total_Rows,

    SUM(CASE WHEN archive_date IS NULL THEN 1 ELSE 0 END) AS Null_Archive_Date,
    SUM(CASE WHEN specialty_hipe IS NULL THEN 1 ELSE 0 END) AS Null_Specialty_HIPE,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(specialty_name)), '') IS NULL THEN 1 ELSE 0 END) AS Blank_Specialty,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(case_type)), '') IS NULL THEN 1 ELSE 0 END) AS Blank_Case_Type,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(adult_child)), '') IS NULL THEN 1 ELSE 0 END) AS Blank_Adult_Child,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(age_profile)), '') IS NULL THEN 1 ELSE 0 END) AS Blank_Age_Profile,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(time_bands)), '') IS NULL THEN 1 ELSE 0 END) AS Blank_Time_Bands,
    SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END) AS Null_Total
    FROM bronze.inpatientdata;

SELECT
    COUNT(*) AS Total_Rows,

    SUM(CASE WHEN archive_date IS NULL THEN 1 ELSE 0 END) AS Null_Archive_Date,
    SUM(CASE WHEN specialty_hipe IS NULL THEN 1 ELSE 0 END) AS Null_Specialty_HIPE,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(Speciality)), '') IS NULL THEN 1 ELSE 0 END) AS Blank_Speciality,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(adult_child)), '') IS NULL THEN 1 ELSE 0 END) AS Blank_Adult_Child,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(age_profile)), '') IS NULL THEN 1 ELSE 0 END) AS Blank_Age_Profile,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(time_bands)), '') IS NULL THEN 1 ELSE 0 END) AS Blank_Time_Bands,
    SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END) AS Null_Total

FROM bronze.outpatientdata;


/*

## Phase 5: Missing Values

### Summary

- Inpatient contains 182,136 records with no NULL or blank values across the analyzed columns.
- Outpatient contains 270,983 records with four identified missing-data issues:
  - 191 NULL `specialty_hipe` values.
  - 175 blank `adult_child` values.
  - 175 NULL `age_profile` values.
  - 2 NULL `time_bands` values.

### Silver Layer Decisions

- `specialty_hipe`: Retain the 191 NULL values because no reliable HIPE identifier could be derived.
- `adult_child`: Convert the 175 blank values to NULL.
- `age_profile`: Retain the 175 NULL values.
- `time_bands`: Retain the 2 NULL values because no reliable derivation rule exists.

No missing values will be artificially imputed.

*/


/*
------ Final Silver Table Validation after Transformation:

SELECT
    SUM(CASE WHEN archive_date IS NULL THEN 1 ELSE 0 END) AS Null_Archive_Date,
    SUM(CASE WHEN specialty_hipe IS NULL THEN 1 ELSE 0 END) AS Null_Specialty_HIPE,
    SUM(CASE WHEN specialty_name IS NULL THEN 1 ELSE 0 END) AS Null_Specialty_Name,
    SUM(CASE WHEN case_type IS NULL THEN 1 ELSE 0 END) AS Null_Case_Type,
    SUM(CASE WHEN adult_child IS NULL THEN 1 ELSE 0 END) AS Null_Adult_Child,
    SUM(CASE WHEN age_profile IS NULL THEN 1 ELSE 0 END) AS Null_Age_Profile,
    SUM(CASE WHEN time_bands IS NULL THEN 1 ELSE 0 END) AS Null_Time_Bands,
    SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END) AS Null_Total
FROM silver.patientwaitlistdata;