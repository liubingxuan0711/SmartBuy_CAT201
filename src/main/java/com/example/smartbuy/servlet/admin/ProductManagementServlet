package com.example.smartbuy.servlet.admin;

import com.example.smartbuy.dao.CategoryDAO;
import com.example.smartbuy.dao.ProductDAO;
import com.example.smartbuy.model.Category;
import com.example.smartbuy.model.Product;
import com.example.smartbuy.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;

public class ProductManagementServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
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
        
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                // Show Add Product Page
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
                
            } else if ("edit".equals(action)) {
                //Show Edit Product Page
                int productId = Integer.parseInt(request.getParameter("id"));
                Product product = productDAO.getProductById(productId);
                List<Category> categories = categoryDAO.getAllCategories();
                
                request.setAttribute("product", product);
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
                
            } else if ("delete".equals(action)) {
                //Delete product
                int productId = Integer.parseInt(request.getParameter("id"));
                boolean success = productDAO.deleteProduct(productId);
                
                String message = success ? "Product deleted successfully!" : "Failed to delete product!";
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?message=" + 
                                    URLEncoder.encode(message, StandardCharsets.UTF_8));
            }
            
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
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
        
        String action = request.getParameter("action");
        
        try {
            //Processing Status Switch
            if ("toggleStatus".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                boolean isAvailable = "true".equals(request.getParameter("isAvailable"));
                
                Product product = productDAO.getProductById(productId);
                product.setAvailable(isAvailable);
                boolean success = productDAO.updateProduct(product);
                
                String message = success ? "Product status updated!" : "Failed to update status!";
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?message=" + 
                                    URLEncoder.encode(message, StandardCharsets.UTF_8));
                return;
            }
            
            // Handle Add/Edit Product
            String productIdStr = request.getParameter("productId");
            String productName = request.getParameter("productName");
            String brand = request.getParameter("brand");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");
            boolean isAvailable = "on".equals(request.getParameter("isAvailable"));
            
            boolean success;
            String message;
            
            if (productIdStr == null || productIdStr.isEmpty()) {
                // Add New Product
                Product product = new Product();
                product.setProductName(productName);
                product.setBrand(brand);
                product.setCategoryId(categoryId);
                product.setPrice(price);
                product.setStock(stock);
                product.setDescription(description);
                product.setImageUrl(imageUrl);
                product.setAvailable(isAvailable);
                
                success = productDAO.addProduct(product);
                message = success ? "Product added successfully!" : "Failed to add product!";
                
            } else {
                // Update Product 
                int productId = Integer.parseInt(productIdStr);
                Product product = productDAO.getProductById(productId);
                
                product.setProductName(productName);
                product.setBrand(brand);
                product.setCategoryId(categoryId);
                product.setPrice(price);
                product.setStock(stock);
                product.setDescription(description);
                product.setImageUrl(imageUrl);
                product.setAvailable(isAvailable);
                
                success = productDAO.updateProduct(product);
                message = success ? "Product updated successfully!" : "Failed to update product!";
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?message=" + 
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
