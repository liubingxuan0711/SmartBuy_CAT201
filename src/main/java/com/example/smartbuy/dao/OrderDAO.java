package com.example.smartbuy.dao;

import com.example.smartbuy.model.Order;
import com.example.smartbuy.model.OrderItem;
import com.example.smartbuy.util.DatabaseUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Order Data Access Object
 */
public class OrderDAO {
    
    /**
     * Create Order
     */
    public int createOrder(Order order) throws SQLException {
        String orderSql = "INSERT INTO orders (user_id, total_amount, status, shipping_address, payment_method) " +
                         "VALUES (?, ?, ?, ?, ?)";
        String itemSql = "INSERT INTO order_items (order_id, product_id, product_name, quantity, unit_price, subtotal) " +
                        "VALUES (?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        int orderId = -1;
        
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Insert Order
            try (PreparedStatement pstmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setInt(1, order.getUserId());
                pstmt.setBigDecimal(2, order.getTotalAmount());
                pstmt.setString(3, order.getStatus());
                pstmt.setString(4, order.getShippingAddress());
                pstmt.setString(5, order.getPaymentMethod());
                
                pstmt.executeUpdate();
                
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }
            
            // Insert order details
            try (PreparedStatement pstmt = conn.prepareStatement(itemSql)) {
                for (OrderItem item : order.getOrderItems()) {
                    pstmt.setInt(1, orderId);
                    pstmt.setInt(2, item.getProductId());
                    pstmt.setString(3, item.getProductName());
                    pstmt.setInt(4, item.getQuantity());
                    pstmt.setBigDecimal(5, item.getUnitPrice());
                    pstmt.setBigDecimal(6, item.getSubtotal());
                    pstmt.addBatch();
                }
                pstmt.executeBatch();
            }
            
            conn.commit();
            return orderId;
            
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
    
    /**
     * Get user order history
     */
    public List<Order> getUserOrders(int userId) throws SQLException {
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                order.setOrderItems(getOrderItems(order.getOrderId()));
                orders.add(order);
            }
        }
        return orders;
    }
    
    /**
     * Get user order history (alias method)
     */
    public List<Order> getOrdersByUserId(int userId) throws SQLException {
        return getUserOrders(userId);
    }
    
    /**
     * Get All Orders (Admin)
     */
    public List<Order> getAllOrders() throws SQLException {
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";
        
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                order.setOrderItems(getOrderItems(order.getOrderId()));
                orders.add(order);
            }
        }
        return orders;
    }
    
    /**
     * Get order by ID
     */
    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                order.setOrderItems(getOrderItems(orderId));
                return order;
            }
        }
        return null;
    }
    
    /**
     *Get orders and their details (alias method, more semantically clear)
     */
    public Order getOrderWithItems(int orderId) throws SQLException {
        return getOrderById(orderId);
    }
    
    /**
     * Get order details
     */
    public List<OrderItem> getOrderItems(int orderId) throws SQLException {
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        
        List<OrderItem> items = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("order_item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnitPrice(rs.getBigDecimal("unit_price"));
                item.setSubtotal(rs.getBigDecimal("subtotal"));
                items.add(item);
            }
        }
        return items;
    }
    
    /**
     * Update order status
     */
    public boolean updateOrderStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Get total revenue
     */
    public BigDecimal getTotalRevenue() throws SQLException {
        String sql = "SELECT SUM(total_amount) as total FROM orders WHERE status != 'Cancelled'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total");
                return total != null ? total : BigDecimal.ZERO;
            }
        }
        return BigDecimal.ZERO;
    }
    
    /**
     * Get total number of orders
     */
    public int getTotalOrderCount() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM orders";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }
    
    /**
     * Sales by category
     */
    public Map<String, BigDecimal> getSalesByCategory() throws SQLException {
        String sql = "SELECT c.category_name, SUM(oi.subtotal) as total " +
                    "FROM order_items oi " +
                    "JOIN products p ON oi.product_id = p.product_id " +
                    "JOIN categories c ON p.category_id = c.category_id " +
                    "JOIN orders o ON oi.order_id = o.order_id " +
                    "WHERE o.status != 'Cancelled' " +
                    "GROUP BY c.category_name " +
                    "ORDER BY total DESC";
        
        Map<String, BigDecimal> result = new LinkedHashMap<>();
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                result.put(rs.getString("category_name"), rs.getBigDecimal("total"));
            }
        }
        return result;
    }
    
    /**
     * Count orders by category
     */
    public Map<String, Integer> getOrderCountByCategory() throws SQLException {
        String sql = "SELECT c.category_name, COUNT(DISTINCT o.order_id) as count " +
                    "FROM order_items oi " +
                    "JOIN products p ON oi.product_id = p.product_id " +
                    "JOIN categories c ON p.category_id = c.category_id " +
                    "JOIN orders o ON oi.order_id = o.order_id " +
                    "WHERE o.status != 'Cancelled' " +
                    "GROUP BY c.category_name " +
                    "ORDER BY count DESC";
        
        Map<String, Integer> result = new LinkedHashMap<>();
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                result.put(rs.getString("category_name"), rs.getInt("count"));
            }
        }
        return result;
    }
    
    /**
     * Sales by Date (Last N Days)
     */
    public Map<String, BigDecimal> getSalesByDate(int days) throws SQLException {
        String sql = "SELECT DATE(order_date) as date, SUM(total_amount) as total " +
                    "FROM orders " +
                    "WHERE status != 'Cancelled' AND order_date >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                    "GROUP BY DATE(order_date) " +
                    "ORDER BY date DESC";
        
        Map<String, BigDecimal> result = new LinkedHashMap<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, days);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                result.put(rs.getString("date"), rs.getBigDecimal("total"));
            }
        }
        return result;
    }
    
    /**
     * Number of orders by date (last N days)
     */
    public Map<String, Integer> getOrderCountByDate(int days) throws SQLException {
        String sql = "SELECT DATE(order_date) as date, COUNT(*) as count " +
                    "FROM orders " +
                    "WHERE order_date >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                    "GROUP BY DATE(order_date) " +
                    "ORDER BY date DESC";
        
        Map<String, Integer> result = new LinkedHashMap<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, days);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                result.put(rs.getString("date"), rs.getInt("count"));
            }
        }
        return result;
    }
    
    /**
     * Count of orders by status
     */
    public Map<String, Integer> getOrderCountByStatus() throws SQLException {
        String sql = "SELECT status, COUNT(*) as count " +
                    "FROM orders " +
                    "GROUP BY status " +
                    "ORDER BY count DESC";
        
        Map<String, Integer> result = new LinkedHashMap<>();
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                result.put(rs.getString("status"), rs.getInt("count"));
            }
        }
        return result;
    }
    
    /**
     * Extract Order object from ResultSet
     */
    private Order extractOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
            
        // Handling potentially null timestamps
        Timestamp orderDateTs = rs.getTimestamp("order_date");
        order.setOrderDate(orderDateTs != null ? orderDateTs.toLocalDateTime() : null);
            
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setPaymentMethod(rs.getString("payment_method"));
            
        Timestamp createdTs = rs.getTimestamp("created_at");
        order.setCreatedAt(createdTs != null ? createdTs.toLocalDateTime() : null);
            
        Timestamp updatedTs = rs.getTimestamp("updated_at");
        order.setUpdatedAt(updatedTs != null ? updatedTs.toLocalDateTime() : null);
            
        return order;
    }
}
