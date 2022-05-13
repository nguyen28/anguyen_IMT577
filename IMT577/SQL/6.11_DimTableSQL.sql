--Dim Location first
create or replace table IMT577_DW_Ashli_nguyen.public.Dim_Location(
    DimLocationID INT IDENTITY(1,1) CONSTRAINT PK_DimLocationID PRIMARY KEY NOT NULL --Surrogate Key
	,SourceLocationID INTEGER NOT NULL --Natural Key
    ,PostalCode INTEGER NOT NULL
    ,Address VARCHAR(255) NOT NULL
    ,City VARCHAR(255) NOT NULL
    ,StateProvince VARCHAR(255) NOT NULL
    ,Country VARCHAR(255) NOT NULL
);

INSERT INTO Dim_Location
(
     DimLocationID
	,SourceLocationID
    ,PostalCode
    ,Address
    ,City
    ,StateProvince
    ,Country
)
VALUES
( 
     -1
    ,-1
    ,-1 
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
);

INSERT INTO Dim_Location
(
     DimLocationID
	,SourceLocationID
    ,PostalCode
    ,Address
    ,City
    ,StateProvince
    ,Country
)
	SELECT 
	SubsegmentID AS DimLocationID
    ,SubsegmentID AS SourceLocationID
    ,PostalCode
    ,Address
    ,City
    ,StateProvince
    ,Country
     
	FROM Customer

/**Need assistance on how to resolve the issues for resller and customer ID in which the ID are varchar(255)**/
INSERT INTO Dim_Location
(
     DimLocationID
	,SourceLocationID
    ,PostalCode
    ,Address
    ,City
    ,StateProvince
    ,Country
)
	SELECT 
	ResellerID AS DimLocationID
    ,ResellerID AS SourceLocationID
    ,PostalCode
    ,Address
    ,City
    ,StateProvince
    ,Country
     
	FROM Reseller

--SELECT * FROM Dim_Location;

--Dim Channel 2nd
TRUNCATE DIM_Channel

create or replace table IMT577_DW_Ashli_nguyen.public.Dim_Channel(
    DimChannelID INT IDENTITY(1,1) CONSTRAINT PK_DimChannelID PRIMARY KEY NOT NULL --Surrogate Key
	,SourceChannelID INTEGER NOT NULL --Natural Key
    ,SourceChannelCategoryID INTEGER NOT NULL
    ,Channel VARCHAR(255) NOT NULL
    ,ChannelCategory VARCHAR(255) NOT NULL
);

INSERT INTO Dim_Channel
(
     DimChannelID
	,SourceChannelID
    ,SourceChannelCategoryID
    ,Channel
    ,ChannelCategory
)
VALUES
( 
     -1
    ,-1
    ,-1 
    ,'Unknown'
    ,'Unknown'
);

INSERT INTO IMT577_DW_Ashli_nguyen.public.Dim_Channel
(
     DimChannelID
	,SourceChannelID
    ,SourceChannelCategoryID
    ,Channel
    ,ChannelCategory
)
	SELECT 
    ChannelID AS DimChannelID
	,ChannelID AS SourceChannelID
    ,Channel.ChannelCategoryID AS SourceChannelCategoryID
    ,Channel
    ,ChannelCategory.ChannelCategory
    FROM Channel
   
    INNER JOIN ChannelCategory ON Channel.ChannelCategoryID = ChannelCategory.ChannelCategoryID


--DIM Product

create or replace table IMT577_DW_Ashli_nguyen.public.Dim_Product(
    DimProductID INT IDENTITY(1,1) CONSTRAINT PK_DimProductID PRIMARY KEY NOT NULL --Surrogate Key
	,SourceProductID INTEGER NOT NULL --Natural Key
    ,SourceProductTypeID INTEGER NOT NULL --Natural Key
    ,SourceProductCategoryID INTEGER NOT NULL --Natural Key
    ,ProductName VARCHAR(255) NOT NULL
    ,ProductType VARCHAR(255) NOT NULL
    ,ProductCategory VARCHAR(255) NOT NULL
    ,ProductRetailPrice FLOAT NOT NULL
    ,ProductWholesalePrice FLOAT NOT NULL
    ,ProductCost FLOAT NOT NULL
    ,ProductRetailProfit FLOAT NOT NULL
    ,ProductWholesaleUnitProfit FLOAT NOT NULL
    ,ProductProfitMarginUnitPercent FLOAT NOT NULL
);

INSERT INTO Dim_Product
(
     DimProductID
	,SourceProductID
    ,SourceProductTypeID
    ,SourceProductCategoryID
    ,ProductName
    ,ProductType
    ,ProductCategory
    ,ProductRetailPrice
    ,ProductWholesalePrice
    ,ProductCost
    ,ProductRetailProfit
    ,ProductWholesaleUnitProfit
    ,ProductProfitMarginUnitPercent
)
VALUES
( 
     -1
    ,-1
    ,-1 
    ,-1
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
    ,-1.0
    ,-1.0
    ,-1.0
    ,-1.0
    ,-1.0
    ,-1.0
);

INSERT INTO Dim_Product
(
     DimProductID
	,SourceProductID
    ,SourceProductTypeID
    ,SourceProductCategoryID
    ,ProductName
    ,ProductType
    ,ProductCategory
    ,ProductRetailPrice
    ,ProductWholesalePrice
    ,ProductCost
    ,ProductRetailProfit
    ,ProductWholesaleUnitProfit
    ,ProductProfitMarginUnitPercent
)
	SELECT 
    ProductID AS DimProductID
	,ProductID AS SourceProductID
    ,Product.ProducttypeID AS SourceProductTypeID
    ,ProductType.productcategoryID AS SourceProductCategoryID
    ,Product AS ProductName
    ,ProductType.ProductType
    ,ProductCategory.productCategory
    ,Price AS ProductRetailPrice
    ,Wholesaleprice AS ProductWholesalePrice
    ,Cost AS ProductCost
    ,(Price - Cost) AS ProductRetailProfit
    ,(Wholesaleprice - cost) AS ProductWholesaleUnitProfit
    ,(ProductWholesaleUnitProfit / 100) AS ProductProfitMarginUnitPercent
    FROM Product
   
    INNER JOIN ProductType ON Product.ProducttypeID = ProductType.ProducttypeID
    INNER JOIN ProductCategory ON ProductType.productcategoryID = ProductCategory.productcategoryID


--DIM Store
USE schema IMT577_DW_Ashli_nguyen.Public;

create or replace table Dim_Store(
    DimStoreID INT IDENTITY(1,1) CONSTRAINT PK_DimStoreID PRIMARY KEY NOT NULL --Surrogate Key
	,DimLocationID INTEGER CONSTRAINT FK_DimLocationIDStore FOREIGN KEY REFERENCES Dim_Location (DimLocationID) NOT NULL
    ,SourceStoreID INTEGER NOT NULL --Natural Key
    ,StoreNumber INTEGER NOT NULL
    ,StoreManager VARCHAR(255) NOT NULL
);

INSERT INTO Dim_Store
(
     DimStoreID
	,DimLocationID
    ,SourceStoreID
    ,StoreNumber
    ,StoreManager
)
VALUES
( 
     -1
    ,-1
    ,-1 
    ,-1
    ,'Unknown'
);


INSERT INTO Dim_Store
(
     DimStoreID
	,DimLocationID
    ,SourceStoreID
    ,StoreNumber
    ,StoreManager
)
	SELECT 
    StoreID AS DimStoreID
	,StoreID AS DimLocationID
    ,StoreID AS SourceStoreID
    ,StoreNumber
    ,StoreManager
    FROM STORE
   

--Dim Reseller
Truncate Dim_Reseller
create or replace table Dim_Reseller(
    DimResellerID INT IDENTITY(1,1) CONSTRAINT PK_DimResellerID PRIMARY KEY NOT NULL --Surrogate Key
	,DimLocationID INTEGER CONSTRAINT FK_DimLocationIDReseller FOREIGN KEY REFERENCES Dim_Location (DimLocationID) NOT NULL
    ,SourceResellerID INTEGER NOT NULL --Natural Key
    ,ContactName VARCHAR(255) NOT NULL
    ,PhoneNumber VARCHAR(255) NOT NULL
    ,EmailAddress VARCHAR(255) NOT NULL
);

INSERT INTO Dim_Reseller
(
     DimResellerID
	,DimLocationID
    ,SourceResellerID
    ,ContactName
    ,PhoneNumber
    ,EmailAddress
)
VALUES
( 
     -1
    ,-1
    ,-1
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
);

INSERT INTO Dim_Reseller
(
     DimResellerID
	,DimLocationID
    ,SourceResellerID
    ,ContactName
    ,PhoneNumber
    ,EmailAddress
)
	SELECT 
     ResellerID AS DimResellerID
	,ResellerID AS DimLocationID
    ,ResellerID AS SourceResellerID
    ,Contact AS ContactName
    ,PhoneNumber
    ,EmailAddress
    FROM Reseller
   
--Dim Customer
create or replace table Dim_Customer(
    DimCustomerID INT IDENTITY(1,1) CONSTRAINT PK_DimCustomerID PRIMARY KEY NOT NULL --Surrogate Key
	,DimLocationID INTEGER CONSTRAINT FK_DimLocationIDCustomer FOREIGN KEY REFERENCES Dim_Location (DimLocationID) NOT NULL
    ,SourceCustomerID INTEGER NOT NULL --Natural Key
    ,FullName VARCHAR(255) NOT NULL
    ,FirstName VARCHAR(255) NOT NULL
    ,LastName VARCHAR(255) NOT NULL
    ,Gender VARCHAR(255) NOT NULL
    ,EmailAddress VARCHAR(255) NOT NULL
    ,PhoneNumber VARCHAR(255) NOT NULL
);

INSERT INTO Dim_Customer
(
     DimCustomerID
	,DimLocationID
    ,SourceCustomerID
    ,FullName
    ,FirstName
    ,LastName
    ,Gender
    ,EmailAddress
    ,PhoneNumber
)
VALUES
( 
     -1
    ,-1
    ,-1
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
    ,'Unknown'
);

