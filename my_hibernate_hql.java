import org.hibernate.Session;
import org.hibernate.query.Query;
import your.package.model.Orders;
import your.package.model.Customers;
import your.package.model.OrderDetails;
import your.package.model.Products;

public List<Object[]> getCustomerCategorySales() {
    Session session = sessionFactory.getCurrentSession();

    String hql = "SELECT P.categoryName, C.customerName, " +
                 "AVG(OD.quantity) AS AvgOrderQuantity, " +
                 "SUM(OD.unitPrice * OD.quantity) AS CustomerTotalSales " +
                 "FROM Orders O " +
                 "JOIN O.customer C " +
                 "JOIN O.orderDetails OD " +
                 "JOIN OD.product P " +
                 "GROUP BY P.categoryName, C.customerName";

    Query<Object[]> query = session.createQuery(hql, Object[].class);

    return query.getResultList();
}


//



