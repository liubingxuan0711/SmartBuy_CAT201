package com.example.smartbuy.servlet;

import com.example.smartbuy.dao.CartDAO;
import com.example.smartbuy.model.CartItem;
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

public class CartServlet extends HttpServlet {
    
    private CartDAO cartDAO = new CartDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set Character Encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            // If the user is not logged in, redirect to the login page
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        String action = request.getParameter("action");
        User currentUser = (User) session.getAttribute("currentUser");
        
        if ("add".equals(action)) {
            // Add Product to Cart - Via GET Request (Compatibility Handling)
            handleAddToCart(request, response, currentUser);
            return;
        } else if ("remove".equals(action)) {
            // Remove item from cart
            try {
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                boolean success = cartDAO.removeFromCart(cartId);
                
                String message;
                if (success) {
                    message = "Product removed from cart successfully!";
                } else {
                    message = "Failed to remove product from cart!";
                }
                
                //Redirect back to the shopping cart page with a message parameter
                String redirectUrl = request.getContextPath() + "/cart?message=" + 
                                   URLEncoder.encode(message, StandardCharsets.UTF_8);
                if (!success) {
                    redirectUrl += "&error=true";
                }
                response.sendRedirect(redirectUrl);
                return;
                
            } catch (NumberFormatException e) {
                String errorMessage = "Invalid cart item ID!";
                response.sendRedirect(request.getContextPath() + "/cart?errorMessage=" + 
                                    URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
                return;
            } catch (SQLException e) {
                String errorMessage = "Database error while removing product from cart: " + e.getMessage();
                response.sendRedirect(request.getContextPath() + "/cart?errorMessage=" + 
                                    URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
                return;
            } catch (Exception e) {
                String errorMessage = "Failed to remove product from cart: " + e.getMessage();
                response.sendRedirect(request.getContextPath() + "/cart?errorMessage=" + 
                                    URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
                return;
            }
        } else if ("update".equals(action)) {
            // Update shopping cart item quantity
            try {
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                
                if (quantity <= 0) {
                    // If the quantity is less than or equal to 0, remove the item from the shopping cart.
                    boolean success = cartDAO.removeFromCart(cartId);
                    String message;
                    if (success) {
                        message = "Product removed from cart successfully!";
                    } else {
                        message = "Failed to remove product from cart!";
                    }
                    
                    // Redirect back to the shopping cart page with a message parameter
                    String redirectUrl = request.getContextPath() + "/cart?message=" + 
                                       URLEncoder.encode(message, StandardCharsets.UTF_8);
                    if (!success) {
                        redirectUrl += "&error=true";
                    }
                    response.sendRedirect(redirectUrl);
                    return;
                } else {
                    boolean success = cartDAO.updateCartItemQuantity(cartId, quantity);
                    String message;
                    if (success) {
                        message = "Cart updated successfully!";
                    } else {
                        message = "Failed to update cart!";
                    }
                    
                    // Redirect back to the shopping cart page with a message parameter
                    String redirectUrl = request.getContextPath() + "/cart?message=" + 
                                       URLEncoder.encode(message, StandardCharsets.UTF_8);
                    if (!success) {
                        redirectUrl += "&error=true";
                    }
                    response.sendRedirect(redirectUrl);
                    return;
                }
                
            } catch (NumberFormatException e) {
                String errorMessage = "Invalid cart item ID or quantity!";
                response.sendRedirect(request.getContextPath() + "/cart?errorMessage=" + 
                                    URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
                return;
            } catch (SQLException e) {
                String errorMessage = "Database error while updating cart: " + e.getMessage();
                response.sendRedirect(request.getContextPath() + "/cart?errorMessage=" + 
                                    URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
                return;
            } catch (Exception e) {
                String errorMessage = "Failed to update cart: " + e.getMessage();
                response.sendRedirect(request.getContextPath() + "/cart?errorMessage=" + 
                                    URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
                return;
            }
            
        } else if ("clear".equals(action)) {
            // Empty cart
            try {
                boolean success = cartDAO.clearCart(currentUser.getUserId());
                String message;
                if (success) {
                    message = "Cart cleared successfully!";
                } else {
                    message = "Failed to clear cart!";
                }
                
                // Redirect back to the shopping cart page with a message parameter
                String redirectUrl = request.getContextPath() + "/cart?message=" + 
                                   URLEncoder.encode(message, StandardCharsets.UTF_8);
                if (!success) {
                    redirectUrl += "&error=true";
                }
                response.sendRedirect(redirectUrl);
                return;
                
            } catch (SQLException e) {
                String errorMessage = "Database error while clearing cart: " + e.getMessage();
                response.sendRedirect(request.getContextPath() + "/cart?errorMessage=" + 
                                    URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
                return;
            } catch (Exception e) {
                String errorMessage = "Failed to clear cart: " + e.getMessage();
                response.sendRedirect(request.getContextPath() + "/cart?errorMessage=" + 
                                    URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
                return;
            }
        } else {
            //Show shopping cart page
            try {
                List<CartItem> cartItems = cartDAO.getCartItems(currentUser.getUserId());
                request.setAttribute("cartItems", cartItems);
                
                request.getRequestDispatcher("/cart.jsp").forward(request, response);
            } catch (SQLException e) {
                request.setAttribute("errorMessage", "Database error while loading cart: " + e.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Failed to load cart: " + e.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set Character Encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            //If the user is not logged in, redirect to the login page
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        String action = request.getParameter("action");
        User currentUser = (User) session.getAttribute("currentUser");
        
        try {
            if ("add".equals(action)) {
                //Add item to cart
                handleAddToCart(request, response, currentUser);
                return;
                
            } else if ("buyNow".equals(action)) {
                //Buy Now: Add the item to your cart and go directly to the checkout page
                handleBuyNow(request, response, currentUser);
                return;
                
            } else if ("remove".equals(action)) {
                // Remove item from cart
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                boolean success = cartDAO.removeFromCart(cartId);
                
                String message;
                if (success) {
                    message = "Product removed from cart successfully!";
                } else {
                    message = "Failed to remove product from cart!";
                }
                
                // Redirect back to the shopping cart page with a message parameter
                String redirectUrl = request.getContextPath() + "/cart?message=" + 
                                   URLEncoder.encode(message, StandardCharsets.UTF_8);
                if (!success) {
                    redirectUrl += "&error=true";
                }
                response.sendRedirect(redirectUrl);
                return;
                
            } else if ("update".equals(action)) {
                // Update shopping cart item quantity
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                
                if (quantity <= 0) {
                    //If the quantity is less than or equal to 0, remove the item from the shopping cart.
                    boolean success = cartDAO.removeFromCart(cartId);
                    String message;
                    if (success) {
                        message = "Product removed from cart successfully!";
                    } else {
                        message = "Failed to remove product from cart!";
                    }
                    
                    // Redirect back to the shopping cart page with a message parameter
                    String redirectUrl = request.getContextPath() + "/cart?message=" + 
                                       URLEncoder.encode(message, StandardCharsets.UTF_8);
                    if (!success) {
                        redirectUrl += "&error=true";
                    }
                    response.sendRedirect(redirectUrl);
                    return;
                } else {
                    boolean success = cartDAO.updateCartItemQuantity(cartId, quantity);
                    String message;
                    if (success) {
                        message = "Cart updated successfully!";
                    } else {
                        message = "Failed to update cart!";
                    }
                    
                    // Redirect back to the shopping cart page with a message parameter
                    String redirectUrl = request.getContextPath() + "/cart?message=" + 
                                       URLEncoder.encode(message, StandardCharsets.UTF_8);
                    if (!success) {
                        redirectUrl += "&error=true";
                    }
                    response.sendRedirect(redirectUrl);
                    return;
                }
                
            } else if ("clear".equals(action)) {
                // Empty cart
                boolean success = cartDAO.clearCart(currentUser.getUserId());
                String message;
                if (success) {
                    message = "Cart cleared successfully!";
                } else {
                    message = "Failed to clear cart!";
                }
                
                // Redirect back to the shopping cart page with a message parameter
                String redirectUrl = request.getContextPath() + "/cart?message=" + 
                                   URLEncoder.encode(message, StandardCharsets.UTF_8);
                if (!success) {
                    redirectUrl += "&error=true";
                }
                response.sendRedirect(redirectUrl);
                return;
            }
            
            //Default behavior: Display the shopping cart page
            doGet(request, response);
            
        } catch (NumberFormatException e) {
            String errorMessage = "Invalid input format!";
            response.sendRedirect(request.getContextPath() + "/cart?errorMessage=" + 
                                URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
        } catch (SQLException e) {
            String errorMessage = "Database error during cart operation: " + e.getMessage();
            response.sendRedirect(request.getContextPath() + "/cart?errorMessage=" + 
                                URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
        } catch (Exception e) {
            String errorMessage = "Cart operation failed: " + e.getMessage();
            response.sendRedirect(request.getContextPath() + "/cart?errorMessage=" + 
                                URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
        }
    }
    
    /**
     * Handle the logic for adding items to the shopping cart (avoid code duplication)
     */
    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String quantityParam = request.getParameter("quantity");
            int quantity = quantityParam != null ? Integer.parseInt(quantityParam) : 1;
            
            boolean success = cartDAO.addToCart(currentUser.getUserId(), productId, quantity);
            String message;
            if (success) {
                message = "Product added to cart successfully!";
            } else {
                message = "Failed to add product to cart!";
            }
            
            // Redirect back to the product page with a message parameter
            String redirectUrl = request.getContextPath() + "/products?message=" + 
                               URLEncoder.encode(message, StandardCharsets.UTF_8);
            if (!success) {
                redirectUrl += "&error=true";
            }
            response.sendRedirect(redirectUrl);
            
        } catch (NumberFormatException e) {
            String errorMessage = "Invalid product ID or quantity!";
            response.sendRedirect(request.getContextPath() + "/products?errorMessage=" + 
                                URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
        } catch (SQLException e) {
            String errorMessage = "Database error while adding product to cart: " + e.getMessage();
            response.sendRedirect(request.getContextPath() + "/products?errorMessage=" + 
                                URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
        } catch (Exception e) {
            String errorMessage = "Failed to add product to cart: " + e.getMessage();
            response.sendRedirect(request.getContextPath() + "/products?errorMessage=" + 
                                URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
        }
    }
    
    /**
     * Handle Buy Now operation: add the item to the shopping cart and go directly to the checkout page
     */
    private void handleBuyNow(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String quantityParam = request.getParameter("quantity");
            int quantity = quantityParam != null ? Integer.parseInt(quantityParam) : 1;
            
            // Add to cart first
            boolean success = cartDAO.addToCart(currentUser.getUserId(), productId, quantity);
            
            if (success) {
                // Get the ID of the newly added cart item
                List<CartItem> cartItems = cartDAO.getCartItems(currentUser.getUserId());
                
                // Find the newly added product
                CartItem addedItem = null;
                for (CartItem item : cartItems) {
                    if (item.getProductId() == productId) {
                        addedItem = item;
                        break;
                    }
                }
                
                if (addedItem != null) {
                    // Directly jump to the checkout page and pass the shopping cart item IDs
                    response.sendRedirect(request.getContextPath() + "/checkout?cartId=" + addedItem.getCartId());
                } else {
                    // If not found, go to the shopping cart page
                    response.sendRedirect(request.getContextPath() + "/cart");
                }
            } else {
                String errorMessage = "Failed to add product to cart!";
                response.sendRedirect(request.getContextPath() + "/products?errorMessage=" + 
                                    URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
            }
            
        } catch (NumberFormatException e) {
            String errorMessage = "Invalid product ID or quantity!";
            response.sendRedirect(request.getContextPath() + "/products?errorMessage=" + 
                                URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
        } catch (SQLException e) {
            String errorMessage = "Database error: " + e.getMessage();
            response.sendRedirect(request.getContextPath() + "/products?errorMessage=" + 
                                URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
        } catch (Exception e) {
            String errorMessage = "Failed to process Buy Now: " + e.getMessage();
            response.sendRedirect(request.getContextPath() + "/products?errorMessage=" + 
                                URLEncoder.encode(errorMessage, StandardCharsets.UTF_8) + "&error=true");
        }
    }
}
