----------------------------------------------------------------
-- Subquery ----------------------------------------------------
----------------------------------------------------------------

-- select (
--     select count(salary)
--     from public.salaries
-- )
-- from public.employees
-- where emp_no < 10010
-- order by emp_no

----------------------------------------------------------------
-- Subquery vs JOIN --------------------------------------------
----------------------------------------------------------------

-- select 
--     title, 
--     price, 
--     round((select avg(price) from public.products), 2) as "Global Average Price"
-- from public.products
-- ORDER by prod_id;

/* Returning a ROW set */

-- select 
--     title, 
--     price, 
--     round((select avg(price) from public.products), 2) as "Global Average Price"
-- from (
--     select * from public.products 
--     where price < 10
-- ) as product_sub  -- An alias IS required
-- 
-- ORDER by prod_id;

----------------------------------------------------------------
-- Use Cases ---------------------------------------------------
----------------------------------------------------------------

/* 1. Show the employees older than the average age */

/* Without Sub-Queries */
-- drop view age_vs_avg;
-- create view age_vs_avg as 
-- SELECT 
--     emp_no,
--     age(birth_date) as emp_age,
--     avg(age(birth_date)) over () as avg_age
-- from public.employees;
-- 
-- select
--     emp_no,
--     concat(first_name, ' ', last_name) as employee,
--     age(birth_date) as emp_age,
--     avg_age
-- from public.employees
-- join age_vs_avg using (emp_no)
-- where emp_age > avg_age
-- order by emp_age;

/* With Sub-Queries */
-- select 
--     *, age(birth_date) as emp_age 
-- from public.employees
-- where age(birth_date) > (select avg(age(birth_date)) from public.employees)
-- order by emp_age;

-- Bruh

/* Show the title by salary for each employee */

-- select 
--     e.emp_no,
--     s.salary,
--     (
--         select title
--         from public.titles as t
--         where (t.from_date = s.from_date + INTERVAL '2 days') and t.emp_no = s.emp_no
--     )
-- from public.employees as e
-- join public.salaries as s using (emp_no)
-- order by emp_no;
-- 
-- /* OR */ 
-- /* This is faster and easier to interpret than a correlated subquery */
-- SELECT 
--     e.emp_no,
--     s.salary,
--     t.title
-- from public.employees as e 
-- join public.salaries as s using (emp_no)
-- left join public.titles as t on (t.from_date = s.from_date + INTERVAL '2 days') and t.emp_no = s.emp_no
-- order by emp_no;

/* The Latest Salary Problem */

-- select 
--     emp_no,
--     concat(first_name, ' ', last_name) as employee,
--     salary,
--     from_date
-- from public.employees
-- join public.salaries as so using (emp_no)
-- where from_date = (
--     select max(from_date) 
--     from public.salaries as si
--     where si.emp_no = so.emp_no
-- )
-- order by emp_no;
 
/* Using JOIN */

-- select 
--     emp_no,
--     concat(first_name, ' ', last_name) as employee,
--     salary,
--     from_date
-- from public.employees
-- join public.salaries as so using (emp_no)
-- Join (
--     select emp_no, max(from_date) as last_date
--     from public.salaries as si
--     group by emp_no
-- ) as ls using (emp_no)
-- where ls.last_date = from_date
-- order by emp_no;

---------------
-- Exercises --
---------------

/* TRY TO WRITE THESE AS JOINS FIRST */
/*
* DB: Store
* Table: orders
* Question: Get all orders from customers who live in Ohio (OH), New York (NY) or Oregon (OR) state
* ordered by orderid
*/
-- EXPLAIN ANALYZE
-- select o.*
-- from public.orders as o
-- join public.customers as c using (customerid)
-- where c.state in ('OH', 'NY', 'OR')
-- ORDER by orderid;
-- 
-- EXPLAIN ANALYZE
-- select *
-- from public.orders
-- where customerid in (select customerid from public.customers where state in ('OH', 'NY', 'OR') )
-- ORDER by orderid;
-- 
-- EXPLAIN ANALYZE
-- SELECT c.firstname, c.lastname, o.orderid 
-- FROM public.orders AS o, (
--     SELECT customerid, state, firstname, lastname
--     FROM public.customers
-- ) AS c
-- WHERE  o.customerid = c.customerid AND 
-- c.state IN ('NY', 'OH', 'OR')
-- ORDER BY o.orderid;

/*
* DB: Employees
* Table: employees
* Question: Filter employees who have emp_no 110183 as a manager
*/
SELECT e.*
FROM public.employees AS e
JOIN public.dept_emp USING (emp_no)
WHERE dept_no = ANY (
    SELECT dept_no
    FROM public.dept_manager
    WHERE emp_no = 110183
)
ORDER BY emp_no;

SELECT *
FROM employees
WHERE emp_no IN (
    SELECT emp_no
    FROM dept_emp
    WHERE dept_no = (
        SELECT dept_no 
        FROM dept_manager
        WHERE emp_no = 110183
    )
)
ORDER BY emp_no;