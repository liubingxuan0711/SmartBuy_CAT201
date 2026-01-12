package com.example.smartbuy.servlet;

import com.example.smartbuy.dao.ProductDAO;
import com.example.smartbuy.dao.OrderDAO;
import com.example.smartbuy.dao.CategoryDAO;
import com.example.smartbuy.model.Product;
import com.example.smartbuy.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class AdminDashboardServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (session == null || currentUser == null || !currentUser.isAdmin()) {
            // If you are not an administrator, redirect to the homepage
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        try {
            // Get product data
            List<Product> products = productDAO.getAllProductsForAdmin();
            request.setAttribute("products", products);
            
            // You can add order statistics and other data here
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Failed to load dashboard: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
