--This page is to demonstrate how to build and configure snowpipe to auto ingest 
--the data from s3 bucket to a snowflake table

-- create a new database 

CREATE OR REPLACE DATABASE SNOWPIPE_DB;
CREATE OR REPLEASE SCHEMA SNOWPIPE_DB.SNOWPIPE_SCH;

USE DATABASE SNOWPIPE_DB;
USE SCHEMA SNOWPIPE_SCH;

--
-- create a new s3 bucket by logging into the aws console. or issue below command from CLI
--  "aws s3 mb s3://testsnowflakeload"
--
-- We need a new role to that will be used by storage integraton object. So, create a new role with custom trust. 
-- For details refer to youtube video. 

CREATE OR REPLACE STORAGE INTEGRATION my_snow_intg
    TYPE=EXTERNAL_STAGE
    STORAGE_PROVIDER=S3
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN='put the new role ARN here'
    STORAGE_ALLOWED_LOCATIONS='s3://testsnowflakeload';

-- see the integration details 
--
DESC INTEGRATION my_snow_intg;

-- get the STORAGE_AWS_EXTERNAL_ID, STORAGE_AWS_IAM_USER_ARN and use to to update the role on aws. 

-- create the stage using integration 

CREATE OR REPLACE STAGE snow_stage1
  URL='s3://testsnowflakeload' 
  STORAGE_INTEGRATION='my_snow_intg';

desc stage snow_stage1;

list @snow_stage1;  -- this command will give error because we haven't updated the role with correct Principal yet. 

