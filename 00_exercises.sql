public.-------------------------------------------------
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
SELECT address2 
FROM public.customers

/*
* DB: Store
* Table: customers
* Question: Fix the following query to apply proper 3VL
*/

SELECT *
FROM public.customers
WHERE COALESCE(address2, NULL) IS NOT NULL;

/*
* DB: Store
* Table: customers
* Question: Fix the following query to apply proper 3VL
*/

SELECT COALESCE(lastName, 'Empty'), * FROM public.customers
WHERE (age = NULL);
