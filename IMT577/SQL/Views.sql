/**1. Give an overall assessment of stores number 5 and 8’s sales.

How are they performing compared to target? Will they meet their 2014 target?
Should either store be closed? Why or why not?
What should be done in the next year to maximize store profits? **/
USE schema IMT577_DW_Ashli_nguyen.Public;

CREATE OR REPLACE SECURE VIEW Store_assessment
AS Select
storenumber,
Fact_salesactual.dimproductID,
Fact_salesactual.dimstoreid,
Fact_salesactual.dimsalesdateid,
Fact_salesactual.saleamount,
Fact_salesactual.saletotalprofit,
fact_srcsalestarget.dimtargetdateid,
fact_srcsalestarget.salestargetamount

FROM Fact_salesactual
LEFT JOIN DIM_Store ON Fact_salesactual.dimstoreID = Dim_store.dimstoreID
left join dim_channel ON dim_channel.dimchannelid =Fact_salesactual.dimchannelid
left join fact_srcsalestarget on fact_srcsalestarget.dimstoreid = Fact_salesactual.dimstoreid
LEFT JOIN dim_date ON Fact_salesactual.dimsalesdateid = Dim_date.date_PKEY
WHERE storenumber IN (5, 8)

/**2. Recommend separate 2013 and 2014 bonus amounts for each store if the total bonus pool for 2013 is $500,000 and the total bonus pool for 2014 is $400,000. Base your recommendation on how well the stores are selling Product Types of Men’s Casual and Women’s Casual. **/

/**3. Assess product sales by day of the week at stores 5 and 8. What can we learn about sales trends?**/
CREATE OR REPLACE SECURE VIEW product_sales
AS
SELECT DIM_store.storenumber,
Fact_salesactual.dimproductID,
--Product.ProductType,
ProductCategory.ProductCategory,
Fact_salesactual.SALEAMOUNT,
Fact_salesactual.SALEQUANTITY,
Fact_salesactual.SALETOTALPROFIT,
Fact_salesactual.dimsalesdateID AS DimDateID,
Dim_date.DATE AS FullDate
FROM Fact_salesactual 
LEFT JOIN DIM_Store ON Fact_salesactual.dimstoreID = Dim_store.dimstoreID
LEFT JOIN DIM_product ON Fact_salesactual.dimproductID = dim_product.dimproductID
Left Join product on dim_product.dimproductID =product.productID
Left Join producttype ON product.producttypeID = productType.producttypeID
Left Join productcategory ON producttype.productcategoryID = productcategory.productcategoryID
LEFT JOIN Dim_Date ON Fact_salesactual.DIMSALESDATEID = Dim_Date.DATE_PKEY
WHERE dim_store.storenumber IN (5, 8)

/**4. Compare the performance of all stores located in states that have more than one store to all stores that are the only store in the state. What can we learn about having more than one store in a state? **/
CREATE OR REPLACE SECURE VIEW store_location
AS
SELECT dim_store.storenumber,
Fact_salesactual.DIMCHANNELID, 
dim_product.dimproductID,
Fact_salesactual.dimlocationID,
producttype.producttype,
Fact_salesactual.saleamount,
Fact_salesactual.salequantity,
Fact_salesactual.SALETOTALPROFIT,
dim_location.StateProvince, 
Fact_salesactual.dimsalesdateID AS DimDateID,
Dim_date.date AS FullDate
FROM Fact_salesactual
LEFT JOIN DIM_Store ON Fact_salesactual.dimstoreID = Dim_store.dimstoreID
LEFT JOIN DIM_product ON Fact_salesactual.dimproductID = dim_product.dimproductID
Left Join product on dim_product.dimproductID =product.productID
Left Join producttype ON product.producttypeID = productType.producttypeID
LEFT JOIN Dim_Date ON Fact_salesactual.DIMSALESDATEID = Dim_Date.DATE_PKEY
LEFT JOIN dim_location ON Dim_store.dimlocationID = dim_location.dimlocationID
WHERE dim_store.storenumber <> -1