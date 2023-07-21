CREATE DATABASE Sales_Database
go 
-- Create table 
CREATE TABLE Customers(
	customer_id INT IDENTITY(1,1) NOT NULL,
	customer_name NVARCHAR(255),
	customer_city NVARCHAR(255),
	customer_state NVARCHAR(2),
	customer_soure NVARCHAR(255),

	PRIMARY KEY(customer_id)
)
go 
CREATE TABLE product(
	product_id INT IDENTITY(1,1) NOT NULL,
	product_name NVARCHAR(255),
	category NVARCHAR(255),
	PRIMARY KEY(product_id)
)
go
CREATE TABLE sales(
	sales_id INT IDENTITY(1,1) NOT NULL,
	created_at DATETIME,
	quantity INT,
	gross_sales INT,
	discount int,
	tax INT,
	net_sales INT,
	product_id INT NOT NULL,
	customer_id INT NOT NULL,
	PRIMARY KEY(sales_id)
)
GO
CREATE TABLE sales_adjusted(
	sales_id INT IDENTITY(1,1) NOT NULL,
	created_at DATE,
	quantity INT,
	gross_sales INT,
	discount int,
	tax INT,
	net_sales INT,
	product_id INT NOT NULL,
	customer_id INT NOT NULL,
	adjusted_created_at DATETIME,
	PRIMARY KEY(sales_id)
)
GO
											-- CONSTRAIN FORIEGN KEY ---

 -- Add FOREIGN KEY constraint to 'sales' table
ALTER TABLE sales
ADD CONSTRAINT FK_sales_product
FOREIGN KEY (product_id) REFERENCES product (product_id);

ALTER TABLE sales
ADD CONSTRAINT FK_sales_customer
FOREIGN KEY (customer_id) REFERENCES Customers (customer_id);

-- Add FOREIGN KEY constraint to 'sales_adjusted' table
ALTER TABLE sales_adjusted
ADD CONSTRAINT FK_sales_adjusted_product
FOREIGN KEY (product_id) REFERENCES product (product_id);

ALTER TABLE sales_adjusted
ADD CONSTRAINT FK_sales_adjusted_customer
FOREIGN KEY (customer_id) REFERENCES Customers (customer_id);
 

 -- ADD VALUE BY FUNCTION
CREATE OR ALTER PROCEDURE InsertCustomers
    @customer_name NVARCHAR(255),
    @customer_city NVARCHAR(255),
    @customer_state NVARCHAR(2),
    @customer_source NVARCHAR(255)
AS
BEGIN
    INSERT INTO Customers (customer_name, customer_city, customer_state, customer_soure)
    VALUES (@customer_name, @customer_city, @customer_state, @customer_source)
END;
---------------
CREATE OR ALTER PROCEDURE InsertProduct
    @product_name NVARCHAR(255),
    @category NVARCHAR(255)
AS
BEGIN
    INSERT INTO product (product_name, category)
    VALUES (@product_name, @category)
END;
----------------------
CREATE OR ALTER PROCEDURE InsertSales
    @created_at DATETIME,
    @quantity INT,
    @gross_sales INT,
    @discount INT,
    @tax INT,
    @net_sales INT,
    @product_id INT,
    @customer_id INT
AS
BEGIN
    INSERT INTO sales (created_at, quantity, gross_sales, discount, tax, net_sales, product_id, customer_id)
    VALUES (@created_at, @quantity, @gross_sales, @discount, @tax, @net_sales, @product_id, @customer_id)
END;
--------------
CREATE OR ALTER PROCEDURE InsertSalesAdjusted
    @created_at DATE,
    @quantity INT,
    @gross_sales INT,
    @discount INT,
    @tax INT,
    @net_sales INT,
    @product_id INT,
    @customer_id INT,
    @adjusted_created_at DATETIME
AS
BEGIN
    INSERT INTO sales_adjusted (created_at, quantity, gross_sales, discount, tax, net_sales, product_id, customer_id, adjusted_created_at)
    VALUES (@created_at, @quantity, @gross_sales, @discount, @tax, @net_sales, @product_id, @customer_id, @adjusted_created_at)
END;
----EXECUTE FUNCTION
DECLARE @i INT = 0;

WHILE @i < 10000
BEGIN
    DECLARE @customerNameWithNumber NVARCHAR(255) = 'John Doe' + CAST(@i AS NVARCHAR);
    EXEC InsertCustomers @customerNameWithNumber, 'New York', 'NY', 'Online';

    DECLARE @productNameWithNumber NVARCHAR(255) = 'Product ' + CAST(@i AS NVARCHAR);
    EXEC InsertProduct @productNameWithNumber, 'Electronics';

    DECLARE @salesCreatedAt DATETIME = '2023-07-21 10:00:00';
    DECLARE @adjustedCreatedAt DATETIME = '2023-07-21 15:30:00';
    DECLARE @quantity1 INT = 5 + @i;
    DECLARE @grossSales INT = 1000 + (@i * 10);
    DECLARE @discount1 INT = 100 + @i;
    DECLARE @tax1 INT = 50 + @i;
    DECLARE @netSales INT = @grossSales - @discount1 - @tax1;
    DECLARE @productID INT = @i + 1;
    DECLARE @customerID INT = @i + 1;

    EXEC InsertSales @salesCreatedAt, @quantity1, @grossSales, @discount1, @tax1, @netSales, @productID, @customerID;
    EXEC InsertSalesAdjusted '2023-07-21', @quantity1, @grossSales, @discount1, @tax1, @netSales, @productID, @customerID, @adjustedCreatedAt;

    SET @i = @i + 1;
END;
--------------------------------------------
--CREATE VIEW---
	CREATE VIEW v_Customer_less_than_1000 AS
		SELECT *FROM Customers where customer_id <1000
	
	select * from v_Customer_less_than_1000
-- CREATE INDEXES 
CREATE CLUSTERED INDEX IDX_customers ON [dbo].[Customers](customer_id)
DROP INDEX PK__Customer__CD65CB8505B1ADBE ON Customer;
SELECT * 
FROM sys.indexes
WHERE name = 'PK__Customer__CD65CB8505B1ADBE' ;