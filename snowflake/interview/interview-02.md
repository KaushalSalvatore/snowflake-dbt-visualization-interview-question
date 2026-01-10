#### Q-1 How to clone a table ?
```bash
CREATE TABLE cust_clone CLONE customers;
```

#### Q-2 Load data using COPY ? 
```bash
COPY INTO customers FROM @stage;
```

#### Q-3 How to flatten JSON ?
```bash
SELECT value FROM table, LATERAL FLATTEN(input => column);
```

#### Q-4 What are Snowflake’s best practices for performance optimization? Query on a 2TB table is slow.
```bash
Clustering: Use clustering keys on large tables to organize the data for faster access. Snowflake automatically 
manages clustering, but for large tables or specific query patterns, defining a cluster key can significantly 
improve performance.

Micro-Partitioning: Snowflake automatically divides data into small, manageable partitions. Query performance 
can be improved by ensuring that queries filter on partitioned columns, reducing the amount of data that needs 
to be scanned. 

Query Optimization: Snowflake has an intelligent query optimizer that automatically optimizes queries. However, 
users can improve performance by writing efficient queries, avoiding complex joins, and limiting the number of 
queries run simultaneously on a single virtual warehouse.

Materialized Views: Use materialized views for frequently queried or aggregate data. Materialized views store 
precomputed results, which can improve performance by reducing the need for recalculating results on every query.

Virtual Warehouses: Choose the right size for virtual warehouses based on workload. Virtual warehouses can be 
resized vertically or horizontally to meet specific demands.

Data Caching: Snowflake automatically caches query results, making subsequent queries faster. Leveraging this 
cache by reusing previous query results can reduce the load on the system and improve performance.

Data Storage Optimization: Use compression for large datasets, and store only necessary data to avoid large, 
unoptimized tables.

ALTER TABLE sales CLUSTER BY (order_date);
```

#### Q-5 Cost Control?  Warehouse running continuously ?
```bash
ALTER WAREHOUSE compute_wh
SET AUTO_SUSPEND = 60
AUTO_RESUME = TRUE;
```

#### Q-6 Difference between result cache, warehouse cache, and metadata cache? 
```bash
| Cache Type      | Description                         |
| --------------- | ----------------------------------- |
| Result Cache    | Stores final query results (24 hrs) |
| Warehouse Cache | Local cache per warehouse           |
| Metadata Cache  | Used for query optimization         |
```

#### Q-7 COPY vs Snowpipe ? 
```bash
Snowpipe is Snowflake’s continuous data ingestion service that enables real-time or near-real-time loading 
of data into Snowflake. It automatically loads data into Snowflake as soon as new files appear in a stage, 
whether the data is in an internal or external stage.


| COPY           | Snowpipe               |
| -------------- | ---------------------- |
| Manual / batch | Continuous auto-ingest |
| User triggered | Event driven           |
| Cheaper        | Near real-time         |


```

#### Q-8 What are Snowflake’s features for data recovery and time travel ?
```bash
Time Travel: Snowflake’s Time Travel feature allows users to query historical versions of data and restore 
data to a previous state. This can be extremely useful in recovering from accidental data changes or deletions. 
Time Travel allows access to data from a specified point in time (up to 90 days) by using the AT or BEFORE clauses 
in queries.

Fail-safe: Snowflake’s Fail-safe feature ensures that data can be recovered in the event of a catastrophic failure, 
even if it’s past the Time Travel period. Fail-safe provides a 7-day period during which Snowflake retains backups 
of data for recovery purposes.

| Feature     | Time Travel             | Fail-safe           |
| ----------- | ----------------------- | ------------------- |
| User Access | Yes                     | No (Snowflake only) |
| Retention   | 1–90 days               | Fixed 7 days        |
| Purpose     | Query/restore past data | Disaster recovery   |
| Cost        | Configurable            | Included            |

Time Travel → Recover accidental delete
Fail-safe → Catastrophic failure recovery
```

#### Q-9 How Snowflake handles skewed data ?
```bash
Snowflake mitigates skew using:
Automatic micro-partitioning
Dynamic query optimization
Distributed compute processing

Example

If one region has 90% of data:

Snowflake spreads processing across nodes
Uses adaptive execution to rebalance workloads
```

#### Q-10 When would you use a clustering key?
```bash
Use a clustering key when:
Table is very large (TBs)
Queries frequently filter on the same column
Micro-partition overlap is high

ALTER TABLE sales CLUSTER BY (order_date);
```

#### Q-11 How does Snowflake handle data consistency and ACID compliance ?
```bash
ACID (Atomicity, Consistency, Isolation, Durability) properties:

Atomicity: All database operations in Snowflake are atomic, meaning that they either complete successfully or are 
rolled back entirely. If a transaction fails, no partial changes are left in the system.

Consistency: Snowflake maintains a consistent state of the database at all times. Once a transaction is completed, 
the data is guaranteed to be valid according to all defined constraints and rules.

Isolation: Snowflake ensures that concurrent transactions do not interfere with each other. It uses isolation levels 
to maintain consistency even with multiple transactions running simultaneously.

Durability: Data in Snowflake is durable, meaning that once a transaction is committed, it is permanently stored, 
and no data will be lost even if the system crashes.
```

#### Q-12 Explain stages and tables in Snowflake ?
```bash
In Snowflake, stages are temporary storage locations that hold data files before they are loaded into tables. 
Internal Stages: These are managed by Snowflake and stored within Snowflake’s infrastructure. Internal 
stages are often used for loading data from Snowflake to external systems or vice versa.

External Stages: These are linked to exInternal cloud storage systems such as AWS S3, Google Cloud Storage, 
or Azure Blob Storage. Data can be staged in these external systems before being loaded into Snowflake for processing.

Internal Tables: These tables are stored within Snowflake’s managed storage layer. Snowflake fully manages 
the storage, which is optimized for performance and compression. Internal tables are typically used when data 
is loaded directly into Snowflake from a stage, and they benefit from Snowflake’s automatic optimization and 
clustering features.

External Tables: External tables are pointers to data stored in external cloud storage systems, such as AWS S3, 
Azure Blob Storage, or Google Cloud Storage. Snowflake does not manage the storage of external tables, but it 
does provide a structured way to access and query this data. External tables are typically used when the data is 
not intended to be permanently stored within Snowflake, and is instead accessed directly from the external source.
```

#### Q-13 What do you mean by Snowflake Computing ?
```bash
Snowflake Computing refers to Snowflake’s unique approach to building and managing its cloud-based data 
warehouse platform. It is designed to separate compute and storage, making it easier for users to scale 
resources independently to meet varying workload demands. Snowflake offers features such as automatic scaling, 
real-time data sharing, and native support for semi-structured data, which enables businesses to manage 
vast amounts of data efficiently.
```

#### Q-14 In Snowflake, how are data and information secured ?
```bash
Encryption: All data in Snowflake is encrypted both in transit (using TLS/SSL) and at rest 
(using AES-256 encryption). This ensures that data is protected during transmission and storage.

Role-based Access Control (RBAC): Snowflake uses RBAC to manage permissions and access control.
Users are assigned specific roles, and these roles determine the actions they can perform and the 
data they can access.

Multi-factor Authentication (MFA): Snowflake supports MFA, requiring users to provide additional 
authentication beyond just a password, enhancing security.

Data Masking: Snowflake supports dynamic data masking, which allows administrators to mask sensitive 
data at the column level based on the user’s role.

Network Policies: Snowflake provides network policies to control which IP addresses can access Snowflake, 
adding an extra layer of security.
``` 

#### Q-15 What do you mean by Horizontal and Vertical Scaling ?
```bash
Horizontal Scaling: This involves adding more compute resources (such as virtual warehouses) to 
handle increased workloads. Horizontal scaling distributes the workload across multiple instances, 
improving performance and concurrency without affecting other tasks. Snowflake supports automatic 
horizontal scaling for workloads with varying demands.

Vertical Scaling: This refers to increasing the computational power (CPU, memory) of an existing 
virtual warehouse. Vertical scaling is useful when a single workload requires more resources to 
complete faster, but it does not improve concurrency as effectively as horizontal scaling.
```

#### Q-16 What is Snowflake’s data sharing feature, and how does it work?
```bash
Snowflake’s data sharing feature allows organizations to securely share data across different Snowflake accounts 
without the need to copy or move the data. This is done in real time, meaning that data can be shared as soon as 
it is available, with no delays.

The sharing process works by creating a share in Snowflake that contains selected data (tables, views, schemas, etc.) 
and then granting access to another Snowflake account.
```

#### Q-17 How does Snowflake handle semi-structured data like JSON, Avro, and Parquet ?
```bash
Snowflake provides native support for semi-structured data, allowing users to ingest, store, and query data 
formats like JSON, Avro, Parquet, and XML without requiring any transformation before loading. The platform 
uses a special data type called VARIANT to store semi-structured data.
```

#### Q-18
```bash
```

#### Q-20
```bash
```

#### Q-21
```bash
```