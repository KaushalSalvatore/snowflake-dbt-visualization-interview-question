#### Q-1 CDC in snowflake ? 
```bash
Snowflake Change Data Capture (CDC) efficiently tracks row-level modifications (inserts, updates, deletes) in tables, 
enabling near real-time data integration without reloading full datasets. Primarily driven by Snowflake Streams, this 
feature records DML changes, allowing for incremental, cost-effective data pipeline updates. 
```

#### Q-2 expalin RBAC(Roll Base Access Control) 
```bash
Access to data and actions is controlled by ROLES, not directly by users
Users → get Roles
Roles → get Privileges
Privileges → apply to Objects (tables, schemas, warehouses, etc.)
```

#### Q-3 What is Caching in Snowflake ? 
```bash
Snowflake has three types of caching: Result Cache, Local Disk Cache, and Remote Disk Cache. Result cache stores final 
query results for 24 hours and returns results instantly if the same query is executed again without data changes. Local 
disk cache stores micro-partitions in the warehouse SSD, and remote disk cache stores data in cloud storage to improve performance and reduce compute cost.

How to Check If Query Used Cache?
Query History → Check “Bytes Scanned”
If 0 bytes scanned → result cache used

How to Disable Result Cache?
ALTER SESSION SET USE_CACHED_RESULT = FALSE;

```

#### Q-4 What is VALIDATION_MODE in Snowflake ?
```bash
VALIDATION_MODE is used with the COPY INTO command to check data errors without actually loading the data into the 
table.

COPY INTO employees
FROM @my_stage/employees.csv
FILE_FORMAT = (TYPE = CSV)
VALIDATION_MODE = RETURN_ERRORS;

VALIDATION_MODE is used in COPY INTO command to validate staged data files without loading them into the target table. 
It helps identify errors like data type mismatch, missing columns, or format issues before actual data loading.
```

#### Q-5
```bash
```

#### Q-6
```bash
```

#### Q-7
```bash
```

#### Q-8
```bash
```

#### Q-9
```bash
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