<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order History - SmartBuy</title>
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
            max-width: 1200px;
            margin: 0 auto;
        }
        .order-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 15px;
            margin-bottom: 15px;
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        .order-items {
            margin: 15px 0;
        }
        .order-item {
            display: flex;
            justify-content: space-between;
            padding: 5px 0;
            border-bottom: 1px dashed #eee;
        }
        .order-summary {
            background-color: #f9f9f9;
            padding: 10px;
            border-radius: 4px;
            margin-top: 10px;
        }
        .btn {
            background-color: #2196F3;
            color: white;
            padding: 10px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
            border: none;
            border-radius: 4px;
        }
        .btn:hover {
            background-color: #1976D2;
        }
        .status-pending { color: #ff9800; }
        .status-paid { color: #4CAF50; }
        .status-shipped { color: #2196F3; }
        .status-completed { color: #8BC34A; }
        .status-cancelled { color: #f44336; }
        .empty-orders {
            text-align: center;
            padding: 40px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .logout-link {
            float: right;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - Order History</h1>
    </div>
    
    <div class="nav">
        <a href="home">Home</a>
        <a href="products">Products</a>
        <a href="cart">Cart</a>
        <a href="order-history">Order History</a>
        <a href="profile">My Profile</a>
        <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.admin}">
            <a href="admin/dashboard">Admin Dashboard</a>
        </c:if>
        <a href="logout" class="logout-link">Logout</a>
    </div>
    
    <div class="container">
        <h2>Your Order History</h2>
        
        <c:choose>
            <c:when test="${empty orders or orders.size() == 0}">
                <div class="empty-orders">
                    <h3>You haven't placed any orders yet</h3>
                    <p><a href="home" class="btn">Start Shopping</a></p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="order" items="${orders}">
                    <div class="order-card">
                        <div class="order-header">
                            <div>
                                <h3>Order #${order.orderId}</h3>
                                <p>Date: 
                                    <c:choose>
                                        <c:when test="${not empty order.orderDate}">
                                            ${order.orderDate.toString().substring(0, 19).replace('T', ' ')}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div>
                                <p class="status-${order.status.toLowerCase()}">Status: ${order.status}</p>
                                <p>Total: ¥${order.totalAmount}</p>
                            </div>
                        </div>
                        
                        <div class="order-items">
                            <h4>Items:</h4>
                            <c:forEach var="item" items="${order.orderItems}">
                                <div class="order-item">
                                    <span>${item.productName} (x${item.quantity})</span>
                                    <span>¥${item.unitPrice} × ${item.quantity} = ¥${item.subtotal}</span>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div class="order-summary">
                            <p><strong>Shipping Address:</strong> ${order.shippingAddress}</p>
                            <p><strong>Payment Method:</strong> ${order.paymentMethod}</p>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
