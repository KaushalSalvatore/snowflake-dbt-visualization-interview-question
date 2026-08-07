-- DBT test types

--1. Generic Tests (Built-in)
--2. Custom Generic Tests
--3. Singular Tests
--4. Package Tests (dbt-utils, dbt-expectations, etc.)

1. Built-in Generic Tests

A. unique

models:
  - name: customers
    columns:
      - name: customer_id
        tests:
          - unique

B. not_null

columns:
  - name: customer_name
    tests:
      - not_null

C. accepted_values

columns:
  - name: gender
    tests:
      - accepted_values:
          values:
            - Male
            - Female

D. Relationships

columns:
  - name: customer_id
    tests:
      - relationships:
          to: ref('customers')
          field: customer_id


2. Custom Generic Tests

columns:
  - name: sales_amount
    tests:
      - positive_amount


3. Singular Tests

SELECT * FROM {{ ref('orders') }}
WHERE order_date > CURRENT_DATE
