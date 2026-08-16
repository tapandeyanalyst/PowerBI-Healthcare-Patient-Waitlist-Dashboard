--------------------------------
--Phase 8 — Outlier & Numeric Analysis
--------------------------------
/*
For this healthcare waitlist dataset, the main numeric field is: total
We already validated the basic integrity:
    Minimum = 1
    Maximum = 4,239
    Zero = 0
    Negative = 0

But Phase 8 should also check whether there are statistical outliers.

*/

--8.1 — Calculate Quartiles and IQR
WITH Stats AS
(
    SELECT DISTINCT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY total) OVER () AS Q1,

        PERCENTILE_CONT(0.50)
            WITHIN GROUP (ORDER BY total) OVER () AS Median_Total,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY total) OVER () AS Q3
    FROM silver.patientwaitlistdata
)
SELECT
    MIN(total) AS Min_Total,
    MAX(total) AS Max_Total,
    AVG(CAST(total AS DECIMAL(18,2))) AS Avg_Total,
    MAX(Q1) AS Q1,
    MAX(Median_Total) AS Median_Total,
    MAX(Q3) AS Q3,
    MAX(Q3 - Q1) AS IQR,
    MAX(Q3 + (1.5 * (Q3 - Q1))) AS Upper_Outlier_Boundary
FROM silver.patientwaitlistdata
CROSS JOIN Stats;
/*
So statistically, values above 128 are potential outliers.
But remember: potential outlier ≠ bad data. A large waitlist can be completely legitimate.
*/

SELECT
    COUNT(*) AS Outlier_Record_Count,
    SUM(total) AS Outlier_Total_Waitlist,
    MIN(total) AS Min_Outlier,
    MAX(total) AS Max_Outlier
FROM silver.patientwaitlistdata
WHERE total > 128;
/*
We found:

51,411 records above the statistical boundary of 128
These records contain 15,299,487 total waitlist
Minimum potential outlier = 129
Maximum = 4,239

That's a significant number of statistical outliers, so we should not treat them as data errors automatically.

For a healthcare waiting-list dataset, high values can be legitimate—for example, a high-volume speciality/month/age-band combination.
*/

--Phase 8.3 — Check where the high values occur
SELECT
    data_category,
    speciality_name,
    COUNT(*) AS Outlier_Records,
    SUM(total) AS Outlier_Waitlist,
    MAX(total) AS Max_Total
FROM silver.patientwaitlistdata
WHERE total > 128
GROUP BY
    data_category,
    speciality_name
ORDER BY
    Outlier_Waitlist DESC;