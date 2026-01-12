<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - SmartBuy</title>
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
        .container {
            padding: 20px;
            max-width: 600px;
            margin: 50px auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
        }
        .error-icon {
            font-size: 48px;
            color: #f44336;
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
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - Error</h1>
    </div>
    
    <div class="container">
        <div class="error-icon">⚠️</div>
        <h2>An Error Occurred</h2>
        
        <c:choose>
            <c:when test="${not empty errorMessage}">
                <p><strong>Error:</strong> ${errorMessage}</p>
            </c:when>
            <c:otherwise>
                <p>An unexpected error occurred while processing your request.</p>
            </c:otherwise>
        </c:choose>
        
        <p>Please go back and try again, or contact support if the problem persists.</p>
        
        <a href="javascript:history.back()" class="btn">Go Back</a>
        <a href="index.jsp" class="btn">Return to Home</a>
    </div>
</body>
</html>
