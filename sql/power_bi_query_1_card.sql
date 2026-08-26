SELECT 
    TOP (10) 
    data_category,
    archive_date,
    YEAR(archive_date) as archive_year,
    speciality_hipe,
    [speciality_name],
    [case_type],
    [adult_child],
    [age_profile],
    [time_bands],
    [total],
    [speciality_group],
    GETDATE()
    --Year(Getdate()) as current_year,
    --Year(DATEADD(year, -1, GETDATE())) as previous_year
  FROM HealthCareDB.gold.patientwaitlistdata

  /*
  SELECT 
  MAX(YEAR(archive_date)),
  archive_date
  FROM HealthCareDB.gold.patientwaitlistdata
  group by archive_date;
  */

  /*
  WITH RankedDates AS (
    SELECT YEAR(archive_date) as year,
           DENSE_RANK() OVER (ORDER BY YEAR(archive_date) DESC) as rnk
    FROM HealthCareDB.gold.patientwaitlistdata
)
SELECT year, rnk FROM RankedDates -- WHERE rnk = 2;
group by year, rnk
order by rnk 
*/

/*
SELECT 
 SUM(total)
 FROM [HealthCareDB].[gold].[patientwaitlistdata]
 where
 archive_date in (select MAX(archive_date) from [HealthCareDB].[gold].[patientwaitlistdata])
 select MAX(archive_date) from [HealthCareDB].[gold].[patientwaitlistdata]
 */


 --Card Display:
 SELECT 
 archive_year,
 SUM(total)
 FROM [HealthCareDB].[gold].[patientwaitlistdata]
 group by archive_year
 order by archive_year desc

 select case_type, count(*)
 FROM gold.patientwaitlistdata
 group by case_type

case_type	(No column name)
Day Case	110185
Outpatient	270983
Inpatient	71951

