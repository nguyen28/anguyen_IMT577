
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
Select Distinct
    NVL(dim_store.Dim_storeID, -1) AS DimStoreID
    ,NVL(dimReseller.Dimresellerid, -1) as ResellerID 
    ,NVL(Dim_Channel.Dim_ChannelID, -1) AS DimChannelID 
    ,Dim_Date.Date_PKey AS DimTargetDateID
    ,(Targetdata_Channel.Targetsalesamount)/365 AS SalesTargetAmount

FROM SalesHeader 
    Inner Join Channel ON SalesHeader.ChannelID= Channel.ChannelID
    Inner Join Targetdata_Channel ON Channel.ChannelName = Targetdata_Channel.ChannelName
    Left Outer Join Dim_Store ON SalesHeader.StoreID = DIM_Store.DimStoreID CASE WHEN TargetName = 'Store Number 5' Then 5 and else "-1" 
    Left Outer Join Dim_Store ON SalesHeader.StoreID = DIM_Store.DimStoreID CASE WHEN TargetName = 'Store Number 8' Then 8 and else "-1"
    LEFT OUTER Join DIM_Date ON Targetdata_Channel.Year = DIM_Date.Year

--Fact_ProductSaleActual
USE schema IMT577_DW_Ashli_nguyen.Public;
DROP TABLE IF EXISTS Fact_ProductSaleActual

create table IMT577_DW_Ashli_nguyen.public.Fact_ProductSaleActual(
(
     DimProductID INTEGER CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(DimProductID) --Foreign Key
     ,DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
     ,DimResellerID VarChar(255) CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID) --Foreign Key
    ,DimCustomerID VarChar(255) CONSTRAINT FK_DimCustomerID FOREIGN KEY REFERENCES Dim_Customer(DimCustomerID) --Foreign Key,DimChannelID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
     ,DimChannelID INTEGER CONSTRAINT FK_DimChannelID FOREIGN KEY REFERENCES Dim_Channel(DimChannelID) --Foreign Key
    ,DimSalesDateID Number(9) CONSTRAINT FK_DimSalesDateID FOREIGN KEY REFERENCES Dim_Date(DimSalesDateID) --Foreign Key
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
    DimProductID 
    ,DimStoreID
    ,DimResellerID 
    ,DimCustomerID 
    ,DimChannelID 
    ,DimSalesDateID 
     ,DimLocationID 
    ,SourceSalesHeaderID 
    ,SourceSalesDetailID 
	,SaleAmount 
    ,SaleQuantity 
    ,SaleUnitPrice 
    ,SaleExtendedCost 
    ,SaleTotalProfit 
)

SELECT Distinct
     NVL(Dim_Product.DimProductID, -1) AS DimProductID 
     NVL(dim_store.Dim_storeID, -1) AS DimStoreID 
    ,NVL(dimReseller.Dimresellerid, "Unknown") as ResellerID 
     ,NVL(Dim_Customer.DimCustomerID,"Unknown") AS DimCustomerID 
     ,NVL(Dim_Channel.Dim_ChannelID, -1) AS DimChannelID 
     ,Dim_Date.DimSalesDateID 
     ,NVL(Dim_Location.Dim_LocationID, -1) AS DimChannelID DimLocationID 
     ,SourceSalesHeaderID 
    ,SourceSalesDetailID 
	,SaleAmount 
    ,SaleQuantity 
    ,(salesdetail.salesamount/salesdetail.salequantity) AS SaleUnitPrice 
    ,(product.cost * salesdetail.salequantity AS SaleExtendedCost 
    ,SaleTotalProfit 

FROM DIM_Product
    Left Join SalesDetail ON dim_product.ProductID = SalesDetail.DimProductID
    Left Join DIM_Store ON DIM_product.SourceproductID = DIM_Store.SourcestoreID
    Left Join DIM_Channel ON DIM_Store.SourcestoreID= DIM_Channel.SourceChannelID
    Left Outer Join DIM_Reseller ON DIM_Channel.SourceResellerID = DIM_Reseller.SourceResellerID
    Left Outer Join DIM_Customer ON DIM_Reseller.SourceresellerID = DIM_Customer.SourceCustomerID
   Left Outer Join Dim_Location ON Dim_Location.DimLocationID = salesdetail.DimLocationID CASE WHEN Salesheader.StoreID IS NOT NULL THEN Dim_Store.DimLocationID = salesdetail.DimLocationID
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


