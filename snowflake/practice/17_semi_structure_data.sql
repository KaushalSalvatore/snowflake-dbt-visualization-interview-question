-- use db STUDENTDB
-- use schema STUDENTSCHEMA

-- variant data 
CREATE OR REPLACE TABLE USERJSON (DATA VARIANT);

SELECT DATA
FROM USERJASON
LIMIT 10;

SELECT 
    f.value,
    f.value,
    f.value
 
FROM USERJASON,
LATERAL FLATTEN(INPUT => DATA) f
LIMIT 10;

SELECT
    DATA:id::INT AS id,
    DATA:first_name::STRING AS "first name",
    DATA:last_name::STRING AS last_name,
    DATA:email::STRING AS email,
    DATA:gender::STRING AS gender,
    DATA:ip_address::STRING AS ip_address
FROM USERJASON;

CREATE OR REPLACE TABLE USERPARQUET (DATA VARIANT);

SELECT
    DATA:id::INT AS id,
    DATA:first_name::STRING AS "first name",
    DATA:last_name::STRING AS "last name",
    DATA:email::STRING AS "email",
    DATA:gender::STRING AS "gender",
    DATA:ip_address::STRING AS "ip address"
FROM student_parque;
