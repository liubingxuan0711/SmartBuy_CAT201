<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - SmartBuy</title>
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
            max-width: 1000px;
            margin: 0 auto;
        }
        .checkout-container {
            display: flex;
            gap: 20px;
            margin-top: 20px;
        }
        .checkout-form {
            flex: 1;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .order-summary {
            width: 300px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
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
            width: 100%;
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
        .cart-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .summary-total {
            font-weight: bold;
            font-size: 18px;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #eee;
        }
        .logout-link {
            float: right;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - Checkout</h1>
    </div>
    
    <div class="nav">
        <a href="home">Home</a>
        <a href="products.jsp">Products</a>
        <a href="cart.jsp">Cart</a>
        <a href="checkout.jsp">Checkout</a>
        <a href="logout" class="logout-link">Logout</a>
    </div>
    
    <div class="container">
        <h2>Checkout</h2>
        
        <div class="checkout-container">
            <div class="checkout-form">
                <h3>Shipping Information</h3>
                <c:if test="${singleCheckout}">
                    <p style="color: #FF9800; font-weight: bold;">Checking out single item</p>
                </c:if>
                <form action="checkout" method="post">
                    <input type="hidden" name="action" value="placeOrder">
                    <c:if test="${not empty checkoutCartId}">
                        <input type="hidden" name="cartId" value="${checkoutCartId}">
                    </c:if>
                    
                    <div class="form-group">
                        <label for="fullName">Full Name:</label>
                        <input type="text" id="fullName" name="fullName" value="${userFullName}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" value="${userEmail}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number:</label>
                        <input type="tel" id="phone" name="phone" value="${userPhone}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Shipping Address:</label>
                        <textarea id="address" name="address" rows="4" required>${userAddress}</textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="city">City:</label>
                        <input type="text" id="city" name="city" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="zipCode">ZIP Code:</label>
                        <input type="text" id="zipCode" name="zipCode" required>
                    </div>
                    
                    <h3>Payment Method</h3>
                    <div class="form-group">
                        <select name="paymentMethod" required>
                            <option value="">Select Payment Method</option>
                            <option value="Credit Card">Credit Card</option>
                            <option value="Debit Card">Debit Card</option>
                            <option value="PayPal">PayPal</option>
                            <option value="Bank Transfer">Bank Transfer</option>
                        </select>
                    </div>
                    
                    <input type="submit" value="Place Order" class="btn">
                    <a href="cart" class="btn btn-back">Back to Cart</a>
                </form>
            </div>
            
            <div class="order-summary">
                <h3>Order Summary</h3>
                
                <c:choose>
                    <c:when test="${empty cartItems or cartItems.size() == 0}">
                        <p>Your cart is empty</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${cartItems}">
                            <div class="cart-item">
                                <span>${item.productName} (x${item.quantity})</span>
                                <span>¥${item.subtotal}</span>
                            </div>
                        </c:forEach>
                        
                        <div class="summary-total">
                            Total: ¥
                            <c:set var="total" value="0"/>
                            <c:forEach var="item" items="${cartItems}">
                                <c:set var="total" value="${total + item.subtotal}"/>
                            </c:forEach>
                            <fmt:formatNumber value="${total}" pattern="#.##"/>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>
