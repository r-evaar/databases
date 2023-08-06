DROP VIEW IF EXISTS suspects;
DROP VIEW IF EXISTS suspected_rides;


CREATE VIEW suspected_rides AS
SELECT DISTINCT
    l.ride_id
    
FROM public.vehicle_location_histories AS l

WHERE 
    l.city = 'new york'
    AND (l.lat BETWEEN -74.997 AND -74.9968) 
    AND (l.long BETWEEN 40.5 AND 40.6)
    AND (date_trunc('day', l.timestamp) = '2020-06-23'::date);
    

SELECT DISTINCT
    r.vehicle_id,
    u.name AS rider_name,
    u.address
FROM suspected_rides AS s
JOIN public.rides AS r ON r.id = s.ride_id
JOIN public.vehicles AS v ON v.id = r.vehicle_id
JOIN public.users AS u ON u.id = r.rider_id;


CREATE VIEW suspects AS 
SELECT DISTINCT 
    split_part(u.name, ' ', 1) AS first_name,
    split_part(u.name, ' ', 2) AS last_name
FROM suspected_rides AS s
JOIN public.rides AS r ON r.id = s.ride_id
JOIN public.users AS u ON u.id = r.rider_id;

SELECT * FROM suspects;

CREATE EXTENSION IF NOT EXISTS dblink; -- run this to run queries across databases

SELECT DISTINCT
    concat (e.first_name, ' ', e.last_name) AS employee,
    concat (s.first_name, ' ', s.last_name) AS rider
FROM dblink('host=localhost user=postgres password=root dbname=Movr_Employees', 'SELECT emp_no, first_name, last_name FROM employees;') 
AS e (emp_no NAME, first_name NAME, last_name NAME) 
JOIN suspects AS s USING (last_name);