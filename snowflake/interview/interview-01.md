#### Q-1 What is Snowflake architecture ?
```bash
Three layers:
Database Storage Layer: This is where all the structured and semi-structured data is stored. It 
is highly scalable and designed for optimal storage management. Data in this layer is stored in a 
compressed, columnar format, which is efficient for analytical queries.

Compute Layer: The compute layer consists of virtual warehouses, which are the computational power 
used to process queries, load data, and perform transformations. Each virtual warehouse operates 
independently, which means one workload does not affect another.

Cloud Services Layer: This is the control layer of Snowflake. It manages everything related to the 
execution of queries, including query parsing, optimization, and metadata storage. It is also responsible 
for managing the security, governance, and overall user experience.
- Handles authentication, metadata, optimization, and query parsing.
```

#### Q-2 What makes Snowflake different from traditional DWs ?
```bash
```
- Separation of storage & compute
- Auto-scaling
- Pay-as-you-use
- No index management

#### Q-3 What are micro-partitions in Snowflake, and what is its contribution to the platform's data storage efficiency ?
```bash
Micro-partitions are a fundamental aspect of Snowflake’s approach to data storage. They are compressed, 
managed, and columnar storage units that Snowflake uses to store data that range from 50MB to 150MB. 
The columnar format allows for efficient data compression and encoding schemes.

Automatic division of data into optimized partitions for fast querying.
Snowflake automatically divides data into immutable micro-partitions (~16MB) with metadata used for pruning 
during queries.
```

#### Q-4 Does Snowflake support indexes?
```bash
No traditional indexes. It uses micro-partitions + metadata.
```

#### Q-5 Explain in short about Snowflake Clustering.?
```bash
Clustering in Snowflake refers to the process of organizing data in a way that improves query performance, 
particularly for large datasets. Snowflake uses automatic clustering by default, meaning it automatically manages 
data distribution and storage optimization. Users can define cluster keys to help Snowflake organize data more 
efficiently based on commonly queried columns. 
```

#### Q-6 Can you tell me how to access the Snowflake Cloud data warehouse ?
```bash
Web Interface (Snowflake UI)
Command-Line Client (SnowSQL)
Third-Party BI Tools
APIs and Drivers
```

#### Q-7 Does Snowflake support semi-structured data?
```bash
Snowflake provides native support for semi-structured data, allowing users to ingest, store, and query 
data formats like JSON, Avro, Parquet, and XML without requiring any transformation before loading. The 
platform uses a special data type called VARIANT to store semi-structured data.

When loading semi-structured data into Snowflake, users can store the data in VARIANT columns, which can 
hold nested and complex data structures.
```

#### Q-8 What is zero-copy cloning in Snowflake, and why is it important?
```bash
Zero-copy cloning is a feature in Snowflake that allows users to create a copy of a database, schema, 
or table without duplicating the underlying storage. When a zero-copy clone is created, it points to the 
original data and only stores changes made to the cloned data, resulting in significant storage savings. 
```

#### Q-9 What is Fail-safe?
```bash
- 7-day recovery for accidental data loss (Snowflake support only).
```

#### Q-10 What is internal vs external stage ?
```bash
Internal = Snowflake-managed
External = S3, Azure Blob, GCS
stage > Temporary storage for loading/unloading data.
``` 

#### Q-11 Can you explain the role of the Metadata Service in Snowflake and how it contributes to performance?
```bash
The Metadata Service in Snowflake is part of the Cloud Services Layer, and it plays a critical role in query 
optimization and data management. This service tracks data storage locations, access patterns, and metadata for 
tables, columns, and partitions.

Additionally, the Metadata Service manages and updates the Result Cache, allowing for faster query retrievals 
when similar queries are executed within a short timeframe.

Information about stored data used for optimization.
``` 

#### Q-12 What is pruning?
```bash
Skipping unnecessary micro-partitions during queries.
``` 

#### Q-13 What is clustering key?
```bash
- what :- Defines how data is grouped in micro-partitions.
- when :- Very large tables with frequent filters. 
- manual :- Yes, but Snowflake manages it automatically. 
```

#### Q-14 Difference between scaling up and scaling out and Explain the process of optimizing warehouse scaling in Snowflake ?
```bash
Monitor Workload Patterns: Begin by analyzing query performance, usage patterns, and peak load times. 
Use Snowflake's monitoring tools to gather insights on warehouse usage and identify trends.

Right-Sizing Warehouses: Choose the appropriate warehouse size based on workload requirements. Snowflake 
offers multiple warehouse sizes (X-Small, Small, Medium, Large, etc.), and selecting the right size can enhance 
performance without overspending.

Auto-Scaling Configuration: Configure auto-scaling to dynamically adjust the size of the warehouse based on demand. 
This allows Snowflake to scale up during peak times and scale down during low usage periods, optimizing resource0 
allocation.

Concurrency Management: Implement concurrency scaling if your organization experiences high levels of concurrent 
queries. This feature automatically provisions additional compute resources to handle increased demand, ensuring 
consistent performance.

Scheduled Scaling: For predictable workloads, consider setting up scheduled scaling. This allows you to pre-emptively 
increase the warehouse size during known peak times (e.g., end-of-month reporting) and reduce it during off-peak times.

Performance Testing: Regularly conduct performance testing to assess the effectiveness of scaling strategies. 
Analyze query execution times and resource utilization to identify areas for improvement.

Feedback Loops: Engage with users and stakeholders to gather feedback on query performance and resource usage. 
Continuous communication can provide valuable insights into optimizing warehouse scaling.

- Up = bigger warehouse
- Out = more clusters
```

#### Q-15 How to reduce Snowflake cost ?
```bash
- Auto-suspend
- Right-size warehouse
- Use result cache
```

#### Q-16 What is a Snowflake schema, and how is it used in data modeling??
```bash
A Snowflake schema is a type of database schema that organizes data into a multi-level structure of 
related tables. It is an extension of the Star Schema, where each dimension is normalized into multiple 
related tables, forming a snowflake-like structure.

Normalized Dimension Tables: Unlike in a star schema, where dimension tables are denormalized, a snowflake 
schema normalizes the dimension tables to reduce redundancy.

Fact Tables: The central fact table contains transactional data, such as sales or revenue, with foreign 
keys pointing to dimension tables.

Efficiency: While the snowflake schema reduces data redundancy, it may require more joins when querying 
the data compared to a star schema.
```

#### Q-17 How Snowflake  multi-cluster , handles concurrency,advantages,architecture?
```bash
Concurrency Scaling: Snowflake automatically spins up multiple clusters to handle high concurrency without 
performance degradation. This is especially useful for organizations with many users or varied workloads.

Separation of Compute and Storage: Compute and storage are decoupled, so users can scale compute resources 
independently based on demand without affecting storage. This flexibility allows Snowflake to handle multiple 
workloads simultaneously without conflicts.

Zero Impact on Other Workloads: With multi-cluster architecture, different virtual warehouses can run independently, 
ensuring that resource-intensive queries or tasks do not impact others. For instance, heavy ETL processes can run on 
one cluster while another cluster serves live analytics queries.

Automatic Scaling: Snowflake automatically handles the creation and management of additional compute clusters when needed, providing on-demand scalability to match workload fluctuations.

Example -
100 users run queries at the same time
Single cluster → queries queue
Multi-cluster → Snowflake spins up new clusters
```

#### Q-18 What is the difference between a transient and permanent table ? 
```bash
Permanent Tables: These tables store data indefinitely. Data in permanent tables is retained unless 
explicitly deleted or dropped. They also include a fail-safe feature that provides additional data protection, 
allowing users to recover data for up to 90 days after deletion.

Transient Tables: These tables are designed for temporary use. Data in transient tables is not subject to the 
fail-safe feature, meaning it is lost immediately after deletion or when the table is dropped. They are suitable 
for data that does not need long-term retention.

Permanent Tables: These tables are ideal for storing critical data that requires long-term retention, such as 
transactional data, customer records, or historical data 

Transient Tables: Transient tables are best used for intermediate data processing, temporary storage, or data 
that only needs to exist for the duration of a specific workflow or analysis. 
```

#### Q-19 What is QUALIFY?
```bash
Filters window functions.
```

#### Q-20 Difference between WHERE and QUALIFY?
```bash
WHERE → before window
QUALIFY → after window
```
