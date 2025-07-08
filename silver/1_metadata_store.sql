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


-- Metadata Store
-- This table is designed for storing various details about the database schema. This exercise aims to illustrate common concepts rather than provide an exhaustive approach. 

CREATE TABLE SchemaMetadata  
(  
    Id INT IDENTITY(1,1) PRIMARY KEY,  
    SchemaName NVARCHAR(128),
    TableName NVARCHAR(128),
    ColumnName NVARCHAR(128),  
    DataType NVARCHAR(128),  
    CharacterMaximumLength INT,  
    NumericPrecision INT,  
    NumericScale INT,  
    IsNullable NVARCHAR(3),  
    DateTimePrecision INT,  
    IsPrimaryKey BIT DEFAULT 0  
)  
GO ;

INSERT INTO SchemaMetadata  
(SchemaName, TableName, ColumnName, DataType, CharacterMaximumLength, 
NumericPrecision, NumericScale, IsNullable, DateTimePrecision, IsPrimaryKey)  
VALUES  
('AdventureWorks', 'Address', 'AddressID', 'int', 
NULL, 10, 0, 'NO', NULL, 1),  
('AdventureWorks', 'Address', 'AddressLine1', 'nvarchar', 
60, NULL, NULL, 'NO', NULL, 0),  
('AdventureWorks', 'Address', 'AddressLine2', 'nvarchar', 
60, NULL, NULL, 'YES', NULL, 0),  
('AdventureWorks', 'Address', 'City', 'nvarchar', 
30, NULL, NULL, 'NO', NULL, 0),  
('AdventureWorks', 'Address', 'StateProvince', 'int', 
NULL, 10, 0, 'NO', NULL, 0),  
('AdventureWorks', 'Address', 'PostalCode', 'nvarchar', 
15, NULL, NULL, 'NO', NULL, 0),  
('AdventureWorks', 'Address', 'CountryRegion', 'geography', 
NULL, NULL, NULL, 'YES', NULL, 0),  
('AdventureWorks', 'Address', 'rowguid', 'uniqueidentifier', 
NULL, NULL, NULL, 'NO', NULL, 0),  
('AdventureWorks', 'Address', 'ModifiedDate', 'datetime', 
NULL, NULL, NULL, 'NO', 3, 0);  
GO

-- Data Validation