package com.example.hrms.dao;

import com.example.hrms.model.Employee;
import com.example.hrms.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    public List<Employee> getAllEmployees() {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT e.*, d.name as department_name, ds.title as designation_title " +
                     "FROM employees e " +
                     "LEFT JOIN departments d ON e.department_id = d.id " +
                     "LEFT JOIN designations ds ON e.designation_id = ds.id " +
                     "ORDER BY e.name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Employee employee = mapEmployeeFromResultSet(rs);
                employees.add(employee);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return employees;
    }

    public Employee getEmployeeById(int id) {
        Employee employee = null;
        String sql = "SELECT e.*, d.name as department_name, ds.title as designation_title " +
                     "FROM employees e " +
                     "LEFT JOIN departments d ON e.department_id = d.id " +
                     "LEFT JOIN designations ds ON e.designation_id = ds.id " +
                     "WHERE e.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                employee = mapEmployeeFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return employee;
    }

    public boolean createEmployee(Employee employee) {
        String sql = "INSERT INTO employees (name, email, department_id, designation_id, join_date, user_id) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, employee.getName());
            pstmt.setString(2, employee.getEmail());
            pstmt.setInt(3, employee.getDepartmentId());
            pstmt.setInt(4, employee.getDesignationId());
            pstmt.setDate(5, employee.getJoinDate());

            // Set user_id (can be null)
            if (employee.getUserId() != null) {
                pstmt.setInt(6, employee.getUserId());
            } else {
                pstmt.setNull(6, java.sql.Types.INTEGER);
            }

            int rowsAffected = pstmt.executeUpdate();

            // Get the generated employee ID
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        employee.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateEmployee(Employee employee) {
        String sql = "UPDATE employees SET name = ?, email = ?, department_id = ?, designation_id = ?, join_date = ?, user_id = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, employee.getName());
            pstmt.setString(2, employee.getEmail());
            pstmt.setInt(3, employee.getDepartmentId());
            pstmt.setInt(4, employee.getDesignationId());
            pstmt.setDate(5, employee.getJoinDate());

            // Set user_id (can be null)
            if (employee.getUserId() != null) {
                pstmt.setInt(6, employee.getUserId());
            } else {
                pstmt.setNull(6, java.sql.Types.INTEGER);
            }

            pstmt.setInt(7, employee.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteEmployee(int id) {
        String sql = "DELETE FROM employees WHERE id = ?";

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

    public int getEmployeeCount() {
        String sql = "SELECT COUNT(*) FROM employees";

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

    public List<Employee> searchEmployees(String searchTerm) {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT e.*, d.name as department_name, ds.title as designation_title " +
                     "FROM employees e " +
                     "LEFT JOIN departments d ON e.department_id = d.id " +
                     "LEFT JOIN designations ds ON e.designation_id = ds.id " +
                     "WHERE e.name ILIKE ? OR e.email ILIKE ? OR d.name ILIKE ? OR ds.title ILIKE ? " +
                     "ORDER BY e.name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setString(4, searchPattern);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Employee employee = mapEmployeeFromResultSet(rs);
                employees.add(employee);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return employees;
    }

    public Employee getEmployeeByEmail(String email) {
        Employee employee = null;
        String sql = "SELECT e.*, d.name as department_name, ds.title as designation_title " +
                     "FROM employees e " +
                     "LEFT JOIN departments d ON e.department_id = d.id " +
                     "LEFT JOIN designations ds ON e.designation_id = ds.id " +
                     "WHERE e.email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                employee = mapEmployeeFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return employee;
    }

    public Employee getEmployeeByUserId(int userId) {
        Employee employee = null;
        String sql = "SELECT e.*, d.name as department_name, ds.title as designation_title " +
                     "FROM employees e " +
                     "LEFT JOIN departments d ON e.department_id = d.id " +
                     "LEFT JOIN designations ds ON e.designation_id = ds.id " +
                     "WHERE e.user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                employee = mapEmployeeFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return employee;
    }

    private Employee mapEmployeeFromResultSet(ResultSet rs) throws SQLException {
        Employee employee = new Employee();
        employee.setId(rs.getInt("id"));
        employee.setName(rs.getString("name"));
        employee.setEmail(rs.getString("email"));
        employee.setDepartmentId(rs.getInt("department_id"));
        employee.setDesignationId(rs.getInt("designation_id"));
        employee.setJoinDate(rs.getDate("join_date"));
        employee.setDepartmentName(rs.getString("department_name"));
        employee.setDesignationTitle(rs.getString("designation_title"));

        // Handle user_id which can be null
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            employee.setUserId(userId);
        }

        return employee;
    }
}
