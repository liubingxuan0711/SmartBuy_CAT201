package com.example.smartbuy.servlet;

import com.example.smartbuy.dao.CartDAO;
import com.example.smartbuy.dao.OrderDAO;
import com.example.smartbuy.dao.ProductDAO;
import com.example.smartbuy.model.CartItem;
import com.example.smartbuy.model.Order;
import com.example.smartbuy.model.OrderItem;
import com.example.smartbuy.model.Product;
import com.example.smartbuy.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CheckoutServlet extends HttpServlet {
    
    private CartDAO cartDAO = new CartDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private ProductDAO productDAO = new ProductDAO();
    
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
        
        User currentUser = (User) session.getAttribute("currentUser");
        
        try {
            List<CartItem> cartItems;
            String cartIdStr = request.getParameter("cartId");
            String buyNowStr = request.getParameter("buyNow");
            String productIdStr = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");
            
            // Decide whether to Buy Now or checkout from the shopping cart
            if ("true".equals(buyNowStr) && productIdStr != null && !productIdStr.isEmpty()) {
                // Buy Now - Purchase the item directly, without using the shopping cart
                int productId = Integer.parseInt(productIdStr);
                int quantity = quantityStr != null ? Integer.parseInt(quantityStr) : 1;
                
                Product product = productDAO.getProductById(productId);
                if (product != null && product.isAvailable() && product.getStock() >= quantity) {
                    // Create a temporary CartItem for checkout
                    CartItem tempItem = new CartItem();
                    tempItem.setProductId(product.getProductId());
                    tempItem.setProductName(product.getProductName());
                    tempItem.setBrand(product.getBrand());
                    tempItem.setPrice(product.getPrice());
                    tempItem.setQuantity(quantity);
                    tempItem.setSubtotal(product.getPrice().multiply(new java.math.BigDecimal(quantity)));
                    
                    cartItems = new ArrayList<>();
                    cartItems.add(tempItem);
                    request.setAttribute("buyNowMode", true);
                } else {
                    response.sendRedirect(request.getContextPath() + "/products?error=Product not available");
                    return;
                }
            } else if (cartIdStr != null && !cartIdStr.isEmpty()) {
                // Checkout single item
                int cartId = Integer.parseInt(cartIdStr);
                CartItem singleItem = cartDAO.getCartItemById(cartId);
                if (singleItem != null) {
                    cartItems = new ArrayList<>();
                    cartItems.add(singleItem);
                } else {
                    response.sendRedirect(request.getContextPath() + "/cart?error=Item not found");
                    return;
                }
            } else {
                // Checkout All Items
                cartItems = cartDAO.getCartItems(currentUser.getUserId());
            }
            
            // Automatically fill in user information
            request.setAttribute("userAddress", currentUser.getAddress() != null ? currentUser.getAddress() : "");
            request.setAttribute("userPhone", currentUser.getPhone() != null ? currentUser.getPhone() : "");
            request.setAttribute("userFullName", currentUser.getFullName() != null ? currentUser.getFullName() : "");
            request.setAttribute("userEmail", currentUser.getEmail() != null ? currentUser.getEmail() : "");
            
            // Save cartId for tracking individual item checkout
            if (cartIdStr != null && !cartIdStr.isEmpty()) {
                request.setAttribute("singleCheckout", true);
                request.setAttribute("checkoutCartId", cartIdStr);
            }
            
            // Get shopping cart items
            request.setAttribute("cartItems", cartItems);
            
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Failed to load checkout: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
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
            // If the user is not logged in, redirect to the login page
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        String action = request.getParameter("action");
        User currentUser = (User) session.getAttribute("currentUser");
        
        if ("placeOrder".equals(action)) {
            try {
                //Get order information
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                String city = request.getParameter("city");
                String zipCode = request.getParameter("zipCode");
                String paymentMethod = request.getParameter("paymentMethod");
                
                // Assemble complete address
                String shippingAddress = address + ", " + city + ", " + zipCode;
                
                // Get shopping cart items
                String cartIdStr = request.getParameter("cartId");
                String buyNowMode = request.getParameter("buyNowMode");
                List<CartItem> cartItems;
                
                if ("true".equals(buyNowMode)) {
                    // Buy Now Mode - Does not require retrieving from the shopping cart, rebuilds from the request
                   // In this case, the shopping cart does not need to be cleared after the order is created
                    cartItems = new ArrayList<>();
                    // Note: In Buy Now mode, checkout.jsp has already displayed the product, we only need to get it from the session or request.
                    // But here we reconstruct from hidden fields
                    response.sendRedirect(request.getContextPath() + "/products?error=Invalid buy now request");
                    return;
                } else if (cartIdStr != null && !cartIdStr.isEmpty()) {
                    // Checkout single item
                    int cartId = Integer.parseInt(cartIdStr);
                    CartItem singleItem = cartDAO.getCartItemById(cartId);
                    if (singleItem != null) {
                        cartItems = new ArrayList<>();
                        cartItems.add(singleItem);
                    } else {
                        request.setAttribute("errorMessage", "Cannot place order: Item not found!");
                        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
                        return;
                    }
                } else {
                    // Checkout All Items
                    cartItems = cartDAO.getCartItems(currentUser.getUserId());
                }
                
                if (cartItems.isEmpty()) {
                    request.setAttribute("errorMessage", "Cannot place order: Cart is empty!");
                    request.getRequestDispatcher("/checkout.jsp").forward(request, response);
                    return;
                }
                
                // Create Order
                Order order = new Order();
                order.setUserId(currentUser.getUserId());
                order.setTotalAmount(computeTotalAmount(cartItems));
                order.setStatus("Pending");
                order.setShippingAddress(shippingAddress);
                order.setPaymentMethod(paymentMethod);
                
                //Convert cart items into order items
                for (CartItem cartItem : cartItems) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setProductId(cartItem.getProductId());
                    orderItem.setProductName(cartItem.getProductName());
                    orderItem.setQuantity(cartItem.getQuantity());
                    orderItem.setUnitPrice(cartItem.getPrice());
                    orderItem.setSubtotal(cartItem.getSubtotal());
                    order.addOrderItem(orderItem);
                }
                
                // Save the order
                int orderId = orderDAO.createOrder(order);
                
                if (orderId != -1) {
                    // Clear the shopping cart (if checking out a single item, only remove that item)
                    if (cartIdStr != null && !cartIdStr.isEmpty()) {
                        int cartId = Integer.parseInt(cartIdStr);
                        cartDAO.removeCartItem(cartId);
                    } else {
                        cartDAO.clearCart(currentUser.getUserId());
                    }
                    
                    // Get complete order information
                    Order fullOrder = orderDAO.getOrderById(orderId);
                    
                    // Set Order Confirmation Information
                    request.setAttribute("orderId", orderId);
                    request.setAttribute("orderDate", fullOrder.getOrderDate());
                    request.setAttribute("totalAmount", fullOrder.getTotalAmount());
                    request.setAttribute("shippingAddress", shippingAddress);
                    request.setAttribute("paymentMethod", paymentMethod);
                    
                    // Forward to the order confirmation page
                    request.getRequestDispatcher("/order-confirmation.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Failed to place order!");
                    request.getRequestDispatcher("/checkout.jsp").forward(request, response);
                }
                
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Failed to place order: " + e.getMessage());
                request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            }
        } else {
            doGet(request, response);
        }
    }
    
    private java.math.BigDecimal computeTotalAmount(List<CartItem> cartItems) {
        java.math.BigDecimal total = java.math.BigDecimal.ZERO;
        for (CartItem item : cartItems) {
            total = total.add(item.getSubtotal());
        }
        return total;
    }
}
