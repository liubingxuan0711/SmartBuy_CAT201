<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation - SmartBuy</title>
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
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }
        .confirmation-box {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 40px;
            margin: 20px 0;
        }
        .success-icon {
            font-size: 64px;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        .btn {
            background-color: #2196F3;
            color: white;
            padding: 12px 20px;
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
        .btn-secondary {
            background-color: #2196F3;
        }
        .btn-secondary:hover {
            background-color: #0b7dda;
        }
        .order-details {
            text-align: left;
            margin: 20px auto;
            max-width: 500px;
            background: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 5px;
            border-bottom: 1px solid #eee;
        }
        .logout-link {
            float: right;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - Order Confirmation</h1>
    </div>
    
    <div class="nav">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/products">Products</a>
        <a href="${pageContext.request.contextPath}/cart">Cart</a>
        <a href="${pageContext.request.contextPath}/order-history">Order History</a>
        <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
    </div>
    
    <div class="container">
        <div class="confirmation-box">
            <div class="success-icon">✓</div>
            <h2>Thank You for Your Order!</h2>
            <p>Your order has been placed successfully.</p>
            <p>Order ID: <strong>#${orderId}</strong></p>
            <p>We will send you an email confirmation shortly.</p>
            
            <div class="order-details">
                <h3>Order Details</h3>
                <div class="detail-row">
                    <span>Order Date:</span>
                    <span>${orderDate}</span>
                </div>
                <div class="detail-row">
                    <span>Total Amount:</span>
                    <span>¥${totalAmount}</span>
                </div>
                <div class="detail-row">
                    <span>Shipping Address:</span>
                    <span>${shippingAddress}</span>
                </div>
                <div class="detail-row">
                    <span>Payment Method:</span>
                    <span>${paymentMethod}</span>
                </div>
                <div class="detail-row">
                    <span>Status:</span>
                    <span>Pending</span>
                </div>
            </div>
            
            <a href="${pageContext.request.contextPath}/order-history" class="btn">View Order History</a>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Continue Shopping</a>
        </div>
    </div>
</body>
</html>
