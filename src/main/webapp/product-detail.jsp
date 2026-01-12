<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${product.productName} - SmartBuy</title>
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
        .product-detail {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 30px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
        }
        .product-image {
            text-align: center;
        }
        .product-image img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .product-info h1 {
            margin-top: 0;
            color: #333;
        }
        .product-brand {
            color: #666;
            font-size: 18px;
            margin-bottom: 10px;
        }
        .product-price {
            font-size: 32px;
            color: #2196F3;
            font-weight: bold;
            margin: 20px 0;
        }
        .product-stock {
            font-size: 16px;
            margin-bottom: 20px;
        }
        .stock-available {
            color: #4CAF50;
        }
        .stock-low {
            color: #ff9800;
        }
        .stock-out {
            color: #f44336;
        }
        .product-description {
            line-height: 1.6;
            color: #555;
            margin: 20px 0;
        }
        .product-specs {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .product-specs h3 {
            margin-top: 0;
            color: #333;
        }
        .product-specs p {
            line-height: 1.8;
            color: #555;
            white-space: pre-line;
        }
        .add-to-cart-section {
            margin-top: 30px;
        }
        .quantity-selector {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        .quantity-selector label {
            font-weight: bold;
        }
        .quantity-selector input {
            width: 80px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        .btn {
            background-color: #2196F3;
            color: white;
            padding: 12px 30px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            cursor: pointer;
            border: none;
            border-radius: 4px;
        }
        .btn:hover {
            background-color: #1976D2;
        }
        .btn-secondary {
            background-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        .btn:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #2196F3;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .logout-link {
            float: right;
        }
        @media (max-width: 768px) {
            .product-detail {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - Product Details</h1>
    </div>
    
    <div class="nav">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/products">Products</a>
        <a href="${pageContext.request.contextPath}/cart">Cart</a>
        <a href="${pageContext.request.contextPath}/order-history">Order History</a>
        <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.admin}">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
        </c:if>
        <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
    </div>
    
    <div class="container">
        <a href="${pageContext.request.contextPath}/products" class="back-link">← Back to Products</a>
        
        <div class="product-detail">
            <div class="product-image">
                <c:choose>
                    <c:when test="${not empty product.imageUrl}">
                        <img src="${pageContext.request.contextPath}/${product.imageUrl}" alt="${product.productName}">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/images/default_product.jpg" 
                             alt="No image available"
                             style="width: 300px; height: 300px; object-fit: cover; background-color: #f0f0f0;">
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="product-info">
                <h1>${product.productName}</h1>
                
                <div class="product-brand">
                    <strong>Brand:</strong> ${product.brand}
                </div>
                
                <div class="product-brand">
                    <strong>Category:</strong> ${product.categoryName}
                </div>
                
                <div class="product-price">
                    ¥${product.price}
                </div>
                
                <div class="product-stock">
                    <strong>Stock:</strong> 
                    <c:choose>
                        <c:when test="${product.stock > 10}">
                            <span class="stock-available">${product.stock} units available</span>
                        </c:when>
                        <c:when test="${product.stock > 0}">
                            <span class="stock-low">Only ${product.stock} units left!</span>
                        </c:when>
                        <c:otherwise>
                            <span class="stock-out">Out of stock</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="product-description">
                    <h3>Description</h3>
                    <p>${product.description}</p>
                </div>
                
                <c:if test="${not empty product.specs}">
                    <div class="product-specs">
                        <h3>Technical Specifications</h3>
                        <p>${product.specs}</p>
                    </div>
                </c:if>
                
                <c:if test="${product.stock > 0 && product.available}">
                    <div class="add-to-cart-section">
                        <form method="post" action="${pageContext.request.contextPath}/cart">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.productId}">
                            
                            <div class="quantity-selector">
                                <label for="quantity">Quantity:</label>
                                <input type="number" id="quantity" name="quantity" 
                                       value="1" min="1" max="${product.stock}" required>
                            </div>
                            
                            <button type="submit" class="btn">Add to Cart</button>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">Continue Shopping</a>
                        </form>
                    </div>
                </c:if>
                
                <c:if test="${product.stock == 0 || !product.available}">
                    <div class="add-to-cart-section">
                        <button class="btn" disabled>Out of Stock</button>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">Back to Products</a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>
