----------------------------------------------------------------
-- GROUP BY ----------------------------------------------------
----------------------------------------------------------------

---------------
-- Exercises --
---------------

/*
*  How many people were hired on any given hire date?
*  Database: Employees
*  Table: Employees
*/
-- SELECT 
--     hire_date as "Hire Date",
--     count( * ) as "No. Hires" 
-- FROM public.employees
-- GROUP by hire_date
-- ORDER by hire_date

/*
*   Show me all the employees, hired after 1991 and count the amount of positions they've had
*  Database: Employees
*/
-- SELECT 
--     e.emp_no as "ID",
--     concat(e.first_name, ' ', e.last_name) as "Employee",
--     count(t.title) as "# of Positions"
-- FROM public.employees as e 
-- join public.titles as t 
--     using ( emp_no )
-- group by "ID"
-- order by "ID";

/*
*  Show me all the employees that work in the department development and the from and to date.
*  Database: Employees
*/
-- select 
--     e.emp_no as "ID",
--     concat(e.first_name, ' ', e.last_name) as "Employee",
--     de.from_date as "From",
--     de.to_date as "To" 
-- from public.employees as e 
-- join public.dept_emp as de 
--     on de.emp_no = e.emp_no
-- join public.departments as d 
--     on d.dept_no = de.dept_no
-- where d.dept_name = 'Development'
-- ORDER by "ID";

----------------------------------------------------------------
-- HAVING ------------------------------------------------------
----------------------------------------------------------------
-- SELECT 
--     d.dept_name as "Department", 
--     e.gender,
--     count(e.*) as "# of Employees"
-- from public.departments as d 
-- inner join public.dept_emp aS de 
--     on de.dept_no = d.dept_no
-- inner join public.employees as e
--     on e.emp_no = de.emp_no
-- GROUP BY d.dept_name, e.gender
-- having e.gender = 'F' and count(e.*) > 25000
-- ORDER by "Department";
-- OR
-- SELECT 
--     d.dept_name as "Department", 
--     e.gender,
--     count(e.*) as "# of Employees"
-- from public.departments as d 
-- inner join public.dept_emp aS de 
--     on de.dept_no = d.dept_no
-- inner join public.employees as e
--     on e.emp_no = de.emp_no
-- where e.gender = 'F'
-- GROUP BY d.dept_name, e.gender
-- having count(e.*) > 25000
-- ORDER by "Department";

---------------
-- Exercises --
---------------

/*
*  Show me all the employees, hired after 1991, that have had more than 2 titles
*  Database: Employees
*/
-- select e.*, count(t.title) as "# of Titles"
-- FROM public.employees as e 
-- inner join public.titles as t
--     using (emp_no)
-- group by emp_no
-- having count(t.title) > 2
-- order by emp_no;
 
/*
*  Show me all the employees that have had more than 15 salary changes that work in the department development
*  Database: Employees
*/
-- select 
--     e.*, 
--     d.dept_name,
--     count(s.*) as "# of Salary Changes"
-- from public.employees as e 
-- inner join public.salaries as s 
--     using (emp_no)
-- inner join public.dept_emp as de 
--     USING (emp_no)
-- inner join public.departments as d
--     using (dept_no)
-- group by emp_no, dept_name 
-- having count(s.*) > 15 and dept_name = 'Development'
-- order by emp_no;

/*
*  Show me all the employees that have worked for multiple departments
*  Database: Employees
*/
-- select 
--     e.*,
--     count(de.dept_no) as "# of Departments"
-- from public.employees as e 
-- join public.dept_emp as de 
--     using (emp_no)
-- group by emp_no
-- having count(de.dept_no) > 1
-- order by emp_no;

----------------------------------------------------------------
-- GROUP BY Mental Model ---------------------------------------
----------------------------------------------------------------

/* Question: Get me the most recent date in which each employee got a salary increase. */
-- select 
--     emp_no as "ID", 
--     concat(first_name, ' ', last_name) as "Employee",
--     max(from_date) as "Latest Salary",
--     max(salary) as "Latest salary? Not Always" -- Mostly, but not always - NOT necessarily corelated to the max(from_date)
-- from public.employees
-- join public.salaries
--     USING (emp_no)
-- group by emp_no
-- order by emp_no;

----------------------------------------------------------------
-- Grouping Sets -----------------------------------------------
----------------------------------------------------------------

---------------
-- Exercises --
---------------

/*
*  Calculate the total amount of employees per department and the total using grouping sets
*  Database: Employees
*  Table: Employees
*/
-- select 
--     COALESCE(dept_name, 'Total') as "Department", 
--     count(de.*) as "# of Employees"
-- FROM public.dept_emp as de
-- join public.departments using (dept_no)
-- group by 
--     GROUPING sets (
--         (),
--         (dept_name)
--     )
-- order by "# of Employees" DESC;

/*
*  Calculate the total average salary per department and the total using grouping sets
*  Database: Employees
*  Table: Employees
*/
-- select 
--     grouping(dept_name),
--     dept_name as "Department",
--     round(avg(salary), 2) as "Average Salary"
-- from public.departments as d 
-- join public.dept_emp using (dept_no)
-- join public.salaries USING (emp_no)
-- group by 
--     GROUPING sets(
--         ("Department"),
--         ()
--     )
-- ORDER by "Department" desc;

----------------------------------------------------------------
-- ROLLUP & CUBE -----------------------------------------------
----------------------------------------------------------------

SELECT 
    EXTRACT (YEAR FROM orderdate) AS "Year",
    EXTRACT (MONTH FROM orderdate) AS "Month",
    EXTRACT (DAY FROM orderdate) AS "Day",
    sum(quantity) AS "Total Sales"
FROM public.orderlines
GROUP BY
    GROUPING SETS(
        ("Year", "Month", "Day"),
        ("Year", "Month"),
        ("Year"),
        ()
    )
ORDER BY "Year", "Month", "Day";

/* OR */

SELECT 
    EXTRACT (YEAR FROM orderdate) AS "Year",
    EXTRACT (MONTH FROM orderdate) AS "Month",
    EXTRACT (DAY FROM orderdate) AS "Day",
    sum(quantity) AS "Total Sales"
FROM public.orderlines
GROUP BY
    ROLLUP ("Year", "Month", "Day")
ORDER BY "Year", "Month", "Day";

/* For ALL possible combinations, use CUBE */

SELECT 
    EXTRACT (YEAR FROM orderdate) AS "Year",
    EXTRACT (MONTH FROM orderdate) AS "Month",
    EXTRACT (DAY FROM orderdate) AS "Day",
    sum(quantity) AS "Total Sales"
FROM public.orderlines
GROUP BY
    CUBE ("Year", "Month", "Day")
ORDER BY "Year", "Month", "Day";