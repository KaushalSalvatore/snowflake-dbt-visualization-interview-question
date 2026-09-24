{{ config(
materialized='incremental',
unique_key='claim_id',
on_schema_change='append_new_columns'
) }}


2. Incremental model + new column

{{ config(
    materialized='incremental',
    on_schema_change='sync_all_columns'
) }}

select
    customer_id,
    first_name,
    email,
    phone_number
from {{ source('raw', 'customers') }}

{% if is_incremental() %}

where updated_at >
      (select max(updated_at) from {{ this }})

{% endif %}


1. Merge Strategy

{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
) }}
select 
    order_id,
    customer_id,
    order_date,
    amount
from {{ ref('stg_orders') }}


2. Insert-Only Strategy

{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='insert_only'
) }}
select *
from {{ ref('stg_orders') }}
where order_date > (select max(order_date) from {{ this }})

3. Delete+Insert (Insert_Overwrite) Strategy

{{ config(
    materialized='incremental',
    incremental_strategy='delete+insert',
    partition_by='order_date::date'
) }}
select *
from {{ ref('stg_orders') }




-- Incremental strategies
-- Strategy One-liner
-- append Insert only, no dedup — pure event logs
-- merge Upsert via unique_key — default for mutable facts
-- delete+insert Delete matches, reinsert — no native MERGE support
-- insert_overwrite Atomic partition swap — Databricks/BigQuery partitioned tables