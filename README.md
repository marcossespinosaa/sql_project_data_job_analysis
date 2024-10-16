# Introduction
Dive ino the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

SQL queries? Check them out here: [project_sql_folder](/project_sql/)

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

Data is from [this SQL Course](https://lukebarousse.com/sql)

### Questions answered
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
- **SQL:** The backbone of the analysis
- **PostgreSQL:** The chosen database management system
- **Visual Studio Code:** For executing SQL queries
- **Git & GitHub:** For version control and collaboration

# The Analysis
### 1. Top Paying Data Analyst Jobs
This query highlights the high paying opportunities in the field.

```sql
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
```

### 2. Skills for Top Paying Jobs
Provides insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        CAST(salary_year_avg AS MONEY),
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
)

SELECT 
    top_paying_jobs.*,
    skills_dim.skills 
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

### 3. In-Demand Skills for Data Analysts
This query identifies the skills most frequently requested in job postings.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills reviealed which are the highest paying.

```sql
SELECT 
    skills,
    CAST(AVG(salary_year_avg) AS MONEY) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```

### 5. Most Optimal Skills to Learn
This query pinpoints skills that are both in high demand and that are high-paying.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    CAST(AVG(job_postings_fact.salary_year_avg) AS MONEY) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

# What I Learned
- **Complex Query Crafting**
- **Data Aggregation**
- **Puzzle Solving Skills**

# Conclusion
### Closing Thoughts
This projecy enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.