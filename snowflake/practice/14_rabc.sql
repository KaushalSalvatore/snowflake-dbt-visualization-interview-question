Create OR REPLACE database BANKCHURN;

create OR REPLACE schema BANKCHURN_SCHEMA;

select count(*) from BANKCHURN_DATA;

select * from BANKCHURN_DATA limit 10 ORDER BY DESC;

-- summonslter table if exists BANKCHURN_DATA modify column balace unset masking policy 
 
CREATE OR REPLACE MASKING POLICY pi_masking 
AS (card NUMBER)
RETURNS NUMBER ->
CASE
    WHEN CURRENT_ROLE() = 'ACCOUNTADMIN' THEN card
    WHEN CURRENT_ROLE() = 'SYSADMIN' THEN 0
    ELSE NULL
END;

ALTER TABLE BANKCHURN_DATA
MODIFY COLUMN Balance
SET MASKING POLICY pi_masking;

ALTER TABLE BANKCHURN_DATA
MODIFY COLUMN EstimatedSalary
SET MASKING POLICY pi_masking;

select * from BANKCHURN_DATA limit 10;

-- Remove Existing Masking Policy (if any)

ALTER TABLE BANKCHURN_DATA
MODIFY COLUMN Balance
UNSET MASKING POLICY;

ALTER TABLE BANKCHURN_DATA
MODIFY COLUMN EstimatedSalary
UNSET MASKING POLICY;

-- if you have complete information masking coulmn (EstimatedSalary) but still you cant retrive data ex.

select * from BANKCHURN_DATA where ESTIMATEDSALARY = 101348.88