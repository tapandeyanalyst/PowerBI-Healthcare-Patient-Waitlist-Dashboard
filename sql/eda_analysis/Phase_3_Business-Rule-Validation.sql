USE HealthCareDB

----------------Phase 7 — Business Rule Validation
/*
We'll validate the data in this order:

Step		Business Rule						Purpose
7.1			adult_child -> age_profile			Detect impossible age combinations
7.2			case_type -> source dataset			Validate our Outpatient classification
7.3			time_bands							Validate allowed categories and sequence
7.4			specialty_hipe -> speciality		Check code-to-speciality consistency
7.5			speciality -> speciality_mapping	Confirm mapping consistency
7.6			total business validity				Check whether totals behave logically
7.7			Cross-column anomalies				Investigate unusual combinations
*/

SELECT
    adult_child,
    age_profile,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM silver.patientwaitlistdata
GROUP BY
    adult_child,
    age_profile
ORDER BY
    adult_child,
    age_profile;

/*
adult_child	        age_profile	        Records	Total       Waitlist	Status
Adult	            0-15	            543	                652         ⚠️ Investigate
Adult	            16-64	            83,687	            1,663,670	✅
Adult	            65+	                69,590	            963,254	    ✅
Child	            0-15	            24,607	            266,969	    ✅
Child	            16-64	            3,709	            10,685	    ⚠️ Investigate

Two potential business-rule anomalies
Adult + 0-15
    543 records
    652 total waitlist

If adult_child represents the patient category and age_profile represents the actual age band, this combination appears contradictory.

Child + 16-64
    3,709 records
    10,685 total waitlist

This is also potentially contradictory.

However, we should not correct either value in Silver yet. These could be:
    - genuine source-data classification issues,
    - differences in how adult_child was defined,
    - historical data-entry conventions,
    - or actual data-quality problems.

Overall Inpatient impact
Potentially inconsistent records: 
    543 + 3,709 = 4,252 records
    That's approximately 2.33% of the Inpatient dataset.

Their combined waitlist:
    652 + 10,685 = 11,337
    That's approximately 0.39% of the total Inpatient waitlist.

Markdown
### Phase 7.1 — `adult_child` vs `age_profile`: Inpatient

Expected logical relationships:

- Adult → `16-64` or `65+`
- Child → `0-15`

Observed potential inconsistencies:

- Adult + `0-15`: 543 records, total waitlist 652.
- Child + `16-64`: 3,709 records, total waitlist 10,685.
- No Child + `65+` records were identified.

Total potentially inconsistent records: 4,252 (approximately 2.33% of Inpatient records).
Combined waitlist associated with these records: 11,337 (approximately 0.39% of the Inpatient total waitlist).
These combinations should be investigated as potential business-rule anomalies. They should not be automatically corrected or removed during Silver transformation without confirmation of the source-system definitions.
*/

SELECT
    adult_child,
    age_profile,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.outpatientdata
GROUP BY
    adult_child,
    age_profile
ORDER BY
    adult_child,
    age_profile;

    /*
adult_child	        age_profile	    Records	    Total Waitlist	    Status
Blank	            NULL	        175	        478	                ⚠️ Missing
Adult	            0-15	        3,482	    34,717	            ⚠️ Investigate
Adult	            0-15	        1,507	    10,894	            ⚠️ Investigate
Adult	            16-64	        108,841	    13,329,218	        ✅
Adult	            65+	            100,622	    5,076,403	        ✅
Child	            0-15	        32,592	    2,209,648	        ✅
Child	            0-15	        16,282	    979,618	            ✅*
Child	            16-64	        7,207	    94,024	            ⚠️ Investigate
Child	            65+	            275	        739	                🚨 Investigate
    */

/*
Three Business-Rule Findings
1. Adult + 0-15
    After normalizing the leading space:
    3,482 + 1,507 = 4,989 records
    with a combined waitlist of:
    34,717 + 10,894 = 45,611
This is a potential age-category inconsistency.

2. Child + 16-64
    7,207 records with: 94,024 total waitlist
    This is a significant potential business-rule anomaly.

3. Child + 65+
    This is the strongest anomaly:
    275 records with only 739 total waitlist.
    A Child associated with the 65+ age profile appears logically contradictory under the expected business definition.

Potentially inconsistent combinations:

Issue	            Records	    Waitlist
Adult + 0-15	    4,989	    45,611
Child + 16-64	    7,207	    94,024
Child + 65+	        275	        739
Total	            12,471	    140,374

That's approximately:
    4.60% of Outpatient records
    0.65% of Outpatient total waitlist
So again, this is not huge in waitlist volume, but it is meaningful from a data-quality/business-rule perspective.

### Phase 7.1 — `adult_child` vs `age_profile`: Outpatient
Expected logical relationships:

- Adult → `16-64` or `65+`
- Child → `0-15`

Observed potential inconsistencies:

- Adult + `0-15`: 4,989 records after combining `0-15` and ` 0-15`, with total waitlist 45,611.
- Child + `16-64`: 7,207 records, with total waitlist 94,024.
- Child + `65+`: 275 records, with total waitlist 739.
- 175 records have both blank `adult_child` and NULL `age_profile`, with total waitlist 478.

Total potentially inconsistent age-category records: 12,471 (approximately 4.60% of Outpatient records).
Combined waitlist associated with potentially inconsistent combinations: 140,374 (approximately 0.65% of Outpatient total waitlist).
These records should not be automatically corrected or removed. The source-system definitions should be investigated before applying any business-rule correction.
The `0-15` and ` 0-15` values should first be normalized using TRIM() before evaluating the business rule.

*/
SELECT
    age_profile,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.inpatientdata
GROUP BY
   age_profile
ORDER BY
    age_profile;
/*
age_profile	    new_age_profile
0-15	        1-16
16-64	        17-59
65+	            60+

### Phase 7.1 — Age Profile Business Rule
A software inconsistency was identified in the source system's age-profile classification.
The Team Manager provided the approved correction:

| Current age_profile | New age_profile |
|---|---|
| `0-15` | `1-16` |
| `16-64` | `17-59` |
| `65+` | `60+` |

This is a classification-label correction only. No records or waitlist totals are redistributed between categories.
The existing record counts and `total` values remain unchanged.
The correction will be implemented in the Silver transformation.
The Engineering team is separately working to resolve the underlying backend/software inconsistency.
This correction is not expected to impact business insights because the change is to the age-band labels rather than the underlying record volumes or waitlist totals.

CASE
    WHEN TRIM(age_profile) = '0-15' THEN '1-16'
    WHEN TRIM(age_profile) = '16-64' THEN '17-59'
    WHEN TRIM(age_profile) = '65+' THEN '60+'
    ELSE NULL
END AS age_profile
*/

--Transformation age_profile and adult_child
SELECT
age_profile,
age_profile_updated,
adult_child,
    CASE
    WHEN TRIM(age_profile_updated) = '1-16' THEN 'Child'
    WHEN TRIM(age_profile_updated) = '17-59' THEN 'Adult'
    WHEN TRIM(age_profile_updated) = '60+' THEN 'Senior Citizens'
    ELSE age_profile_updated
END AS adult_child_updated

fROM(

SELECT
    TRIM(age_profile) AS age_profile,
    CASE
    WHEN TRIM(age_profile) = '0-15' THEN '1-16'
    WHEN TRIM(age_profile) = '16-64' THEN '17-59'
    WHEN TRIM(age_profile) = '65+' THEN '60+'
    ELSE NULL
END AS age_profile_updated,
    adult_child,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.inpatientdata
GROUP BY
    adult_child,
    TRIM(age_profile)
) as t
-------------------------------------------------------------------------------------------------------

----------------------------------
--Phase 7.2 — case_type Validation
----------------------------------

--Lets validate case_type in Inpatient data

SELECT
    case_type,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM bronze.inpatientdata
GROUP BY case_type
ORDER BY case_type;


/* Observations:
We have 2 types of cases in the inpatient table:
1. Day Case
2. Inpatient

And we do not have any data field in the outpatient table, so we will add `case_type` data field in 
the silver layer and will default to 'Outpatient' AS case_type. This will also help us synchronizing columns during UNION.
*/


-----------------------------------------
--Phase 7.4 — time_bands validation
-----------------------------------------
--Let's check what time_bands gives.
SELECT
    TRIM(time_bands) AS time_bands,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM silver.patientwaitlistdata
GROUP BY TRIM(time_bands)
ORDER BY time_bands;
/*
time_bands	        Record_Count	Total_Waitlist
NULL	            2	            2
0-3 Months	        93818	        6984338
12-15 Months	    53839	        1847868
15-18 Months	    45269	        1409466
18 Months +	        19183	        3362358
18+ Months	        24820	        1219913
3-6 Months	        81510	        4318959
6-9 Months	        71802	        3101584
9-12 Months	        62876	        2396481

We have potential 2 issues in time_bands that needs to be fixed.
18 Months +	
18+ Months

Transformation:
18 Months + → 18+ Months
TRIM all values
NULL → retain NULL

Fixing
CASE
    WHEN TRIM(time_bands) = '18 Months +' THEN '18+ Months'
    ELSE TRIM(time_bands)
END AS time_bands

*/

-----------------------------------------
--Phase 7.5 — total validation
-----------------------------------------
SELECT
    case 
    when SUM(total) = 0 then 'Zero'
    when SUM(total) <0 then 'negative total'
    else 'positive total'
    end as total_update,
    COUNT(*) AS Record_Count,
    SUM(total) AS Total_Waitlist
FROM silver.patientwaitlistdata
/*
There is no potential issues in total
*/
