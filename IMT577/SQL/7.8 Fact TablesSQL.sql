
--create Fact_SRCSalesTarget
USE schema IMT577_DW_Ashli_nguyen.Public;
create table IMT577_DW_Ashli_nguyen.public.Fact_ProductSaleTarget (
(
     DimProductID INTEGER CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(DimProductID) --Foreign Key
     ,DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
     ,DimResellerID INTEGER CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID) --Foreign Key
    ,DimCustomerID INTEGER CONSTRAINT FK_DimCustomerID FOREIGN KEY REFERENCES Dim_Customer(DimCustomerID) --Foreign Key,DimChannelID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
     ,DimSalesDateID INTEGER CONSTRAINT FK_DimSalesDateID FOREIGN KEY REFERENCES Dim_Date(DimSalesDateID) --Foreign Key
     ,DimLocationID INTEGER CONSTRAINT FK_DimLocationID FOREIGN KEY REFERENCES Dim_Location(DimLocationID) --Foreign Key
     ,SourceSalesHeaderID INT --Natural Key
    ,SourceSalesDetailID INTEGER --Natural Key 
	,SaleAmount FLOAT
    ,SaleQuantity INT
    ,SaleUnitPrice FLOAT
    ,SaleExtendedCost FLOAT
    ,SaleTotalProfit FLOAT
);

INSERT INTO Fact_ProductSaleTarget(
    Dim_Product.DimProductID 
     ,Dim_Store.DimStoreID 
     ,Dim_reseller.DimResellerID 
     ,Dim_Customer.DimCustomerID 
     ,Dim_Channel.DimChannelID 
     ,Dim_Date.DimSalesDateID 
     ,Dim_Location.DimLocationID 
     ,SourceSalesHeaderID 
    ,SourceSalesDetailID 
	,SaleAmount 
    ,SaleQuantity 
    ,SaleUnitPrice 
    ,SaleExtendedCost 
    ,SaleTotalProfit 
)
FROM 

--Create Fact_SalesActual
USE schema IMT577_DW_Ashli_nguyen.Public;
create table IMT577_DW_Ashli_nguyen.public.Fact_SalesActual (
(
    DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
    ,DimResellerID INTEGER CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID) --Foreign Key
    ,DimCustomerID INTEGER CONSTRAINT FK_DimCustomerID FOREIGN KEY REFERENCES Dim_Customer(DimCustomerID) --Foreign Key
--create Fact_ProductSaleTarget
DROP TABLE IF EXISTS Fact_ProductSaleTarget

create table IMT577_DW_Ashli_nguyen.public.Fact_ProductSaleTarget (
(
     DimProductID INTEGER CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(DimProductID) --Foreign Key
     DimTargetDateID INTEGER CONSTRAINT FK_DimTaretDateID FOREIGN KEY REFERENCES Dim_Date(DimTargetDateID) --Foreign Key
	,ProductTargetSalesQuantity FLOAT
);

Insert Into Fact_ProductSaleTarget(
    DimProductID
    ,DimTargetDateID
    ,ProductTargetSalesQuantity
)
SELECT Distinct
    Dim_Product.DimProductID
    ,Dim_Date.DimTargetDateID
    ,ProductTargetSalesQuantity
    FROM Dim_Product
    INNER JOIN DIM_Date ON Dim_date.DATE_PKEY = Dim_product
