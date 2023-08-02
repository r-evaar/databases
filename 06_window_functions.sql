----------------------------------------------------------------
-- Window Functions --------------------------------------------
----------------------------------------------------------------

-- select
--     s.*,
--     dept_name as "Department", 
--     AVG(salary) over (
--         PARTITION by dept_name
--     ) as "Department Avg Salary"
-- from public.salaries as s
-- join public.dept_emp using (emp_no)
-- join public.departments using (dept_no)
-- order by emp_no, from_date;

/* Solving for Current Salary */

-- select distinct 
--     emp_no as "ID",
--     concat(first_name, ' ', last_name) as "Employee",
--     last_value(salary) over (
--         PARTITION by emp_no
--         order by from_date
--         range between UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING
--     ) as "Last Salary",
--     last_value(from_date) over (
--         PARTITION by emp_no
--         order by from_date
--         range BETWEEN UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING
--     ) as "Effective On"
--         
-- from public.employees
-- join public.salaries using (emp_no)
-- 
-- order by emp_no;

----------------------------------------------------------------
-- FIRST_VALUE -------------------------------------------------
----------------------------------------------------------------
/* Compare product price against lowest price in the same category */

-- select 
--     prod_id,
--     title,
--     category,
--     price,
--     first_value(price) over (
--         PARTITION by category
--         ORDER by price
        -- range BETWEEN UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING -- not necessary with FIRST_VALUE
--     ) as "Lowset Price in Category"
-- from public.products
-- order by category, title;
-- 
-- /* OR */
-- 
-- select 
--     prod_id,
--     title,
--     category,
--     price,
--     min(price) over (
--         PARTITION by category
--     ) as "Lowset Price in Category"
-- from public.products
-- order by category, title;

----------------------------------------------------------------
-- SUM ---------------------------------------------------------
----------------------------------------------------------------

-- select 
--     orderid,
--     customerid,
--     netamount,
--     sum (netamount) over (
--         PARTITION by customerid
--         order by orderid
--     ) as "Cumulative Sum"
-- from public.orders
-- ORDER by customerid

----------------------------------------------------------------
-- ROW_NUMBER --------------------------------------------------
----------------------------------------------------------------

/* Know where a product is positioned in its category by price */
-- select 
--     prod_id,
--     title,
--     category,
--     price,
--     row_number() over (
--         PARTITION by category
--         ORDER by price
--     ) as "Order by Price in Category"
-- from public.products
-- order by category, title;

----------------------------------------------------------------
-- Window Functions Excercises ---------------------------------
----------------------------------------------------------------
/*
*  Show the population per continent
*  Database: World
*  Table: Country
*/
-- select 
--     continent,
--     sum(population) as "Total population"
-- from public.country
-- group by continent
-- order by continent;
-- 
-- /* OR */
-- 
-- select DISTINCT
--     continent,
--     sum(population) over w1 as "Total population"
-- from public.country
-- Window w1 as(
--     PARTITION by continent
-- )
-- order by continent;

/*
*  To the previous query add on the ability to calculate the percentage of the world population
*  What that means is that you will divide the population of that continent by the total population and multiply by 100 to get a percentage.
*  Make sure you convert the population numbers to float using `population::float` otherwise you may see zero pop up
*  Try to use CONCAT AND ROUND to make the data look pretty
*
*  Database: World
*  Table: Country
*/
-- SELECT DISTINCT
--     continent,
--     sum(population) OVER w1 AS "Continent Population",
--     round ( (100 * sum(population) OVER w1 :: FLOAT / sum(population) OVER () :: FLOAT)::numeric , 2 ) AS "Population Percentage"
-- FROM public.country
-- WINDOW w1 AS (PARTITION BY continent)
-- ORDER BY continent;


/*
*  Count the number of towns per region
*
*  Database: France
*  Table: Regions (Join + Window function)
*/
SELECT 
    r.name AS "Region", 
    count(t.name) AS "# of Towns"
FROM public.regions AS r
JOIN public.departments AS d
    ON d.region = r.code
JOIN public.towns AS t
    ON t.department = d.code
GROUP BY r.name
ORDER BY r.name;

/* OR */

SELECT DISTINCT
    r.name AS "Region", 
    count(t.name) OVER (
        PARTITION BY r.name
    ) AS "# of Towns"
FROM public.regions AS r
JOIN public.departments AS d
    ON d.region = r.code
JOIN public.towns AS t
    ON t.department = d.code
ORDER BY r.name;