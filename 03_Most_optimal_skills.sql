/*
* 
*/

SELECT 
    sd.skills,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY jpf.salary_year_avg),1) AS median_salary,
    COUNT(jpf.*) AS posting_count,
    ROUND(LN(COUNT(jpf.*))) AS log_posting_count,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY jpf.salary_year_avg) * LN(COUNT(jpf.*))/1000000,2) AS Optimal_score
FROM SKILLS_DIM  AS sd
INNER JOIN skills_job_dim AS sjd
    ON sd.skill_id = sjd.skill_id
INNER JOIN job_postings_fact AS jpf
    ON sjd.job_id = jpf.job_id
WHERE 
    jpf.salary_year_avg IS NOT NULL
 AND
    jpf.job_country = 'Colombia' 
 AND  
    jpf.job_title_short = 'Data Engineer'           
GROUP BY
   sd.skills

  HAVING COUNT(jpf.*) > 5 
  
ORDER BY  Optimal_score DESC 
LIMIT 25

;

/*

RESULTS: Most Optimal Skills for Data Engineers in Colombia
┌────────────┬───────────────┬───────────────┬───────────────────┬───────────────┐
│   skills   │ median_salary │ posting_count │ log_posting_count │ Optimal_score │
│  varchar   │    double     │     int64     │      double       │    double     │
├────────────┼───────────────┼───────────────┼───────────────────┼───────────────┤
│ sql        │       96773.0 │            18 │               3.0 │          0.28 │
│ python     │       96773.0 │            13 │               3.0 │          0.25 │
│ azure      │       96773.0 │            12 │               2.0 │          0.24 │
│ aws        │      134000.0 │             6 │               2.0 │          0.24 │
│ spark      │       96773.0 │            10 │               2.0 │          0.22 │
│ databricks │       96773.0 │            10 │               2.0 │          0.22 │
│ sql server │       96773.0 │            10 │               2.0 │          0.22 │
│ redshift   │       96773.0 │             9 │               2.0 │          0.21 │
│ nosql      │       96773.0 │             9 │               2.0 │          0.21 │
│ dynamodb   │       96773.0 │             7 │               2.0 │          0.19 │
│ oracle     │       96773.0 │             7 │               2.0 │          0.19 │
└────────────┴───────────────┴───────────────┴───────────────────┴───────────────┘

*/

-- Query to obtain the most optimal skills for remote Data Engineers based on median salary and posting count.
SELECT 
    sd.skills,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY jpf.salary_year_avg),1) AS median_salary,
    COUNT(jpf.*) AS posting_count,
    ROUND(LN(COUNT(jpf.*))) AS log_posting_count,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY jpf.salary_year_avg) * LN(COUNT(jpf.*))/1000000,2) AS Optimal_score
FROM SKILLS_DIM  AS sd
INNER JOIN skills_job_dim AS sjd
    ON sd.skill_id = sjd.skill_id
INNER JOIN job_postings_fact AS jpf
    ON sjd.job_id = jpf.job_id
WHERE 
     jpf.salary_year_avg IS NOT NULL
     AND
    jpf.job_work_from_home = TRUE 
    AND  
    jpf.job_title_short = 'Data Engineer'           
GROUP BY
   sd.skills

  HAVING COUNT(jpf.*) > 100 
  
ORDER BY  Optimal_score DESC 
LIMIT 25

;

/*
* Most Optimal Skills for  Remote Data Engineers 
┌────────────┬───────────────┬───────────────┬───────────────────┬───────────────┐
│   skills   │ median_salary │ posting_count │ log_posting_count │ Optimal_score │
│  varchar   │    double     │     int64     │      double       │    double     │
├────────────┼───────────────┼───────────────┼───────────────────┼───────────────┤
│ terraform  │      184000.0 │           193 │               5.0 │          0.97 │
│ python     │      135000.0 │          1133 │               7.0 │          0.95 │
│ aws        │      137320.3 │           783 │               7.0 │          0.91 │
│ sql        │      130000.0 │          1128 │               7.0 │          0.91 │
│ airflow    │      150000.0 │           386 │               6.0 │          0.89 │
│ spark      │      140000.0 │           503 │               6.0 │          0.87 │
│ snowflake  │      135500.0 │           438 │               6.0 │          0.82 │
│ kafka      │      145000.0 │           292 │               6.0 │          0.82 │
│ azure      │      128000.0 │           475 │               6.0 │          0.79 │
│ java       │      135000.0 │           303 │               6.0 │          0.77 │
│ scala      │      137290.5 │           247 │               6.0 │          0.76 │
│ git        │      140000.0 │           208 │               5.0 │          0.75 │
│ kubernetes │      150500.0 │           147 │               5.0 │          0.75 │
│ databricks │      132750.0 │           266 │               6.0 │          0.74 │
│ redshift   │      130000.0 │           274 │               6.0 │          0.73 │
│ gcp        │      136000.0 │           196 │               5.0 │          0.72 │
│ nosql      │      134415.0 │           193 │               5.0 │          0.71 │
│ hadoop     │      135000.0 │           198 │               5.0 │          0.71 │
│ pyspark    │      140000.0 │           152 │               5.0 │           0.7 │
│ mongodb    │      135750.0 │           136 │               5.0 │          0.67 │
│ docker     │      135000.0 │           144 │               5.0 │          0.67 │
│ r          │      134775.0 │           133 │               5.0 │          0.66 │
│ go         │      140000.0 │           113 │               5.0 │          0.66 │
│ bigquery   │      135000.0 │           123 │               5.0 │          0.65 │
│ github     │      135000.0 │           127 │               5.0 │          0.65 │
└────────────┴───────────────┴───────────────┴───────────────────┴───────────────┘
*/