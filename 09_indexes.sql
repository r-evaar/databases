----------------------------------------------------------------
-- Indexes -----------------------------------------------------
----------------------------------------------------------------
-- drop index idx_countrycode;

-- create INDEX idx_countrycode
--     on city (countrycode);
     
-- create INDEX idx_countrycode
--     on city (countrycode)
--     where countrycode in ('TUN', 'BE', 'NL');
    
-- EXPLAIN ANALYZE
-- SELECT 
--     "name",
--     district,
--     countrycode
-- from public.city
-- where countrycode in ('TUN', 'BE', 'NL');

----------------------------------------------------------------
-- Index Algorithms --------------------------------------------
----------------------------------------------------------------
-- create index idx_countrycode
--     on public.city using hash (countrycode);

EXPLAIN ANALYSE
SELECT 
    "name",
    district,
    countrycode
FROM public.city;
-- where countrycode in ('TUN', 'BE', 'NL');