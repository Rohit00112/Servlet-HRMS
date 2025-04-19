package com.example.hrms.dao;

import com.example.hrms.model.Payroll;
import com.example.hrms.util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PayrollDAO {

    // Create a new payroll record
    public int createPayroll(Payroll payroll) throws SQLException {
        String sql = "INSERT INTO payroll (employee_id, month, base_salary, days_present, days_absent, " +
                "days_late, days_half, allowances, deductions, net_salary, generation_date, status, notes) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, payroll.getEmployeeId());
            stmt.setString(2, payroll.getMonth());
            stmt.setBigDecimal(3, payroll.getBaseSalary());
            stmt.setInt(4, payroll.getDaysPresent());
            stmt.setInt(5, payroll.getDaysAbsent());
            stmt.setInt(6, payroll.getDaysLate());
            stmt.setInt(7, payroll.getDaysHalf());
            stmt.setBigDecimal(8, payroll.getAllowances());
            stmt.setBigDecimal(9, payroll.getDeductions());
            stmt.setBigDecimal(10, payroll.getNetSalary());
            stmt.setDate(11, new java.sql.Date(payroll.getGenerationDate().getTime()));
            stmt.setString(12, payroll.getStatus());
            stmt.setString(13, payroll.getNotes());

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return -1;
        }
    }

    // Update an existing payroll record
    public boolean updatePayroll(Payroll payroll) throws SQLException {
        String sql = "UPDATE payroll SET base_salary = ?, days_present = ?, days_absent = ?, " +
                "days_late = ?, days_half = ?, allowances = ?, deductions = ?, net_salary = ?, " +
                "generation_date = ?, status = ?, notes = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBigDecimal(1, payroll.getBaseSalary());
            stmt.setInt(2, payroll.getDaysPresent());
            stmt.setInt(3, payroll.getDaysAbsent());
            stmt.setInt(4, payroll.getDaysLate());
            stmt.setInt(5, payroll.getDaysHalf());
            stmt.setBigDecimal(6, payroll.getAllowances());
            stmt.setBigDecimal(7, payroll.getDeductions());
            stmt.setBigDecimal(8, payroll.getNetSalary());
            stmt.setDate(9, new java.sql.Date(payroll.getGenerationDate().getTime()));
            stmt.setString(10, payroll.getStatus());
            stmt.setString(11, payroll.getNotes());
            stmt.setInt(12, payroll.getId());

            return stmt.executeUpdate() > 0;
        }
    }

    // Get a payroll record by ID
    public Payroll getPayrollById(int id) throws SQLException {
        String sql = "SELECT p.*, e.name as employee_name FROM payroll p " +
                "JOIN employees e ON p.employee_id = e.id WHERE p.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToPayroll(rs);
            }
            return null;
        }
    }

    // Get payroll records for a specific employee
    public List<Payroll> getPayrollsByEmployeeId(int employeeId) throws SQLException {
        String sql = "SELECT p.*, e.name as employee_name FROM payroll p " +
                "JOIN employees e ON p.employee_id = e.id WHERE p.employee_id = ? ORDER BY p.month DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, employeeId);
            ResultSet rs = stmt.executeQuery();

            List<Payroll> payrolls = new ArrayList<>();
            while (rs.next()) {
                payrolls.add(mapResultSetToPayroll(rs));
            }
            return payrolls;
        }
    }

    // Get payroll records for a specific month
    public List<Payroll> getPayrollsByMonth(String month) throws SQLException {
        String sql = "SELECT p.*, e.name as employee_name FROM payroll p " +
                "JOIN employees e ON p.employee_id = e.id WHERE p.month = ? ORDER BY e.name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, month);
            ResultSet rs = stmt.executeQuery();

            List<Payroll> payrolls = new ArrayList<>();
            while (rs.next()) {
                payrolls.add(mapResultSetToPayroll(rs));
            }
            return payrolls;
        }
    }

    // Get all payroll records
    public List<Payroll> getAllPayrolls() throws SQLException {
        String sql = "SELECT p.*, e.name as employee_name FROM payroll p " +
                "JOIN employees e ON p.employee_id = e.id ORDER BY p.month DESC, e.name";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            List<Payroll> payrolls = new ArrayList<>();
            while (rs.next()) {
                payrolls.add(mapResultSetToPayroll(rs));
            }
            return payrolls;
        }
    }

    // Check if a payroll record exists for an employee in a specific month
    public boolean payrollExists(int employeeId, String month) throws SQLException {
        String sql = "SELECT COUNT(*) FROM payroll WHERE employee_id = ? AND month = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, employeeId);
            stmt.setString(2, month);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    // Get a payroll record for an employee in a specific month
    public Payroll getPayrollByEmployeeAndMonth(int employeeId, String month) throws SQLException {
        String sql = "SELECT p.*, e.name as employee_name FROM payroll p " +
                "JOIN employees e ON p.employee_id = e.id WHERE p.employee_id = ? AND p.month = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, employeeId);
            stmt.setString(2, month);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToPayroll(rs);
            }
            return null;
        }
    }

    // Update payroll status
    public boolean updatePayrollStatus(int id, String status) throws SQLException {
        String sql = "UPDATE payroll SET status = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, id);

            return stmt.executeUpdate() > 0;
        }
    }

    // Delete a payroll record
    public boolean deletePayroll(int id) throws SQLException {
        String sql = "DELETE FROM payroll WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    // Get attendance summary for a specific month
    public Map<Integer, Map<String, Integer>> getAttendanceSummaryForMonth(String month) throws SQLException {
        // Extract year and month from the input string (format: YYYY-MM)
        String year = month.substring(0, 4);
        String monthNum = month.substring(5, 7);
        
        String sql = "SELECT employee_id, status, COUNT(*) as count FROM attendance " +
                "WHERE EXTRACT(YEAR FROM date) = ? AND EXTRACT(MONTH FROM date) = ? " +
                "GROUP BY employee_id, status";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, Integer.parseInt(year));
            stmt.setInt(2, Integer.parseInt(monthNum));
            ResultSet rs = stmt.executeQuery();

            Map<Integer, Map<String, Integer>> result = new HashMap<>();
            while (rs.next()) {
                int employeeId = rs.getInt("employee_id");
                String status = rs.getString("status");
                int count = rs.getInt("count");

                if (!result.containsKey(employeeId)) {
                    result.put(employeeId, new HashMap<>());
                    // Initialize all statuses to 0
                    result.get(employeeId).put("PRESENT", 0);
                    result.get(employeeId).put("ABSENT", 0);
                    result.get(employeeId).put("HALF_DAY", 0);
                    result.get(employeeId).put("LATE", 0);
                }

                result.get(employeeId).put(status, count);
            }
            return result;
        }
    }

    // Get base salary for an employee
    public BigDecimal getEmployeeBaseSalary(int employeeId) throws SQLException {
        // In a real system, this would come from an employee_salary table
        // For this example, we'll use a fixed value or the most recent payroll
        String sql = "SELECT base_salary FROM payroll WHERE employee_id = ? " +
                "ORDER BY month DESC LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, employeeId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal("base_salary");
            }
            // Default base salary if no previous record exists
            return new BigDecimal("50000.00");
        }
    }

    // Helper method to map ResultSet to Payroll object
    private Payroll mapResultSetToPayroll(ResultSet rs) throws SQLException {
        Payroll payroll = new Payroll();
        payroll.setId(rs.getInt("id"));
        payroll.setEmployeeId(rs.getInt("employee_id"));
        payroll.setEmployeeName(rs.getString("employee_name"));
        payroll.setMonth(rs.getString("month"));
        payroll.setBaseSalary(rs.getBigDecimal("base_salary"));
        payroll.setDaysPresent(rs.getInt("days_present"));
        payroll.setDaysAbsent(rs.getInt("days_absent"));
        payroll.setDaysLate(rs.getInt("days_late"));
        payroll.setDaysHalf(rs.getInt("days_half"));
        payroll.setAllowances(rs.getBigDecimal("allowances"));
        payroll.setDeductions(rs.getBigDecimal("deductions"));
        payroll.setNetSalary(rs.getBigDecimal("net_salary"));
        payroll.setGenerationDate(rs.getDate("generation_date"));
        payroll.setStatus(rs.getString("status"));
        payroll.setNotes(rs.getString("notes"));
        return payroll;
    }
}
