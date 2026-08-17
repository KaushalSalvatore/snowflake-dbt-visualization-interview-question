-- error intergration using sns and topic (recive a email when any error happed in injection in snowpipe)

-- kaushal.pandey@kenexai.com

-- arn:aws:sns:ap-southeast-1:889486283825:snowpipe_topic

CREATE OR REPLACE NOTIFICATION INTEGRATION ERROR_EMAIL
ENABLED = TRUE
TYPE = QUEUE
NOTIFICATION_PROVIDER=AWS_SNS
DIRECTION = OUTBOUND
AWS_SNS_TOPIC_ARN='arn:aws:sns:ap-southeast-1:889486283825:snowpipe_topic'
AWS_SNS_ROLE_ARN='arn:aws:iam::889486283825:role/s3-to-snowflake-role';

DESC NOTIFICATION INTEGRATION ERROR_EMAIL;

SHOW PIPES;

ALTER PIPE AWS_STUDENT_PIPE SET ERROR_INTEGRATION = ERROR_EMAIL;

SELECT SYSTEM$PIPE_STATUS('AWS_STUDENT_PIPE');