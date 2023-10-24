SELECT CategoryName, CustomerName, AVG(OrderQuantity) AS AvgOrderQuantity, SUM(TotalSales) AS CustomerTotalSales
FROM (
    SELECT CategoryName, CustomerName, OrderQuantity, TotalSales
    FROM (
        SELECT O.CustomerID, C.CustomerName, OD.ProductID, P.CategoryName, OD.Quantity AS OrderQuantity, OD.UnitPrice * OD.Quantity AS TotalSales
        FROM Orders O
        INNER JOIN Customers C ON O.CustomerID = C.CustomerID
        INNER JOIN OrderDetails OD ON O.OrderID = OD.OrderID
        INNER JOIN Products P ON OD.ProductID = P.ProductID
    ) AS Subquery1
) AS Subquery2
GROUP BY CategoryName, CustomerName;

--

SELECT CategoryName, AVG(OrderQuantity) AS AvgOrderQuantity
FROM (
    SELECT P.ProductID, P.CategoryName, OD.Quantity AS OrderQuantity
    FROM Products P
    INNER JOIN OrderDetails OD ON P.ProductID = OD.ProductID
) AS Subquery
GROUP BY CategoryName;

--

--These examples involve operations like partitioning, 
--running totals, complex joins, percentiles, and cross-tabulations and can be applied to large datasets. 
--Remember to optimize query performance through proper indexing and database tuning, 
--especially when working with very large datasets, to ensure efficient execution.

SELECT ProductName, 
    SUM(CASE WHEN Region = 'North' THEN Quantity ELSE 0 END) AS North,
    SUM(CASE WHEN Region = 'South' THEN Quantity ELSE 0 END) AS South
FROM HugeSalesData
GROUP BY ProductName;


--

SELECT Year, PERCENTILE_CONT(0.5) 
  WITHIN GROUP (ORDER BY MonthlySales) AS MedianSales
FROM LargeSalesData

--

SELECT 
  Customers.CustomerName, Orders.OrderDate
FROM 
  Customers
INNER JOIN 
  Orders ON Customers.CustomerID = Orders.CustomerID
WHERE 
  Orders.OrderDate >= '2023-01-01'
AND 
  Orders.OrderDate <= '2023-12-31'

__

-- Problem: You want to calculate percentiles over a large dataset.
-- Solution: Use window functions like PERCENTILE_CONT()
  
SELECT 
  Year, PERCENTILE_CONT(0.5) 
WITHIN 
  GROUP (ORDER BY MonthlySales) AS MedianSales
FROM 
  LargeSalesData
GROUP BY 
  Year;

--

-- Problem: You have a large dataset, and you want to compute aggregates over partitions to optimize performance.
-- Solution: Use the PARTITION BY clause with aggregate functions.

SELECT 
  Department, AVG(Salary) OVER (PARTITION BY Department) AS AvgSalary
FROM 
  EmployeeSalaries;

