CREATE SCHEMA Security;  
GO  

-- Creating a function for the SalesPerson  
CREATE FUNCTION Security.udf_securitypredicate(@SalesPerson AS varchar(50))  
    RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS udf_securitypredicate_result  
    WHERE @SalesPerson = USER_NAME() OR IS_ROLEMEMBER('manager') = 1;  
GO

-- Using the function to create a Security Policy  
CREATE SECURITY POLICY SalesFilter  
ADD FILTER PREDICATE Security.udf_securitypredicate(SalesPerson)  
ON SalesLT.Customer  
WITH (STATE = ON);  
GO