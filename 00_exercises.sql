-------------------------------------------------
-- COALESCE -------------------------------------
-------------------------------------------------

-- SELECT * 
-- FROM "public"."Student";
-- 
-- /*
-- * DB: https://www.db-fiddle.com/f/PnGNcaPYfGoEDvfexzEUA/0
-- * Question: 
-- * Assuming a students minimum age for the class is 15, what is the average age of a student?
-- */
-- 
-- SELECT avg(COALESCE(age, 15)) AS "Average Age"
-- FROM "public"."Student";
-- 
-- /*
-- * DB: https://www.db-fiddle.com/f/PnGNcaPYfGoEDvfexzEUA/0
-- * Question: 
-- * Replace all empty first or last names with a default?
-- */
-- 
-- SELECT id, COALESCE("name", 'unknown') AS "name", COALESCE("lastname", 'unknown') AS "lastname", age
-- FROM "public"."Student";

-------------------------------------------------
-- Valued Logic ---------------------------------
-------------------------------------------------

/*
* DB: Store
* Table: customers
* Question: adjust the following query to display the null values as "No Address"
*/

-- SELECT coalesce(address2, 'No Address') as address2 
-- FROM public.customers

/*
* DB: Store
* Table: customers
* Question: Fix the following query to apply proper 3VL
*/

-- SELECT *
-- FROM public.customers
-- WHERE address2 IS NOT null;

/*
* DB: Store
* Table: customers
* Question: Fix the following query to apply proper 3VL
*/

-- SELECT coalesce(lastName, 'Empty'), * from public.customers
-- where (age is null);

-------------------------------------------------
-- BETWEEN + AND --------------------------------
-------------------------------------------------

/*
Who between the ages of 30 and 50 has an income less than 50 000?
(include 30 and 50 in the results)
*/

-- select *
-- from public.customers
-- where age BETWEEN 30 and 50 and income < 50000;

/*
What is the average income between the ages of 20 and 50? (Including 20 and 50)
*/

-- select concat('$', round(avg(income), 2)) as "Average Income"
-- from public.customers
-- where age between 20 and 50;

-------------------------------------------------
-- IN Keyword -----------------------------------
-------------------------------------------------

/*
* DB: Store
* Table: orders
* Question: How many orders were made by customer 7888, 1082, 12808, 9623
*/

-- SELECT * FROM public.orders where customerid in (7888, 1082, 12808, 9623);

/*
* DB: World
* Table: city
* Question: How many cities are in the district of Zuid-Holland, Noord-Brabant and Utrecht?
*/

-- SELECT * FROM public.city where district in ('Zuid-Holland', 'Noord-Brabant', 'Utrecht');

-------------------------------------------------
-- LIKE & ILIKE ---------------------------------
-------------------------------------------------

/*
* DB: Employees
* Table: employees
* Question: Find the age of all employees who's name starts with M.
* Sample output: https://imgur.com/vXs4093
* Use EXTRACT (YEAR FROM AGE(birth_date)) we will learn about this in later parts of the course
*/
-- SELECT *, EXTRACT (YEAR FROM AGE(birth_date)) as "age" FROM public.employees WHERE first_name LIKE 'M%';

/*
* DB: Employees
* Table: employees
* Question: How many people's name start with A and end with R?
* Expected output: 1846
*/
-- SELECT count( * ) from public.employees WHERE first_name ILIKE 'a%r'

/*
* DB: Store
* Table: customers
* Question: How many people's zipcode have a 2 in it?.
* Expected output: 4211 
*/
-- SELECT count( * ) from public.customers where zip::text like '%2%';


/*
* DB: Store
* Table: customers
* Question: How many people's zipcode start with 2 with the 3rd character being a 1.
* Expected output: 109 
*/
-- select count(*) from public.customers where zip::text like '2_1%';

/*
* DB: Store
* Table: customers
* Question: Which states have phone numbers starting with 302?
* Replace null values with "No State"                                                  
* Expected output: https://imgur.com/AVe6G4c
*/
-- select COALESCE(state, 'No State') as "State" from public.customers where phone::text like '302%'

-------------------------------------------------
-- Dates and Filtering --------------------------
-------------------------------------------------

/*
* DB: Employees
* Table: employees
* Question: Get me all the employees above 60, use the appropriate date functions
*/

-- SELECT *, date_trunc('year', age(birth_date::date)) as age
-- FROM public.employees
-- where Extract(year from age(birth_date::date)) > 60;

/*
* DB: Employees
* Table: employees
* Question: How many employees where hired in February?
*/

-- SELECT count(*) as "# Employees hired in Feb"
-- FROM public.employees
-- where Extract(month from hire_date::date) = 2;

/*
* DB: Employees
* Table: employees
* Question: How many employees were born in november?
*/

-- SELECT count(*)
-- FROM public.employees
-- where extract (month FROM birth_date) = 11;

/*
* DB: Employees
* Table: employees
* Question: Who is the oldest employee? (Use the analytical function MAX)
*/

-- SELECT *, age(birth_date)
-- FROM public.employees
-- where age(birth_date) = (select max(age(birth_date)) from public.employees);

/*
* DB: Store
* Table: orders
* Question: How many orders were made in January 2004?
*/

-- SELECT count(*) 
-- FROM public.orders
-- where date_trunc('month', orderdate) = date '2004/01/01';