CREATE DATABASE SCD_DEMO;
USE DATABASE SCD_DEMO;

CREATE  SCHEMA SCD_SCHEMA;
USE SCHEMA SCD_DEMO;


-- FILE FORMATE
-- STORAGE INTEGRATION 
-- STAGE 
-- COPY INTO 
-- SNOWPIPE

-- Step 1: Create Table 

CREATE OR REPLACE TABLE CUSTOMER_STG (
CUSTOMER_ID STRING,
CUSTOMER_NAME STRING,
CITY STRING,
EMAIL STRING,
PHONE STRING,
UPDATED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Step 2: Insert Initial Data (20 Indian Customers)
INSERT INTO CUSTOMER_STG (CUSTOMER_ID, CUSTOMER_NAME, CITY, EMAIL, PHONE)
VALUES
('C001', 'Amit Sharma', 'Delhi', 'amit. sharma@gmail.com', '9876543210'),
('C002', 'Neha Patel', 'Mumbai', 'neha.patel@yahoo.com', '9988776655'),
('C003', 'Rohit Singh', 'Bangalore', 'rohit.singh@outlook.com' , '9898989898'),
('C004', 'Priya Nair', 'Kochi', 'priya.nair@gmail.com', '7765432109'),
('C005', 'Karan Mehta', 'Ahmedabad', 'karan.mehta@gmail.com', '8800112233'),
('C006', 'Divya Reddy', 'Hyderabad', 'divya.reddy@outlook. com', '7711223344' ),
('C007', 'Manish Gupta', 'Pune', 'manish.gupta@yahoo.com', '9933445566' ),
('C008', 'Sneha Roy', 'Kolkata', 'sneha.roy@gmail.com', '9944556677'),
('C009', 'Vikram Chauhan', 'Chandigarh', 'vikram.chauhan@gmail.com', '9955667788'),
('C010', 'Tina Kapoor', 'Jaipur', 'tina.kapoor@outlook.com', '123456789'),
('C011', 'Suresh Iyer', 'Chennai', 'suresh.iyer@gmail.com', '9999991234'),
('C012', 'Anjali Deshmukh', 'Nagpur', 'anjali.deshmukh@yahoo.com' , '999999999'),
('C013', 'Raj Malhotra', 'Surat', 'raj.malhotra@gmail.com', '7896543210'),
('C014', 'Meena George', 'Trivandrum', 'meena. george@outlook.com', '234567891'),
('C015', 'Arjun Verma', 'Lucknow', 'arjun.verma@gmail.com', '9876543211'),
('C016', 'Pooja Das', 'Guwahati', 'pooja.das@yahoo.com', '9877665544'),
('C017', 'Harish Kumar', 'Bhopal', 'harish.kumar@gmail.com', '7878787878'),
('C018', 'Ritika Jain', 'Indore', 'ritika. jain@outlook.com', '9988776655'),
('C019', 'Sameer Ali', 'Patna', 'sameer.ali@gmail.com', '7896541230'),
('C020', 'Kavita Rani', 'Amritsar', 'kavita.rani@yahoo.com', '8886667771');

Select * from CUSTOMER_STG;

CREATE OR REPLACE DYNAMIC TABLE CUSTOMER_SCD2
    LAG = '1 minute'
    WAREHOUSE = 'COMPUTE_WH'
    REFRESH_MODE=FULL
    INITIALIZE = ON_CREATE
    AS
    SELECT
    CUSTOMER_ID,
    CUSTOMER_NAME,
    CITY,
    EMAIL,
    PHONE,
    UPDATED_AT AS START_DATE,
    NVL(LEAD(UPDATED_AT) OVER (PARTITION BY CUSTOMER_ID ORDER BY UPDATED_AT),'2999-12-31') AS END_DATE,
    CASE
    WHEN LEAD(UPDATED_AT) OVER (PARTITION BY CUSTOMER_ID ORDER BY UPDATED_AT) IS NULL
    THEN TRUE ELSE FALSE
    END AS IS_ACTIVE
    FROM CUSTOMER_STG ;

Select * from CUSTOMER_SCD2;


INSERT INTO CUSTOMER_STG (CUSTOMER_ID, CUSTOMER_NAME, CITY, EMAIL, PHONE)
VALUES
('C002', 'Neha Patel', 'Pune', 'neha:patel@yahoo.com', '9988776655' ),
('C005', 'Karan Mehta', 'Surat', 'karan.mehta@gmail.com', '9900112233'),
('C010', 'Tina Kapoor', 'Udaipur', 'tina.kapoor@outlook.com', '9966778899' ),
('C013', 'Raj Malhotra', 'Vadodara', 'raj.malhotra@gmail.com', '9812345678');

--- 24 records ,
Select * from CUSTOMER_SCD2;

I-- CREATE SCD -1 TABLE ONLY FOR ACTIVE RECORD

CREATE OR REPLACE DYNAMIC TABLE CUSTOMER_SCD1
    LAG = '1 minute'
    WAREHOUSE = 'COMPUTE_WH'
    AS
    SELECT
    CUSTOMER_ID,
    CUSTOMER_NAME,
    CITY,
    EMAIL,
    PHONE,
    START_DATE,
    IS_ACTIVE
    FROM CUSTOMER_SCD2
    WHERE IS_ACTIVE = TRUE;

SELECT * FROM CUSTOMER_SCD1;

INSERT INTO CUSTOMER_STG (CUSTOMER_ID, CUSTOMER_NAME, CITY, EMAIL, PHONE)
VALUES
('C002', 'Neha Patel', 'London', 'neha.patel@yahoo.com', '9988776655'),
('C110', 'Vishal K', 'Noida', 'Vishal.kaushal', '9002920292029');

Select * from CUSTOMER_SCD2;

I

