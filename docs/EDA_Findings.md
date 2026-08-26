# EDA - Exploratory Data Analysis

Exploratory data analysis is the most important phase of the project. Up until now, we've been collecting and storing data. From here onward, we'll understand the data, its quality, its type and granularity .The quality of the Silver layer, Gold layer, and ultimately your Power BI dashboard will depend on the quality of this EDA.  

EDA Framework:   
* Phase 1  : Dataset Overview
* Phase 2  : Data Quality
* Phase 3  : Business Rule Validation
* Phase 4  : Relationship Analysis
* Phase 5  : Silver Layer Recommendation
---

## Phase 1 — Dataset Overview
Objective: Build a high-level understanding of each Bronze table before examining individual columns.   

* Data Inventory:
   * Tables available in bronze layer.
   * Type of the table:
      * Fact / Lookup
         * Fact tables which provides dimensions/measures
         * Lookup: May provide additional information of the fact table.
   * Purpose
   * The Grain : "What does one row represent?" This is called the grain of the table.
   * Number of Rows
   * Number of Columns

* Column Inventory:
   * Column names
   * Datatype
   * Column description: What does the particular column mean?
   * Column role: Dimension/Measure/Key Identifier

### Findings:
1. Inpatient and Outpatient are fact tables
2. spciality mapping table is a lookup table.
3. Inpatient table has 182136 record counts with 8 coloumns
4. Outpatient Table has 270983 record counts with 7 columns
5. speciality mapping table has 78 record counts with 3 columns
6. `specialty_hipe` is considered as dimension because in the Hospital In-Patient Enquiry (HIPE) system, the specialty of a case is a code assigned based on the specialty assignment of the consultant associated with the patient's principal diagnosis.

Refer : [Dataset Overview Query](../sql/eda_analysis/Phase_1_Dataset_Overview.sql)

## Phase 2  : Data Quality

### Findings:
- data_category
   - No issues found
   - Tranformation required: No

- archive_date
   - No issues found
   - No Tranformation requird.
   - Date Format: YYYY-MM-DD
   - Tranformation required: No

- speciality_hipe
   - speciality_hipe has 2231 recods with value 0
   - 0's are for Small Volume Specialities. Its not an issue.
   - 191 NULLs and all for 'Other' speciality_name. If the report does not require nulls, we can filter at the dashboard level.
   - Transformation required : No

- speciality_name
   - No Nulls
   - No Blanks
   - No inconsistencies in data
   - Transformation required : Yes
      - TRIM(speciality_hipe)

- case_type
   - No Nulls
   - No Blanks
   - No inconsistencies in data
   - Transformation required : Yes
      - TRIM(speciality_hipe)

- adult_child
   - No Nulls
   - 175 records where it is blank
   - adult_child is based on age_profile and in 175 records in the outpatient table age_profile is NULL
      - If the report does not require nulls, we can filter at the dashboard level.
   - Transformation required: Yes  
      - CASE
         WHEN TRIM(age_profile) = '1-16' THEN 'Child'  
         WHEN TRIM(age_profile) = '17-59' THEN 'Adult'  
         WHEN TRIM(age_profile) = '60+' THEN 'Senior Citizens'  
         ELSE adult_child END AS adult_child,  

- age_profile
   - No blank
   - 175 records where it is NUlls
   - Transformation required: Yes  
      - CASE
         WHEN TRIM(age_profile) = '0-15' THEN '1-16'  
         WHEN TRIM(age_profile) = '16-64' THEN '17-59'  
         WHEN TRIM(age_profile) = '65+' THEN '60+'  
         ELSE age_profile END AS age_profile,  

- time_bands
   - No blanks
   - in 2 business time_bands is NULL
      - No action is required as of now.
   - Transformation required : Yes
      -  CASE  
         WHEN TRIM(time_bands) = '18 Months +' THEN '18+ Months'  
         ELSE TRIM(time_bands)  
         END AS time_bands,  

- total
   - No blanks
   - No NULLs
   - No Negative values
   - No Zeros

## Phase 3  : Business Rule Validation
* Refer : [Business Rule Validation Script](../sql/eda_analysis/Phase_3_Business-Rule-Validation.sql)

## Phase 4  : Relationship Analysis
* Refer : [Relationship Analysis Script](../sql/eda_analysis/Phase_4_Relationship_Analysis.sql)

## Phase 5  : Silver Layer Recommendations
The EDA findings were used to define the transformation rules implemented in the Silver Layer.

### Transformation Summary

| EDA Finding | Silver Layer Transformation |
|---|---|
| Leading/trailing whitespace | Apply `TRIM()` |
| Inconsistent age profiles | Standardize age profile values |
| Inconsistent time-band values | Standardize `18 Months +` to `18+ Months` |
| Different source structures | Combine Inpatient and Outpatient using `UNION ALL` |
| Missing Outpatient Case Type | Assign `Outpatient` as the case type |
| Specialty mapping required | Integrate specialty mapping |
| Duplicate specialty mapping combinations | Use `GROUP BY` to retain unique mappings |
| Adult/Child classification requires standardization | Derive standardized `adult_child` values |

### Silver Layer Objects

- `silver.patientwaitlistdata`
- `silver.speciality_mapping`
- `silver.load_silver`

### Gold Layer Object

- `gold.patientwaitlistdata`

### Automation

The Silver and Gold layers are refreshed through the master stored procedure:

```sql
dbo.sp_load
<<<<<<< HEAD
=======

```
## PowerBI Dashboard Screenshot
>>>>>>> 7126ffc (Update Files)
