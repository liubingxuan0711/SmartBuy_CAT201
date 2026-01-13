package com.example.smartbuy.servlet;

import com.example.smartbuy.dao.UserDAO;
import com.example.smartbuy.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        //Set Character Encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password");
        
        //Verify Input
        if (username.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username and password cannot be empty!");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }
        
        try {
            User user = userDAO.login(username, password);
            
            if (user != null) {
                // Save user to session
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                
                //Redirect to different pages based on user roles
                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } else {
                request.setAttribute("errorMessage", "Username or password is incorrect!");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Login failed: " + e.getMessage());
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
