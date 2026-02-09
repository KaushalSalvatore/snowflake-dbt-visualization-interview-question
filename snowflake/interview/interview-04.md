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
Snowflake has three caching layers: Result cache (stores query results for 24 hours), Warehouse cache 
(stores scanned data in local SSD while warehouse is active), and Metadata cache (stores table statistics and 
micro-partition info for pruning). Result cache avoids compute usage entirely if conditions match.

Step 1 → Result Cache Check
Snowflake checks:
Has this exact query run before?
Has data changed?
If yes → return cached result instantly.
If no →

Step 2 → Metadata Cache Used
Snowflake checks micro-partitions:
Finds only partitions containing department = 'IT'
Prunes unnecessary partitions

Step 3 → Warehouse Cache Check
Warehouse checks:
Is required data already in SSD?
If yes → faster scan
If no → load from cloud storage

How to Check If Query Used Cache?
Query History → Check “Bytes Scanned”
If 0 bytes scanned → result cache used

How to Disable Result Cache?
ALTER SESSION SET USE_CACHED_RESULT = FALSE;

| Feature                     | Result Cache | Warehouse Cache | Metadata Cache       |
| --------------------------- | ------------ | --------------- | -------------------- |
| Stores                      | Final result | Scanned data    | Table info           |
| Duration                    | 24 hours     | Until suspend   | Managed by Snowflake |
| User control                | Yes          | No              | No                   |
| Requires warehouse running? | No           | Yes             | Yes                  |
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

#### Q-5 Types of Time Travel in Snowflake ?
```bash
AT -> Used to query data at a specific time in the past. (Timestamp / Offset / Statement)
SELECT * 
FROM employees 
AT (TIMESTAMP => '2026-02-01 10:00:00');

SELECT * 
FROM employees 
AT (OFFSET => -3600);

SELECT * 
FROM employees 
AT (STATEMENT => '01b71944-0001-b181-0000-0129032279f6');

SELECT * 
FROM employees 
BEFORE (TIMESTAMP => '2026-02-01 10:00:00');

AT	Query data at a specific time
BEFORE	Query data before a specific time
UNDROP	Restore dropped objects
CLONE + AT	Create historical copy
```

#### Q-6 Row data connect to snowflake using dataframe and snowpark ? 
```bash
pip install snowflake-snowpark-python

from snowflake.snowpark import Session

connection_parameters = {
    "account": "your_account",
    "user": "your_username",
    "password": "your_password",
    "role": "your_role",
    "warehouse": "your_warehouse",
    "database": "your_database",
    "schema": "your_schema"
}

session = Session.builder.configs(connection_parameters).create()

data = [(1, "John", 5000)]

df = session.create_dataframe(
    data,
    schema=["id", "name", "salary"]
)

df.write.mode("overwrite").save_as_table("employees")

If Data Already Exists in Table
df = session.table("employees")
df.show()
```

#### Q-7 How we connect python code to snowflake ? 
```bash
1️ -> Snowflake Connector for Python (basic SQL execution)
2️ -> Snowpark for Python (DataFrame + advanced processing)

Run -> SQL queries	-> Connector
Work -> with DataFrames	-> Snowpark
Build -> ETL pipeline	-> Snowpark
Insert/Fetch -> data	-> Both

Method 1: Using Snowflake Connector
pip install snowflake-connector-python

Step 2: Connect to Snowflake
import snowflake.connector

conn = snowflake.connector.connect(
    user='YOUR_USERNAME',
    password='YOUR_PASSWORD',
    account='YOUR_ACCOUNT',   # e.g. xy12345.ap-south-1
    warehouse='YOUR_WAREHOUSE',
    database='YOUR_DATABASE',
    schema='YOUR_SCHEMA',
    role='YOUR_ROLE'
)

cur = conn.cursor()

Step 3: Execute Query
cur.execute("SELECT CURRENT_VERSION()")
print(cur.fetchone())

Step 4: Close Connection
cur.close()
conn.close()

Method 2: Using Snowpark (For DataFrame Operations)

Step 1: Install Snowpark
pip install snowflake-snowpark-python

Step 2: Create Session
from snowflake.snowpark import Session

connection_parameters = {
    "account": "YOUR_ACCOUNT",
    "user": "YOUR_USERNAME",
    "password": "YOUR_PASSWORD",
    "role": "YOUR_ROLE",
    "warehouse": "YOUR_WAREHOUSE",
    "database": "YOUR_DATABASE",
    "schema": "YOUR_SCHEMA"
}
session = Session.builder.configs(connection_parameters).create()

Step 3: Run Query
df = session.sql("SELECT CURRENT_VERSION()")
df.show()
```

#### Q-8 How to Load Data from S3 ?
```bash
CREATE STAGE my_stage
URL='s3://my-bucket/data/'
CREDENTIALS=(AWS_KEY_ID='xxx' AWS_SECRET_KEY='xxx');

COPY INTO employees
FROM @my_stage
FILE_FORMAT = (TYPE = CSV);
```

#### Q-9 Table Deleted Accidentally ? 
```bash
Use UNDROP if within retention
Otherwise contact Snowflake (Fail-safe)
UNDROP TABLE employees;
```

#### Q-10 What happens if warehouse is suspended ?
```bash
Compute Stops
All compute resources are shut down
You are not charged for compute while suspended
Only storage cost continues

When a warehouse is suspended, compute resources are stopped and billing for compute stops. Running queries are 
aborted if suspension is manual. If AUTO_RESUME is enabled, the warehouse automatically resumes when a new query arrives. 
Local SSD cache is cleared, but result cache remains available.
```

#### Q-11 Query is slow. Should you scale up or scale out ?
```bash
If single query slow → Scale Up
If many queries waiting in queue → Scale Out

Scaling up increases warehouse size to improve performance of a single query. Scaling out increases cluster count 
to handle concurrency. Use scaling up for heavy transformations and scaling out for multiple simultaneous users.

| Feature   | Scaling Up               | Scaling Out                |
| --------- | ------------------------ | -------------------------- |
| Increases | Warehouse size           | Number of clusters         |
| Solves    | Slow query               | Concurrency issue          |
| Affects   | Single query performance | Multiple query performance |
| Example   | MEDIUM → LARGE           | 1 cluster → 3 clusters     |
```

#### Q-12 snowflake how share table database to other ex sales and analytics team required steps and required setting and quries
```bash
In Snowflake, you can share data in two main ways:

1️ Internal sharing (same Snowflake account, different departments)
2️ Secure Data Sharing (different Snowflake accounts)

To share tables internally, I create roles, grant USAGE on database and schema, grant SELECT or DML on tables, 
and assign roles to users. For cross-account sharing, I create a SHARE object, grant database/schema/table access 
to it, and add the consumer account.

✅ SCENARIO 1: Share Table with Sales & Analytics Teams (Same Account)
Best practice → Use Role-Based Access Control (RBAC)

Step 1: Create Roles
CREATE ROLE sales_role;
CREATE ROLE analytics_role;

Step 2: Grant Usage on Database
Without USAGE, they cannot even see the database.
GRANT USAGE ON DATABASE company_db TO ROLE sales_role;
GRANT USAGE ON DATABASE company_db TO ROLE analytics_role;

Step 3: Grant Usage on Schema
GRANT USAGE ON SCHEMA company_db.public TO ROLE sales_role;
GRANT USAGE ON SCHEMA company_db.public TO ROLE analytics_role;

Step 4: Grant Access on Table
If Read-only access:
GRANT SELECT ON TABLE company_db.public.orders TO ROLE sales_role;
GRANT SELECT ON TABLE company_db.public.orders TO ROLE analytics_role;

If Sales team needs insert/update:
GRANT INSERT, UPDATE ON TABLE company_db.public.orders TO ROLE sales_role;

Step 5: Assign Role to Users
GRANT ROLE sales_role TO USER sales_user1;
GRANT ROLE analytics_role TO USER analyst_user1;

SCENARIO 2: Share Database to Another Snowflake Account (Secure Data Sharing)

Step 1: Create Share
CREATE SHARE sales_share;

Step 2: Grant Database & Schema Access to Share
GRANT USAGE ON DATABASE company_db TO SHARE sales_share;
GRANT USAGE ON SCHEMA company_db.public TO SHARE sales_share;
```

#### Q-13 Important Snowflake Concepts Related to Data Purging ? 
```bash
Data purging means permanently deleting data from a database so it cannot be recovered.

1️. DELETE vs PURGE
DELETE
DELETE FROM table_name WHERE condition;

Removes rows logically
Data is still recoverable
Snowflake keeps it for Time Travel retention period

PURGE
To permanently remove data without keeping it in Time Travel:
DROP TABLE table_name PURGE;

Skips Time Travel
Immediately removes historical data
Cannot be recovered

TRUNCATE

TRUNCATE TABLE table_name;

Removes all rows
Faster than DELETE
Still subject to Time Travel
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