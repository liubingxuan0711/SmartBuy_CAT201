package com.example.smartbuy.servlet.admin;

import com.example.smartbuy.dao.OrderDAO;
import com.example.smartbuy.model.Order;
import com.example.smartbuy.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/order-detail")
public class OrderDetailServlet extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set Character Encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        // Verify administrator identity
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (!currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }
        
        try {
            // Get Order ID
            String orderIdStr = request.getParameter("orderId");
            if (orderIdStr == null || orderIdStr.isEmpty()) {
                request.setAttribute("errorMessage", "Order ID is required!");
                request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            
            // Get order details (including order items)
            Order order = orderDAO.getOrderWithItems(orderId);
            
            if (order != null) {
                request.setAttribute("order", order);
            } else {
                request.setAttribute("errorMessage", "Order not found!");
            }
            
            request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid order ID format!");
            request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading order details: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
