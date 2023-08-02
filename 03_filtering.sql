-- BETWEEN + AND -----------------------------------------------
----------------------------------------------------------------

-- select concat('$', round(avg(income), 2)) as "Average Income"
-- from public.customers
-- where age between 20 and 50;

-- IN ----------------------------------------------------------
----------------------------------------------------------------

-- SELECT * 
-- from public.employees
-- WHERE emp_no in (100001, 100006, 11008);

-- LIKE --------------------------------------------------------
----------------------------------------------------------------

-- SELECT *
-- from public.employees
-- where first_name like 'G%r';

-- SELECT *
-- from public.employees
-- where first_name ilike 'g%er';

-- Date Filtering ----------------------------------------------
----------------------------------------------------------------
-- SET TIME ZONE 'UTC';    -- Set the timezone only for this session
                        -- (Resets when restarting)
-- Configure timezone for a user
-- alter user postgres set timezone='UTC';

-- SHOW TIMEZONE;

-- Timestamp ---------------------------------------------------
----------------------------------------------------------------

-- create table timezones (
--     ts TIMESTAMP without time ZONE,
--     tz timestamp with time zone
-- );
-- 
-- insert into timezones VALUES(
--     timestamp without time zone '2000-01-01 10:00:00-05', -- Ignores the '-05'
--     timestamp with time zone '2000-01-01 10:00:00-05'
-- );

-- Date Functions ----------------------------------------------
----------------------------------------------------------------

-- /* Date format modifiers: https://www.postgresql.org/docs/current/functions-formatting.html */
-- select 
--     to_char(now()::date, 'yyyy_mm_dd') As "Date", 
--     to_char(now()::date, 'DDD') as "Day of the Year",
--     to_char(now()::date, 'WW') as "Week of the Year";
    
-- /* Subtracting dates */
-- SELECT now() - '2010-01-01';

-- /* Casting dates */
-- select 
--     date '07/05/2022',
--     '07/05/2022'::date;

-- /* Calculating Age */
-- select AGE(date '1998-11-07'), age(now()::date, date '2011-05-23');

-- /* Extracting Date Info */
-- select EXTRACT (day from CURRENT_DATE) as DAY;
-- 
-- /* Rounding a Date */ 
-- select date_trunc('month', date '1992/11/13'), date_trunc('day', TIMESTAMP with time ZONE '1992/11/13 10:00:00-5');

/* Interval */
SELECT 
    now() - INTERVAL '22 years' AS "EXP1", 
    TIMESTAMP WITH TIME ZONE '2023/08/01 15:30:30-3' - INTERVAL '11 hours' AS "EXP2",
    EXTRACT (HOUR FROM INTERVAL '20 days 3 hours ago')  -- 'ago' returns a negative result
