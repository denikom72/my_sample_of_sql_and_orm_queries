//AvgOrderQuantity.hql
SELECT c.categoryName, AVG(od.quantity) AS avgOrderQuantity, SUM(od.unitPrice * od.quantity) AS customerTotalSales
FROM Order o
JOIN o.customer c
JOIN o.orderDetails od
JOIN od.product p
GROUP BY c.categoryName, c.customerName

//AvgOrderQuantityByCategory.hql
SELECT p.categoryName, AVG(od.quantity) AS avgOrderQuantity
FROM Product p
JOIN p.orderDetails od
GROUP BY p.categoryName

//RegionalSalesSums
SELECT h.productName,
       SUM(CASE WHEN h.region = 'North' THEN h.quantity ELSE 0 END) AS North,
       SUM(CASE WHEN h.region = 'South' THEN h.quantity ELSE 0 END) AS South
FROM HugeSalesData h
GROUP BY h.productName

//MedianSales
SELECT h.year, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY h.monthlySales) AS medianSales
FROM LargeSalesData h
GROUP BY h.year

//CustomerOrders
SELECT c.customerName, o.orderDate
FROM Customer c
JOIN c.orders o
WHERE o.orderDate >= '2023-01-01' AND o.orderDate <= '2023-12-31'

//MedianSalesByYear
SELECT h.year, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY h.monthlySales) AS medianSales
FROM LargeSalesData h
GROUP BY h.year

//
SELECT e.department, AVG(e.salary) AS avgSalary
FROM EmployeeSalaries e
GROUP BY e.department

//
SELECT h.region, e.employeeName, SUM(h.totalSales) AS employeeRegionSales
FROM (
    SELECT c.region, e.employeeName, o.orderId, SUM(od.unitPrice * od.quantity) AS totalSales
    FROM Customer c
    JOIN c.orders o
    JOIN Employee e
    ON o.employeeId = e.employeeId
    JOIN OrderDetail od
    ON o.orderId = od.orderId
    GROUP BY c.region, e.employeeName, o.orderId
) h
GROUP BY h.region, h.employeeName

//
WITH HighValueCustomers AS (
    SELECT c.customerId
    FROM Customer c
    WHERE c.totalPurchases > 10000
),
CategoryTotalSales AS (
    SELECT cat.categoryName, SUM(s.unitPrice * s.quantity) AS totalSales
    FROM Sale s
    JOIN Product p
    ON s.productId = p.productId
    JOIN Category cat
    ON p.categoryId = cat.categoryId
    WHERE s.orderDate BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY cat.categoryName
)
SELECT cat.categoryName, c.customerName, cts.totalSales
FROM CategoryTotalSales cts
JOIN HighValueCustomers hvc
ON cts.customerId = hvc.customerId
JOIN Customer c
ON hvc.customerId = c.customerId

/*
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

public class HibernateHQLExample {
    public static void main(String[] args) {
        SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
        Session session = sessionFactory.openSession();

        executeHQLQuery("AvgOrderQuantity.hql", session);
        executeHQLQuery("AvgOrderQuantityByCategory.hql", session);
        executeHQLQuery("RegionalSalesSums.hql", session);
        executeHQLQuery("MedianSales.hql", session);
        executeHQLQuery("CustomerOrders.hql", session);
        executeHQLQuery("MedianSalesByYear.hql", session);
        executeHQLQuery("AvgSalaryByDepartment.hql", session);
        executeHQLQuery("EmployeeRegionSales.hql", session);
        executeHQLQuery("HighValueCustomerCategoryTotalSales.hql", session);

        session.close();
        sessionFactory.close();
    }

    private static void executeHQLQuery(String hqlFileName, Session session) {
        session.beginTransaction();

        try {
            String hql = loadHQLFile(hqlFileName);

            Query query = session.createQuery(hql);
            query.getResultList().forEach(System.out::println);
        } catch (Exception e) {
            e.printStackTrace();
        }

        session.getTransaction().commit();
    }

    private static String loadHQLFile(String fileName) throws IOException {
        try (InputStream is = HibernateHQLExample.class.getClassLoader().getResourceAsStream(fileName)) {
            if (is != null) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(is));
                return reader.lines().collect(Collectors.joining("\n"));
            } else {
                throw new FileNotFoundException("HQL file not found: " + fileName);
            }
        }
    }
}
*/

  
