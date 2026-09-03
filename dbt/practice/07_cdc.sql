-- create stagging model 
models/staging/stg_customer_cdc.sql

select name , city , customer_id , update_at from {{ source('raw', 'customer_cdc')}}

-- Get latest CDC record

with rank as (

    select name , city , customer_id , update_at 
    row_number() over( PARTITION BY customer_id
                        ORDER BY updated_at DESC ) as rnk
    from {{ ref('raw', 'customer_cdc')}}
)
SELECT
    customer_id,
    name,
    city,
    operation,
    updated_at

FROM ranked
WHERE rn = 1

-- Now implement incremental model
-- models/marts/dim_customer.sql

{{ config(
    materialized='incremental',
    unique_key='customer_id'
) }}

WITH latest_changes AS (

    SELECT
        customer_id,
        name,
        city,
        operation,
        updated_at,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY updated_at DESC
        ) AS rn

    FROM {{ ref('stg_customer_cdc') }}

    {% if is_incremental() %}

        WHERE updated_at >
              (SELECT MAX(updated_at) FROM {{ this }})

    {% endif %}

)

SELECT
    customer_id,
    name,
    city,
    updated_at

FROM latest_changes

WHERE rn = 1
  AND operation != 'D'