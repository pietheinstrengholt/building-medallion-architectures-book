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