<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - SmartBuy</title>
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
        }
        .profile-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 20px;
        }
        .profile-section h2 {
            margin-top: 0;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 20px;
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
        .form-group input:focus {
            outline: none;
            border-color: #2196F3;
        }
        .btn {
            background-color: #2196F3;
            color: white;
            padding: 12px 30px;
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
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error-message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .info-text {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }
        .logout-link {
            float: right;
        }
        hr {
            margin: 30px 0;
            border: none;
            border-top: 1px solid #ddd;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SmartBuy - My Profile</h1>
    </div>
    
    <div class="nav">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/products">Products</a>
        <a href="${pageContext.request.contextPath}/cart">Cart</a>
        <a href="${pageContext.request.contextPath}/order-history">Order History</a>
        <a href="${pageContext.request.contextPath}/profile">My Profile</a>
        <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.admin}">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
        </c:if>
        <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
    </div>
    
    <div class="container">
        <div class="profile-section">
            <h2>Personal Information</h2>
            
            <c:if test="${not empty param.message}">
                <div class="message">${param.message}</div>
            </c:if>
            
            <c:if test="${not empty param.error}">
                <div class="error-message">${param.error}</div>
            </c:if>
            
            <form method="post" action="${pageContext.request.contextPath}/profile">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" value="${user.username}" disabled>
                    <p class="info-text">Username cannot be changed</p>
                </div>
                
                <div class="form-group">
                    <label for="fullName">Full Name *</label>
                    <input type="text" id="fullName" name="fullName" 
                           value="${user.fullName}" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" 
                           value="${user.email}" required>
                </div>
                
                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="tel" id="phone" name="phone" 
                           value="${user.phone}">
                </div>
                
                <div class="form-group">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address" 
                           value="${user.address}">
                </div>
                
                <hr>
                
                <h3>Change Password (Optional)</h3>
                <p class="info-text">Leave blank if you don't want to change your password</p>
                
                <div class="form-group">
                    <label for="currentPassword">Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword">
                </div>
                
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" minlength="6">
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" minlength="6">
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn">Update Profile</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // Password verification
        document.querySelector('form').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const currentPassword = document.getElementById('currentPassword').value;
            
            // If you enter a new password, you must enter your current password.
            if (newPassword && !currentPassword) {
                alert('Please enter your current password to change password');
                e.preventDefault();
                return false;
            }
            
            // Verify that the new password and the confirmed password match.
            if (newPassword && newPassword !== confirmPassword) {
                alert('New passwords do not match!');
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>
