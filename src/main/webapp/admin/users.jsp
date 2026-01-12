<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Management - SmartBuy Admin</title>
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
        .stats {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .stat-item {
            text-align: center;
        }
        .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #4CAF50;
        }
        .stat-label {
            color: #666;
            margin-top: 5px;
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
        .role-admin {
            background-color: #f44336;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
        }
        .role-customer {
            background-color: #2196F3;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
        }
        .logout-link {
            float: right;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - User Management</h1>
    </div>
    
    <div class="nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/orders">Manage Orders</a>
        <a href="${pageContext.request.contextPath}/admin/users">Manage Users</a>
        <a href="${pageContext.request.contextPath}/admin/sales-report">Sales Report</a>
        <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
    </div>
    
    <div class="container">
        <h2>All Users</h2>
        
        <div class="stats">
            <div class="stat-item">
                <div class="stat-number">${users.size()}</div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">
                    <c:set var="adminCount" value="0"/>
                    <c:forEach var="user" items="${users}">
                        <c:if test="${user.admin}">
                            <c:set var="adminCount" value="${adminCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${adminCount}
                </div>
                <div class="stat-label">Administrators</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">${users.size() - adminCount}</div>
                <div class="stat-label">Customers</div>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${empty users}">
                <p>No users found.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Username</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Address</th>
                            <th>Role</th>
                            <th>Created At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>${user.userId}</td>
                                <td>${user.username}</td>
                                <td>${user.fullName}</td>
                                <td>${user.email}</td>
                                <td>${user.phone}</td>
                                <td>${user.address}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.admin}">
                                            <span class="role-admin">ADMIN</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="role-customer">CUSTOMER</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty user.createdAt}">
                                            ${user.createdAt.toString().substring(0, 16).replace('T', ' ')}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
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
