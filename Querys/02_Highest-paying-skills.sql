/*
* this query is used to find the highest paying skills for a specific job title in a specific country. It calculates the median salary for each skill and counts the total number of occurrences of each skill in job postings.
*/
/*
v1: ranking base  
*/
SELECT 
sd.skills,
 PERCENTILE_CONT(0.5)
    WITHIN GROUP (ORDER BY jpf.salary_year_avg) AS median_salary,
COUNT(*) AS posting_count
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
ORDER BY  median_salary DESC ,posting_count DESC
LIMIT 10
  ;

/*
RESULTS:

┌────────────┬───────────────┬───────────────┐
│   skills   │ median_salary │ posting_count │
│  varchar   │    double     │     int64     │
├────────────┼───────────────┼───────────────┤
│ rust       │      161875.0 │             1 │
│ zoom       │      161875.0 │             1 │
│ express    │      161875.0 │             1 │
│ kubernetes │      145000.0 │             3 │
│ go         │      145000.0 │             1 │
│ aws        │      134000.0 │             6 │
│ docker     │      134000.0 │             2 │
│ javascript │      129659.5 │             2 │
│ airflow    │      123000.0 │             3 │
│ fastapi    │      123000.0 │             1 │
└────────────┴───────────────┴───────────────┘


In this first version, the median salary is heavily influenced by skills that appear in only one or two postings. Since Colombia has a limited number of postings with a specified salary, a single observation can push a skill to the top of the ranking without being representative
*/

/*
V2: ranking base with a filter to avoid skills with less than 5 occurrences in job postings
*/

SELECT 
sd.skills,
 PERCENTILE_CONT(0.5)
    WITHIN GROUP (ORDER BY jpf.salary_year_avg) AS median_salary,
COUNT(*) AS posting_count
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
ORDER BY  median_salary DESC ,posting_count DESC

  ;

  /*
RESULTS: 
┌────────────┬───────────────┬───────────────┐
│   skills   │ median_salary │ posting_count │
│  varchar   │    double     │     int64     │
├────────────┼───────────────┼───────────────┤
│ aws        │      134000.0 │             6 │
│ sql        │       96773.0 │            18 │
│ python     │       96773.0 │            13 │
│ azure      │       96773.0 │            12 │
│ spark      │       96773.0 │            10 │
│ sql server │       96773.0 │            10 │
│ databricks │       96773.0 │            10 │
│ nosql      │       96773.0 │             9 │
│ redshift   │       96773.0 │             9 │
│ dynamodb   │       96773.0 │             7 │
│ oracle     │       96773.0 │             7 │
└────────────┴───────────────┴───────────────┘

To get a more "realistic" result, I added a HAVING clause that keeps only skills with a minimum number of postings. The threshold is adjustable depending on how much data is available for the selected country.
*/



SELECT 
sd.skills,
 PERCENTILE_CONT(0.5)
    WITHIN GROUP (ORDER BY jpf.salary_year_avg) AS median_salary,
COUNT(*) AS posting_count
FROM SKILLS_DIM  AS sd
INNER JOIN skills_job_dim AS sjd
    ON sd.skill_id = sjd.skill_id
INNER JOIN job_postings_fact AS jpf
    ON sjd.job_id = jpf.job_id
WHERE 
     jpf.salary_year_avg IS NOT NULL
     AND
    jpf.job_country = 'United States' 
    AND  
    jpf.job_title_short = 'Data Engineer'           
GROUP BY
   sd.skills
HAVING COUNT(jpf.*) > 100 

ORDER BY  median_salary DESC ,posting_count DESC


  ;