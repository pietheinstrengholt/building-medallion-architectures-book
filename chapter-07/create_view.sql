IF OBJECT_ID('adventureworks.v_dimension_customer', 'V') IS NOT NULL
    DROP VIEW adventureworks.v_dimension_customer
GO

CREATE VIEW adventureworks.v_dimension_customer
AS SELECT * FROM adventureworks.dimension_customer WHERE current_flag = 1;