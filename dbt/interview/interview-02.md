#### Q-1 How DBT is used to integrate with other data tools ?
```bash
Data Warehouses: Integrate with popular data warehouses like Snowflake, BigQuery, Redshift.
BI Tools: Use the clean, transformed data in BI tools like Looker, Tableau.
Data Lakes: Connect to and transform data in data lakes.
```

#### Q-2 How DBT is used to automate your data workflow ?
```bash
Scheduled Runs: Schedule DBT runs using tools like Air flow or DBT Cloud.
CI/CD Integration: Integrate DBT with CI/CD pipelines for automated testing and deployment.
Modular Design: Create reusable, modular models to simplify maintenance and automation.
```

#### Q-3 What are ephemeral models in DBT ?
```bash
In dbt, ephemeral models are not directly built in the database. Rather, their code is inserted into the 
dependent models as common table expressions (CTEs). This ways it helps to keep the data warehouse clean 
and simple by reducing the clutter and allows for reusable logic. But still they can’t be selected directly.
```

#### Q-4 Can we split models across multiple schemas ?
```bash
Yes, we can.By usingvthe schema configuration in your DBT_project.yml file or by using a config block 
in the model file. For example: ‘schema: marketing.
```

#### Q-5 Do model names must be unique ? 
```bash
Yes because, dependencies between models are built using the ref function.And it only takes the model 
name as an argument. So, models even in distinct folders must have unique names.
```

#### Q-6 Explain the differences between DBT’s compile, run, and test phases ? 
```bash
Compile: DBT processes the Jinja templates and compiles them into SQL queries. This is a preparatory step 
before execution.
Run: DBT executes the compiled SQL queries against the target database, creating models (tables or views).

Test: DBT validates data by running assertions to ensure quality and consistency, such as checking for uniqueness, 
null values, or referential integrity.
```

#### Q-7 What is the purpose of DBT’s manifest file ? 
```bash
The manifest.json file contains metadata about the DBT project, including model dependencies, execution paths, 
configurations, and documentation. It helps DBT understand the lineage and structure of the models, improving 
dependency management and troubleshooting.
```

#### Q-8 What is dbt and how does it integrate with data warehouses like BigQuery ?
```bash
bt is a command-line tool that helps data analysts and engineers transform data within their data warehouses 
directly using SQL. It operates on top of the data platform (like BigQuery), enabling version control and 
testing of SQL scripts.
```

#### Q-9 How do you set up a dbt environment for a project ?
```bash
dbt init my_new_project
```

#### Q-10 Can you explain using dbt's package management to extend your project's capabilities ?
```bash
dbt allows the use of packages which are pre-built dbt projects that you can include in your own. This 
is done by adding the packages in your packages.yml file.

packages:
  - package: fishtown-analytics/dbt_utils
    version: 0.6.4
```

#### Q-11 Describe how you would test the integrity of date fields in your dbt models ?
```bash
dbt provides a way to perform custom data tests you can write SQL expressions that return records that 
violate data integrity.

SELECT
    *
FROM
    {{ ref('my_model') }}
WHERE
    my_date_field IS NOT NULL
    AND my_date_field > current_date
```

#### Q-12 What is the role of the dbt_project.yml file, and why is it important ?
```bash
The dbt_project.yml file is essential in dbt projects, as it centralizes configuration settings that dictate 
the entire project's structure, behavior, and properties. It sets metadata like project name, version, and 
descriptions while defining directory paths for models, seeds, and snapshots, so dbt knows where to locate
each asset. This file also enables project-wide settings for database connections, materialization strategies, 
and configurations, allowing for uniformity and streamlined changes across the project. 
```

#### Q-13 Can you explain the difference between ‘ref’ and ‘source’ in DBT ?
```bash
Feature       ref Function     source Function

Purpose   ->  References internal DBT models     References external data sources
Use Case  ->  Used within the DBT project for model dependencies    Used to connect to raw tables or 
                                                                    external sources
Dependency Handling  ->   Ensures proper build order of models      Tracks external data dependencies
Configuration -> No additional configuration is needed      Requires defining sources in sources.yml
Schema Changes -> Automatically adapts to schema changes   Does not handle schema changes automatically
```

#### Q-14 Explain how you’ve optimized complex DBT models to improve performance. What techniques do you use to minimize run times when dealing with large datasets ?
```bash
One effective approach is refactoring long and nested SQL queries by breaking them into smaller, more 
manageable incremental models. Instead of repeatedly processing the entire dataset, incremental models 
process only new or changed data, significantly reducing runtime and computational load.

Another technique is leveraging DBT’s materializations like table and incremental instead of view, particularly 
when working with complex aggregations or joins. Materialized tables store the data physically, reducing the 
need for repetitive and costly computations with each query execution. 

Using CTEs (Common Table Expressions) judiciously is also critical; while they can make SQL logic cleaner
```

#### Q-15 How do you handle dependency management in DBT in a project with hundreds of models? What strategies do you implement to ensure a smooth dependency graph? 
```bash
A common strategy is to establish a layered architecture, typically organized into stages like staging, 
intermediate, and marts layers. Each layer serves a distinct purpose: the staging layer ingests raw data 
from the source, the intermediate layer handles transformations and calculations, and the marts layer prepares 
data for final reporting. This layered structure ensures that changes in upstream models minimally affect downstream 
ones, enhancing overall stability.

```

#### Q-16 Can you explain the role of dbt run, dbt test, and dbt seed in your workflow? How do you automate these tasks in a CI/CD pipeline?
```bash
dbt run - executes transformations defined in SQL-based models, allowing complex data transformations to be built 
on top of raw data. For instance, a table of raw transaction records can be transformed into a cleaned, aggregated 
table ready for reporting. 

dbt test - ensures data quality by running tests on specific data models to catch issues like nulls in primary keys 
or unexpected values. 

dbt seed - load small CSV files into the database, often as reference or lookup tables; for example, a CSV file 
containing region codes can be loaded as a table to enhance the primary data.
```

#### Q-17 How do you manage data freshness and handle incremental models in DBT? Can you describe a specific use case where an incremental model improved your ETL process?
```bash
Managing data freshness and handling incremental models involves configuring models to process only new or 
modified data, optimizing both storage and processing time. Incremental models in DBT leverage conditional 
logic to identify and update only records that meet specific conditions, such as a recent timestamp. This 
approach minimizes data duplication and enhances efficiency, especially for large datasets.
```

#### Q-18 How do you monitor and troubleshoot issues in dbt ?
```bash
You can use dbt’s logging and error messages for troubleshooting, along with its built-in tests and source 
freshness checks to monitor data quality. dbt Cloud’s notifications and job history tracking also help identify
and address issues quickly.
```

#### Q-19 Imagine your organization has a mix of structured and semi-structured data. How can DBT handle transformations for both types of data ?
```bash
DBT can effectively handle transformations for both structured and semi-structured data by utilizing its integration 
capabilities with various data warehouses and its flexible modeling structure. For structured data, standard DBT models 
can be created using SQL transformations that take advantage of relational databases' capabilities. This typically 
involves focusing on data preparation tasks such as cleaning, aggregating, and joining tables. In the case of 
semi-structured data, such as JSON or nested data formats commonly found in NoSQL databases, DBT’s support for 
functions like json_extract and others can be leveraged to extract and transform these datasets. Additionally, 
DBT’s ability to create views enables the definition of transformations that can be easily adjusted as data structures 
evolve.
```

#### Q-20 Suppose your team member has added a new column to a DBT model that is already in production, but the change hasn’t propagated to downstream models. What steps should be taken to ensure that this column is available throughout the transformation pipeline?
```bash
When adding a new column to an existing DBT model, it’s important to update both the affected model and any 
downstream models that reference it. First, the schema should be refreshed to ensure the new column is recognized. 
Then, all dependent models should be updated to include references to the new column if it is needed in transformations 
or analyses. DBT's ref function automatically detects dependencies, so rerunning the dependent models will apply 
changes.

It’s also recommended to perform a full model run (dbt run) and test the models to confirm that the new column 
has propagated correctly and is functioning as expected.
```