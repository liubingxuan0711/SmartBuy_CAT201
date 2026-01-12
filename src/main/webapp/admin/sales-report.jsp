<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sales Report - SmartBuy Admin</title>
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
            max-width: 1400px;
            margin: 0 auto;
        }
        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 20px;
            text-align: center;
        }
        .stat-card h3 {
            margin: 0 0 10px 0;
            color: #666;
            font-size: 16px;
        }
        .stat-card .number {
            font-size: 36px;
            font-weight: bold;
            color: #4CAF50;
        }
        .report-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 20px;
        }
        .report-section h2 {
            margin-top: 0;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f9f9f9;
        }
        .bar-chart {
            margin-top: 20px;
        }
        .bar-item {
            margin-bottom: 15px;
        }
        .bar-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .bar {
            height: 30px;
            background-color: #2196F3;
            border-radius: 4px;
            position: relative;
            transition: width 0.3s ease;
        }
        .bar-value {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: white;
            font-weight: bold;
        }
        .logout-link {
            float: right;
        }
        .status-pending { color: #ffc107; font-weight: bold; }
        .status-paid { color: #17a2b8; font-weight: bold; }
        .status-shipped { color: #007bff; font-weight: bold; }
        .status-completed { color: #28a745; font-weight: bold; }
        .status-cancelled { color: #dc3545; font-weight: bold; }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - Sales Report</h1>
    </div>
    
    <div class="nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/orders">Manage Orders</a>
        <a href="${pageContext.request.contextPath}/admin/users">Manage Users</a>
        <a href="${pageContext.request.contextPath}/admin/sales-report">Sales Report</a>
        <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
    </div>
    
    <div class="container">
        <h1>Sales & Revenue Report</h1>
        
        <!-- Overall Statistics -->
        <div class="stats-overview">
            <div class="stat-card">
                <h3>Total Revenue</h3>
                <div class="number">¥<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></div>
            </div>
            <div class="stat-card">
                <h3>Total Orders</h3>
                <div class="number">${totalOrders}</div>
            </div>
            <div class="stat-card">
                <h3>Average Order Value</h3>
                <div class="number">
                    ¥<fmt:formatNumber value="${totalOrders > 0 ? totalRevenue / totalOrders : 0}" pattern="#,##0.00"/>
                </div>
            </div>
        </div>
        
        <!-- Statistics by Category -->
        <div class="report-section">
            <h2>Sales by Category</h2>
            <table>
                <thead>
                    <tr>
                        <th>Category</th>
                        <th>Total Revenue</th>
                        <th>Order Count</th>
                        <th>Average Order Value</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="entry" items="${salesByCategory}">
                        <tr>
                            <td>${entry.key}</td>
                            <td>¥<fmt:formatNumber value="${entry.value}" pattern="#,##0.00"/></td>
                            <td>${ordersByCategory[entry.key]}</td>
                            <td>¥<fmt:formatNumber value="${entry.value / ordersByCategory[entry.key]}" pattern="#,##0.00"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <div class="bar-chart">
                <h3>Revenue Distribution</h3>
                <c:set var="maxRevenue" value="0"/>
                <c:forEach var="entry" items="${salesByCategory}">
                    <c:if test="${entry.value > maxRevenue}">
                        <c:set var="maxRevenue" value="${entry.value}"/>
                    </c:if>
                </c:forEach>
                
                <c:forEach var="entry" items="${salesByCategory}">
                    <div class="bar-item">
                        <div class="bar-label">
                            <span>${entry.key}</span>
                            <span>¥<fmt:formatNumber value="${entry.value}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="bar" style="width: ${(entry.value / maxRevenue) * 100}%">
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        
        <!-- Statistics by date (last 30 days) -->
        <div class="report-section">
            <h2>Sales by Date (Last 30 Days)</h2>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Revenue</th>
                        <th>Orders</th>
                        <th>Average Order Value</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="entry" items="${salesByDate}">
                        <tr>
                            <td>${entry.key}</td>
                            <td>¥<fmt:formatNumber value="${entry.value}" pattern="#,##0.00"/></td>
                            <td>${ordersByDate[entry.key]}</td>
                            <td>¥<fmt:formatNumber value="${entry.value / ordersByDate[entry.key]}" pattern="#,##0.00"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <!-- Statistics by order status -->
        <div class="report-section">
            <h2>Orders by Status</h2>
            <table>
                <thead>
                    <tr>
                        <th>Status</th>
                        <th>Count</th>
                        <th>Percentage</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="entry" items="${ordersByStatus}">
                        <tr>
                            <td>
                                <span class="status-${entry.key.toLowerCase()}">${entry.key}</span>
                            </td>
                            <td>${entry.value}</td>
                            <td>
                                <fmt:formatNumber value="${(entry.value * 100.0) / totalOrders}" pattern="#0.0"/>%
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
