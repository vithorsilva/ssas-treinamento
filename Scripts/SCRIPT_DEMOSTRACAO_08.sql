USE AdventureWorksDW
GO
DROP TABLE IF EXISTS [dbo].[FactResellerSales_load]
-- CRIAR TABELA EM BRANCO
SELECT * 
INTO [dbo].[FactResellerSales_load]
FROM [dbo].[FactResellerSales] r WHERE 1=2
GO

-- *********************************************************************
-- 1a carga:
INSERT INTO [dbo].[FactResellerSales_load]
-- 785 Registros
SELECT r.ProductKey,
	FORMAT(DATEFROMPARTS(YEAR(GETDATE()), MONTH(OrderDate), DAY(OrderDate)), 'yyyyMMdd') OrderDateKey, 
	FORMAT(DATEFROMPARTS(YEAR(GETDATE()), MONTH(DueDate), DAY(DueDate)), 'yyyyMMdd') DueDateKey, 
	FORMAT(DATEFROMPARTS(YEAR(GETDATE()), MONTH(ShipDate), DAY(ShipDate)), 'yyyyMMdd') ShipDateKey, 
	r.ResellerKey, r.EmployeeKey, r.PromotionKey, r.CurrencyKey, r.SalesTerritoryKey
	,REPLACE(r.SalesOrderNumber, 'SO', 'C1') SalesOrderNumber, r.SalesOrderLineNumber, r.RevisionNumber
	,r.OrderQuantity, r.UnitPrice, r.ExtendedAmount, r.UnitPriceDiscountPct, r.DiscountAmount
	,r.ProductStandardCost, r.TotalProductCost, r.SalesAmount, r.TaxAmt, r.Freight, r.CarrierTrackingNumber
	,r.CustomerPONumber
	,DATEFROMPARTS(YEAR(GETDATE()), MONTH(OrderDate), DAY(OrderDate)) OrderDate
	,DATEFROMPARTS(YEAR(GETDATE()), MONTH(DueDate), DAY(DueDate)) DueDate
	,DATEFROMPARTS(YEAR(GETDATE()), MONTH(ShipDate), DAY(ShipDate)) ShipDate
FROM [dbo].[FactResellerSales] r
where YEAR(r.OrderDate) = 2011 AND MONTH(r.OrderDate) = 01

-- *********************************************************************
TRUNCATE TABLE [dbo].[FactResellerSales_load]
GO
-- *********************************************************************
-- 2a carga:
INSERT INTO [dbo].[FactResellerSales_load]
-- 2185 Registros
SELECT r.ProductKey,
	FORMAT(DATEFROMPARTS(YEAR(GETDATE()), MONTH(OrderDate), DAY(OrderDate)), 'yyyyMMdd') OrderDateKey, 
	FORMAT(DATEFROMPARTS(YEAR(GETDATE()), MONTH(DueDate), DAY(DueDate)), 'yyyyMMdd') DueDateKey, 
	FORMAT(DATEFROMPARTS(YEAR(GETDATE()), MONTH(ShipDate), DAY(ShipDate)), 'yyyyMMdd') ShipDateKey, 
	r.ResellerKey, r.EmployeeKey, r.PromotionKey, r.CurrencyKey, r.SalesTerritoryKey
	,REPLACE(r.SalesOrderNumber, 'SO', 'C2') SalesOrderNumber, r.SalesOrderLineNumber, r.RevisionNumber
	,r.OrderQuantity, r.UnitPrice, r.ExtendedAmount, r.UnitPriceDiscountPct, r.DiscountAmount
	,r.ProductStandardCost, r.TotalProductCost, r.SalesAmount, r.TaxAmt, r.Freight, r.CarrierTrackingNumber
	,r.CustomerPONumber
	,DATEFROMPARTS(YEAR(GETDATE()), MONTH(OrderDate), DAY(OrderDate)) OrderDate
	,DATEFROMPARTS(YEAR(GETDATE()), MONTH(DueDate), DAY(DueDate)) DueDate
	,DATEFROMPARTS(YEAR(GETDATE()), MONTH(ShipDate), DAY(ShipDate)) ShipDate
FROM [dbo].[FactResellerSales] r
where YEAR(r.OrderDate) = 2012 AND MONTH(r.OrderDate) = 02
-- *********************************************************************
TRUNCATE TABLE [dbo].[FactResellerSales_load]
GO
-- *********************************************************************
-- 3a carga:
INSERT INTO [dbo].[FactResellerSales_load]
-- 13226 Registros
SELECT r.ProductKey,
	FORMAT(DATEFROMPARTS(YEAR(GETDATE()), MONTH(OrderDate), DAY(OrderDate)), 'yyyyMMdd') OrderDateKey, 
	FORMAT(DATEFROMPARTS(YEAR(GETDATE()), MONTH(DueDate), DAY(DueDate)), 'yyyyMMdd') DueDateKey, 
	FORMAT(DATEFROMPARTS(YEAR(GETDATE()), MONTH(ShipDate), DAY(ShipDate)), 'yyyyMMdd') ShipDateKey, 
	r.ResellerKey, r.EmployeeKey, r.PromotionKey, r.CurrencyKey, r.SalesTerritoryKey
	,REPLACE(r.SalesOrderNumber, 'SO', 'C3') SalesOrderNumber, r.SalesOrderLineNumber, r.RevisionNumber
	,r.OrderQuantity, r.UnitPrice, r.ExtendedAmount, r.UnitPriceDiscountPct, r.DiscountAmount
	,r.ProductStandardCost, r.TotalProductCost, r.SalesAmount, r.TaxAmt, r.Freight, r.CarrierTrackingNumber
	,r.CustomerPONumber
	,DATEFROMPARTS(YEAR(GETDATE()), MONTH(OrderDate), DAY(OrderDate)) OrderDate
	,DATEFROMPARTS(YEAR(GETDATE()), MONTH(DueDate), DAY(DueDate)) DueDate
	,DATEFROMPARTS(YEAR(GETDATE()), MONTH(ShipDate), DAY(ShipDate)) ShipDate
FROM [dbo].[FactResellerSales] r
where YEAR(r.OrderDate) IN (2012,2013) AND MONTH(r.OrderDate) IN (03,04,05)
GO