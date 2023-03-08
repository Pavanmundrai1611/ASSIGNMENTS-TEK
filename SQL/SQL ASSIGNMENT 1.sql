create database if not exists assignment;
use assignment;
select * from hr_employee;

-- 2.	Return the shape of the table
desc hr_employee;

-- 3.	Show the count of Employee & percentage Workforce in each Department.
SELECT department, COUNT(*) as total
FROM hr_employee
GROUP BY department order by Department;

-- 4.	Which gender have higher strength as workforce in each department?
    SELECT department, gender, COUNT(*) as count
FROM hr_employee
GROUP BY department, gender
HAVING COUNT(*) = (
  SELECT MAX(count)
  FROM (
    SELECT COUNT(*) as count
    FROM hr_employee
    GROUP BY department, gender
  ) sub
  WHERE department = hr_employee.department
  GROUP BY department
);

  --  .5.	Show the workforce in each Job Role
SELECT jobrole, gender, COUNT(*) as count
FROM hr_employee
GROUP BY jobrole, gender order by JobRole;
select jobrole, count(*) as workforce from hr_employee group by jobrole;


-- 6.	Show Distribution of Employee's Age Group
	select age ,count(*) as age_dis from hr_employee group by age order by age;
    ALTER TABLE hr_employee ADD column AGE_GROUP VARCHAR(50);
	SET SQL_SAFE_UPDATES=0;
	UPDATE hr_employee
	SET AGE_GROUP=IF(AGE<=25,'<25',
	IF(AGE>40,'40+','25-40'));
    select age,age_group,count(age_group) as age_gr from hr_employee group by age,age_group;
    
    
    
  --  7.	Compare all marital status of employee and find the most frequent marital status.
  select count(maritalstatus),maritalstatus from hr_employee group by maritalstatus;
  select max(m_count) from(select count(maritalstatus) as m_count from hr_employee group by maritalstatus) as  newt;


 -- 8.	What is Job satisfaction level of employee?
	select jobrole, jobsatisfaction from hr_employee group by jobrole,jobsatisfaction;
    use assignment;
  
  
  -- 9.	How frequently employee is going on Business Trip.
    select * from hr_employee;
    select distinct(jobrole) as 'employee',BusinessTravel from hr_employee order by jobrole;
    
    
    -- 10.	Show the Department with Highest Attrition Rate (Percentage)
    
 SELECT
  department,
  COUNT(*) as total_count,
  COUNT(CASE WHEN attrition = 'Yes' THEN 1 ELSE NULL END) as yes_attrition,
  (COUNT(CASE WHEN attrition = 'Yes' THEN 1 ELSE NULL END) * 100.0 / COUNT(*)) as attrition_rate
FROM hr_employee
GROUP BY department
ORDER BY attrition_rate desc
limit 1;

-- select department , count(attrition)*100/count(attrition) as att from hr_employee where attrition='yes' group by department,attrition;

-- 11.	Show the Job Role with Highest Attrition Rate (Percentage)
SELECT
  jobrole,
  COUNT(*) as total_count,
  COUNT(CASE WHEN attrition = 'Yes' THEN 1 ELSE NULL END) as yes_attrition,
  (COUNT(CASE WHEN attrition = 'Yes' THEN 1 ELSE NULL END) * 100.0 / COUNT(*)) as attrition_rate
FROM hr_employee
GROUP BY jobrole
ORDER BY attrition_rate DESC
limit 1;

-- 12. show distribution of employees promotion find the maximum chances of emplpoyee getting promoted
alter table hr_employee drop promotion_chance; 
alter table hr_employee add column promotion_chance varchar(20);
set sql_safe_updates=0;
update hr_employee
set promotion_chance = if(YearsSinceLastPromotion>10,'high',
if(YearsSinceLastPromotion<5,'low','medium'));
select * from hr_employee;


-- 13.	Find the Attrition Rate for Marital Status

SELECT
  maritalstatus,
  (COUNT(CASE WHEN attrition = 'Yes' THEN 1 ELSE NULL END) * 100 / COUNT(*)) as attrition_rate
FROM hr_employee
GROUP BY maritalstatus;

-- 14.	Find the Attrition Count & Percentage for Different Education Levels
SELECT
  education,
  COUNT(*) as total_count,
  COUNT(CASE WHEN attrition = 'Yes' THEN 1 ELSE NULL END) as attrition_count,
  (COUNT(CASE WHEN attrition = 'Yes' THEN 1 ELSE NULL END) * 100 / COUNT(*)) as attrition_rate
FROM hr_employee
GROUP BY education;


-- 15.	Find the Attrition & Percentage Attrition for Business Travel.
 select BusinessTravel,
 count(*) as Total_count,
 count(case when attrition='yes' then 1 else null end) as yes_attrition,
 count(case when attrition='yes' then 1 else null end) *100/count(*) as attrition_percentage
 from hr_employee
 group by BusinessTravel;
 
 
 -- 16 	Find the Attrition & Percentage Attrition for Various JobInvolvement
 select JobInvolvement,
 count(*) as count,
 count(case when attrition='yes' then 1 else null end) as yes_attrition,
 count(case when attrition='yes' then 1 else null end)*100/count(*) as attrition_percent
 from hr_employee
 group by JobInvolvement;
 
 
 
 -- 17.	Show Attrition Rate for Different JobSatisfaction.
   select JobSatisfaction,
   count(case when attrition='yes'then 1 else null end)*100/count(*) as Attrition_Rate
   from hr_employee
   group by JobSatisfaction;
   
   
   -- 18.Find key reasons for Attrition in Company.
   select Income,MaritalStatus, JobSatisfaction, WorkLifeBalance,YearsSinceLastPromotion,Attrition from 
(select avg(Income) as avg_income from hr_employee) avg_derived_table ,hr_employee
 where (Income > avg_derived_table.avg_income or MaritalStatus = 'Single' 
 or JobSatisfaction = 'Low' or WorkLifeBalance = 'Bad' or YearsSinceLastPromotion < 5) and Attrition like 'Yes';
   
-- 19.	Return all employee where WorkEx greater than 10, provided that they travel frequently,WorkLifeBalance as Good and JobSatisfaction is Very High.
select * from hr_employee where Workex>10 and WorkLifeBalance='good' and BusinessTravel='Travel_frequently'and Jobsatisfaction='very high';
 
 
 
 -- 20.	 Write query to display who has better WorkLifeBalance , Married, Single or Divorced provided that Performace_Rating is Outstanding

SELECT
maritalstatus,
count(case when worklifebalance='better' and performance_rating = 'Outstanding' then 1 else null end) as countb
FROM hr_employee
GROUP BY maritalstatus
order by countb desc limit 1;
