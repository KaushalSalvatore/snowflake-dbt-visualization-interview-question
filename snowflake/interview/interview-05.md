#### Q-1 How would you design a pipeline to ingest millions of files using Snowpipe while controlling costs ? 
```bash
Architecture & Design Choices

1. Staging & Batching

-> Store files in external stage like S3, GCS, or Azure Blob.

-> Organize files in the cloud storage bucket using a partitioned folder structure 
(e.g., s3://bucket_name/year=2025/month=07/day=06/) to enable efficient file discovery and reduce unnecessary 
scans. This leverages Snowflake’s external table metadata to limit the scope of Snowpipe’s file detection.

-> Use appropriately sized files (e.g., 100–250 MB compressed) to balance ingestion performance and cost. 
Smaller files increase metadata overhead, while overly large files may lead to longer processing times.

-> Compress files (e.g., GZIP, Snappy) to reduce storage and data transfer costs.

-> Instead of triggering Snowpipe for each file, batch them at the source (via Spark, Airflow, Kafka Connect) or 
orchestrate with micro-batches using cloud event filtering (e.g., S3 event notifications via SNS → SQS → Lambda).

-> Aim for ~100–250 files per pipe call. A large number of small files (e.g., <100KB) will lead to metadata overhead 
and higher per-file ingestion cost.

2. Use Auto-Ingest with Cloud Events

-> Set up auto-ingest Snowpipe via cloud notifications.

-> Filter events at source (e.g., prefix filtering or S3 object size) to avoid triggering pipe on junk files or partial 
writes.

-> Set the PIPE_EXECUTION_PAUSED parameter to pause Snowpipe during maintenance windows or low-priority periods to avoid unnecessary compute usage.

-> Configure Snowpipe with ON_ERROR = CONTINUE to skip problematic files, preventing pipeline stalls and reducing retry 
costs. Log errors to a separate table for later analysis

-> For high-volume pipelines, implement a custom notification delay (e.g., via SQS message delays) to batch events and 
reduce Snowpipe triggers during peak loads.

3. File Format Optimization

-> Use columnar formats like Parquet or ORC.

->  Enable compression (e.g., Snappy) to reduce transfer size.

->  Each file should ideally be 100MB–250MB uncompressed for Snowflake to efficiently parallelize loading.

4. Avoid Duplicates & Handle Idempotency

-> Add file metadata (e.g., MD5 hash, UUID, load time) to avoid duplicate ingestion in case of retries.

5. Cost Controls

-> Snowpipe charges per file loaded. Consolidate smaller files via tools like Apache Hudi, Delta Lake, 
or pre-processing scripts.

-> Monitor load history using LOAD_HISTORY and tune batch sizes accordingly.

-> Avoid frequent pipe invocations for trickle data (e.g., IOT); instead, buffer and load in intervals.
```

#### Q-2 How will you capture bad data without blocking good data in your Snowflake pipeline ?
```bash
1. Staging Raw Zone (Immutable)

-> Load all data as-is into a raw staging table (stg_raw_orders) using VARIANT columns (semi-structured), 
especially from JSON, Avro, etc.

-> This avoids schema enforcement upfront and allows flexible parsing. 

2. Parse with Error Handling:

-> Use TRY_CAST, TRY_TO_DATE, or TRY_PARSE_JSON functions during transformation. These return NULL instead 
of throwing errors.

-> In case we are using snowpipe we can do this with ON_ERROR& VALIDATION_MODE

3. Good Records Continue

-> The valid records can be inserted into the curated DWH tables, possibly via MERGE or INSERT INTO.

4. Observability

-> Add Data Quality Metrics via Snowflake’s Data Quality Framework or tools like Monte Carlo, Great Expectations, 
or dbt tests.

-> Use custom views or dashboards to monitor error rates, source-wise breakdown, schema drift, etc.

5. Alerting

-> Create a Snowflake TASK to periodically process the ERROR_LOG table, alerting data engineers (e.g., via email or 
Slack integration) or triggering automated remediation (e.g., reprocessing fixed files).

-> Use TASK to retry ingestion of failed files after manual correction, leveraging COPY INTO with a specific file list.

-> Monitor pipeline health using PIPE_USAGE_HISTORY and COPY_HISTORY views to track error rates and ensure good data flows uninterrupted.

-> This design ensures the pipeline is non-blocking, resilient, and observable, enabling fast troubleshooting and correction.
```

#### Q-3 If your dashboards are slow, how would you debug Snowflake performance ?
```bash
1. Identify Slow Queries

-> Use the QUERY_HISTORY view to pinpoint slow queries powering the dashboard. Filter by execution time, warehouse, 
and user. 

dashboard. Filter by execution time, warehouse, and user.
SELECT
    QUERY_ID,
    QUERY_TEXT,
    EXECUTION_TIME,
    ROWS_PRODUCED,
    WAREHOUSE_NAME
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE EXECUTION_TIME > 10000 -- Queries >10s
AND START_TIME > DATEADD(HOUR, -24, CURRENT_TIMESTAMP)
ORDER BY EXECUTION_TIME DESC;

-> Check for queries with high EXECUTION_TIME, excessive BYTES_SCANNED, or large ROWS_PRODUCED.  

-> Identify whether slowness is due to backend query latency or frontend rendering. 

-> Check Caching & Result Reuse

-> Warehouse Sizing
```

#### Q-4
```bash
-> 
-> 
-> 
-> 
-> 

```

#### Q-5
```bash
-> 
-> 
-> 
-> 
-> 

```

#### Q-6
```bash
-> 
-> 
-> 
-> 
-> 

```

#### Q-7
```bash
-> 
-> 
-> 
-> 
-> 

```

#### Q-8
```bash
-> 
-> 
-> 
-> 
-> 

```

#### Q-9
```bash
-> 
-> 
-> 
-> 
-> 

```

#### Q-10
```bash
```

#### Q-11
```bash
```

#### Q-12
```bash
```

#### Q-13
```bash
```

#### Q-14
```bash
```

#### Q-15
```bash
```

#### Q-16
```bash
```

#### Q-17
```bash
```

#### Q-18
```bash
```

#### Q-19
```bash
```

#### Q-20
```bash
```