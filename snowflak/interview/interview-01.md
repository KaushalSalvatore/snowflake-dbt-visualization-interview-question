
#### Q-1 What is Snowflake architecture ?
Three layers:
- Storage layer
- Compute layer (Virtual Warehouses)
- Cloud services layer

#### Q-2 What makes Snowflake different from traditional DWs ?
- Separation of storage & compute
- Auto-scaling
- Pay-as-you-use
- No index management

#### Q-3 What is micro-partitioning?
- Automatic division of data into optimized partitions for fast querying.
- Snowflake automatically divides data into immutable micro-partitions (~16MB) with metadata used for pruning during queries.

#### Q-4 Does Snowflake support indexes?
- No traditional indexes. It uses micro-partitions + metadata.

#### Q-5 What is automatic clustering?
- Snowflake reorganizes micro-partitions to improve query performance.

#### Q-6 What is Cloud Services layer?
- Handles authentication, metadata, optimization, and query parsing.

#### Q-7 Does Snowflake support semi-structured data?
- Yes — JSON, Avro, Parquet, XML.

#### Q-8 What is zero-copy cloning ?
- Creates instant copies without duplicating data.

#### Q-9 What is Fail-safe?
- 7-day recovery for accidental data loss (Snowflake support only).

#### Q-10 What is internal vs external stage ?
Internal = Snowflake-managed
External = S3, Azure Blob, GCS
stage > Temporary storage for loading/unloading data. 

#### Q-11 What is metadata ?
- Information about stored data used for optimization.

#### Q-12 What is pruning?
- Skipping unnecessary micro-partitions during queries.

#### Q-13 What is clustering key?
- **what** Defines how data is grouped in micro-partitions.
- **when** Very large tables with frequent filters. 
- **manual** Yes, but Snowflake manages it automatically. 

#### Q-14 Difference between scaling up and scaling out ?
- Up = bigger warehouse
- Out = more clusters

#### Q-15 How to reduce Snowflake cost ?
- Auto-suspend
- Right-size warehouse
- Use result cache

#### Q-16 What is account usage schema?
- Metadata & monitoring views.

#### Q-17 How Snowflake handles concurrency?
- Multi-cluster warehouses.

#### Q-18 Difference between transient and temporary?
- Temporary = session based
- Transient = permanent

#### Q-19 What is QUALIFY?
- Filters window functions.

#### Q-20 Difference between WHERE and QUALIFY?
- WHERE → before window
- QUALIFY → after window
