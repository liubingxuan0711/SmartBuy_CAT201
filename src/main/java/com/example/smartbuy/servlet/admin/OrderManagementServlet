package com.example.smartbuy.servlet.admin;

import com.example.smartbuy.dao.OrderDAO;
import com.example.smartbuy.model.Order;
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
import java.util.List;

public class OrderManagementServlet extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (!currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            // Get all orders
            List<Order> orders = orderDAO.getAllOrders();
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
            
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (!currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            
            boolean success = orderDAO.updateOrderStatus(orderId, status);
            String message = success ? "Order status updated successfully!" : "Failed to update order status!";
            
            response.sendRedirect(request.getContextPath() + "/admin/orders?message=" + 
                                URLEncoder.encode(message, StandardCharsets.UTF_8));
            
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
