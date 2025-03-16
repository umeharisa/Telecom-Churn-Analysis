-- DATA CLEANING

SELECT * FROM telecom_customer_churn;

-- CREATE copy table for data cleaning

CREATE TABLE telecom_customer_churn_staging
like telecom_customer_churn;

SELECT * FROM telecom_customer_churn_staging;

-- Insert data into new table

insert into telecom_customer_churn_staging
select * from telecom_customer_churn;

SELECT * FROM telecom_customer_churn_staging;

-- Checking for duplicates
-- (Below shows there are unique customers)
SELECT CustomerID, COUNT( CustomerID ) as count FROM telecom_customer_churn_staging
group by CustomerID
having count(CustomerID) > 1;

-- Checking for Null values in each column

-- MultipleLines
select MultipleLines, count(Distinct CustomerID) from telecom_customer_churn_staging
group by MultipleLines;

-- InternetType
select InternetType, count(Distinct CustomerID) from telecom_customer_churn_staging
group by InternetType;

-- Updating InternetType empty string '' to 'NA' for those customers whosevinternet service was not available
Update telecom_customer_churn_staging
SET InternetType = 'NA' where InternetType='';

-- ChurnCategory
select ChurnCategory, count(Distinct CustomerID) from telecom_customer_churn_staging
group by ChurnCategory;

-- updating empty string with 'Active'
Update telecom_customer_churn_staging
set ChurnCategory = 'Active' where ChurnCategory = '';

select ChurnCategory, count(Distinct CustomerID) from telecom_customer_churn_staging
group by ChurnCategory;


select * from telecom_customer_churn_staging;



