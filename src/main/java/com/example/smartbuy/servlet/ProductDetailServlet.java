package com.example.smartbuy.servlet;

import com.example.smartbuy.dao.ProductDAO;
import com.example.smartbuy.model.Product;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

public class ProductDetailServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        // Allow unregistered users to view product details
        boolean isLoggedIn = (session != null && session.getAttribute("currentUser") != null);
        request.setAttribute("isLoggedIn", isLoggedIn);
        
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(productId);
            
            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/products?error=Product not found");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products?error=Invalid product ID");
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
