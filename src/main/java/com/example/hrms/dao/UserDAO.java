package com.example.hrms.dao;

import com.example.hrms.model.User;
import com.example.hrms.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    
    public User getUserByUsername(String username) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setRole(rs.getString("role"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
    }
    
    public boolean createUser(User user) {
        String sql = "INSERT INTO users (username, password_hash, role) VALUES (?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPasswordHash());
            pstmt.setString(3, user.getRole());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean validateCredentials(String username, String password) {
        User user = getUserByUsername(username);
        
        if (user != null) {
            // Verify the password using BCrypt
            return at.favre.lib.crypto.bcrypt.BCrypt.verifyer()
                    .verify(password.toCharArray(), user.getPasswordHash())
                    .verified;
        }
        
        return false;
    }
}
