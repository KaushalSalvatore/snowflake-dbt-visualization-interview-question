-- Pre-hook → runs before the model is created/updated.
-- Post-hook → runs after the model is created/updated.

-- 1. Pre-hook example

{{ config(
    materialized='incremental',
    pre_hook="
        DELETE FROM {{ this }}
        WHERE order_date = CURRENT_DATE
    "
) }}

SELECT
    order_id,
    customer_id,
    order_date,
    amount
FROM {{ source('sales', 'orders') }}

{% if is_incremental() %}
WHERE order_date >= CURRENT_DATE
{% endif %}

-- 2. Post-hook example

{{ config(
    materialized='table',
    post_hook="
        GRANT SELECT ON {{ this }}
        TO ROLE REPORTING_ROLE
    "
) }}
SELECT
    order_id,
    customer_id,
    amount
FROM {{ source('sales', 'orders') }}