-- 1st-- what if we want to capture only partial data without impacting other changes ?
-- 2nd -- What if multiple people want to check/consume DML changes for their needs
-- 3rd- I want to capture chnges only for some time frame ?
-- Then we will use CHANGES


SHOW TABLES;

INSERT INTO PRODUCTS VALUES
(1, 'IPHONE', 'BLACK', 500000),
(2, 'SAMSUNG GALAXY', 'WHITE', 400000),
(3, 'ONEPLUS', 'BLUE', 350000),
(4, 'GOOGLE PIXEL', 'BLACK', 450000),
(5, 'XIAOMI', 'RED', 300000),
(6, 'OPPO', 'GREEN', 280000),
(7, 'VIVO', 'SILVER', 270000),
(8, 'REALME', 'GOLD', 260000),
(9, 'NOKIA', 'GRAY', 200000),
(10, 'MOTOROLA', 'BLACK', 220000);

SELECT * FROM PRODUCTS;

CREATE STREAM STR_PRODUCTS ON TABLE PRODUCTS;

SELECT * FROM PRODUCTS;

UPDATE PRODUCTS
SET COLOR = 'RED'
WHERE PRODUCTID = 10;

UPDATE PRODUCTS
SET PRICE = 10000000
WHERE PRODUCTID = 10;

SELECT * FROM STR_PRODUCTS;

CREATE OR REPLACE TRANSIENT TABLE ABC
AS
SELECT * FROM STR_PRODUCTS;

SELECT * FROM ABC;

-- what if we what partial changes not all changes then
CREATE OR REPLACE TRANSIENT TABLE XYZ
AS
SELECT * FROM STR_PRODUCTS WHERE PRODUCTID = 10;

SELECT * FROM XYZ

-- CHANGES 
-- ENABLE CHANGES IN TABLE 

SHOW TABLES ;

ALTER TABLE EMPLOYEE_TYPE_1 SET CHANGE_TRACKING = TRUE;

--Get changes between timestamps

SELECT *
FROM EMPLOYEE_TYPE_1
CHANGES(
    INFORMATION => DEFAULT
)

AT (TIMESTAMP => '2026-06-04 10:00:00')
END (TIMESTAMP => CURRENT_TIMESTAMP());


--Get changes since statement
SELECT *
FROM EMPLOYEE
CHANGES(
    INFORMATION => DEFAULT
)
AT (STATEMENT => '01bc9d4f-0001-1234-0000-abc123xyz');

--: Using Offset (easier for testing)
SELECT *
FROM EMPLOYEE
CHANGES(
    INFORMATION => DEFAULT
   --INFORMATION => APPEND_ONLY

)
AT (OFFSET => -60*5);

-- Use STREAM for pipelines/tasks
-- Use CHANGES for auditing or checking what changed during a time window.

--| STREAM                 | CHANGES                      |
--| ---------------------- | ---------------------------- |
--| Needs creation         | No creation                  |
--| CDC object             | Query clause                 |
--| Consumed once          | Reusable                     |
--| Best for ETL pipelines | Best for time-based analysis |
--| Persistent tracking    | Ad hoc querying              |
