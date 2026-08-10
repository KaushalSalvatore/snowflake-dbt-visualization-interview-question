-- project structure 
dbt_project/
models/
seeds/
    country.csv

seeds/country.csv
dbt_project.yml


-- Step 1: Create CSV File :- seeds/country.csv

-- Step 2: Configure dbt_project.yml
seeds:
  my_project:
    +schema: seed_data

-- Step 3: Load Seed into Snowflake
dbt seed

-- Step 4: Verify
SELECT * FROM seed_data.country;

-- Step 5: Use Seed in Models

SELECT
    o.order_id,
    o.customer_name,
    c.country_name
FROM {{ ref('orders') }} o
LEFT JOIN {{ ref('country') }} c
ON o.country_code = c.country_code

-- seeds/schema.yml

