SELECT DISTINCT(WAREHOUSE_NAME)
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY;

SELECT DATABASE_NAME,DATABASE_OWNER
FROM SNOWFLAKE.ACCOUNT_USAGE.DATABASES;

SELECT count(query_id) 
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY;

SELECT (AVG(STORAGE_BYTES+STAGE_BYTES+FAILSAFE_BYTES)/4)/1000000 AS total_mb
FROM SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE;


-- Last 7 Days Warehouse Credit Consumption
SELECT 
    warehouse_name,
    DATE(start_time) AS usage_date,
    SUM(credits_used) AS total_credits_used,
    SUM(credits_used_compute) AS compute_credits,
    SUM(credits_used_cloud_services) AS cloud_service_credits
FROM snowflake.account_usage.warehouse_metering_history
WHERE start_time >= DATEADD(DAY, -7, CURRENT_TIMESTAMP())
GROUP BY warehouse_name, DATE(start_time)
ORDER BY usage_date DESC, warehouse_name;


-- total account credit consumption for last 7 days
SELECT 
    DATE(start_time) AS usage_date,
    SUM(credits_used) AS total_credits_used
FROM snowflake.account_usage.warehouse_metering_history
WHERE start_time >= DATEADD(DAY, -7, CURRENT_TIMESTAMP())
GROUP BY DATE(start_time)
ORDER BY usage_date DESC;


-- total type of query 
SELECT QUERY_TYPE , COUNT(*) AS TOTAL_QUERY
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
GROUP BY ALL 
HAVING COUNT(*) > 40
ORDER BY TOTAL_QUERY DESC;
