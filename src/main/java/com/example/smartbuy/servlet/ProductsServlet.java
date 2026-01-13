package com.example.smartbuy.servlet;

import com.example.smartbuy.dao.CategoryDAO;
import com.example.smartbuy.dao.ProductDAO;
import com.example.smartbuy.model.Category;
import com.example.smartbuy.model.Product;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class ProductsServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set Character Encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        //Allow unauthenticated users to access the product list, but track login status.
        boolean isLoggedIn = (session != null && session.getAttribute("currentUser") != null);
        request.setAttribute("isLoggedIn", isLoggedIn);
        
        // Handle message parameters from the cart servlet
        String message = request.getParameter("message");
        String errorMessage = request.getParameter("errorMessage");
        String errorParam = request.getParameter("error");
        
        if (message != null) {
            if ("true".equals(errorParam)) {
                request.setAttribute("errorMessage", message);
            } else {
                request.setAttribute("message", message);
            }
        }
        
        if (errorMessage != null && !"true".equals(errorParam)) {
            request.setAttribute("errorMessage", errorMessage);
        }
        
        try {
            // Get search and filter parameters
            String keyword = request.getParameter("keyword");
            String categoryIdStr = request.getParameter("categoryId");
            String brand = request.getParameter("brand");
            String minPriceStr = request.getParameter("minPrice");
            String maxPriceStr = request.getParameter("maxPrice");
            String sortBy = request.getParameter("sortBy");
            
            Integer categoryId = null;
            Double minPrice = null;
            Double maxPrice = null;
            
            // Parse parameters
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdStr);
                } catch (NumberFormatException e) {
                    // Ignore invalid parameters
                }
            }
            
            if (minPriceStr != null && !minPriceStr.isEmpty()) {
                try {
                    minPrice = Double.parseDouble(minPriceStr);
                } catch (NumberFormatException e) {
                    // Ignore invalid parameters
                }
            }
            
            if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
                try {
                    maxPrice = Double.parseDouble(maxPriceStr);
                } catch (NumberFormatException e) {
                    // Ignore invalid parameters
                }
            }
            
            // Get product list based on parameters
            List<Product> products;
            
            if (keyword != null || categoryId != null || brand != null || 
                minPrice != null || maxPrice != null || sortBy != null) {
                // Use Advanced Search
                products = productDAO.advancedSearch(keyword, categoryId, minPrice, maxPrice, brand, sortBy);
            } else {
                // Get all products
                products = productDAO.getAllProducts();
            }
            
            //Get category list and brand list (for filters)
            List<Category> categories = categoryDAO.getAllCategories();
            List<String> brands = productDAO.getAllBrands();
            
            // Set Properties
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("brands", brands);
            
            // Save search criteria for display
            request.setAttribute("currentKeyword", keyword);
            request.setAttribute("currentCategoryId", categoryId);
            request.setAttribute("currentBrand", brand);
            request.setAttribute("currentMinPrice", minPrice);
            request.setAttribute("currentMaxPrice", maxPrice);
            request.setAttribute("currentSortBy", sortBy);
            
            request.getRequestDispatcher("/products.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Failed to load products: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
