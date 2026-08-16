CREATE PIPE AWS_STUDENT_PIPE 
AUTO_INGEST = TRUE
AS 
COPY INTO student_scores
FROM @stage_aws_stu_v1;

SHOW PIPES;

select count(*) from student_scores;

select SYSTEM$PIPE_STATUS('AWS_STUDENT_PIPE');

--How to check pipe history failed or success 
Select * from SNOWFLAKE.ACCOUNT_USAGE.COPY_HISTORY where PIPE_NAME='AWS_STUDENT_PIPE';

--- How to check credits used for any Snowpipe

select *
  from table(information_schema.pipe_usage_history(
       date_range_start=>dateadd('hour',-12,current_timestamp()),pipe_name=>'AWS_STUDENT_PIPE'));
       
-- Check load history
SELECT *
FROM TABLE(
    INFORMATION_SCHEMA.COPY_HISTORY(
        TABLE_NAME => 'STUDENT_SCORES',
        START_TIME => DATEADD(HOUR,-24,CURRENT_TIMESTAMP())
    )
)
ORDER BY LAST_LOAD_TIME DESC;

SELECT
    FILE_NAME,
    ROW_COUNT,
    STATUS,
    LAST_LOAD_TIME
FROM TABLE(
    INFORMATION_SCHEMA.COPY_HISTORY(
        TABLE_NAME=>'STUDENT_SCORES',
        START_TIME=>DATEADD(HOUR,-2,CURRENT_TIMESTAMP())
    )
)
ORDER BY LAST_LOAD_TIME DESC;

-- refresh snow pipe 
ALTER PIPE AWS_STUDENT_PIPE REFRESH;

select count(*) from STUDENT_SCORES;
