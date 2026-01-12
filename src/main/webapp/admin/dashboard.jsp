<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - SmartBuy</title>
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
        .admin-panel {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .stat-card {
            background: #f9f9f9;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #4CAF50;
        }
        .stat-label {
            font-size: 16px;
            color: #666;
            margin-top: 10px;
        }
        .product-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .product-table th, .product-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .product-table th {
            background-color: #f2f2f2;
        }
        .btn {
            background-color: #2196F3;
            color: white;
            padding: 10px 15px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            margin: 4px 2px;
            cursor: pointer;
            border: none;
            border-radius: 4px;
        }
        .btn:hover {
            background-color: #1976D2;
        }
        .btn-edit {
            background-color: #2196F3;
        }
        .btn-edit:hover {
            background-color: #0b7dda;
        }
        .btn-delete {
            background-color: #f44336;
        }
        .btn-delete:hover {
            background-color: #da190b;
        }
        .btn-add {
            background-color: #FF9800;
        }
        .btn-add:hover {
            background-color: #e68a00;
        }
        .available-yes { color: #4CAF50; }
        .available-no { color: #f44336; }
        .logout-link {
            float: right;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - Admin Dashboard</h1>
    </div>
    
    <div class="nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/orders">Manage Orders</a>
        <a href="${pageContext.request.contextPath}/admin/users">Manage Users</a>
        <a href="${pageContext.request.contextPath}/admin/sales-report">Sales Report</a>
        <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
    </div>
    
    <div class="container">
        <div class="admin-panel">
            <h2>Administrator Dashboard</h2>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">0</div>
                    <div class="stat-label">Total Orders</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">0</div>
                    <div class="stat-label">Total Revenue</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${products.size()}</div>
                    <div class="stat-label">Total Products</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">0</div>
                    <div class="stat-label">Customers</div>
                </div>
            </div>
            
            <h3>Manage Products</h3>
            <c:if test="${not empty param.message}">
                <div style="padding: 10px; margin: 10px 0; background-color: #d4edda; color: #155724; border-radius: 4px;">
                    ${param.message}
                </div>
            </c:if>
            <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn btn-add">Add New Product</a>
            
            <table class="product-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Brand</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <td>${product.productId}</td>
                            <td>${product.productName}</td>
                            <td>${product.brand}</td>
                            <td>¥${product.price}</td>
                            <td>${product.stock}</td>
                            <td>${product.categoryName}</td>
                            <td>
                                <form style="display: inline;" method="post" action="${pageContext.request.contextPath}/admin/products">
                                    <input type="hidden" name="action" value="toggleStatus">
                                    <input type="hidden" name="productId" value="${product.productId}">
                                    <select name="isAvailable" onchange="this.form.submit()" style="padding: 5px; border: 1px solid #ddd; border-radius: 4px;">
                                        <option value="true" ${product.available ? 'selected' : ''}>Available</option>
                                        <option value="false" ${!product.available ? 'selected' : ''}>Unavailable</option>
                                    </select>
                                </form>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${product.productId}" class="btn btn-edit">Edit</a>
                                <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${product.productId}" 
                                   class="btn btn-delete" 
                                   onclick="return confirm('Are you sure you want to delete this product?');">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
