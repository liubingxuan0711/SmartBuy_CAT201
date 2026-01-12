<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Management - SmartBuy Admin</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .header {
            background-color: #333;
            color: white;
            padding: 15px;
            text-align: center;
        }
        .nav {
            background-color: #2196F3;
            overflow: hidden;
        }
        .nav a {
            float: left;
            display: block;
            color: white;
            text-align: center;
            padding: 14px 20px;
            text-decoration: none;
        }
        .nav a:hover {
            background-color: #1976D2;
        }
        .container {
            padding: 20px;
        }
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #2196F3;
            color: white;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .status-form {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .status-form select {
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .btn {
            background-color: #2196F3;
            color: white;
            padding: 6px 12px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            cursor: pointer;
            border: none;
            border-radius: 4px;
            margin: 2px;
        }
        .btn:hover {
            background-color: #1976D2;
        }
        .btn-view {
            background-color: #9C27B0;
        }
        .btn-view:hover {
            background-color: #7B1FA2;
        }
        .status-pending { color: #ffc107; }
        .status-paid { color: #17a2b8; }
        .status-shipped { color: #007bff; }
        .status-completed { color: #28a745; }
        .status-cancelled { color: #dc3545; }
        .logout-link {
            float: right;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - Order Management</h1>
    </div>
    
    <div class="nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/orders">Manage Orders</a>
        <a href="${pageContext.request.contextPath}/admin/users">Manage Users</a>
        <a href="${pageContext.request.contextPath}/admin/sales-report">Sales Report</a>
        <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
    </div>
    
    <div class="container">
        <h2>All Orders</h2>
        
        <c:if test="${not empty param.message}">
            <div class="message">${param.message}</div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty orders}">
                <p>No orders found.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>User ID</th>
                            <th>Order Date</th>
                            <th>Total Amount</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td>${order.orderId}</td>
                                <td>${order.userId}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty order.orderDate}">
                                            ${order.orderDate.toString().substring(0, 19).replace('T', ' ')}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                <td>
                                    <span class="status-${order.status.toLowerCase()}">${order.status}</span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/order-detail?orderId=${order.orderId}" class="btn btn-view">View Details</a>
                                    <form class="status-form" method="post" action="${pageContext.request.contextPath}/admin/orders" style="display: inline-block;">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <select name="status">
                                            <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                            <option value="Paid" ${order.status == 'Paid' ? 'selected' : ''}>Paid</option>
                                            <option value="Shipped" ${order.status == 'Shipped' ? 'selected' : ''}>Shipped</option>
                                            <option value="Completed" ${order.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                            <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                        <button type="submit" class="btn">Update</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
