Fact Table Design
FactSales
Declared Grain: One row per sales order line item.

Measures:

Sales Amount
Quantity Sold
Discount Amount
Foreign Keys:

Customer Key
Product Key
Store Key
Date Key
FactReturns
Declared Grain: One row per returned order line item.

Measures:

Return Amount
Return Quantity
Foreign Keys:

Customer Key
Product Key
Store Key
Date Key
FactInventory
Declared Grain: One row per product per store per day.

Measures:

Inventory On Hand
Foreign Keys:

Product Key
Store Key
Date Key




Fact Tables
FactSales
Grain: One row per sales order line item.

FactReturns
Grain: One row per returned order line item.

FactInventory
Grain: One row per product per store per day.





                          +------------------+
                          |     DimDate      |
                          +------------------+
                                   |
                                   |
+------------------+      +------------------+      +------------------+
|   DimCustomer    |------|    FactSales     |------|    DimProduct    |
+------------------+      +------------------+      +------------------+
                                   |
                                   |
                          +------------------+
                          |    DimStore      |
                          +------------------+
                                   |
                                   |
                          +------------------+
                          |  DimPromotion    |
                          +------------------+


                          +------------------+
                          |     DimDate      |
                          +------------------+
                                   |
                                   |
+------------------+      +------------------+      +------------------+
|   DimCustomer    |------|   FactReturns    |------|    DimProduct    |
+------------------+      +------------------+      +------------------+
                                   |
                                   |
                          +------------------+
                          |    DimStore      |
                          +------------------+


                          +------------------+
                          |     DimDate      |
                          +------------------+
                                   |
                                   |
+------------------+      +------------------+      +------------------+
|    DimStore      |------|  FactInventory   |------|    DimProduct    |
+------------------+      +------------------+      +------------------+
