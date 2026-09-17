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


-- Incremental strategies
-- Strategy One-liner
-- append Insert only, no dedup — pure event logs
-- merge Upsert via unique_key — default for mutable facts
-- delete+insert Delete matches, reinsert — no native MERGE support
-- insert_overwrite Atomic partition swap — Databricks/BigQuery partitioned tables