----------------------------------------------------------------
-- Text Types --------------------------------------------------
----------------------------------------------------------------

-- CREATE SCHEMA if not EXISTS private;
-- 
-- CREATE TABLE if not EXISTS private.test_text (
--     fixed_field char(7),
--     variable_field varchar(20),
--     unlimited_field text
-- );
-- 
-- TRUNCATE TABLE private.test_text; -- Clears the entire table
-- 
-- INSERT INTO private.test_text VALUES (
--     'Evaar',  -- must be below or equal to 6 characters, otherwise error
--     'Evaar',
--     'I have the power!'
-- );
-- 
-- SELECT * from private.test_text;

----------------------------------------------------------------
-- Numeric Types -----------------------------------------------
----------------------------------------------------------------

-- drop TABLE if EXISTS private.test_numeric;
-- 
-- CREATE TABLE private.test_numeric (_4B float4, _8B float8, big decimal);
-- 
-- INSERT INTO private.test_numeric VALUES (
--     1.1234567891,
--     1.123456789123456789123456,
--     1.1234567891234567891234567891234567891234567891234567891234567891
-- );
-- 
-- select * from private.test_numeric;  -- Test in the terminal

----------------------------------------------------------------
-- Arrays ------------------------------------------------------
----------------------------------------------------------------

DROP TABLE IF EXISTS private.test_arrays;

CREATE TABLE private.test_arrays (
    _character  CHAR(4)[], 
    _text       TEXT[],
    _float32    FLOAT(32)[],
    _varchar6   VARCHAR(6)[]
);

INSERT INTO private.test_arrays VALUES (
    ARRAY ['bruh', 'cool', 'yes'],
    ARRAY ['Is this weird?', 'Hey! How are you?', 'NLP', 'I love coding', 'Best Generative AI? Diffusion!'],
    ARRAY [0.123456789, 55],
    ARRAY ['Single']
);

SELECT * FROM private.test_arrays;