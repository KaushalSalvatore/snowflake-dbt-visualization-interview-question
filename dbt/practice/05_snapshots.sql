{% snapshot customers_snapshot %}

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
    name,
    city,
    salary,
    updated_at
FROM {{ source('raw', 'customers') }}
{% endsnapshot %}


-- Timestamp strategy

{{
    config(
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

-- Use when you don't have a reliable updated timestamp, but want to detect changes in specific columns.

{{
    config(
        unique_key='customer_id',
        strategy='check',
        check_cols=['city', 'salary', 'phone']
    )
}}

-- Example 

{% snapshot customers_snapshot %}
{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='check',
        check_cols=['city', 'salary', 'phone']
    )
}}
SELECT
    customer_id,
    name,
    city,
    salary,
    phone
FROM {{ source('raw', 'customers') }}
{% endsnapshot %}