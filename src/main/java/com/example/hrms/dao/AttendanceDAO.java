package com.example.hrms.dao;

import com.example.hrms.model.Attendance;
import com.example.hrms.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Date;
import java.time.LocalDate;
import java.time.DayOfWeek;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;

public class AttendanceDAO {

    public List<Attendance> getAllAttendance() {
        List<Attendance> attendanceList = new ArrayList<>();
        String sql = "SELECT a.*, e.name as employee_name, d.name as department_name " +
                     "FROM attendance a " +
                     "JOIN employees e ON a.employee_id = e.id " +
                     "LEFT JOIN departments d ON e.department_id = d.id " +
                     "ORDER BY a.date DESC, e.name ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Attendance attendance = mapAttendanceFromResultSet(rs);
                attendanceList.add(attendance);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return attendanceList;
    }

    public List<Attendance> getAttendanceByEmployeeId(int employeeId) {
        List<Attendance> attendanceList = new ArrayList<>();
        String sql = "SELECT a.*, e.name as employee_name, d.name as department_name " +
                     "FROM attendance a " +
                     "JOIN employees e ON a.employee_id = e.id " +
                     "LEFT JOIN departments d ON e.department_id = d.id " +
                     "WHERE a.employee_id = ? " +
                     "ORDER BY a.date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Attendance attendance = mapAttendanceFromResultSet(rs);
                attendanceList.add(attendance);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return attendanceList;
    }

    public List<Attendance> getAttendanceByDepartmentId(int departmentId) {
        List<Attendance> attendanceList = new ArrayList<>();
        String sql = "SELECT a.*, e.name as employee_name, d.name as department_name " +
                     "FROM attendance a " +
                     "JOIN employees e ON a.employee_id = e.id " +
                     "LEFT JOIN departments d ON e.department_id = d.id " +
                     "WHERE e.department_id = ? " +
                     "ORDER BY a.date DESC, e.name ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, departmentId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Attendance attendance = mapAttendanceFromResultSet(rs);
                attendanceList.add(attendance);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return attendanceList;
    }

    public List<Attendance> getAttendanceByDateRange(Date startDate, Date endDate) {
        List<Attendance> attendanceList = new ArrayList<>();
        String sql = "SELECT a.*, e.name as employee_name, d.name as department_name " +
                     "FROM attendance a " +
                     "JOIN employees e ON a.employee_id = e.id " +
                     "LEFT JOIN departments d ON e.department_id = d.id " +
                     "WHERE a.date BETWEEN ? AND ? " +
                     "ORDER BY a.date DESC, e.name ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDate(1, startDate);
            pstmt.setDate(2, endDate);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Attendance attendance = mapAttendanceFromResultSet(rs);
                attendanceList.add(attendance);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return attendanceList;
    }

    public List<Attendance> getAttendanceByEmployeeAndDateRange(int employeeId, Date startDate, Date endDate) {
        List<Attendance> attendanceList = new ArrayList<>();
        String sql = "SELECT a.*, e.name as employee_name, d.name as department_name " +
                     "FROM attendance a " +
                     "JOIN employees e ON a.employee_id = e.id " +
                     "LEFT JOIN departments d ON e.department_id = d.id " +
                     "WHERE a.employee_id = ? AND a.date BETWEEN ? AND ? " +
                     "ORDER BY a.date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            pstmt.setDate(2, startDate);
            pstmt.setDate(3, endDate);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Attendance attendance = mapAttendanceFromResultSet(rs);
                attendanceList.add(attendance);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return attendanceList;
    }

    public Attendance getAttendanceByEmployeeAndDate(int employeeId, Date date) {
        Attendance attendance = null;
        String sql = "SELECT a.*, e.name as employee_name, d.name as department_name " +
                     "FROM attendance a " +
                     "JOIN employees e ON a.employee_id = e.id " +
                     "LEFT JOIN departments d ON e.department_id = d.id " +
                     "WHERE a.employee_id = ? AND a.date = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            pstmt.setDate(2, date);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                attendance = mapAttendanceFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return attendance;
    }

    public boolean markAttendance(Attendance attendance) {
        String sql = "INSERT INTO attendance (employee_id, date, check_in_time, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?) " +
                     "ON CONFLICT (employee_id, date) DO UPDATE " +
                     "SET check_in_time = EXCLUDED.check_in_time, status = EXCLUDED.status, notes = EXCLUDED.notes";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, attendance.getEmployeeId());
            pstmt.setDate(2, attendance.getDate());
            pstmt.setTime(3, attendance.getCheckInTime());
            pstmt.setString(4, attendance.getStatus());
            pstmt.setString(5, attendance.getNotes());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markCheckOut(int employeeId, Date date, Time checkOutTime) {
        String sql = "UPDATE attendance SET check_out_time = ? WHERE employee_id = ? AND date = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setTime(1, checkOutTime);
            pstmt.setInt(2, employeeId);
            pstmt.setDate(3, date);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateAttendanceStatus(int employeeId, Date date, String status, String notes) {
        String sql = "UPDATE attendance SET status = ?, notes = ? WHERE employee_id = ? AND date = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setString(2, notes);
            pstmt.setInt(3, employeeId);
            pstmt.setDate(4, date);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, Integer> getAttendanceStatsByEmployeeId(int employeeId, Date startDate, Date endDate) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("PRESENT", 0);
        stats.put("ABSENT", 0);
        stats.put("HALF_DAY", 0);
        stats.put("LATE", 0);
        stats.put("TOTAL", 0);

        String sql = "SELECT status, COUNT(*) as count " +
                     "FROM attendance " +
                     "WHERE employee_id = ? AND date BETWEEN ? AND ? " +
                     "GROUP BY status";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            pstmt.setDate(2, startDate);
            pstmt.setDate(3, endDate);
            ResultSet rs = pstmt.executeQuery();

            int total = 0;
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");
                stats.put(status, count);
                total += count;
            }
            stats.put("TOTAL", total);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * Get the attendance rate for an employee for the current month
     *
     * @param employeeId The employee ID
     * @return The attendance rate as a percentage
     */
    public double getEmployeeAttendanceRate(int employeeId) {
        // Get the current month's start and end dates
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.LocalDate firstDayOfMonth = today.withDayOfMonth(1);
        java.time.LocalDate lastDayOfMonth = today.withDayOfMonth(today.lengthOfMonth());

        // Convert to SQL Date
        Date startDate = Date.valueOf(firstDayOfMonth);
        Date endDate = Date.valueOf(lastDayOfMonth);

        // Use the existing method to calculate attendance percentage
        return getAttendancePercentage(employeeId, startDate, endDate);
    }

    /**
     * Get the change in attendance rate compared to previous period
     *
     * @param employeeId The employee ID
     * @return The change in attendance rate (positive means increase, negative means decrease)
     */
    public double getAttendanceRateChange(int employeeId) {
        // Get current month's attendance rate
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.LocalDate firstDayOfMonth = today.withDayOfMonth(1);
        java.time.LocalDate lastDayOfMonth = today.withDayOfMonth(today.lengthOfMonth());

        // Get previous month's dates
        java.time.LocalDate firstDayOfPrevMonth = firstDayOfMonth.minusMonths(1);
        java.time.LocalDate lastDayOfPrevMonth = firstDayOfPrevMonth.withDayOfMonth(
                firstDayOfPrevMonth.lengthOfMonth());

        // Calculate attendance rates
        double currentRate = getAttendancePercentage(employeeId,
                Date.valueOf(firstDayOfMonth),
                Date.valueOf(lastDayOfMonth));

        double previousRate = getAttendancePercentage(employeeId,
                Date.valueOf(firstDayOfPrevMonth),
                Date.valueOf(lastDayOfPrevMonth));

        // Calculate the change (can be positive or negative)
        return currentRate - previousRate;
    }

    public double getAttendancePercentage(int employeeId, Date startDate, Date endDate) {
        Map<String, Integer> stats = getAttendanceStatsByEmployeeId(employeeId, startDate, endDate);
        int present = stats.get("PRESENT") + stats.get("LATE");
        int halfDay = stats.get("HALF_DAY");
        int total = stats.get("TOTAL");

        if (total == 0) {
            return 0.0;
        }

        return ((present + (halfDay * 0.5)) / total) * 100;
    }

    public int getAttendanceCountByStatusAndDate(String status, String date) throws SQLException {
        String sql = "SELECT COUNT(*) FROM attendance WHERE status = ? AND date = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setDate(2, Date.valueOf(date));
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

        return 0;
    }

    private Attendance mapAttendanceFromResultSet(ResultSet rs) throws SQLException {
        Attendance attendance = new Attendance();
        attendance.setId(rs.getInt("id"));
        attendance.setEmployeeId(rs.getInt("employee_id"));
        attendance.setDate(rs.getDate("date"));
        attendance.setCheckInTime(rs.getTime("check_in_time"));
        attendance.setCheckOutTime(rs.getTime("check_out_time"));
        attendance.setStatus(rs.getString("status"));
        attendance.setNotes(rs.getString("notes"));

        // Additional fields for display
        attendance.setEmployeeName(rs.getString("employee_name"));
        attendance.setDepartmentName(rs.getString("department_name"));

        return attendance;
    }

    /**
     * Get attendance data for the last 7 days for a specific employee
     *
     * @param employeeId The employee ID
     * @return Map with day names as keys and attendance status as values
     */
    public Map<String, String> getWeeklyAttendanceData(int employeeId) {
        Map<String, String> weeklyData = new LinkedHashMap<>(); // LinkedHashMap to maintain order

        // Get the last 7 days
        LocalDate today = LocalDate.now();
        LocalDate sevenDaysAgo = today.minusDays(6); // 7 days including today

        // Initialize the map with the last 7 days
        for (int i = 0; i < 7; i++) {
            LocalDate date = sevenDaysAgo.plusDays(i);
            String dayName = date.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
            weeklyData.put(dayName, "ABSENT"); // Default to absent
        }

        // Query to get attendance for the last 7 days
        String sql = "SELECT date, status FROM attendance " +
                     "WHERE employee_id = ? AND date BETWEEN ? AND ? " +
                     "ORDER BY date ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            pstmt.setDate(2, Date.valueOf(sevenDaysAgo));
            pstmt.setDate(3, Date.valueOf(today));

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Date date = rs.getDate("date");
                String status = rs.getString("status");

                // Convert SQL date to LocalDate
                LocalDate localDate = date.toLocalDate();
                String dayName = localDate.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);

                // Update the map with actual status
                weeklyData.put(dayName, status);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return weeklyData;
    }

    /**
     * Get monthly attendance data for a specific employee
     *
     * @param employeeId The employee ID
     * @return Map with status types as keys and counts as values
     */
    public Map<String, Integer> getMonthlyAttendanceData(int employeeId) {
        Map<String, Integer> monthlyData = new HashMap<>();

        // Initialize with all possible statuses
        monthlyData.put("PRESENT", 0);
        monthlyData.put("ABSENT", 0);
        monthlyData.put("LATE", 0);
        monthlyData.put("HALF_DAY", 0);

        // Get the current month's start and end dates
        LocalDate today = LocalDate.now();
        LocalDate firstDayOfMonth = today.withDayOfMonth(1);
        LocalDate lastDayOfMonth = today.withDayOfMonth(today.lengthOfMonth());

        // Query to get attendance counts by status for the current month
        String sql = "SELECT status, COUNT(*) as count FROM attendance " +
                     "WHERE employee_id = ? AND date BETWEEN ? AND ? " +
                     "GROUP BY status";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, employeeId);
            pstmt.setDate(2, Date.valueOf(firstDayOfMonth));
            pstmt.setDate(3, Date.valueOf(lastDayOfMonth));

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");
                monthlyData.put(status, count);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return monthlyData;
    }

    /**
     * Get attendance trend data for the last 6 months for a specific employee
     *
     * @param employeeId The employee ID
     * @return Map with month names as keys and attendance percentages as values
     */
    public Map<String, Double> getAttendanceTrendData(int employeeId) {
        Map<String, Double> trendData = new LinkedHashMap<>(); // LinkedHashMap to maintain order

        // Get data for the last 6 months
        LocalDate today = LocalDate.now();

        for (int i = 5; i >= 0; i--) {
            LocalDate firstDayOfMonth = today.minusMonths(i).withDayOfMonth(1);
            LocalDate lastDayOfMonth = firstDayOfMonth.withDayOfMonth(
                    firstDayOfMonth.lengthOfMonth());

            String monthName = firstDayOfMonth.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);

            // Calculate attendance percentage for this month
            double percentage = getAttendancePercentage(employeeId,
                    Date.valueOf(firstDayOfMonth),
                    Date.valueOf(lastDayOfMonth));

            trendData.put(monthName, percentage);
        }

        return trendData;
    }
}
