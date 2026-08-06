create database studentDB;

create schema studentSchema;

Create or replace storage Integration S3_int_stu_data_v1
Type = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE   
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::889486283825:role/s3-to-snowflake-role'
STORAGE_ALLOWED_LOCATIONS = ('s3://student.detail.data.v1/student.performance.v1/');

DESC STORAGE INTEGRATION S3_int_stu_data_v1;
select "property", "property_value" from TABLE(RESULT_SCAN(LAST_QUERY_ID()))
where "property" = 'STORAGE_AWS_IAM_USER_ARN' or "property" = 'STORAGE_AWS_EXTERNAL_ID';

CREATE OR REPLACE FILE FORMAT ingest_csv_data
TYPE = CSV
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

SHOW FILE FORMATS;

DESC FILE FORMAT ingest_csv_data;

CREATE OR REPLACE STAGE stage_aws_stu_v1
URL='s3://student.detail.data.v1/student.performance.v1/'
STORAGE_INTEGRATION = S3_int_stu_data_v1
FILE_FORMAT = (FORMAT_NAME = ingest_csv_data);

LIST @stage_aws_stu_v1;

select $1,$2,$3,$4 from @stage_aws_stu_v1;

CREATE OR REPLACE TABLE student_scores (
    Math_Score varchar,
    Reading_Score varchar,
    Writing_Score varchar,
    Placement_Score varchar,
    Club_Join_Date varchar
);

COPY INTO student_scores FROM (SELECT $1,$2,$3,$4,$5 FROM @stage_aws_stu_v1)

FILE_FORMAT = (FORMAT_NAME = ingest_csv_data);

select Count(*) from student_scores;