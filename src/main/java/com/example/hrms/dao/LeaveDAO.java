package com.example.hrms.dao;

import com.example.hrms.model.Leave;
import com.example.hrms.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.Month;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class LeaveDAO {

    // Default annual leave quota for employees (in days)
    private static final int DEFAULT_ANNUAL_LEAVE_QUOTA = 21;

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
        return getLeaveCountByStatus("PENDING");
    }

    public int getLeaveCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM leaves WHERE status = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();

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

    /**
     * Get the leave balance for an employee
     *
     * @param employeeId The employee ID
     * @return The number of leave days remaining
     */
    public int getEmployeeLeaveBalance(int employeeId) {
        // Get the current year
        int currentYear = java.time.LocalDate.now().getYear();

        // Calculate the total approved leave days taken this year
        String sql = "SELECT COALESCE(SUM(end_date - start_date + 1), 0) AS days_taken " +
                     "FROM leaves " +
                     "WHERE employee_id = ? AND status = 'APPROVED' " +
                     "AND EXTRACT(YEAR FROM start_date) = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            pstmt.setInt(2, currentYear);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                int daysTaken = rs.getInt("days_taken");
                return DEFAULT_ANNUAL_LEAVE_QUOTA - daysTaken;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // If there's an error or no leaves taken, return the default quota
        return DEFAULT_ANNUAL_LEAVE_QUOTA;
    }

    /**
     * Get the change in leave balance compared to previous period
     *
     * @param employeeId The employee ID
     * @return The change in leave balance (positive means increase, negative means decrease)
     */
    public int getLeaveBalanceChange(int employeeId) {
        // Get the current year and previous year
        int currentYear = java.time.LocalDate.now().getYear();
        int previousYear = currentYear - 1;

        // Calculate the total approved leave days taken this year
        String currentYearSql = "SELECT COALESCE(SUM(end_date - start_date + 1), 0) AS days_taken " +
                         "FROM leaves " +
                         "WHERE employee_id = ? AND status = 'APPROVED' " +
                         "AND EXTRACT(YEAR FROM start_date) = ?";

        // Calculate the total approved leave days taken last year
        String previousYearSql = "SELECT COALESCE(SUM(end_date - start_date + 1), 0) AS days_taken " +
                         "FROM leaves " +
                         "WHERE employee_id = ? AND status = 'APPROVED' " +
                         "AND EXTRACT(YEAR FROM start_date) = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement currentYearStmt = conn.prepareStatement(currentYearSql);
             PreparedStatement previousYearStmt = conn.prepareStatement(previousYearSql)) {

            // Get current year leave days
            currentYearStmt.setInt(1, employeeId);
            currentYearStmt.setInt(2, currentYear);
            ResultSet currentYearRs = currentYearStmt.executeQuery();

            // Get previous year leave days
            previousYearStmt.setInt(1, employeeId);
            previousYearStmt.setInt(2, previousYear);
            ResultSet previousYearRs = previousYearStmt.executeQuery();

            int currentYearDaysTaken = 0;
            int previousYearDaysTaken = 0;

            if (currentYearRs.next()) {
                currentYearDaysTaken = currentYearRs.getInt("days_taken");
            }

            if (previousYearRs.next()) {
                previousYearDaysTaken = previousYearRs.getInt("days_taken");
            }

            // Calculate the difference (positive means more leave days available)
            return previousYearDaysTaken - currentYearDaysTaken;

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

    /**
     * Get leave usage by month for the current year
     *
     * @param employeeId The employee ID
     * @return Map with month names as keys and leave days taken as values
     */
    public Map<String, Integer> getLeaveUsageByMonth(int employeeId) {
        Map<String, Integer> leaveUsage = new LinkedHashMap<>();

        // Initialize with all months
        for (int i = 0; i < 12; i++) {
            Month month = Month.of(i + 1);
            String monthName = month.getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
            leaveUsage.put(monthName, 0);
        }

        // Get the current year
        int currentYear = java.time.LocalDate.now().getYear();

        // Query to get leave days taken by month for the current year
        String sql = "SELECT EXTRACT(MONTH FROM start_date) AS month, " +
                     "SUM(end_date - start_date + 1) AS days_taken " +
                     "FROM leaves " +
                     "WHERE employee_id = ? AND status = 'APPROVED' " +
                     "AND EXTRACT(YEAR FROM start_date) = ? " +
                     "GROUP BY EXTRACT(MONTH FROM start_date) " +
                     "ORDER BY EXTRACT(MONTH FROM start_date)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            pstmt.setInt(2, currentYear);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                int monthNum = rs.getInt("month");
                int daysTaken = rs.getInt("days_taken");

                Month month = Month.of(monthNum);
                String monthName = month.getDisplayName(TextStyle.SHORT, Locale.ENGLISH);

                leaveUsage.put(monthName, daysTaken);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return leaveUsage;
    }

    /**
     * Get leave usage by type for the current year
     *
     * @param employeeId The employee ID
     * @return Map with leave types as keys and counts as values
     */
    public Map<String, Integer> getLeaveUsageByType(int employeeId) {
        // Use LinkedHashMap to maintain insertion order for consistent display
        Map<String, Integer> leaveTypes = new LinkedHashMap<>();

        // Initialize with common leave types in a specific order
        leaveTypes.put("Annual", 0);
        leaveTypes.put("Sick", 0);
        leaveTypes.put("Personal", 0);
        leaveTypes.put("Other", 0);

        // Get the current year
        int currentYear = java.time.LocalDate.now().getYear();

        // For this example, we'll categorize leaves based on the reason field
        // In a real system, you would have a separate leave_type field
        String sql = "SELECT reason, SUM(end_date - start_date + 1) AS days_taken " +
                     "FROM leaves " +
                     "WHERE employee_id = ? AND status = 'APPROVED' " +
                     "AND EXTRACT(YEAR FROM start_date) = ? " +
                     "GROUP BY reason";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            pstmt.setInt(2, currentYear);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                String reason = rs.getString("reason").toLowerCase();
                int daysTaken = rs.getInt("days_taken");

                // Categorize based on keywords in the reason
                if (reason.contains("sick") || reason.contains("illness") || reason.contains("medical")) {
                    leaveTypes.put("Sick", leaveTypes.get("Sick") + daysTaken);
                } else if (reason.contains("vacation") || reason.contains("holiday") || reason.contains("annual")) {
                    leaveTypes.put("Annual", leaveTypes.get("Annual") + daysTaken);
                } else if (reason.contains("personal") || reason.contains("family")) {
                    leaveTypes.put("Personal", leaveTypes.get("Personal") + daysTaken);
                } else {
                    leaveTypes.put("Other", leaveTypes.get("Other") + daysTaken);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return leaveTypes;
    }

    /**
     * Get leave status distribution for an employee
     *
     * @param employeeId The employee ID
     * @return Map with status types as keys and counts as values
     */
    public Map<String, Integer> getLeaveStatusDistribution(int employeeId) {
        // Use LinkedHashMap to maintain insertion order for consistent display
        Map<String, Integer> statusDistribution = new LinkedHashMap<>();

        // Initialize with all status types in a specific order
        statusDistribution.put("APPROVED", 0);
        statusDistribution.put("PENDING", 0);
        statusDistribution.put("REJECTED", 0);

        // Get the current year
        int currentYear = java.time.LocalDate.now().getYear();

        // Query to get leave count by status for the current year
        String sql = "SELECT status, COUNT(*) as count " +
                     "FROM leaves " +
                     "WHERE employee_id = ? " +
                     "AND EXTRACT(YEAR FROM start_date) = ? " +
                     "GROUP BY status";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            pstmt.setInt(2, currentYear);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");

                statusDistribution.put(status, count);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return statusDistribution;
    }
}
