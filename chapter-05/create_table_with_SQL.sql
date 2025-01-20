CREATE TABLE customer (
    CustomerID INT COMMENT 'Customer identifier',
    NameStyle BOOLEAN COMMENT 'Style of the name',
    Title STRING COMMENT 'Title of the customer',
    FirstName STRING COMMENT 'First name of the customer'
)
USING delta