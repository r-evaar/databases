-- Quering Data ------------------------------------------------
----------------------------------------------------------------
-- SELECT * FROM public.employees;
-- SELECT * FROM public.departments;
-- SELECT * FROM public.salaries
-- WHERE emp_no=10001;
-- SELECT title FROM public.titles
-- WHERE emp_no=10006;

-- Renaming Comumns --------------------------------------------
----------------------------------------------------------------
-- SELECT emp_no AS "Employee #", birth_date AS "Birthday", first_name as "First Name" from public.employees;

-- Concat Function ---------------------------------------------
----------------------------------------------------------------
-- SELECT CONCAT(emp_no, ' ', title) AS "Employee Title" 
-- FROM public.titles;
-- 
-- SELECT CONCAT(first_name, ' ', last_name) AS "Full Name" 
-- FROM public.employees;

-- Agreggate Function ------------------------------------------
----------------------------------------------------------------
-- SELECT 
--     count(emp_no) AS "# of Employees",
--     min(emp_no) As "First ID" 
-- FROM public.employees;

-- -- Get the highest salary available, and the total amount of salaries paid
-- SELECT 
--     concat('$', max(salary)) As "Top Salary",
--     concat('$', sum(salary)) As "Total Salaries"
-- from public.salaries;

-- -- Question 1: What is the average salary for the company?
-- -- Table: Salaries
-- SELECT 
--     round(avg(salary), 2) as "Average Salary"
-- FROM public.salaries;

-- -- Question 2: What year was the youngest person born in the company?
-- -- Table: employees
-- Select max(birth_date) as "Youngest Employee's DoB"
-- FROM public.employees;

-- select * from public.countrylanguage;
-- 
-- select count(isofficial) 
-- from public.countrylanguage
-- where isofficial=True;

-- Comments ----------------------------------------------------
----------------------------------------------------------------
/* 
 * Multi
 * Line 
 * Code
*/

-- -- Mayumi Schueller Details
-- SELECT *
-- from public.employees
-- where first_name='Mayumi' and last_name='Schueller';
