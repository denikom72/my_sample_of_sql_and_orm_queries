db.Products.aggregate([
   { $group: { _id: "$Category", AvgPrice: { $avg: "$Price" } } }
]);

//SQL Aggregation with Filtering and MongoDB Equivalent:**
```sql
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
WHERE Price > 50
GROUP BY Category;
```
db.Products.aggregate([
   { $match: { Price: { $gt: 50 } } },
   { $group: { _id: "$Category", AvgPrice: { $avg: "$Price" } }
]);

//SQL Aggregation with Joins and MongoDB Equivalent (assuming embedded documents):**
```sql
SELECT Customers.CustomerName, Orders.OrderDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;
```

db.Customers.aggregate([
   {
       $lookup: {
           from: "Orders",
           localField: "CustomerID",
           foreignField: "CustomerID",
           as: "Orders"
       }
   },
   { $unwind: "$Orders" },
   { $project: { _id: 0, CustomerName: 1, OrderDate: "$Orders.OrderDate" } }
]);

//SQL Aggregation with Grouping, Filtering, and Sorting and MongoDB Equivalent:**
```sql
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 50
ORDER BY AvgPrice DESC;
```

db.Products.aggregate([
   { $group: { _id: "$Category", AvgPrice: { $avg: "$Price" } } },
   { $match: { AvgPrice: { $gt: 50 } } },
   { $sort: { AvgPrice: -1 } }
]);

//SQL Aggregation with Multiple Aggregates and MongoDB Equivalent:**
```sql
SELECT Category, AVG(Price) AS AvgPrice, MAX(Price) AS MaxPrice
FROM Products
GROUP BY Category;
```



