----------------------------------------------------------------
-- CASE Statement ----------------------------------------------
----------------------------------------------------------------
/*
* Database: Store
* Table: products
* Create a case statement that's named "price class" where if a product is over 20 dollars you show 'expensive'
* if it's between 10 and 20 you show 'average' 
* and of is lower than or equal to 10 you show 'cheap'.
*/

-- SELECT
--     title as "Product",
--     price as "Cost",
--     case 
--         when price > 20
--             then 'expensive'
--         when price BETWEEN 10 and 20
--             then 'average'
--         else 'cheap'
--     END
--         as "Price Class"
-- from public.products

----------------------------------------------------------------
-- NULLIF ------------------------------------------------------
----------------------------------------------------------------

-- SELECT 
--     NULLIF(0, 0),
--     nullif('ABC', 'DEF')

/*
* DB: Store
* Table: products
* Question: Show NULL when the product is not on special (0)
*/
SELECT 
    title AS "Product",
    NULLIF(special, 0) AS "Special"
FROM
    public.products

