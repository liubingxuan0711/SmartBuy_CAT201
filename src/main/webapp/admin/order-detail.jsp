<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Details - SmartBuy Admin</title>
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
        .order-detail-box {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 20px;
        }
        .detail-header {
            border-bottom: 2px solid #2196F3;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        .detail-header h2 {
            margin: 0;
            color: #333;
        }
        .detail-section {
            margin-bottom: 30px;
        }
        .detail-section h3 {
            color: #2196F3;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }
        .info-item {
            display: flex;
            padding: 10px;
            background-color: #f9f9f9;
            border-radius: 4px;
        }
        .info-label {
            font-weight: bold;
            color: #555;
            min-width: 150px;
        }
        .info-value {
            color: #333;
            flex: 1;
        }
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        .items-table th, .items-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .items-table th {
            background-color: #2196F3;
            color: white;
        }
        .items-table tr:hover {
            background-color: #f5f5f5;
        }
        .total-section {
            text-align: right;
            margin-top: 20px;
            padding: 15px;
            background-color: #e3f2fd;
            border-radius: 4px;
        }
        .total-amount {
            font-size: 24px;
            font-weight: bold;
            color: #2196F3;
        }
        .btn {
            background-color: #2196F3;
            color: white;
            padding: 10px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            cursor: pointer;
            border: none;
            border-radius: 4px;
            margin: 5px;
        }
        .btn:hover {
            background-color: #1976D2;
        }
        .btn-back {
            background-color: #6c757d;
        }
        .btn-back:hover {
            background-color: #5a6268;
        }
        .status-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
        }
        .status-pending { 
            background-color: #fff3cd; 
            color: #856404; 
        }
        .status-paid { 
            background-color: #d1ecf1; 
            color: #0c5460; 
        }
        .status-shipped { 
            background-color: #cce5ff; 
            color: #004085; 
        }
        .status-completed { 
            background-color: #d4edda; 
            color: #155724; 
        }
        .status-cancelled { 
            background-color: #f8d7da; 
            color: #721c24; 
        }
        .logout-link {
            float: right;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - Order Details</h1>
    </div>
    
    <div class="nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/orders">Manage Orders</a>
        <a href="${pageContext.request.contextPath}/admin/users">Manage Users</a>
        <a href="${pageContext.request.contextPath}/admin/sales-report">Sales Report</a>
        <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
    </div>
    
    <div class="container">
        <c:choose>
            <c:when test="${not empty order}">
                <div class="order-detail-box">
                    <div class="detail-header">
                        <h2>Order #${order.orderId}</h2>
                    </div>
                    
                    <!-- Basic order information -->
                    <div class="detail-section">
                        <h3>Order Information</h3>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="info-label">Order ID:</span>
                                <span class="info-value">${order.orderId}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">User ID:</span>
                                <span class="info-value">${order.userId}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Order Date:</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty order.orderDate}">
                                            ${order.orderDate.toString().substring(0, 19).replace('T', ' ')}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Status:</span>
                                <span class="info-value">
                                    <span class="status-badge status-${order.status.toLowerCase()}">${order.status}</span>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Payment Method:</span>
                                <span class="info-value">${order.paymentMethod}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Total Amount:</span>
                                <span class="info-value" style="font-weight: bold; color: #2196F3; font-size: 18px;">
                                    ¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Shipping address -->
                    <div class="detail-section">
                        <h3>Shipping Address</h3>
                        <div class="info-item">
                            <span class="info-value">${order.shippingAddress}</span>
                        </div>
                    </div>
                    
                    <!-- Order details -->
                    <div class="detail-section">
                        <h3>Order Items</h3>
                        <c:choose>
                            <c:when test="${not empty order.orderItems}">
                                <table class="items-table">
                                    <thead>
                                        <tr>
                                            <th>Product ID</th>
                                            <th>Product Name</th>
                                            <th>Unit Price</th>
                                            <th>Quantity</th>
                                            <th>Subtotal</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${order.orderItems}">
                                            <tr>
                                                <td>${item.productId}</td>
                                                <td>${item.productName}</td>
                                                <td>¥<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                                                <td>${item.quantity}</td>
                                                <td>¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                
                                <div class="total-section">
                                    <span style="font-size: 18px; margin-right: 20px;">Total:</span>
                                    <span class="total-amount">¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p>No items found for this order.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Operation buttons -->
                    <div style="text-align: center; margin-top: 30px;">
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-back">Back to Orders</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="order-detail-box">
                    <h2>Order Not Found</h2>
                    <p>The requested order could not be found.</p>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-back">Back to Orders</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
