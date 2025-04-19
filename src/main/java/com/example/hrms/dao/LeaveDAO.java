package com.example.hrms.dao;

import com.example.hrms.model.Leave;
import com.example.hrms.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LeaveDAO {
    
    public List<Leave> getAllLeaves() {
        List<Leave> leaves = new ArrayList<>();
        String sql = "SELECT l.*, e.name as employee_name, u.username as reviewer_name " +
                     "FROM leaves l " +
                     "LEFT JOIN employees e ON l.employee_id = e.id " +
                     "LEFT JOIN users u ON l.reviewed_by = u.id " +
                     "ORDER BY l.applied_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Leave leave = mapLeaveFromResultSet(rs);
                leaves.add(leave);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return leaves;
    }
    
    public List<Leave> getLeavesByEmployeeId(int employeeId) {
        List<Leave> leaves = new ArrayList<>();
        String sql = "SELECT l.*, e.name as employee_name, u.username as reviewer_name " +
                     "FROM leaves l " +
                     "LEFT JOIN employees e ON l.employee_id = e.id " +
                     "LEFT JOIN users u ON l.reviewed_by = u.id " +
                     "WHERE l.employee_id = ? " +
                     "ORDER BY l.applied_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, employeeId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Leave leave = mapLeaveFromResultSet(rs);
                leaves.add(leave);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return leaves;
    }
    
    public List<Leave> getPendingLeaves() {
        List<Leave> leaves = new ArrayList<>();
        String sql = "SELECT l.*, e.name as employee_name, u.username as reviewer_name " +
                     "FROM leaves l " +
                     "LEFT JOIN employees e ON l.employee_id = e.id " +
                     "LEFT JOIN users u ON l.reviewed_by = u.id " +
                     "WHERE l.status = 'PENDING' " +
                     "ORDER BY l.applied_date ASC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Leave leave = mapLeaveFromResultSet(rs);
                leaves.add(leave);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return leaves;
    }
    
    public Leave getLeaveById(int id) {
        Leave leave = null;
        String sql = "SELECT l.*, e.name as employee_name, u.username as reviewer_name " +
                     "FROM leaves l " +
                     "LEFT JOIN employees e ON l.employee_id = e.id " +
                     "LEFT JOIN users u ON l.reviewed_by = u.id " +
                     "WHERE l.id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                leave = mapLeaveFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return leave;
    }
    
    public boolean createLeave(Leave leave) {
        String sql = "INSERT INTO leaves (employee_id, start_date, end_date, reason, status, applied_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, leave.getEmployeeId());
            pstmt.setDate(2, leave.getStartDate());
            pstmt.setDate(3, leave.getEndDate());
            pstmt.setString(4, leave.getReason());
            pstmt.setString(5, leave.getStatus());
            pstmt.setDate(6, leave.getAppliedDate());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateLeaveStatus(int leaveId, String status, int reviewedBy, Date reviewedDate, String comments) {
        String sql = "UPDATE leaves SET status = ?, reviewed_by = ?, reviewed_date = ?, comments = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, reviewedBy);
            pstmt.setDate(3, reviewedDate);
            pstmt.setString(4, comments);
            pstmt.setInt(5, leaveId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getPendingLeaveCount() {
        String sql = "SELECT COUNT(*) FROM leaves WHERE status = 'PENDING'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    public int getEmployeePendingLeaveCount(int employeeId) {
        String sql = "SELECT COUNT(*) FROM leaves WHERE employee_id = ? AND status = 'PENDING'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, employeeId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    private Leave mapLeaveFromResultSet(ResultSet rs) throws SQLException {
        Leave leave = new Leave();
        leave.setId(rs.getInt("id"));
        leave.setEmployeeId(rs.getInt("employee_id"));
        leave.setStartDate(rs.getDate("start_date"));
        leave.setEndDate(rs.getDate("end_date"));
        leave.setReason(rs.getString("reason"));
        leave.setStatus(rs.getString("status"));
        leave.setAppliedDate(rs.getDate("applied_date"));
        
        // These fields might be null
        leave.setReviewedBy(rs.getObject("reviewed_by") != null ? rs.getInt("reviewed_by") : null);
        leave.setReviewedDate(rs.getDate("reviewed_date"));
        leave.setComments(rs.getString("comments"));
        
        // Additional fields for display
        leave.setEmployeeName(rs.getString("employee_name"));
        leave.setReviewerName(rs.getString("reviewer_name"));
        
        return leave;
    }
}
