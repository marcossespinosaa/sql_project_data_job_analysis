/*
What are the top paying data analyst jobs?
Identify the top 10 highest paying Data Analyst roles that are available remotely.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    CAST(salary_year_avg AS MONEY),
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim USING(company_id)
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;