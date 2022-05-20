
--create Fact_SRCSalesTarget
USE schema IMT577_DW_Ashli_nguyen.Public;
create table IMT577_DW_Ashli_nguyen.public.Fact_SRCSalesTarget(
    DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
    ,DimResellerID INTEGER CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID) --Foreign Key
    ,DimChannelID INTEGER CONSTRAINT FK_DimChannelID FOREIGN KEY REFERENCES Dim_Channel(DimChannelID) --Foreign Key
    ,DimTargetDateID number(9) CONSTRAINT FK_DimTargetDateID FOREIGN KEY REFERENCES Dim_Date(DATE_PKEY) --Foreign Key,SourceSalesHeaderID INT --Natural Key
    ,SalesTargetAmount Float 
);

INSERT INTO Fact_ProductSaleTarget( 
    DimStoreID 
    ,DimResellerID 
    ,DimChannelID 
    ,DimTargetDateID
    ,SalesTargetAmount 
)
    
    Dim_Store.DimStoreID
    ,Dim_Reseller.DimResellerID
    ,Dim_Channel.DimChannelID 
    ,Dim_Date.Date_PKey AS DimTargetDateID
    ,Targetdata_Channel.Targetsalesamount AS SalesTargetAmount

FROM Dim_Channel
    INNER JOIN Targetdata_Channel ON DIM_Channel.Channel= Targetdata_Channel.ChannelName
    Inner Join SalesHeader ON DIM_Channel.DimChannelID= SalesHeader.ChannelID 
    Left Outer Join DIM_Reseller ON SalesHeader.ResellerID = DIM_Reseller.DIMResellerID
    Left Outer Join Dim_Store ON SalesHeader.StoreID = DIM_Store.DimStoreID
    LEFT OUTER Join DIM_Date ON Targetdata_Channel.Year = DIM_Date.Year



--Create Fact_SalesActual
USE schema IMT577_DW_Ashli_nguyen.Public;
create table IMT577_DW_Ashli_nguyen.public.Fact_SalesActual (
    DimProductID INTEGER CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(DimProductID) --Foreign Key
    ,DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
    ,DimResellerID INTEGER CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID) --Foreign Key
    ,DimCustomerID INTEGER CONSTRAINT FK_DimCustomerID FOREIGN KEY REFERENCES Dim_Customer(DimCustomerID) --Foreign Key
    ,DimChannelID INTEGER CONSTRAINT FK_DimChannelID FOREIGN KEY REFERENCES Dim_Channel(DimChannelID) --Foreign Key
    ,DimSalesDateID number(9) CONSTRAINT FK_DimSalesDateID FOREIGN KEY REFERENCES Dim_Date(DATE_PKEY) --Foreign Key
    ,DimLocationID INTEGER CONSTRAINT FK_DimLocationID FOREIGN KEY REFERENCES Dim_Location(DimLocationID) --Foreign Key
    ,SourceSalesHeaderID INT
    ,SourceSalesDetailID INT
    ,SaleAmount INT
    ,SaleQuantity INT
    ,SaleUnitPrice FLOAT
    ,SaleExtendedCost FLOAT
    ,SaleTotalProfit FLOAT
);

Insert Into Fact_ProductSaleTarget(
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
    Dim_product.DimProductID 
    ,Dim_Store.DimStoreID
    ,Dim_Reseller.DimResellerID
    ,Dim_Customer.DimCustomerID
    ,Dim_Channel.DimChannelID 
    ,Dim_Date.Date_PKey AS DimSalesDateID 
    ,Dim_Location.DimLocationID
    ,SalesHeader.SalesHeaderID AS SourceSalesHeaderID 
    ,SalesDetail.SalesDetailID AS SourceSalesDetailID 
    ,SalesDetail.SalesAmount AS SaleAmount
    ,SalesDetail.SalesQuantity AS SaleQuantity
    ,DIM_Product.productretailprice AS SaleUnitPrice
    ,DIM_Product.productcost AS SaleExtendedCost 
    ,DIM_Product.Productretailprofit AS SaleTotalProfit 
FROM
    DIM_Product
    Inner Join SalesDetail ON dim_product.ProductID = SalesDetail.DimProductID
    Inner Join SalesHeader ON SalesDetail.SalesHeaderID = SalesHeader.SalesHeaderID
    Left Outer Join DIM_Channel ON SalesHeader.ChannelID = DIM_Channel.DimChannelID
    Left Outer Join DIM_Reseller ON SalesHeader.ResellerID = DIM_Channel.DIMResellerID
    Left Outer Join DIM_Store ON SalesHeader.StoreID = DIM_Channel.DimStoreID
    Left Outer Join DIM_Customer ON SalesHeader.CustomerID = DIM_Customer.DimCustomerID
    LEFT OUTER Join DIM_Date ON Salesheader.date = DIM_Date.Date_Pkey


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
    ,Targetdata_product.SalesQuantityTarget AS ProductTargetSalesQuantity
    FROM Targetdata_product
    INNER JOIN DIM_Product ON Targetdata_product.ProductID = Dim_product.DimProductID
    LEFT OUTER Join DIM_Date ON Targetdata_product.Year = DIM_Date.Year
