use database demo_db;

show tables;

use schema pipe_scema;

select TOP 10 * from ORDERS;

create role front_office;

use role front_office;

GRANT ROLE front_office TO USER PRASANTA;

USE ROLE front_office;

select current_user();
SELECT CURRENT_ROLE();
-- create row level access 

CREATE OR REPLACE ROW ACCESS POLICY paid_policy
AS ( status string )
returns boolean -> case 
    when current_role() = 'GENERAL_USER' AND status = 'pending' then true
    when current_role() = 'front_office' and status = 'paid' then true
    WHEN CURRENT_ROLE() = 'ACCOUNTADMIN' THEN true
    else false
end;

SHOW ROW ACCESS POLICIES;

Alter table orders 
    add row access policy paid_policy on (status);
    

select * from orders;
