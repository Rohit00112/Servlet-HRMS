package com.example.hrms.dao;

import com.example.hrms.model.Designation;
import com.example.hrms.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DesignationDAO {
    
    public List<Designation> getAllDesignations() {
        List<Designation> designations = new ArrayList<>();
        String sql = "SELECT * FROM designations ORDER BY title";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Designation designation = new Designation();
                designation.setId(rs.getInt("id"));
                designation.setTitle(rs.getString("title"));
                designations.add(designation);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return designations;
    }
    
    public Designation getDesignationById(int id) {
        Designation designation = null;
        String sql = "SELECT * FROM designations WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                designation = new Designation();
                designation.setId(rs.getInt("id"));
                designation.setTitle(rs.getString("title"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return designation;
    }
    
    public boolean createDesignation(Designation designation) {
        String sql = "INSERT INTO designations (title) VALUES (?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, designation.getTitle());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateDesignation(Designation designation) {
        String sql = "UPDATE designations SET title = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, designation.getTitle());
            pstmt.setInt(2, designation.getId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteDesignation(int id) {
        String sql = "DELETE FROM designations WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
