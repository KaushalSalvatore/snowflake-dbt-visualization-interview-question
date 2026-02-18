#### Q-1 What do you mean by virtual warehouse ?
```bash
Users can create multiple virtual warehouses to handle different workloads, such as ETL jobs, reporting, 
and ad-hoc queries. Snowflake can automatically scale a warehouse up or down based on workload demands,
ensuring that performance remains optimal.
```

#### Q-2 Define ‘Staging’ in Snowflake ?
```bash
When you load data into a stage in Snowflake, it is known as ‘Staging.’ External staging is when the data 
is kept in another cloud region, and internal staging is when the data is kept inside Snowflake. The internal 
staging is integrated within the Snowflake environment and stores files and data to load into Snowflake tables. 
```

#### Q-3 Can you describe the impact of the different states of virtual warehouses on query performance ?
```bash
The ‘Cold’ virtual warehouse query processing takes longer than a warm and hot virtual warehouse. This 
is due to using a remote disk where the local disk cache and result cache are not used.

The ‘Warm’ virtual warehouse query processing is faster than a cold warehouse but requires more time 
than a hot virtual warehouse. This is due to using a local disk. However, it does not use a remote disk and 
results cache.

The ‘Hot’ virtual warehouse query processing takes less time in comparison to both the cold and warm virtual warehouse. 
It does not use both the remote disk and local disk cache, and the result is returned using the result cache. This is 
the most efficient way of getting the result of the query.
```

#### Q-4 How does Snowflake handle data distribution and partitioning within its architecture ?
```bash
Snowflake handles data distribution through micro-partitions, which are automatically created and managed 
by Snowflake. These micro-partitions are small storage units (50–150 MB each) that store data in a columnar 
format.

Snowflake’s automatic clustering ensures efficient data distribution, minimizing the need for manual partitioning.
```

#### Q-5 How do you build a Snowflake task that calls a Stored Procedure ?
```bash
These are the following steps :-
Create a new task using the ‘CREATE TASK’ command, following the name of your task.

Specify the virtual warehouse that Snowflake will be using to execute the task using ‘WAREHOUSE’

Using a cron expression, define when the task will be executed, for example, 1:00 AM UTC every day in the 
‘SCHEDULE’.

Introduce the SQL statement that the task will execute with the ‘AS’ keyword.

Specify the action that the task will perform using ‘CALL’ using the stored procedure.

CREATE TASK daily_sales_datacamp
  WAREHOUSE = 'datacampwarehouse'
  SCHEDULE = 'USING CRON 0 1 * * * UTC'
  AS
  CALL daily_sales_datacamp();
```

#### Q-6 How do you create a clone of an existing table in Snowflake ?
```bash
CREATE TABLE cloned_table_name CLONE original_table_name 
```

#### Q-7 What naming conventions does your organization follow for access management ?
```bash
Our organization follows a structured naming convention for access management to ensure clarity and 
consistency. Use a prefix to indicate the type of access, e.g., 'READ_', 'WRITE_', 'ADMIN_'.

1. Include the role or department in the name, e.g., 'READ_SALES_TEAM'.
2. Utilize a suffix for specific resources, e.g., 'ADMIN_DATABASE_XYZ'.
3. Incorporate versioning if necessary, e.g., 'READ_FINANCE_V1'.
4. Maintain a consistent case style, such as snake_case or camelCase.
```

#### Q-8 Describe a real-time data pipeline in Snowflake ?
```bash
1. Ingest data via Snowpipe (S3 → Snowflake).
2. Track changes using streams.
3. Process with tasks (merge into target tables).
4. Analyze with dashboards (Power BI, Tableau).
```

#### Q-9 List the drivers and connectors available in Snowflake ?
```bash
.NET Driver
JDBC Driver
ODBC Driver
Node.js Driver
Go Driver
Connector for Python, Kafka & Spark
PHP PDO Driver.
```

#### Q-10 What is the benefit of Dynamic Tables in Snowflake ?
```bash
They enable near-real-time data processing by automatically refreshing query results from streaming sources 
using Delayed View Semantics.

CREATE OR REPLACE DYNAMIC TABLE my_dynamic_table
TARGET_LAG = '5 minutes'
WAREHOUSE = my_warehouse
AS
SELECT *
FROM source_table;
```

#### Q-11 How does Snowflake support data governance ?
```bash
Through features like Row Access Policies, Column Masking, Object Tagging, and Access Control to ensure security 
and compliance.
```

#### Q-12 How would you design a pipeline to ingest millions of files using Snowpipe while controlling costs ?
```bash
Store files in external stage like S3, GCS, or Azure Blob.

Organize files in the cloud storage bucket using a partitioned folder structure 
(e.g., s3://bucket_name/year=2025/month=07/day=06/) to enable efficient file discovery and reduce unnecessary 
scans. This leverages Snowflake’s external table metadata to limit the scope of Snowpipe’s file detection.

Use appropriately sized files (e.g., 100–250 MB compressed) to balance ingestion performance and cost. 
Smaller files increase metadata overhead, while overly large files may lead to longer processing times.

Compress files (e.g., GZIP, Snappy) to reduce storage and data transfer costs.

Instead of triggering Snowpipe for each file, batch them at the source (via Spark, Airflow, Kafka Connect) 
or orchestrate with micro-batches using cloud event filtering (e.g., S3 event notifications via SNS → SQS → Lambda).

Aim for ~100–250 files per pipe call. A large number of small files (e.g., <100KB) will lead to metadata 
overhead and higher per-file ingestion cost.
```

#### Q-13 How will you capture bad data without blocking good data in your Snowflake pipeline ?
```bash
Pattern: Error-tolerant ETL with Quarantine Zone

Staging Raw Zone (Immutable)
Load all data as-is into a raw staging table (stg_raw_orders) using VARIANT columns (semi-structured), 
especially from JSON, Avro, etc.

This avoids schema enforcement upfront and allows flexible parsing.

Parse with Error Handling:

Use TRY_CAST, TRY_TO_DATE, or TRY_PARSE_JSON functions during transformation. These return NULL instead 
of throwing errors.

example :-

SELECT 
  TRY_TO_DATE(order_date) AS order_date,
  TRY_CAST(order_amount AS FLOAT) AS order_amount,
  $1 AS raw_json
FROM stg_raw_orders;
```

#### Q-14 How do I stop Snowflake from caching query results ?
```bash
alter session set use_cached_result =false;
```

#### Q-15 What are the main components of Snowflake ?
```bash
Databases
Schemas
Tables
Views
Virtual Warehouses
Stages
File Formats
Streams and Tasks
```

#### Q-16 How do you automate tasks in Snowflake using Python or other languages ?
```bash
1. Snowflake Connector for Python: Utilize the Snowflake Connector for Python to interact with Snowflake.

2. Scheduled Scripts: Write Python scripts to perform routine tasks such as data loading, transformation, 
and analysis. These scripts can be scheduled using tools like cron jobs on Linux or Task Scheduler on Windows.

3. Using Snowflake Tasks: Snowflake has a built-in task scheduler that allows users to define SQL-based tasks 
that can be scheduled to run at specified intervals.

4. External Functions: You can create external functions that leverage Python or other languages. 

5. Third-Party Orchestration Tools: Use orchestration tools like Apache Airflow, Prefect, or dbt to automate 
workflows that include Snowflake.

6. API Integration: Utilize Snowflake's REST APIs to automate administrative tasks, such as managing users, 
roles, and data pipelines.
```

#### Q-17 How do you optimize storage costs in Snowflake ?
```bash
1. Data Clustering: By clustering large tables based on frequently queried columns, you can reduce the 
amount of data Snowflake needs to scan during queries,

2. Data Retention Policies: Implementing appropriate data retention policies ensures that unnecessary 
or outdated data is purged from the system.

3. Data Compression: Snowflake uses automatic compression to store data efficiently. 

4. File Formats: When loading data, choose the right file format (like Parquet or ORC) that supports columnar 
storage and offers better compression rates compared to formats like CSV.

5. Data Sharing: Use Snowflake's secure data sharing capabilities to share data with other Snowflake accounts 
instead of creating copies.  

6. Monitoring Storage Usage: Regularly review storage consumption through Snowflake’s usage and billing views. 
```

#### Q-18 Explain the different types of joins supported by Snowflake ?
```bash
INNER JOIN : 
SELECT *
FROM table1
INNER JOIN table2 ON table1.id = table2.id;

LEFT JOIN 
SELECT *
FROM table1
LEFT JOIN table2 ON table1.id = table2.id;

RIGHT JOIN 
SELECT *
FROM table1
RIGHT JOIN table2 ON table1.id = table2.id;

FULL JOIN
SELECT *
FROM table1
FULL JOIN table2 ON table1.id = table2.id;

CROSS JOIN
SELECT *
FROM table1
CROSS JOIN table2;

SELF JOIN:
SELECT a.*, b.*
FROM table1 a
INNER JOIN table1 b ON a.id = b.parent_id;
```

#### Q-19 How can you delete data from a table in Snowflake ?
```bash
DELETE FROM my_table WHERE condition;

DELETE FROM my_table;

TRUNCATE TABLE my_table;

Using Transactions: 
BEGIN;
DELETE FROM my_table WHERE condition;
COMMIT;  -- or ROLLBACK if needed
```

#### Q-20 Explain how Snowflake processes data in real time ?
```bash
1. Streams and Tasks: Snowflake allows for continuous data ingestion using streams, which capture changes in 
real-time from source tables.

2. Snowpipe: Snowpipe is Snowflake’s continuous data ingestion service that allows users to load data into 
Snowflake as soon as it arrives in an external stage (e.g., Amazon S3). 

3. Automatic Clustering: To ensure optimal performance, Snowflake can automatically maintain the clustering of 
data as it is ingested, allowing for faster querying of real-time data.

4. Concurrency Scaling: Snowflake's architecture supports high concurrency, allowing multiple users to query 
data simultaneously without performance degradation. 

5. Materialized Views: Users can create materialized views to precompute and store query results, which can 
be refreshed automatically.

6. Integration with External Tools: Snowflake easily integrates with streaming platforms like Kafka and event-based 
architectures.
```