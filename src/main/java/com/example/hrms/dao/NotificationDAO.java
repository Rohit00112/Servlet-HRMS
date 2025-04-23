package com.example.hrms.dao;

import com.example.hrms.model.Notification;
import com.example.hrms.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    /**
     * Get unread notifications for an employee
     *
     * @param employeeId The employee ID
     * @return List of unread notifications
     */
    public List<Notification> getNotificationsByEmployeeId(int employeeId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE employee_id = ? AND is_read = false ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Notification notification = mapNotificationFromResultSet(rs);
                notifications.add(notification);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return notifications;
    }

    /**
     * Get all notifications for an employee with pagination
     *
     * @param employeeId The employee ID
     * @param limit Maximum number of notifications to return
     * @param offset Offset for pagination
     * @return List of notifications
     */
    public List<Notification> getAllNotificationsByEmployeeId(int employeeId, int limit, int offset) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE employee_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            pstmt.setInt(2, limit);
            pstmt.setInt(3, offset);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Notification notification = mapNotificationFromResultSet(rs);
                notifications.add(notification);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return notifications;
    }

    /**
     * Get total count of notifications for an employee
     *
     * @param employeeId The employee ID
     * @return Total count of notifications
     */
    public int getTotalNotificationCount(int employeeId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE employee_id = ?";

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

    public int getUnreadNotificationCount(int employeeId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE employee_id = ? AND is_read = false";

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

    /**
     * Mark a notification as read
     *
     * @param notificationId The notification ID
     * @return true if the notification was marked as read successfully, false otherwise
     */
    public boolean markNotificationAsRead(int notificationId) {
        String sql = "UPDATE notifications SET is_read = true WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, notificationId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Mark all notifications as read for an employee
     *
     * @param employeeId The employee ID
     * @return true if the notifications were marked as read successfully, false otherwise
     */
    public boolean markAllNotificationsAsRead(int employeeId) {
        String sql = "UPDATE notifications SET is_read = true WHERE employee_id = ? AND is_read = false";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            int rowsAffected = pstmt.executeUpdate();

            // Log for debugging
            System.out.println("Marked " + rowsAffected + " notifications as read for employee ID: " + employeeId);

            // Return true even if no rows were affected (no unread notifications)
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createNotification(Notification notification) {
        String sql = "INSERT INTO notifications (employee_id, title, message, type, is_read, created_at) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, notification.getEmployeeId());
            pstmt.setString(2, notification.getTitle());
            pstmt.setString(3, notification.getMessage());
            pstmt.setString(4, notification.getType());
            pstmt.setBoolean(5, notification.isRead());
            pstmt.setTimestamp(6, notification.getCreatedAt());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Create a notification for an employee with the current timestamp
     *
     * @param employeeId The employee ID
     * @param title The notification title
     * @param message The notification message
     * @param type The notification type (INFO, SUCCESS, WARNING, ERROR)
     * @return true if the notification was created successfully, false otherwise
     */
    public boolean createNotification(int employeeId, String title, String message, String type) {
        Notification notification = new Notification();
        notification.setEmployeeId(employeeId);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setType(type);
        notification.setRead(false);
        notification.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        return createNotification(notification);
    }

    /**
     * Create a leave status notification
     *
     * @param employeeId The employee ID
     * @param status The leave status (APPROVED, REJECTED)
     * @param startDate The leave start date
     * @param endDate The leave end date
     * @return true if the notification was created successfully, false otherwise
     */
    public boolean createLeaveStatusNotification(int employeeId, String status, Date startDate, Date endDate) {
        String title = "Leave Request " + status;
        String message = "Your leave request for " + startDate + " to " + endDate + " has been " + status.toLowerCase() + ".";
        String type = status.equals("APPROVED") ? "SUCCESS" : "WARNING";

        return createNotification(employeeId, title, message, type);
    }

    /**
     * Create a payslip notification
     *
     * @param employeeId The employee ID
     * @param month The payroll month
     * @return true if the notification was created successfully, false otherwise
     */
    public boolean createPayslipNotification(int employeeId, String month) {
        String title = "Payslip Generated";
        String message = "Your payslip for " + month + " is now available.";
        String type = "INFO";

        return createNotification(employeeId, title, message, type);
    }

    /**
     * Create an attendance notification
     *
     * @param employeeId The employee ID
     * @param status The attendance status (PRESENT, LATE, etc.)
     * @param checkInTime The check-in time
     * @return true if the notification was created successfully, false otherwise
     */
    public boolean createAttendanceNotification(int employeeId, String status, Time checkInTime) {
        String title = "Attendance Marked";
        String message = "You checked in at " + checkInTime + " today.";
        String type = status.equals("LATE") ? "WARNING" : "INFO";

        return createNotification(employeeId, title, message, type);
    }

    private Notification mapNotificationFromResultSet(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setId(rs.getInt("id"));
        notification.setEmployeeId(rs.getInt("employee_id"));
        notification.setTitle(rs.getString("title"));
        notification.setMessage(rs.getString("message"));
        notification.setType(rs.getString("type"));
        notification.setRead(rs.getBoolean("is_read"));
        notification.setCreatedAt(rs.getTimestamp("created_at"));
        return notification;
    }
}
