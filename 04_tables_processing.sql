----------------------------------------------------------------
-- DISTINCT Keyword --------------------------------------------
----------------------------------------------------------------

-- SELECT DISTINCT emp_no, first_name
-- FROM public.employees;

---------------
-- Exercises --
---------------

/*
* DB: Employees
* Table: titles
* Question: What unique titles do we have?
*/
-- SELECT DISTINCT title 
-- FROM public.titles;

/*
* DB: Employees
* Table: employees
* Question: How many unique birth dates are there?
*/
-- SELECT count(DISTINCT birth_date) FROM public.employees;

/*
* DB: World
* Table: country
* Question: Can I get a list of distinct life expectancy ages
* Make sure there are no nulls
*/
-- SELECT DISTINCT lifeexpectancy FROM public.country WHERE lifeexpectancy is not NULL;

----------------------------------------------------------------
-- Sorting Data ------------------------------------------------
----------------------------------------------------------------

-- SELECT *
-- from public.employees
-- order by first_name ASC, last_name DESC;

-- select first_name, last_name
-- from public.employees
-- order by length(first_name), first_name, last_name;

---------------
-- Exercises --
---------------

/*
* DB: Employees
* Table: employees
* Question: Sort employees by first name ascending and last name descending
*/
-- select *
-- from public.employees
-- ORDER by first_name, last_name DESC;


/*
* DB: Employees
* Table: employees
* Question: Sort employees by age
*/
-- select * from public.employees order by age(birth_date);

/*
* DB: Employees
* Table: employees
* Question: Sort employees who's name starts with a "k" by hire_date
*/
-- select * 
-- from public.employees 
-- where first_name ilike 'k%' 
-- order by hire_date; 

----------------------------------------------------------------
-- JOIN --------------------------------------------------------
----------------------------------------------------------------

-- select a.emp_no, concat(a.first_name, ' ', a.last_name) as "name", b.salary, b.from_date
-- from public.employees as a, public.salaries as b
-- where a.emp_no = b.emp_no
-- ORDER by emp_no

-- /*
-- NOTE that the linking must happen between a primary and a foreign key to ensure the 
-- data in one table is consistent with the data in another table
-- 
-- For example: this is wrong "on c.emp_no = b.emp_no" because both are foreign keys in this case,
-- and it will mess up the returned data
-- 
-- A primary key is a column (or group of columns) in a relational database table that uniquely identifies each row in the table. 
-- */
-- SELECT a.emp_no, b.salary, c.title, b.from_date as "Promotion?"
-- from public.employees as a
-- join public.salaries as b
--     on b.emp_no = a.emp_no
-- join public.titles as c
--     on c.emp_no = a.emp_no -- lock table c (foreign) to table a (primary)
--     AND (
--         c.from_date = (b.from_date + interval '2 days') /* Add a filtering condition based on the foreign keys */
--                                                         /* The 2 days are becase promotion title appears 2 days after the raise */
--                                                         /* (Date of raise [actual promotion] in table b, date of updated info is in table c) */
--         or 
--         c.from_date = b.from_date  -- To compare the price before promotion
--     )
-- order by a.emp_no asc;

----------------------------------------------------------------
-- OUTER JOIN --------------------------------------------------
----------------------------------------------------------------

-- SELECT count(*)
-- from public.employees as emp
-- left join public.dept_manager as dep 
--     on emp.emp_no = dep.emp_no
-- where dep.emp_no is NULL

/* Knowing every salary raise and also know which one were a promotion: */
-- select e.emp_no, s.salary, t.title is not NULL as "Promotion?"
-- from public.employees as e
-- inner join public.salaries as s
--     on s.emp_no = e.emp_no
-- left join public.titles as t 
--     on t.emp_no = s.emp_no
--     AND ((t.from_date - INTERVAL '2 days') = s.from_date)
-- ORDER by s.emp_no

----------------------------------------------------------------
-- CROSS JOIN --------------------------------------------------
----------------------------------------------------------------

-- drop table "cartesianA";
-- drop table "cartesianB";
-- 
-- create table "cartesianA" (id INT);
-- create table "cartesianB" (id INT);
-- 
-- insert into "cartesianA" values (1);
-- insert into "cartesianA" values (2);
-- insert into "cartesianA" values (3);
-- 
-- insert into "cartesianB" values (1);
-- insert into "cartesianB" values (2);

-- select *
-- from "cartesianA"
-- cross join "cartesianB";

----------------------------------------------------------------
-- FULL OUTER JOIN ---------------------------------------------
----------------------------------------------------------------

-- SELECT *
-- from "cartesianA" as a
-- full join "cartesianB" as b
--     on b.id = a.id;

----------------------------------------------------------------
-- JOIN Exercises ----------------------------------------------
----------------------------------------------------------------
/*
* DB: Store
* Table: orders
* Question: Get all orders from customers who live in Ohio (OH), New York (NY) or Oregon (OR) state
* ordered by orderid
*/
-- select * 
-- from public.orders as o
-- inner join public.customers as c
--     on c.customerid = o.customerid
-- where c.state in ('OH', 'NY', 'OR')
-- order by o.orderid

/*
* DB: Store
* Table: products
* Question: Show me the inventory for each product
*/
-- select p.*, i.quan_in_stock
-- from public.products as p 
-- join public.inventory as i 
--     on i.prod_id = p.prod_id;

/*
* DB: Employees
* Table: employees
* Question: Show me for each employee which department they work in
*/
-- select 
--     e.emp_no as "ID", 
--     concat(e.first_name, ' ', e.last_name) as "Employee", 
--     d.dept_name as "Department"
-- from public.employees as e 
-- join public.dept_emp as de 
--     on de.emp_no = e.emp_no
-- join public.departments as d 
--     on d.dept_no = de.dept_no 
-- order by e.emp_no

----------------------------------------------------------------
-- USING Keyword -----------------------------------------------
----------------------------------------------------------------
SELECT 
    e.emp_no AS "ID", 
    concat(e.first_name, ' ', e.last_name) AS "Employee", 
    d.dept_name AS "Department"
FROM public.employees AS e 
JOIN public.dept_emp AS de 
    USING(emp_no)
JOIN public.departments AS d 
    USING(dept_no)  -- with some ambiguity though 
ORDER BY e.emp_no
