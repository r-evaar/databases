----------------------------------------------------------------
-- Views -------------------------------------------------------
----------------------------------------------------------------

-- DROP view if EXISTS last_salary_change;

-- CREATE or Replace VIEW last_salary_change AS
-- 
-- SELECT 
--     emp_no,
--     concat(first_name, ' ', last_name) as employee,
--     max(from_date) as latest_salary_date
-- from public.employees
-- JOIN public.salaries
--     using (emp_no)
-- GROUP by emp_no
-- order by emp_no;
-- 
-- SELECT * 
-- FROM last_salary_change;
-- 
-- select 
--     emp_no,
--     employee,
--     salary as latest_salary
-- from last_salary_change
-- join public.salaries
--     using (emp_no)
-- where from_date = latest_salary_date
-- order by emp_no;

---------------
-- Exercises --
---------------
/*
*  Create a view "90-95" that:
*  Shows me all the employees, hired between 1990 and 1995
*  Database: Employees
*/
-- create or replace view "90-95" as 
-- 
-- SELECT * 
-- from public.employees
-- where extract (year from hire_date) BETWEEN 1990 and 1995;
-- 
-- select *
-- from "90-95"
-- order by hire_date;

/*
*  Create a view "bigbucks" that:
*  Shows me all employees that have ever had a salary over 80000
*  Database: Employees
*/
CREATE OR REPLACE VIEW "bigbucks" AS 

SELECT *
FROM public.employees
JOIN public.salaries USING (emp_no)

WHERE salary > 80000;

SELECT * FROM "bigbucks" ORDER BY salary;