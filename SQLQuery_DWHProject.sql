-- Melihat isi tabel pada database Staging 

USE Staging;

SELECT*FROM customer;
SELECT*FROM product;
SELECT*FROM sales_order;
SELECT*FROM status_order;

-- Membuat database DWH_Project

CREATE DATABASE DWH_Project;

-- Membuat tabel fact dan tabel dimension

USE DWH_Project;

CREATE TABLE DimCustomer (
    CustomerID INT not null PRIMARY KEY,
    CustomerName VARCHAR(255) not null,
	Age INT not null,
	Gender VARCHAR(100) not null,
	City VARCHAR(255) not null,
	NoHp VARCHAR(20) not null
);

CREATE TABLE DimProduct (
    ProductID INT not null PRIMARY KEY,
    ProductName VARCHAR(255) not null,
    ProductCategory VARCHAR(255) not null,
	ProductUnitPrice INT not null
);

CREATE TABLE DimStatusOrder (
    StatusID INT not null PRIMARY KEY,
    StatusOrder VARCHAR(255) not null,
    StatusOrderDesc VARCHAR(255) not null
);

CREATE TABLE FactSalesOrder (
    OrderID INT not null PRIMARY KEY,
    CustomerID INT not null FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    ProductID INT not null FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
	Quantity INT not null ,
	Amount INT not null,
	StatusID INT not null FOREIGN KEY (StatusID) REFERENCES DimStatusOrder(StatusID),
	OrderDate DATE not null,
);


-- Melihat hasil pemindahan data dari Staging ke DWH_Project

SELECT*FROM DimCustomer;
SELECT*FROM DimProduct;
SELECT*FROM DimStatusOrder;
SELECT*FROM FactSalesOrder;

-- Membuat store prosedure untuk menampilkan summary sales order berdasarkan status pengiriman.

CREATE PROCEDURE summary_order_status
    @StatusID INT
AS
BEGIN
    SELECT
        o.OrderID,
        c.CustomerName,
        p.ProductName,
        o.Quantity,
        s.StatusOrder
    FROM
        FactSalesOrder o
    JOIN DimCustomer c ON o.CustomerID = c.CustomerID
    JOIN DimProduct p ON o.ProductID = p.ProductID
    JOIN FactSalesOrder d ON o.OrderID = d.OrderID
    JOIN DimStatusOrder s ON d.StatusID = s.StatusID
    WHERE
        s.StatusID = @StatusID;
END;

-- Melihat output store procedure

EXEC summary_order_status @StatusID = 1; 

EXEC summary_order_status @StatusID = 2;

EXEC summary_order_status @StatusID = 3;

EXEC summary_order_status @StatusID = 4;
