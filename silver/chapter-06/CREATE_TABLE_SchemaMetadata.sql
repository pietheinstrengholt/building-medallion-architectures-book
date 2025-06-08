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
GO 