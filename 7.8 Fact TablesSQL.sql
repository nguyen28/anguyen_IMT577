
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
    CASE    
        WHEN TargetName = 'Store Number 5' Then 5
        WHEN TargetName = 'Store Number 8' then 8
    Else -1 
    end AS storeID
    ,NVL(dim_Reseller.Dimresellerid, -1) as dimResellerID 
    ,NVL(Channel.ChannelID, -1) AS DimChannelID 
    ,Dim_Date.Date_PKey AS DimTargetDateID
    ,(Targetdata_Channel.Targetsalesamount)/365 AS SalesTargetAmount

FROM SalesHeader 
    Inner Join Channel ON SalesHeader.ChannelID= Channel.ChannelID
    Inner Join Targetdata_Channel ON Channel.Channel = Targetdata_Channel.ChannelName
    Left Outer Join Dim_Store ON SalesHeader.StoreID = DIM_Store.DimStoreID 
    Left Join Dim_reseller ON salesheader.resellerid = dim_reseller.sourceresellerid
    LEFT OUTER Join DIM_Date ON Targetdata_Channel.Year = DIM_Date.Year

--Fact_ProductSaleActual
USE schema IMT577_DW_Ashli_nguyen.Public;
DROP TABLE IF EXISTS Fact_SalesActual

create table IMT577_DW_Ashli_nguyen.public.Fact_SalesActual(
     DimProductID INTEGER CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(DimProductID) --Foreign Key
     ,DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
     ,DimResellerID INTEGER CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID) --Foreign Key
    ,DimCustomerID INTEGER CONSTRAINT FK_DimCustomerID FOREIGN KEY REFERENCES Dim_Customer(DimCustomerID) --Foreign Key,DimChannelID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID) --Foreign Key
     ,DimChannelID INTEGER CONSTRAINT FK_DimChannelID FOREIGN KEY REFERENCES Dim_Channel(DimChannelID) --Foreign Key
    ,DimSalesDateID Number(9) CONSTRAINT FK_DimSalesDateID FOREIGN KEY REFERENCES Dim_Date(Date_PKey) --Foreign Key
     ,DimLocationID INTEGER CONSTRAINT FK_DimLocationID FOREIGN KEY REFERENCES Dim_Location(DimLocationID) --Foreign Key
     ,SourceSalesHeaderID INT --Natural Key
    ,SourceSalesDetailID INTEGER --Natural Key 
	,SaleAmount FLOAT
    ,SaleQuantity INT
    ,SaleUnitPrice FLOAT
    ,SaleExtendedCost FLOAT
    ,SaleTotalProfit FLOAT
);

INSERT INTO Fact_SalesActual(
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
    ,NVL(salesheader.storeID, -1) AS DimStoreID 
    ,NVL(Dim_reseller.dimresellerid, -1) as DimResellerID 
    ,NVL(dim_customer.dimCustomerID,-1) AS DimCustomerID 
    ,NVL(salesheader.ChannelID, -1) AS DimChannelID 
    ,Dim_Date.Date_PKey AS DimSalesDateID 
   ,NVL(Dim_Location.DimLocationID, -1) AS DimLocationID 
    ,salesheader.salesheaderid AS SourceSalesHeaderID 
    ,salesdetail.salesdetailID AS SourceSalesDetailID 
	,salesdetail.SalesAmount AS SaleAmount 
    ,salesdetail.SalesQuantity AS SaleQuantity 
    ,(salesdetail.salesamount/salesdetail.salesquantity) AS SaleUnitPrice
    ,CASE 
        when (salesdetail.SalesAmount / salesdetail.SalesQuantity) = Dim_Product.ProductRetailPrice then Dim_Product.ProductRetailPrice else Dim_Product.ProductWholesalePrice end AS SaleExtendedCost,
    CASE 
        when (salesdetail.SalesAmount / salesdetail.SalesQuantity) = Dim_Product.ProductRetailPrice then (Dim_Product.ProductRetailProfit * salesdetail.SalesQuantity) else (Dim_Product.ProductWholesaleUnitProfit * salesdetail.SalesQuantity) 
        end AS SaleTotalProfit  

FROM SalesDetail
    LEFT JOIN Salesheader ON SalesDetail.SalesHeaderID = Salesheader.SalesHeaderID
    Left Join Dim_product ON dim_product.dimProductID = SalesDetail.ProductID
    Left Outer Join DIM_Reseller ON Salesheader.ResellerID = DIM_Reseller.SourceResellerID
    Left Outer Join DIM_Customer ON Salesheader.customerid = DIM_Customer.SourceCustomerID
    --Inner Join Targetdata_Product ON dim_product.dimproductID = Targetdata_Product.productID
    LEFT OUTER Join DIM_Date ON TO_DATE(salesheader.date, 'mm/dd/yy') = dim_date.date
    Left Join DIM_Store ON Salesheader.storeID = DIM_Store.SourcestoreID
    Left Outer Join Dim_Location ON Dim_Location.DimLocationID = dim_store.dimLocationID 
     /**  CASE 
        WHEN Salesheader.StoreID IS NOT NULL THEN Dim_Store.DimLocationID = Dim_location.DimLocationID
        ELSE -1
        end AS DimLocationID**/
   -- Left Join DIM_Channel ON DIM_Store.SourcestoreID= DIM_Channel.SourceChannelID
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


