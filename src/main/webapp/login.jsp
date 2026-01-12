<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - SmartBuy</title>
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
            max-width: 400px;
            margin: 50px auto;
            background: white;
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
        .form-group input {
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
        .message {
            color: green;
            text-align: center;
            margin: 20px 0;
        }
        .error-message {
            color: red;
            text-align: center;
            margin: 20px 0;
        }
        .back-link {
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - Login</h1>
    </div>
    
    <div class="nav">
        <a href="index.jsp">Home</a>
        <a href="login.jsp">Login</a>
        <a href="register.jsp">Register</a>
    </div>
    
    <div class="container">
        <h2>Login to Your Account</h2>
        
        <c:if test="${not empty successMessage}">
            <div class="message">${successMessage}</div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>
        
        <form action="login" method="post">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <input type="submit" value="Login" class="btn">
        </form>
        
        <div class="back-link">
            <a href="register.jsp">Don't have an account? Register here</a>
        </div>
    </div>
</body>
</html>
