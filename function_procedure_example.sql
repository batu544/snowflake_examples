-- UDF demo 

use Database snowpipe_db;
use schema public;

-- create one table and load it. 

CREATE OR REPLACE TABLE EMP(
    NAME VARCHAR(100),
    EMP_LOCATION VARCHAR(100),
    EMP_SAL NUMBER(20,2)
);

INSERT INTO snowpipe_db.public.EMP VALUES('James Bond', 'Connecticut', 5000);
INSERT INTO EMP VALUES('Mike J', 'India', 8000);
INSERT INTO EMP VALUES('John', 'India', 12000);
INSERT INTO EMP VALUES('Daniel Sea', 'New York', 3450);
INSERT INTO EMP VALUES('James', 'Florida', 9802);
INSERT INTO EMP VALUES('Sunny', 'Atlanta', 1400);
-- Define UDF 

select * from emp;

-- create one user defined function (UDF) to caclulate the salary hike by 10%. 

CREATE OR REPLACE function hike(sal int)
RETURNS INT
LANGUAGE PYTHON
RUNTIME_VERSION=3.9  --python version
packages = ('snowflake-snowpark-python') --packages used in the function
handler = 'hike_func'  -- python function name
AS
$$
def hike_func(sal):
    return sal * 1.1
$$;


-- use of the function to get the new salary. 

select *, hike(emp_sal) as new_sal from emp;


-- Define a new procedure to get the total row count 

CREATE OR REPLACE PROCEDURE new_hike(table_name string)
RETURNS string
LANGUAGE python
RUNTIME_VERSION = '3.9'
packages = ('snowflake-snowpark-python')
HANDLER= 'main'
EXECUTE AS CALLER
AS 
$$
import snowflake.snowpark as snowpark

def main( session: snowpark.Session, table_name: str)-> str:
    df = session.table(table_name)
    row_count = df.count()

    return row_count

$$;

-- Call the procedure to get the total row count

call new_hike('emp');
