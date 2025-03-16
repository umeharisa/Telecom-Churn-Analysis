-- Exploratory Analysis for Initial Insights

Select * from telecom_customer_churn_staging;

-- Finding top reasons for customer churn.

select ChurnCategory, Round(((count(Distinct ChurnCategory) / count(CustomerID))*100),2) as Churn_Percentage from 
telecom_customer_churn_staging
where ChurnCategory != 'Active'
group by ChurnCategory
order by Churn_percentage desc;

-- Comparing churn rates for different customer demographics.

-- Churn Rate by Gender
select Gender, Round(((count(Distinct ChurnCategory) *100)/ count(CustomerID)),2) as Churn_Percentage from 
telecom_customer_churn_staging
where CustomerStatus = 'Churned'
group by Gender
order by Churn_percentage desc;

-- Churn Rate by Age Group
Select case 
			When Age>25 Then 'Under_Age'
            When Age Between 25 and 40 Then '25-40'
            when Age Between 41 and 60 Then '41-60'
            else 'Above 60'
		End as Age_group,
        ROUND((COUNT(CustomerID) * 100.0 / (SELECT COUNT(CustomerID) 
                                           FROM telecom_customer_churn_staging 
                                           WHERE ChurnCategory != 'Active')), 2) 
       AS Churn_Percentage
FROM telecom_customer_churn_staging
WHERE CustomerStatus = 'Churned'
GROUP BY Age_Group
ORDER BY Churn_Percentage DESC;

-- Top  10 city Churn Rate
SELECT City, 
       ROUND((COUNT(CustomerID) * 100.0 / (SELECT COUNT(CustomerID) 
                                           FROM telecom_customer_churn_staging 
                                           WHERE CustomerStatus = 'Churned')), 2) 
       AS Churn_Percentage
FROM telecom_customer_churn_staging
WHERE CustomerStatus = 'Churned'
GROUP BY City
ORDER BY Churn_Percentage DESC
Limit 10;

-- Churn Rate by Tenure (Customer Loyalty)
select case
		when TenureinMonths < 6 Then '0-6 Months'
        when TenureinMonths between 6 and 12 Then '6-12 Months'
        when TenureinMonths between 13 and 24 then '1-2 Years'
        else 'Above 2 years'
	End as Tenure_group,
    ROUND((COUNT(CustomerID) * 100.0 / (SELECT COUNT(CustomerID) 
                                           FROM telecom_customer_churn_staging 
                                           WHERE CustomerStatus = 'Churned')), 2) 
       AS Churn_Percentage
FROM telecom_customer_churn_staging
WHERE CustomerStatus = 'Churned'
GROUP BY Tenure_group
ORDER BY Churn_Percentage DESC;

-- Revenue was lost to churned customers

SELECT 
    CustomerStatus, 
    COUNT(DISTINCT CustomerID) AS Total_Customers, 
    SUM(TotalCharges) AS Revenue_Amt,
    SUM(CASE WHEN CustomerStatus = 'Churned' THEN TotalCharges ELSE 0 END) AS Revenue_Lost_To_ChurnedCust
FROM telecom_customer_churn_staging
GROUP BY CustomerStatus;

-- what Offers did churned customers have
select Offer, COUNT(DISTINCT CustomerID) AS Total_Customers,
ROUND((COUNT(CustomerID) * 100.0 / (SELECT COUNT(CustomerID) 
                                           FROM telecom_customer_churn_staging 
                                           WHERE CustomerStatus = 'Churned')), 2) as Churned_Percentage
from telecom_customer_churn_staging
where CustomerStatus = 'Churned'
group by offer;

-- Did churned customers have premium tech support?
select PremiumTechSupport, COUNT(DISTINCT CustomerID) AS Total_Customers
from telecom_customer_churn_staging
where CustomerStatus = 'Churned'
group by PremiumTechSupport;

-- Potential customers in different areas.
SELECT p.ZipCode, p.Population, 
       COUNT(DISTINCT t.CustomerID) AS Total_Customers,
       ROUND((COUNT(DISTINCT t.CustomerID) * 100.0) / Population, 2) AS Market_Penetration_Rate
FROM telecom_customer_churn_staging t
Join telecom_zipcode_population p on t.ZipCode = p.ZipCode
GROUP BY p.ZipCode, p.Population
ORDER BY Market_Penetration_Rate DESC;




       
