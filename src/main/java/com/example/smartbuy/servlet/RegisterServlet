package com.example.smartbuy.servlet;

import com.example.smartbuy.dao.UserDAO;
import com.example.smartbuy.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        //Set Character Encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password");
        String email = request.getParameter("email").trim();
        String fullName = request.getParameter("fullName").trim();
        
        // Verify Input
        if (username.isEmpty() || password.isEmpty() || email.isEmpty()) {
            request.setAttribute("errorMessage", "Username, password, and email cannot be empty!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check if the username already exists
        try {
            if (userDAO.usernameExists(username)) {
                request.setAttribute("errorMessage", "Username already exists!");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Check if the email already exists
            if (userDAO.emailExists(email)) {
                request.setAttribute("errorMessage", "Email already exists!");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            //Create New User
            User newUser = new User(username, password, email, fullName);
            boolean success = userDAO.register(newUser);
            
            if (success) {
                request.setAttribute("successMessage", "Registration successful! Please login.");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Registration failed!");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}
