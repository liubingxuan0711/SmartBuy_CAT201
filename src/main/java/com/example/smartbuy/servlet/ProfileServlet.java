package com.example.smartbuy.servlet;

import com.example.smartbuy.dao.UserDAO;
import com.example.smartbuy.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

public class ProfileServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set Character Encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        request.setAttribute("user", currentUser);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set Character Encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        
        try {
            // Get form data
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Update Basic Information
            currentUser.setFullName(fullName);
            currentUser.setEmail(email);
            currentUser.setPhone(phone);
            currentUser.setAddress(address);
            
            // If you want to change your password
            boolean passwordChanged = false;
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                // Verify current password
                if (currentPassword == null || !currentPassword.equals(currentUser.getPassword())) {
                    String message = "Current password is incorrect!";
                    response.sendRedirect(request.getContextPath() + "/profile?error=" + 
                                        URLEncoder.encode(message, StandardCharsets.UTF_8));
                    return;
                }
                
                // Verify new password
                if (!newPassword.equals(confirmPassword)) {
                    String message = "New passwords do not match!";
                    response.sendRedirect(request.getContextPath() + "/profile?error=" + 
                                        URLEncoder.encode(message, StandardCharsets.UTF_8));
                    return;
                }
                
                // Update the password in the database
                if (userDAO.updatePassword(currentUser.getUserId(), newPassword)) {
                    currentUser.setPassword(newPassword);
                    passwordChanged = true;
                } else {
                    String message = "Failed to update password!";
                    response.sendRedirect(request.getContextPath() + "/profile?error=" + 
                                        URLEncoder.encode(message, StandardCharsets.UTF_8));
                    return;
                }
            }
            
            // Save basic information to the database
            boolean success = userDAO.updateUser(currentUser);
            
            if (success) {
                // Update the user information in the session
                session.setAttribute("currentUser", currentUser);
                
                String message = passwordChanged ? 
                    "Profile and password updated successfully!" : 
                    "Profile updated successfully!";
                response.sendRedirect(request.getContextPath() + "/profile?message=" + 
                                    URLEncoder.encode(message, StandardCharsets.UTF_8));
            } else {
                String message = "Failed to update profile!";
                response.sendRedirect(request.getContextPath() + "/profile?error=" + 
                                    URLEncoder.encode(message, StandardCharsets.UTF_8));
            }
            
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
