SHOW VIEWS;

SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

CREATE OR REPLACE VIEW VW_CUSTOMER
AS
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
WHERE C_NATIONKEY IN (13,15);

SELECT * FROM VW_CUSTOMER;

CREATE OR REPLACE VIEW VW_CUSTOMER_EXCLUDE
AS
SELECT * EXCLUDE(C_PHONE,C_ACCTBAL) FROM VW_CUSTOMER;

SELECT * FROM VW_CUSTOMER_EXCLUDE;

-- Materialized View
CREATE OR REPLACE MATERIALIZED VIEW MVW_CUSTOMER
AS 
SELECT * EXCLUDE(C_PHONE,C_ACCTBAL) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

SELECT * FROM MVW_CUSTOMER;

-- THIS WORK
SELECT 
    n.n_name,
    COUNT(c.c_custkey) AS total_people
FROM snowflake_sample_data.tpch_sf1.customer c
INNER JOIN snowflake_sample_data.tpch_sf1.nation n
    ON c.c_nationkey = n.n_nationkey
GROUP BY n.n_name
ORDER BY total_people DESC;

-- JOIN NOT WORK IN Materialized View
CREATE OR REPLACE MATERIALIZED VIEW MVW_CUSTOMER AS
SELECT 
    n.n_name,
    COUNT(c.c_custkey) AS total_people
FROM snowflake_sample_data.tpch_sf1.customer c
INNER JOIN snowflake_sample_data.tpch_sf1.nation n
    ON c.c_nationkey = n.n_nationkey
GROUP BY n.n_name
ORDER BY total_people DESC;

-- JOIN WORK IN View
CREATE OR REPLACE VIEW VW_JOIN_CUSTOMER AS
SELECT 
    n.n_name,
    COUNT(c.c_custkey) AS total_people
FROM snowflake_sample_data.tpch_sf1.customer c
INNER JOIN snowflake_sample_data.tpch_sf1.nation n
    ON c.c_nationkey = n.n_nationkey
GROUP BY n.n_name
ORDER BY total_people DESC;

-- Secure View

CREATE OR REPLACE SECURE VIEW SVW_JOIN_CUSTOMER AS
SELECT 
    n.n_name,
    COUNT(c.c_custkey) AS total_people
FROM snowflake_sample_data.tpch_sf1.customer c
INNER JOIN snowflake_sample_data.tpch_sf1.nation n
    ON c.c_nationkey = n.n_nationkey
GROUP BY n.n_name
ORDER BY total_people DESC;

SELECT * FROM SVW_JOIN_CUSTOMER;