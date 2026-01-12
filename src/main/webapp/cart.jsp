<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart - SmartBuy</title>
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
        .cart-item {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 15px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        .cart-item-info {
            flex-grow: 1;
        }
        .cart-item-actions {
            display: flex;
            align-items: center;
            gap: 10px;
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
        .btn-danger {
            background-color: #f44336;
        }
        .btn-danger:hover {
            background-color: #da190b;
        }
        .btn-secondary {
            background-color: #2196F3;
        }
        .btn-secondary:hover {
            background-color: #0b7dda;
        }
        .btn-checkout {
            background-color: #FF9800;
        }
        .btn-checkout:hover {
            background-color: #F57C00;
        }
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .quantity-input {
            width: 50px;
            text-align: center;
            padding: 5px;
        }
        .summary {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 20px;
            margin-top: 20px;
        }
        .empty-cart {
            text-align: center;
            padding: 40px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .message {
            color: green;
            text-align: center;
            margin: 20px 0;
            padding: 10px;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 4px;
        }
        .error-message {
            color: red;
            text-align: center;
            margin: 20px 0;
            padding: 10px;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
        }
        .logout-link {
            float: right;
        }
        /* The hidden form is used for shopping cart operations. */
        .cart-action-form {
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - Shopping Cart</h1>
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
        <h2>Your Shopping Cart</h2>
        
        <!-- Display message -->
        <c:if test="${not empty param.message}">
            <div class="message">${param.message}</div>
        </c:if>
        
        <c:if test="${not empty param.errorMessage}">
            <div class="error-message">${param.errorMessage}</div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty cartItems or cartItems.size() == 0}">
                <div class="empty-cart">
                    <h3>Your cart is empty</h3>
                    <p><a href="home" class="btn btn-secondary">Continue Shopping</a></p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="cart-items">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="cart-item">
                            <div class="cart-item-info">
                                <h3>${item.productName}</h3>
                                <p>Brand: ${item.brand}</p>
                                <p>Price: ¥${item.price}</p>
                                <p>Subtotal: ¥${item.subtotal}</p>
                            </div>
                            
                            <div class="cart-item-actions">
                                <div class="quantity-control">
                                    <form class="cart-action-form" method="post" action="cart">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="cartId" value="${item.cartId}">
                                        <input type="hidden" name="quantity" value="${item.quantity-1}">
                                        <button type="submit" class="btn btn-secondary">-</button>
                                    </form>
                                    <input type="text" class="quantity-input" value="${item.quantity}" readonly>
                                    <form class="cart-action-form" method="post" action="cart">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="cartId" value="${item.cartId}">
                                        <input type="hidden" name="quantity" value="${item.quantity+1}">
                                        <button type="submit" class="btn btn-secondary">+</button>
                                    </form>
                                </div>
                                
                                <a href="checkout?cartId=${item.cartId}" class="btn btn-checkout">Checkout This Item</a>
                                
                                <form class="cart-action-form" method="post" action="cart">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="cartId" value="${item.cartId}">
                                    <button type="submit" class="btn btn-danger">Remove</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <div class="summary">
                    <h3>Order Summary</h3>
                    <p>Total Items: <span id="itemCount"><c:out value="${cartItems.size()}"/></span></p>
                    <p>Subtotal: ¥<span id="subtotal">
                        <c:set var="total" value="0"/>
                        <c:forEach var="item" items="${cartItems}">
                            <c:set var="total" value="${total + item.subtotal}"/>
                        </c:forEach>
                        <fmt:formatNumber value="${total}" pattern="#.##"/>
                    </span></p>
                    <p>Total: ¥<span id="total">
                        <fmt:formatNumber value="${total}" pattern="#.##"/>
                    </span></p>
                    
                    <div style="margin-top: 20px;">
                        <form class="cart-action-form" method="post" action="cart">
                            <input type="hidden" name="action" value="clear">
                            <button type="submit" class="btn btn-danger">Clear Cart</button>
                        </form>
                        <a href="checkout" class="btn">Checkout All Items</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        // If the URL contains message parameters, the parameters will be automatically cleared after 2 seconds (keeping them on the current page).
        if (window.location.search.includes('message') || window.location.search.includes('errorMessage')) {
            setTimeout(function() {
                // Use `replaceState` to clear URL parameters without triggering a page reload.
                const cleanUrl = window.location.pathname;
                window.history.replaceState({}, document.title, cleanUrl);
            }, 2000); // Clear URL parameters in 2 seconds
        }
        
        //Add processing logic to the shopping cart operation form
        document.querySelectorAll('.cart-action-form').forEach(form => {
            form.addEventListener('submit', function(e) {
                // Allow the form to submit normally without preventing default submission.
                // This ensures that the functionality will work properly even if JavaScript is disabled.
            });
        });
    </script>
</body>
</html>
