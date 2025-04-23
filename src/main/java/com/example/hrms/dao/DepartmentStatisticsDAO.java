package com.example.hrms.dao;

import com.example.hrms.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Data Access Object for department statistics
 */
public class DepartmentStatisticsDAO {

    /**
     * Get employee count by department
     * 
     * @return Map with department names as keys and employee counts as values
     */
    public Map<String, Integer> getEmployeeCountByDepartment() {
        Map<String, Integer> employeeCounts = new LinkedHashMap<>();
        
        String sql = "SELECT d.name, COUNT(e.id) as employee_count " +
                     "FROM departments d " +
                     "LEFT JOIN employees e ON d.id = e.department_id " +
                     "GROUP BY d.id, d.name " +
                     "ORDER BY d.name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                String departmentName = rs.getString("name");
                int count = rs.getInt("employee_count");
                employeeCounts.put(departmentName, count);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return employeeCounts;
    }
    
    /**
     * Get average salary by department
     * 
     * @return Map with department names as keys and average salaries as values
     */
    public Map<String, Double> getAverageSalaryByDepartment() {
        Map<String, Double> averageSalaries = new LinkedHashMap<>();
        
        String sql = "SELECT d.name, AVG(e.salary) as avg_salary " +
                     "FROM departments d " +
                     "LEFT JOIN employees e ON d.id = e.department_id " +
                     "GROUP BY d.id, d.name " +
                     "ORDER BY d.name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                String departmentName = rs.getString("name");
                double avgSalary = rs.getDouble("avg_salary");
                averageSalaries.put(departmentName, avgSalary);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return averageSalaries;
    }
    
    /**
     * Get leave usage by department
     * 
     * @return Map with department names as keys and total leave days as values
     */
    public Map<String, Integer> getLeaveUsageByDepartment() {
        Map<String, Integer> leaveUsage = new LinkedHashMap<>();
        
        // Get the current year
        int currentYear = java.time.LocalDate.now().getYear();
        
        String sql = "SELECT d.name, COALESCE(SUM(l.end_date - l.start_date + 1), 0) as leave_days " +
                     "FROM departments d " +
                     "LEFT JOIN employees e ON d.id = e.department_id " +
                     "LEFT JOIN leaves l ON e.id = l.employee_id AND l.status = 'APPROVED' AND EXTRACT(YEAR FROM l.start_date) = ? " +
                     "GROUP BY d.id, d.name " +
                     "ORDER BY d.name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, currentYear);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String departmentName = rs.getString("name");
                int leaveDays = rs.getInt("leave_days");
                leaveUsage.put(departmentName, leaveDays);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return leaveUsage;
    }
    
    /**
     * Get attendance rate by department
     * 
     * @return Map with department names as keys and attendance rates as values
     */
    public Map<String, Double> getAttendanceRateByDepartment() {
        Map<String, Double> attendanceRates = new LinkedHashMap<>();
        
        // Get the current month
        int currentMonth = java.time.LocalDate.now().getMonthValue();
        int currentYear = java.time.LocalDate.now().getYear();
        
        String sql = "SELECT d.name, " +
                     "COALESCE(AVG(CASE WHEN a.status = 'PRESENT' THEN 100 " +
                     "WHEN a.status = 'HALF_DAY' THEN 50 " +
                     "WHEN a.status = 'LATE' THEN 75 " +
                     "ELSE 0 END), 0) as attendance_rate " +
                     "FROM departments d " +
                     "LEFT JOIN employees e ON d.id = e.department_id " +
                     "LEFT JOIN attendance a ON e.id = a.employee_id AND EXTRACT(MONTH FROM a.date) = ? AND EXTRACT(YEAR FROM a.date) = ? " +
                     "GROUP BY d.id, d.name " +
                     "ORDER BY d.name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, currentMonth);
            pstmt.setInt(2, currentYear);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String departmentName = rs.getString("name");
                double attendanceRate = rs.getDouble("attendance_rate");
                attendanceRates.put(departmentName, attendanceRate);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return attendanceRates;
    }
    
    /**
     * Get gender distribution by department
     * 
     * @return Map with department names as keys and gender distribution maps as values
     */
    public Map<String, Map<String, Integer>> getGenderDistributionByDepartment() {
        Map<String, Map<String, Integer>> genderDistribution = new LinkedHashMap<>();
        
        String sql = "SELECT d.name, e.gender, COUNT(e.id) as count " +
                     "FROM departments d " +
                     "LEFT JOIN employees e ON d.id = e.department_id " +
                     "WHERE e.id IS NOT NULL " +
                     "GROUP BY d.id, d.name, e.gender " +
                     "ORDER BY d.name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            String currentDepartment = null;
            Map<String, Integer> genderCounts = null;
            
            while (rs.next()) {
                String departmentName = rs.getString("name");
                String gender = rs.getString("gender");
                int count = rs.getInt("count");
                
                if (!departmentName.equals(currentDepartment)) {
                    currentDepartment = departmentName;
                    genderCounts = new HashMap<>();
                    genderDistribution.put(departmentName, genderCounts);
                }
                
                genderCounts.put(gender, count);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return genderDistribution;
    }
}
