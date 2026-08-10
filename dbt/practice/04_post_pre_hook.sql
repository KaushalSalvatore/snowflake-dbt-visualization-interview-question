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

--3. multiple hooks 

{{ config(
    pre_hook=[
        "DELETE FROM {{ this }} WHERE order_date = CURRENT_DATE",
        "INSERT INTO audit_log VALUES ('orders', CURRENT_TIMESTAMP, 'STARTED')"
    ],

    post_hook=[
        "GRANT SELECT ON {{ this }} TO ROLE REPORTING_ROLE",
        "INSERT INTO audit_log VALUES ('orders', CURRENT_TIMESTAMP, 'COMPLETED')"
    ]
) }}

SELECT *
FROM {{ source('sales', 'orders') }}

-- dbt_project.yml

models:
  my_project:
    staging:
      +pre-hook:
        - "INSERT INTO audit_log VALUES ('STARTED', CURRENT_TIMESTAMP)"

      +post-hook:
        - "INSERT INTO audit_log VALUES ('COMPLETED', CURRENT_TIMESTAMP)"