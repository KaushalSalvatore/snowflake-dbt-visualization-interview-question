CREATE SCHEMA DYNAMIC;

CREATE OR REPLACE TABLE orders (
    order_id INT,
    customername STRING,
    order_date DATE,
    product STRING,
    amount NUMBER
);

INSERT INTO orders VALUES
(1, 'Vishal', '2025-08-01', 'Laptop', 1200),
(2, 'Rohan', '2025-08-01', 'Mobile', 800),
(3, 'Vishal', '2025-08-02', 'Headphones', 1500),
(4, 'Mark', '2025-08-02', 'Tablet', 600),
(5, 'Rohan', '2025-08-02', 'Mobile', 950),
(6, 'Vishal', '2025-08-03', 'Mobile', 700),
(7, 'Zach', '2025-08-03', 'Laptop', 2000),
(8, 'Mark', '2025-08-03', 'Headphones', 300);

SELECT * FROM orders;

CREATE OR REPLACE DYNAMIC TABLE DAILY_SALES_CUSTOMER
TARGET_LAG = '1 minute'
WAREHOUSE = compute_wh
REFRESH_MODE = AUTO
INITIALIZE = ON_CREATE
AS
SELECT
    customername,
    order_date,
    SUM(amount) AS total_sales
FROM orders
GROUP BY customername, order_date;

SELECT * FROM DAILY_SALES_CUSTOMER;

INSERT INTO orders VALUES(9, 'Vishal', '2025-08-03', 'Tablet', 1100);



ALTER DYNAMIC TABLE DAILY_SALES_CUSTOMER REFRESH;


CREATE OR REPLACE DYNAMIC TABLE MONTH_SALES_CUSTOMER
TARGET_LAG = '1 minute'
WAREHOUSE = compute_wh
REFRESH_MODE = AUTO
INITIALIZE = ON_SCHEDULE
AS
SELECT
    customername,
    MONTH(order_date) AS "Months",
    SUM(amount) AS total_sales
FROM orders
GROUP BY customername, MONTH(order_date);

SELECT * FROM MONTH_SALES_CUSTOMER;

ALTER DYNAMIC TABLE MONTH_SALES_CUSTOMER REFRESH;



INSERT INTO orders VALUES(10, 'Mark', '2025-08-03', 'Ipod', 1000);


ALTER DYNAMIC TABLE MONTH_SALES_CUSTOMER REFRESH;


SELECT * FROM MONTH_SALES_CUSTOMER;


SELECT * FROM DAILY_SALES_CUSTOMER;

----- chained Dynamic tables

CREATE OR REPLACE TABLE customer_city (
    customer_name STRING,
    city STRING
);


INSERT INTO customer_city VALUES
('Vishal', 'Mumbai'),
('Rohan', 'London'),
('Mark', 'New York'),
('Zach', 'Sydney');

CREATE OR REPLACE DYNAMIC TABLE region_sales
TARGET_LAG = DOWNSTREAM
WAREHOUSE = compute_wh
INITIALIZE = ON_SCHEDULE
AS
SELECT
    cr.city,
    o.order_date,
    SUM(o.amount) AS region_total_sales
FROM orders o
JOIN customer_city cr
    ON o.customername = cr.customer_name
GROUP BY cr.city, o.order_date;

SELECT * FROM region_sales;

ALTER DYNAMIC TABLE REGION_SALES REFRESH;

CREATE OR REPLACE DYNAMIC TABLE product_contribution
TARGET_LAG = '1 minute'
WAREHOUSE = compute_wh
AS
SELECT
    cr.city,
    o.product,
    o.order_date,
    SUM(o.amount) AS product_sales,
    rs.region_total_sales,
    ROUND(SUM(o.amount) / rs.region_total_sales * 100, 2) AS contribution_pct
FROM orders o -- normal table
JOIN customer_city cr -- normal table 
    ON o.customername = cr.customer_name
JOIN region_sales rs
    ON cr.city = rs.city
    AND o.order_date = rs.order_date
GROUP BY
    cr.city,
    o.product,
    o.order_date,
    rs.region_total_sales;

SELECT * FROM product_contribution;

SELECT * FROM REGION_SALES;