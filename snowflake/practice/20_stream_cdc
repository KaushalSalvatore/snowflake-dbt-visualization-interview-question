CREATE OR REPLACE TABLE student_details (
    student_id INT,
    student_name STRING,
    age INT,
    course STRING,
    marks NUMBER(5,2),
    city STRING,
    admission_date DATE
);

INSERT INTO student_details VALUES (101, 'Rahul Sharma', 20, 'Male', 'Data Engineering', 85.50, 'Ahmedabad', '2025-01-10');
INSERT INTO student_details VALUES (102, 'Priya Patel', 21, 'Female', 'Data Science', 91.00, 'Surat', '2025-02-15');
INSERT INTO student_details VALUES (103, 'Amit Kumar', 22, 'Male', 'Cloud Computing', 78.25, 'Vadodara', '2025-03-05');


select * from student_details;

--(102, 'Priya Patel', 21, 'Female', 'Data Science', 91.00, 'Surat', '2025-02-15'),
--(103, 'Amit Kumar', 22, 'Male', 'Cloud Computing', 78.25, 'Vadodara', '2025-03-05'),
--(104, 'Sneha Shah', 20, 'Female', 'Data Engineering', 88.75, 'Rajkot', '2025-01-20'),
--(105, 'Rohan Mehta', 23, 'Male', 'Cyber Security', 72.00, 'Ahmedabad', '2025-04-01'),
--(106, 'Neha Verma', 21, 'Female', 'AI & ML', 95.20, 'Mumbai', '2025-02-28'),
--(108, 'Pooja Jain', 20, 'Female', 'Cloud Computing', 89.40, 'Pune', '2025-01-25'),
--(109, 'Vikas Gupta', 24, 'Male', 'Data Engineering', 67.80, 'Jaipur', '2025-04-12'),
--(110, 'Anjali Desai', 21, 'Female', 'AI & ML', 93.60, 'Ahmedabad', '2025-03-30');

create or replace stream str_stu
on table student_details;

show streams;

select * from str_stu;
-- METADATA$ACTION > insert and delete
-- METADATA$ISUPDATE > update 
-- METADATA$ROW_ID > unique identifier 

update student_details
set city = 'indore' where student_id=102;

-- by default stream store for 14 days but we customized till 90 days
alter table student_details set max_data_extension_time_in_days=20;

create or replace stream str_stu_v1
on table student_details
append_only = TRUE -- it will track only inserted record
-- insert only work in external table and apache iceberg

CREATE or REPLACE table consume_stream AS 
select * exclude(METADATA$ACTION,METADATA$ISUPDATE) from str_stu;

SELECT * FROM consume_stream;