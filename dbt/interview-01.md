#### Q-1 What is DBT ?
```bash
DBT, short for Data Build Tool, is an open-source data transformation and modeling tool.
DBT is primarily used for data transformation, modeling, and preparing data for analysis 
and reporting. It is commonly used in data warehouses to create and maintain data pipelines.

common uses of dbt: 
Data transformation
Testing
Documentation
Smooth migration
```

#### Q-2 How does DBT differ from traditional ETL tools ?
```bash
traditional ETL tools, DBT focuses on transforming and modeling data within the data warehouse itself, 
making it more suitable for ELT (Extract, Load, Transform) workflows. DBT leverages the power and scalability
of modern data warehouses and allows for version control and testing of data models.
```

#### Q-3 What is a DBT model ?
```bash
A DBT model is a SQL file that defines a transformation or a table within the data warehouse. Models 
can be simple SQL queries or complex transformations that create derived datasets.
```

#### Q-4 Explain the difference between source and model in DBT ?   
```bash
A source in DBT refers to the raw or untransformed data that is ingested into the data warehouse. 
Models are the transformed and structured datasets created using DBT to support analytics.
```

#### Q-5 What is a DBT project ?
```bash
A DBT project is a directory containing all the files and configurations necessary to define data models, 
tests, and documentation. It is the primary unit of organization for DBT
```

#### Q-6 What is a DAG in the context of DBT ?
```bash
DAG stands for Directed Acyclic Graph, and in the context of DBT, it represents the dependencies between
models. DBT uses a DAG to determine the order in which models are built
```

#### Q-7  How do you write a DBT model to transform data ?
```bash
To write a DBT model, you create a `.sql` file in the appropriate project directory, defining the SQL 
transformation necessary to generate the target dataset.
```

#### Q-8 What are DBT macros, and how are they useful in transformations ?
```bash
DBT macros are reusable SQL code snippets that can simplify and standardize common operations in your 
DBT models, such as filtering, aggregating, or renaming columns.
```

#### Q-9 How can you perform testing and validation of DBT models ?
```bash
You can perform testing in DBT by writing custom SQL tests to validate your data models. These tests can 
check for data quality, consistency, and other criteria to ensure your models are correct.
```

#### Q-10 Explain the process of deploying DBT models to production ? 
```bash
Deploying DBT models to production typically involves using DBT Cloud, CI/CD pipelines, or other orchestration 
tools. You’ll need to compile and build the models and then deploy them to your data warehouse environment.
```

#### Q-11 What are some common performance optimization techniques for DBT models ?
```bash
Performance optimization in DBT can be achieved by using techniques like materialized views, optimizing SQL 
queries, and using caching to reduce query execution times.
```

#### Q-12 How does DBT handle incremental loading of data from source systems ?
```bash
DBT can handle incremental loading by using source freshness checks and managing data updates from 
source systems. It can be configured to only transform new or changed data.
```

#### Q-13 Types of Materialization ?
```bash
DBT supports several types of materialization are as follows :- 
1. View (Default):
2. Table:
3. Incremental:
4. Table + Unique Key:
5. Snapshot:
```

```bash
1 View (Default):

Purpose: Views are virtual tables that are not materialized. They are essentially saved queries that 
are executed at runtime. Use Case: Useful for simple transformations or when you want to reference a 
SQL query in multiple models.

{{ config(
  materialized='view'
) }}
SELECT
  ...
FROM ...
```

```bash
2 Table:

Purpose: Materializes the result of a SQL query as a physical table in your data warehouse.
Use Case: Suitable for intermediate or final tables that you want to persist in your data warehouse.

{{ config(
  materialized='table'
) }}
SELECT
  ...
INTO {{ ref('my_table') }}
FROM ...
```

```bash
3 Incremental:

Purpose: Materializes the result of a SQL query as a physical table, but is designed to be updated 
incrementally. It’s typically used for incremental data loads.
Use Case: Ideal for situations where you want to update your table with only the new or changed data 
since the last run.

{{ config(
  materialized='incremental'
) }}
SELECT
  ...
FROM ...
```

```bash
4 Table + Unique Key:
Purpose: Similar to the incremental materialization, but specifies a unique key that dbt can use to 
identify new or updated rows.

Use Case: Useful when dbt needs a way to identify changes in the data.

{{ config(
  materialized='table',
  unique_key='id'
) }}
SELECT
  ...
INTO {{ ref('my_table') }}
FROM ...
```

```bash
5 Snapshot:
Purpose: Materializes a table in a way that retains a version history of the data, allowing 
you to query the data as it was at different points in time.

Use Case: Useful for slowly changing dimensions or situations where historical data is important.

{{ config(
  materialized='snapshot'
) }}
SELECT
  ...
INTO {{ ref('my_snapshot_table') }}
FROM ...
```

#### Q-14  Types of Tests in DBT ?
```bash
1. Unique Key Test (unique):
2. Not Null Test (not_null):
3. Accepted Values Test (accepted_values):
4. Relationship Test (relationship):


version: 2
models:
  - name: my_model
    tests:
      - unique:
          columns: [id]
      - not_null:
          columns: [name, age]
      - accepted_values:
          column: status
          values: ['active', 'inactive']
      - relationship:
          to: ref('customers')
          field: customer_id
```

#### Q-15 What is seed ?
```bash
A “seed” refers to a type of dbt model that represents a table or view containing static or 
reference data. Seeds are typically used to store data that doesn’t change often and doesn’t
require transformation during the ETL (Extract, Transform, Load) process.

1. Static Data: Seeds are used for static or reference data that doesn’t change frequently. Examples 
include lookup tables, reference data, or any data that serves as a fixed input for analysis.

2. Initial Data Load: Seeds are often used to load initial data into a data warehouse or data mart. This
data is typically loaded once and then used as a stable reference for reporting and analysis.

3. YAML Configuration: In dbt, a seed is defined in a YAML file where you specify the source of the data
and the destination table or view in your data warehouse. The YAML file also includes configurations for 
how the data should be loaded.

The CSV files which are stored in a DBT project are called Seeds. The seed files can be loaded to a 
data warehouse using the dot seed command

version: 2

sources:
  - name: my_seed_data
    tables:
      - name: my_seed_table
        seed:
          freshness: { warn_after: '7 days', error_after: '14 days' }
```

#### Q-16 What is Pre-hook and Post-hook ?
```bash
Pre-hooks and Post-hooks are mechanisms to execute SQL commands or scripts before and after the execution 
of dbt models, respectively. dbt is an open-source tool that enables analytics engineers to transform data 
in their warehouse more effectively.
```

#### Q-17 what is snapshots ?
```bash
“snapshots” refer to a type of dbt model that is used to track changes over time in a table or view. Snapshots 
are particularly useful for building historical reporting or analytics, where you want to analyze how data
has changed over different points in time.

example :- 
{{ config(
  materialized='snapshot',
  unique_key='customer_id',
  target_database='analytics',
  target_schema='snapshots',
  strategy='timestamp'
) }}

SELECT
  customer_id,
  name,
  email,
  address,
  current_timestamp() as snapshot_timestamp
FROM
  source.customer;
```

#### Q-18 What is macros?
```bash
macros refer to reusable blocks of SQL code that can be defined and invoked within dbt models. dbt macros 
are similar to functions or procedures in other programming languages, allowing you to encapsulate and reuse 
SQL logic across multiple queries.

Example :- 

-- my_macro.sql
{% macro my_macro(parameter1, parameter2) %}
SELECT
  column1,
  column2
FROM
  my_table
WHERE
  condition1 = {{ parameter1 }}
  AND condition2 = {{ parameter2 }}
{% endmacro %}

-- my_model.sql
{{ my_macro(parameter1=1, parameter2='value') }}
```

#### Q-19 What are sources in dbt ? 
```bash
In dbt, sources are the raw data tables. We don't directly write SQL queries on those raw tables — 
we specify the schema and table name and define them as sources. This makes it easier to refer to 
data objects in tables.  

Imagine you have a raw data table in your database called orders in the sales schema. Instead of 
querying this table directly, you would define it as a source in dbt like this:

Define the source in your sources.yml file:

version: 2

sources:
  - name: sales
    tables:
      - name: orders
```

#### Q-20 What is the use of a Job Scheduler in DBT ?
```bash
The Job Scheduler is the main component for running DBT jobs in the cloud and it simplifies the process to 
build data pipelines. It handles both event-based and CORN-based schedules.
```