-- Logical -----------------------------------------------------
----------------------------------------------------------------
-- SELECT *
-- from public.employees
-- where 
--     (first_name = 'Georgi' AND last_name = 'Facello' and hire_date = '1986-06-26')
--     or 
--     (first_name = 'Bezalel' AND last_name = 'Simmel');
--     
-- SELECT count(*)
-- from public.customers
-- where gender = 'F' and (state='OR' or state='NY')
-- 
-- SELECT count(*)
-- from public.customers
-- where not age=55 and age!=20 and age<>33; -- All syntax forms are the same!
-- 
-- select count(*)
-- from public.customers
-- where age > 20 and age <=22 and firstname > lastname; -- 'abc' > 'acb'

-- IS Keyword --------------------------------------------------
----------------------------------------------------------------

-- select 1 = 1 as "Numeric", null = Null as "Null";

-- SELECT *
-- from "public"."Student"
-- WHERE lastname is not NULL;

SELECT NULL IS NULL AS "Null IS NULL", NULL = NULL AS "Null = Null", NULL = FALSE AS "NULL = False", NULL AND FALSE AS "Null AND False";