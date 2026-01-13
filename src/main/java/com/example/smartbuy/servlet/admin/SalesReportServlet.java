package com.example.smartbuy.servlet.admin;

import com.example.smartbuy.dao.OrderDAO;
import com.example.smartbuy.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Map;

public class SalesReportServlet extends HttpServlet {
    
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
            // Get total revenue and number of orders
            BigDecimal totalRevenue = orderDAO.getTotalRevenue();
            int totalOrders = orderDAO.getTotalOrderCount();
            
            // Get sales data categorized by category
            Map<String, BigDecimal> salesByCategory = orderDAO.getSalesByCategory();
            Map<String, Integer> ordersByCategory = orderDAO.getOrderCountByCategory();
            
            // Get sales data broken down by date
            Map<String, BigDecimal> salesByDate = orderDAO.getSalesByDate(30); // Last 30 days
            Map<String, Integer> ordersByDate = orderDAO.getOrderCountByDate(30);
            
            // Get the number of orders by status
            Map<String, Integer> ordersByStatus = orderDAO.getOrderCountByStatus();
            
            // Set Properties
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("salesByCategory", salesByCategory);
            request.setAttribute("ordersByCategory", ordersByCategory);
            request.setAttribute("salesByDate", salesByDate);
            request.setAttribute("ordersByDate", ordersByDate);
            request.setAttribute("ordersByStatus", ordersByStatus);
            
            request.getRequestDispatcher("/admin/sales-report.jsp").forward(request, response);
            
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
