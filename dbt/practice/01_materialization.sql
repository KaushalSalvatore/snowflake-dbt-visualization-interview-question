1. View (Default):
2. Table:
3. Incremental:
4. Table + Unique Key:
5. Snapshot:

1. View 

{{ config(materialized='view') }}
SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.amount) AS total_sales
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name;


2. Table 

{{ config(materialized='table') }}
SELECT
    product_id,
    DATE_TRUNC('month', order_date) AS month,
    SUM(amount) AS total_sales
FROM orders
GROUP BY
    product_id,
    DATE_TRUNC('month', order_date);


3. Incremental Materialization

{{ config(materialized='incremental') }}
SELECT
    order_id,
    customer_id,
    amount,
    order_date
FROM orders
{% if is_incremental() %}

WHERE order_date >
(
SELECT MAX(order_date)
FROM {{ this }}
)
{% endif %}

4. Table + Unique Key (Incremental Merge)

{{ config(
    materialized='incremental',
    unique_key='customer_id'
) }}
SELECT
    customer_id,
    customer_name,
    city,
    phone,
    updated_at
FROM customers
{% if is_incremental() %}

WHERE updated_at >
(
SELECT MAX(updated_at)
FROM {{ this }}
)
{% endif %}

5. Snapshot

{% snapshot customer_snapshot %}
{{
config(
    target_schema='snapshots',
    unique_key='customer_id',
    strategy='timestamp',
    updated_at='updated_at'
)
}}
SELECT
    customer_id,
    customer_name,
    city,
    updated_at
FROM customers
{% endsnapshot %}
