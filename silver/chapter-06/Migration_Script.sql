SELECT
    'AdventureWorks' as 'SchemaName',
    TABLE_NAME as 'TableName',  
    COLUMN_NAME as 'ColumnName',  
    DATA_TYPE as 'DataType',  
    CHARACTER_MAXIMUM_LENGTH as 'CharacterMaximumLength',  
    NUMERIC_PRECISION as 'NumericPrecision',  
    NUMERIC_SCALE as 'NumericScale',  
    IS_NULLABLE as 'IsNullable',  
    DATETIME_PRECISION as 'DateTimePrecision',
    COLUMNPROPERTY(OBJECT_ID(TABLE_NAME), COLUMN_NAME, 'IsIdentity') 
    as 'IsPrimaryKey'  
FROM   
    INFORMATION_SCHEMA.COLUMNS  
WHERE   
    TABLE_NAME = 'Address'