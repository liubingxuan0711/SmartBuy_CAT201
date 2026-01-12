<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products - SmartBuy</title>
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
        .search-filter-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .search-filter-section h3 {
            margin-top: 0;
        }
        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        .filter-group {
            display: flex;
            flex-direction: column;
        }
        .filter-group label {
            font-weight: bold;
            margin-bottom: 5px;
        }
        .filter-group input,
        .filter-group select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .filter-buttons {
            display: flex;
            gap: 10px;
        }
        .btn-search {
            background-color: #2196F3;
        }
        .btn-reset {
            background-color: #6c757d;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .product-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 15px;
            text-align: center;
        }
        .product-image {
            width: 100%;
            height: 150px;
            background-color: #eee;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
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
        .btn-cart {
            background-color: #FF9800;
        }
        .btn-cart:hover {
            background-color: #F57C00;
        }
        .btn-detail {
            background-color: #9C27B0;
        }
        .btn-detail:hover {
            background-color: #7B1FA2;
        }
        .btn-buy-now {
            background-color: #4CAF50;
        }
        .btn-buy-now:hover {
            background-color: #45a049;
        }
        .btn-reset {
            background-color: #757575;
        }
        .btn-reset:hover {
            background-color: #616161;
        }
        .price {
            color: #f44336;
            font-weight: bold;
            font-size: 18px;
            margin: 10px 0;
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
        /* The hidden form is used to add items to the cart. */
        .add-to-cart-form {
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - Electronics Store</h1>
    </div>
    
    <div class="nav">
        <a href="home">Home</a>
        <a href="products">Products</a>
        <c:choose>
            <c:when test="${isLoggedIn}">
                <a href="cart">Cart</a>
                <a href="order-history">Order History</a>
                <a href="profile">My Profile</a>
                <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.admin}">
                    <a href="admin/dashboard">Admin Dashboard</a>
                </c:if>
                <a href="logout" class="logout-link">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/" class="logout-link">Login / Register</a>
            </c:otherwise>
        </c:choose>
    </div>
    
    <div class="container">
        <h2>Products</h2>
        
        <!-- Search and filter areas -->
        <div class="search-filter-section">
            <h3>Search & Filter</h3>
            <form method="get" action="products">
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="keyword">Keyword</label>
                        <input type="text" id="keyword" name="keyword" 
                               placeholder="Search by name or brand"
                               value="${currentKeyword}">
                    </div>
                    
                    <div class="filter-group">
                        <label for="categoryId">Category</label>
                        <select id="categoryId" name="categoryId">
                            <option value="">All Categories</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}" 
                                        ${currentCategoryId == category.categoryId ? 'selected' : ''}>
                                    ${category.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="brand">Brand</label>
                        <select id="brand" name="brand">
                            <option value="">All Brands</option>
                            <c:forEach var="brandName" items="${brands}">
                                <option value="${brandName}" 
                                        ${currentBrand == brandName ? 'selected' : ''}>
                                    ${brandName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="sortBy">Sort By</label>
                        <select id="sortBy" name="sortBy">
                            <option value="" ${currentSortBy == null ? 'selected' : ''}>Newest</option>
                            <option value="price_asc" ${currentSortBy == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                            <option value="price_desc" ${currentSortBy == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                            <option value="name" ${currentSortBy == 'name' ? 'selected' : ''}>Name: A-Z</option>
                        </select>
                    </div>
                </div>
                
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="minPrice">Min Price</label>
                        <input type="number" id="minPrice" name="minPrice" 
                               step="0.01" min="0" placeholder="0.00"
                               value="${currentMinPrice}">
                    </div>
                    
                    <div class="filter-group">
                        <label for="maxPrice">Max Price</label>
                        <input type="number" id="maxPrice" name="maxPrice" 
                               step="0.01" min="0" placeholder="9999.99"
                               value="${currentMaxPrice}">
                    </div>
                    
                    <div class="filter-group" style="justify-content: flex-end;">
                        <label>&nbsp;</label>
                        <div class="filter-buttons">
                            <button type="submit" class="btn btn-search">Search</button>
                            <a href="products" class="btn btn-reset">Reset</a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        
        <!-- Check the message in the URL parameters -->
        <!-- Display message -->
        <c:if test="${not empty param.message}">
            <div class="message">${param.message}</div>
        </c:if>
        
        <c:if test="${not empty param.errorMessage}">
            <div class="error-message">${param.errorMessage}</div>
        </c:if>
        
        <div class="product-grid">
            <c:forEach var="product" items="${products}">
                <div class="product-card">
                    <div class="product-image">
                        <c:choose>
                            <c:when test="${not empty product.imageUrl}">
                                <img src="${pageContext.request.contextPath}/${product.imageUrl}" 
                                     alt="${product.productName}" 
                                     style="width: 100%; height: 100%; object-fit: contain;">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/images/default_product.jpg" 
                                     alt="No Image" 
                                     style="width: 100%; height: 100%; object-fit: contain;">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <h3>${product.productName}</h3>
                    <p>${product.brand}</p>
                    <div class="price">¥${product.price}</div>
                    <p>Stock: ${product.stock}</p>
                    <a href="product-detail?id=${product.productId}" class="btn btn-detail">View Details</a>
                    <c:choose>
                        <c:when test="${isLoggedIn}">
                            <form class="add-to-cart-form" method="post" action="cart" style="display: inline-block; margin: 2px;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${product.productId}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-cart">Add to Cart</button>
                            </form>
                            <form class="buy-now-form" method="post" action="cart" style="display: inline-block; margin: 2px;">
                                <input type="hidden" name="action" value="buyNow">
                                <input type="hidden" name="productId" value="${product.productId}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-buy-now">Buy Now</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <button onclick="alert('Please login to add items to cart or purchase'); window.location.href='${pageContext.request.contextPath}/'" class="btn btn-cart">Add to Cart</button>
                            <button onclick="alert('Please login to purchase'); window.location.href='${pageContext.request.contextPath}/'" class="btn btn-buy-now">Buy Now</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:forEach>
        </div>
    </div>
    
    <script>
        // If the URL contains message parameters, the parameters will be automatically cleared after 2 seconds (keeping them on the current page).
        if (window.location.search.includes('message') || window.location.search.includes('errorMessage')) {
            setTimeout(function() {
                // Use `replaceState` to clear URL parameters without triggering a page reload.
                const cleanUrl = window.location.pathname + window.location.search.split('&').filter(param => 
                    !param.includes('message') && !param.includes('errorMessage')
                ).join('&').replace(/^&/, '?').replace(/^\?$/, '');
                window.history.replaceState({}, document.title, cleanUrl || window.location.pathname);
            }, 2000); // Clear message URL parameters after 2 seconds
        }
        
        // Add confirmation and processing logic to the Add to Cart form
        document.querySelectorAll('.add-to-cart-form').forEach(form => {
            form.addEventListener('submit', function(e) {
                // Allow the form to submit normally without preventing default submission.
                // This ensures that the functionality will work properly even if JavaScript is disabled.
            });
        });
    </script>
</body>
</html>
