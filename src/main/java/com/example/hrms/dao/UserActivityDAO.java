package com.example.hrms.dao;

import com.example.hrms.model.UserActivity;
import com.example.hrms.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserActivityDAO {

    /**
     * Log a user activity
     * 
     * @param activity The activity to log
     * @return true if the activity was logged successfully, false otherwise
     */
    public boolean logActivity(UserActivity activity) {
        String sql = "INSERT INTO user_activities (user_id, username, user_role, activity_type, description, " +
                     "entity_type, entity_id, timestamp, ip_address) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, activity.getUserId());
            pstmt.setString(2, activity.getUsername());
            pstmt.setString(3, activity.getUserRole());
            pstmt.setString(4, activity.getActivityType());
            pstmt.setString(5, activity.getDescription());
            pstmt.setString(6, activity.getEntityType());
            
            if (activity.getEntityId() != null) {
                pstmt.setInt(7, activity.getEntityId());
            } else {
                pstmt.setNull(7, Types.INTEGER);
            }
            
            pstmt.setTimestamp(8, activity.getTimestamp());
            pstmt.setString(9, activity.getIpAddress());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Create a user activity with the current timestamp
     * 
     * @param userId The user ID
     * @param username The username
     * @param userRole The user role
     * @param activityType The activity type
     * @param description The activity description
     * @param entityType The entity type
     * @param entityId The entity ID
     * @param ipAddress The IP address
     * @return true if the activity was logged successfully, false otherwise
     */
    public boolean logActivity(int userId, String username, String userRole, String activityType,
                              String description, String entityType, Integer entityId, String ipAddress) {
        UserActivity activity = new UserActivity();
        activity.setUserId(userId);
        activity.setUsername(username);
        activity.setUserRole(userRole);
        activity.setActivityType(activityType);
        activity.setDescription(description);
        activity.setEntityType(entityType);
        activity.setEntityId(entityId);
        activity.setTimestamp(new Timestamp(System.currentTimeMillis()));
        activity.setIpAddress(ipAddress);
        
        return logActivity(activity);
    }

    /**
     * Get recent activities for a specific user
     * 
     * @param userId The user ID
     * @param limit The maximum number of activities to return
     * @return A list of recent activities
     */
    public List<UserActivity> getRecentActivitiesByUserId(int userId, int limit) {
        List<UserActivity> activities = new ArrayList<>();
        String sql = "SELECT * FROM user_activities WHERE user_id = ? ORDER BY timestamp DESC LIMIT ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                UserActivity activity = mapActivityFromResultSet(rs);
                activities.add(activity);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return activities;
    }

    /**
     * Get recent activities for all users
     * 
     * @param limit The maximum number of activities to return
     * @return A list of recent activities
     */
    public List<UserActivity> getRecentActivities(int limit) {
        List<UserActivity> activities = new ArrayList<>();
        String sql = "SELECT * FROM user_activities ORDER BY timestamp DESC LIMIT ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                UserActivity activity = mapActivityFromResultSet(rs);
                activities.add(activity);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return activities;
    }

    /**
     * Get recent activities for a specific role
     * 
     * @param role The user role
     * @param limit The maximum number of activities to return
     * @return A list of recent activities
     */
    public List<UserActivity> getRecentActivitiesByRole(String role, int limit) {
        List<UserActivity> activities = new ArrayList<>();
        String sql = "SELECT * FROM user_activities WHERE user_role = ? ORDER BY timestamp DESC LIMIT ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, role);
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                UserActivity activity = mapActivityFromResultSet(rs);
                activities.add(activity);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return activities;
    }

    /**
     * Get recent activities for a specific entity type
     * 
     * @param entityType The entity type
     * @param limit The maximum number of activities to return
     * @return A list of recent activities
     */
    public List<UserActivity> getRecentActivitiesByEntityType(String entityType, int limit) {
        List<UserActivity> activities = new ArrayList<>();
        String sql = "SELECT * FROM user_activities WHERE entity_type = ? ORDER BY timestamp DESC LIMIT ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, entityType);
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                UserActivity activity = mapActivityFromResultSet(rs);
                activities.add(activity);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return activities;
    }

    /**
     * Get recent activities for a specific entity
     * 
     * @param entityType The entity type
     * @param entityId The entity ID
     * @param limit The maximum number of activities to return
     * @return A list of recent activities
     */
    public List<UserActivity> getRecentActivitiesByEntity(String entityType, int entityId, int limit) {
        List<UserActivity> activities = new ArrayList<>();
        String sql = "SELECT * FROM user_activities WHERE entity_type = ? AND entity_id = ? ORDER BY timestamp DESC LIMIT ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, entityType);
            pstmt.setInt(2, entityId);
            pstmt.setInt(3, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                UserActivity activity = mapActivityFromResultSet(rs);
                activities.add(activity);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return activities;
    }

    private UserActivity mapActivityFromResultSet(ResultSet rs) throws SQLException {
        UserActivity activity = new UserActivity();
        activity.setId(rs.getInt("id"));
        activity.setUserId(rs.getInt("user_id"));
        activity.setUsername(rs.getString("username"));
        activity.setUserRole(rs.getString("user_role"));
        activity.setActivityType(rs.getString("activity_type"));
        activity.setDescription(rs.getString("description"));
        activity.setEntityType(rs.getString("entity_type"));
        
        // Handle null entity_id
        int entityId = rs.getInt("entity_id");
        if (!rs.wasNull()) {
            activity.setEntityId(entityId);
        }
        
        activity.setTimestamp(rs.getTimestamp("timestamp"));
        activity.setIpAddress(rs.getString("ip_address"));
        return activity;
    }
}
