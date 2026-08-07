create task FIRSTTASK
    warehouse = 'COMPUTE_WH'
    schedule = '2 M'
    -- <session_parameter> = <value> [ , <session_parameter> = <value> ... ]
    -- user_task_timeout_ms = <num>
    -- copy grants
    -- comment = '<comment>'
    -- after <string>
  -- when <boolean_expr>
  as
    select 1;

create or replace table task_test 
(ID int , details varchar);

create or replace sequence SEQ1 start with 1 increment by 1;

select * from task_test;

insert into task_test values(SEQ1.nextval,'task inserted this record');

create or replace Task firsttask
    warehouse = 'COMPUTE_WH'
schedule = '1 M'
AS 
insert into task_test values(SEQ1.nextval,'task inserted this record');

show tasks ;

alter task firsttask resume;

select * from table(INFORMATION_SCHEMA.TASK_HISTORY());

select * from task_test;

-- to check particular history 

select * from table(INFORMATION_SCHEMA.TASK_HISTORY(TASK_NAME => 'task_test'));

alter task firsttask suspend;
