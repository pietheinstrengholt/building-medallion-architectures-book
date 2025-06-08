/** Create table with user-friendly comments **/
CREATE TABLE silver.customer (
    CustomerID BIGINT COMMENT 'Customer Identifi
    FullName STRING COMMENT 'Customer Full Name'
    Region STRING COMMENT 'Region Code',
    SignupDate DATE COMMENT 'First Sign Up Date'
    LastLogin DATE  COMMENT 'Last Login Date'
);
/** Table and field names are easy to read **/
INSERT INTO silver.customer
(CustomerID, FullName, Region, SignupDate, LastL
SELECT
    custID AS CustomerID,
    CONCAT(f_name, ' ', l_name) AS FullName,
    rgcd AS Region,
    sigdt AS SignupDate,
    lldt AS LastLogin
FROM
bronze.cust_data;