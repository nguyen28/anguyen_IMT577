
--create Fact_SRCSalesTarget
create table IMT577_DW_Ashli_nguyen.public.Fact_SRCSalesTarget(
    DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
    ,DimResellerID INTEGER CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID) --Foreign Key
    ,DimChannelID INTEGER CONSTRAINT FK_DimChannelID FOREIGN KEY REFERENCES Dim_Channel(DimChannelID) --Foreign Key
    ,DimTargetDateID number(9) CONSTRAINT FK_DimTargetDateID FOREIGN KEY REFERENCES Dim_Date(DATE_PKEY) --Foreign Key,SourceSalesHeaderID INT --Natural Key
    ,SalesTargetAmount Float 
);

INSERT INTO Fact_SRCSalesTarget( 
    DimStoreID 
    ,DimResellerID 
    ,DimChannelID 
    ,DimTargetDateID
    ,SalesTargetAmount 
)
    
    NVL(dim_store.Dim_storeID, -1) AS DimStoreID
    ,NVL(dimReseller.Dimresellerid, -1) as ResellerID 
    ,NVL(Dim_Channel.Dim_ChannelID, -1) AS DimChannelID 
    ,Dim_Date.Date_PKey AS DimTargetDateID
    ,(Targetdata_Channel.Targetsalesamount)/365 AS SalesTargetAmount

FROM Dim_Channel
    INNER JOIN Targetdata_Channel ON DIM_Channel.Channel= Targetdata_Channel.ChannelName
    Inner Join SalesHeader ON DIM_Channel.DimChannelID= SalesHeader.ChannelID 
    Left Outer Join DIM_Reseller ON SalesHeader.ResellerID = DIM_Reseller.DIMResellerID
    Left Outer Join Dim_Store ON SalesHeader.StoreID = DIM_Store.DimStoreID CASE WHEN TargetName = 'Store Number 5' Then 5 and else "-1"
    Left Outer Join Dim_Store ON SalesHeader.StoreID = DIM_Store.DimStoreID CASE WHEN TargetName = 'Store Number 8' Then 8 and else "-1"
    LEFT OUTER Join DIM_Date ON Targetdata_Channel.Year = DIM_Date.Year

--Fact_ProductSaleActual
USE schema IMT577_DW_Ashli_nguyen.Public;
create table IMT577_DW_Ashli_nguyen.public.Fact_ProductSaleActual(
(
     DimProductID INTEGER CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(DimProductID) --Foreign Key
     ,DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
     ,DimResellerID INTEGER CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID) --Foreign Key
    ,DimCustomerID INTEGER CONSTRAINT FK_DimCustomerID FOREIGN KEY REFERENCES Dim_Customer(DimCustomerID) --Foreign Key,DimChannelID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
     ,DimChannelID INTEGER CONSTRAINT FK_DimChannelID FOREIGN KEY REFERENCES Dim_Channel(DimChannelID) --Foreign Key
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

INSERT INTO Fact_ProductSaleActual(
    NVL(Dim_Product.DimProductID, -1) AS DimProductID 
     NVL(dim_store.Dim_storeID, -1) AS DimStoreID 
    ,NVL(dimReseller.Dimresellerid, -1) as ResellerID 
     ,NVL(Dim_Customer.DimCustomerID, -1) AS DimCustomerID 
     ,NVL(Dim_Channel.Dim_ChannelID, -1) AS DimChannelID 
     ,Dim_Date.DimSalesDateID 
     ,NVL(Dim_Location.Dim_LocationID, -1) AS DimChannelID DimLocationID 
     ,SourceSalesHeaderID 
    ,SourceSalesDetailID 
	,SaleAmount 
    ,SaleQuantity 
    ,SaleUnitPrice 
    ,SaleExtendedCost 
    ,SaleTotalProfit 
)
FROM DIM_Product
    Inner Join SalesDetail ON dim_product.ProductID = SalesDetail.DimProductID
    Inner Join SalesHeader ON SalesDetail.SalesHeaderID = SalesHeader.SalesHeaderID
    Left Outer Join DIM_Channel ON SalesHeader.ChannelID = DIM_Channel.DimChannelID
    Left Outer Join DIM_Reseller ON SalesHeader.ResellerID = DIM_Channel.DIMResellerID
   Left Outer Join Dim_Store ON SalesHeader.StoreID = DIM_Store.DimStoreID CASE WHEN TargetName = 'Store Number 5' Then 5 and else "-1"
    Left Outer Join Dim_Store ON SalesHeader.StoreID = DIM_Store.DimStoreID CASE WHEN TargetName = 'Store Number 8' Then 8 and else "-1"
    Left Outer Join DIM_Customer ON SalesHeader.CustomerID = DIM_Customer.DimCustomerID
    LEFT OUTER Join DIM_Date ON Salesheader.date = DIM_Date.Date_Pkey

--Create Fact_ProductSaleTarget
USE schema IMT577_DW_Ashli_nguyen.Public;
create table IMT577_DW_Ashli_nguyen.public.Fact_ProductSaleTarget  (
(
    DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
    ,DimResellerID INTEGER CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID) --Foreign Key
    ,DimCustomerID INTEGER CONSTRAINT FK_DimCustomerID FOREIGN KEY REFERENCES Dim_Customer(DimCustomerID) --Foreign Key
--create Fact_ProductSaleTarget
DROP TABLE IF EXISTS Fact_ProductSaleTarget

create table IMT577_DW_Ashli_Nguyen.public.Fact_ProductSaleTarget(
     DimProductID INT CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(DimProductID) --Foreign Key
    ,DimTargetDateID number(9) CONSTRAINT FK_DimTargetDateID FOREIGN KEY REFERENCES Dim_Date(DATE_PKEY) --Foreign Key
	,ProductTargetSalesQuantity INT
);

Insert Into Fact_ProductSaleTarget(
    DimProductID
    ,DimTargetDateID
    ,ProductTargetSalesQuantity
)
SELECT Distinct
    Dim_Product.DimProductID
    ,Dim_Date.Date_PKey AS DimTargetDateID
    ,(Targetdata_product.SalesQuantityTarget)/365 AS ProductTargetSalesQuantity
    FROM Targetdata_product
    INNER JOIN DIM_Product ON Targetdata_product.ProductID = Dim_product.DimProductID
    LEFT OUTER Join DIM_Date ON Targetdata_product.Year = DIM_Date.Year


