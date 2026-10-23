/*
* This query retrieves the top 10 most demanded skills for the job title 'Data Engineer' in Colombia.
*/

SELECT 
sd.skills,
COUNT(sd.skills) AS total_skills,
FROM SKILLS_DIM  AS sd
INNER JOIN skills_job_dim AS sjd
    ON sd.skill_id = sjd.skill_id

INNER JOIN job_postings_fact AS jpf
    ON sjd.job_id = jpf.job_id
WHERE 
    jpf.job_country = 'Colombia' 
    AND  
    jpf.job_title_short = 'Data Engineer'           
GROUP BY
   sd.skills
ORDER BY  total_skills DESC
LIMIT 10   
  ;
/* RESULTS: 
┌───────────┬──────────────┐
│  skills   │ total_skills │
│  varchar  │    int64     │
├───────────┼──────────────┤
│ sql       │         1533 │
│ python    │         1462 │
│ aws       │          809 │
│ spark     │          652 │
│ azure     │          593 │
│ airflow   │          474 │
│ snowflake │          452 │
│ java      │          408 │
│ gcp       │          384 │
│ scala     │          371 │
└───────────┴──────────────┘
*/
