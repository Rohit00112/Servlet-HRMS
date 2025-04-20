package com.example.hrms.dao;

import com.example.hrms.model.Attendance;
import com.example.hrms.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
}
