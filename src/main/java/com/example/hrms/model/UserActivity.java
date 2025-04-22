package com.example.hrms.model;

import java.sql.Timestamp;

public class UserActivity {
    private int id;
    private int userId;
    private String username;
    private String userRole;
    private String activityType; // LOGIN, LOGOUT, CREATE, UPDATE, DELETE, APPROVE, REJECT, etc.
    private String description;
    private String entityType; // EMPLOYEE, LEAVE, ATTENDANCE, PAYROLL, etc.
    private Integer entityId; // ID of the related entity (if applicable)
    private Timestamp timestamp;
    private String ipAddress;

    public UserActivity() {
    }

    public UserActivity(int userId, String username, String userRole, String activityType, 
                        String description, String entityType, Integer entityId, 
                        Timestamp timestamp, String ipAddress) {
        this.userId = userId;
        this.username = username;
        this.userRole = userRole;
        this.activityType = activityType;
        this.description = description;
        this.entityType = entityType;
        this.entityId = entityId;
        this.timestamp = timestamp;
        this.ipAddress = ipAddress;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getEntityType() {
        return entityType;
    }

    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }

    public Integer getEntityId() {
        return entityId;
    }

    public void setEntityId(Integer entityId) {
        this.entityId = entityId;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    @Override
    public String toString() {
        return "UserActivity{" +
                "id=" + id +
                ", userId=" + userId +
                ", username='" + username + '\'' +
                ", userRole='" + userRole + '\'' +
                ", activityType='" + activityType + '\'' +
                ", description='" + description + '\'' +
                ", entityType='" + entityType + '\'' +
                ", entityId=" + entityId +
                ", timestamp=" + timestamp +
                ", ipAddress='" + ipAddress + '\'' +
                '}';
    }
    
    // Helper method to get a formatted timestamp for display
    public String getFormattedTimestamp() {
        if (timestamp == null) {
            return "";
        }
        
        // Format: "2 hours ago", "Yesterday at 3:45 PM", "April 15, 2023"
        long now = System.currentTimeMillis();
        long diff = now - timestamp.getTime();
        
        // Less than a minute
        if (diff < 60 * 1000) {
            return "Just now";
        }
        
        // Less than an hour
        if (diff < 60 * 60 * 1000) {
            long minutes = diff / (60 * 1000);
            return minutes + " minute" + (minutes > 1 ? "s" : "") + " ago";
        }
        
        // Less than a day
        if (diff < 24 * 60 * 60 * 1000) {
            long hours = diff / (60 * 60 * 1000);
            return hours + " hour" + (hours > 1 ? "s" : "") + " ago";
        }
        
        // Less than a week
        if (diff < 7 * 24 * 60 * 60 * 1000) {
            long days = diff / (24 * 60 * 60 * 1000);
            if (days == 1) {
                return "Yesterday";
            } else {
                return days + " days ago";
            }
        }
        
        // Format as date
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
        return sdf.format(timestamp);
    }
    
    // Helper method to get an icon class based on activity type
    public String getIconClass() {
        switch (activityType) {
            case "LOGIN":
                return "login";
            case "LOGOUT":
                return "logout";
            case "CREATE":
                return "plus";
            case "UPDATE":
                return "pencil";
            case "DELETE":
                return "trash";
            case "APPROVE":
                return "check";
            case "REJECT":
                return "x";
            case "VIEW":
                return "eye";
            case "DOWNLOAD":
                return "download";
            case "UPLOAD":
                return "upload";
            case "MARK_ATTENDANCE":
                return "clock";
            case "APPLY_LEAVE":
                return "calendar";
            case "GENERATE_PAYROLL":
                return "currency-dollar";
            default:
                return "information-circle";
        }
    }
    
    // Helper method to get a color class based on activity type
    public String getColorClass() {
        switch (activityType) {
            case "LOGIN":
            case "CREATE":
            case "APPROVE":
                return "green";
            case "LOGOUT":
            case "DELETE":
            case "REJECT":
                return "red";
            case "UPDATE":
            case "MARK_ATTENDANCE":
                return "blue";
            case "VIEW":
            case "DOWNLOAD":
                return "indigo";
            case "UPLOAD":
            case "APPLY_LEAVE":
                return "purple";
            case "GENERATE_PAYROLL":
                return "yellow";
            default:
                return "gray";
        }
    }
}
