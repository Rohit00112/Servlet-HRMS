package com.example.hrms.service;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.PayrollDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.Payroll;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class PayrollService {
    private PayrollDAO payrollDAO;
    private EmployeeDAO employeeDAO;

    public PayrollService() {
        this.payrollDAO = new PayrollDAO();
        this.employeeDAO = new EmployeeDAO();
    }

    // Generate payroll for a specific employee and month
    public Payroll generatePayroll(int employeeId, String month) throws SQLException {
        // Check if payroll already exists
        if (payrollDAO.payrollExists(employeeId, month)) {
            return payrollDAO.getPayrollByEmployeeAndMonth(employeeId, month);
        }

        // Get attendance summary for the month
        Map<Integer, Map<String, Integer>> attendanceSummary = payrollDAO.getAttendanceSummaryForMonth(month);

        // Get employee's base salary
        BigDecimal baseSalary = payrollDAO.getEmployeeBaseSalary(employeeId);

        // Create new payroll
        Payroll payroll = new Payroll();
        payroll.setEmployeeId(employeeId);
        payroll.setMonth(month);
        payroll.setBaseSalary(baseSalary);
        payroll.setGenerationDate(new Date());
        payroll.setStatus("DRAFT");

        // Set attendance data
        if (attendanceSummary.containsKey(employeeId)) {
            Map<String, Integer> employeeAttendance = attendanceSummary.get(employeeId);
            payroll.setDaysPresent(employeeAttendance.getOrDefault("PRESENT", 0));
            payroll.setDaysAbsent(employeeAttendance.getOrDefault("ABSENT", 0));
            payroll.setDaysLate(employeeAttendance.getOrDefault("LATE", 0));
            payroll.setDaysHalf(employeeAttendance.getOrDefault("HALF_DAY", 0));
        } else {
            // No attendance records found
            payroll.setDaysPresent(0);
            payroll.setDaysAbsent(0);
            payroll.setDaysLate(0);
            payroll.setDaysHalf(0);
        }

        // Calculate net salary
        calculateNetSalary(payroll);

        // Save to database
        int payrollId = payrollDAO.createPayroll(payroll);
        payroll.setId(payrollId);

        return payroll;
    }

    // Generate payroll for all employees for a specific month
    public List<Payroll> generatePayrollForAllEmployees(String month) throws SQLException {
        List<Employee> employees = employeeDAO.getAllEmployees();
        List<Payroll> payrolls = new ArrayList<>();

        for (Employee employee : employees) {
            Payroll payroll = generatePayroll(employee.getId(), month);
            payrolls.add(payroll);
        }

        return payrolls;
    }

    // Calculate net salary based on attendance and base salary
    private void calculateNetSalary(Payroll payroll) {
        BigDecimal baseSalary = payroll.getBaseSalary();

        // Get total working days (assuming 22 working days in a month if no data)
        int totalWorkingDays = payroll.getTotalWorkingDays();
        if (totalWorkingDays == 0) {
            totalWorkingDays = 22; // Default working days in a month
        }

        // Calculate per day salary
        BigDecimal perDaySalary = baseSalary.divide(BigDecimal.valueOf(totalWorkingDays), 2, RoundingMode.HALF_UP);

        // Calculate effective working days
        BigDecimal effectiveWorkingDays = payroll.getEffectiveWorkingDays();

        // Calculate salary based on attendance
        BigDecimal attendanceSalary = perDaySalary.multiply(effectiveWorkingDays);

        // Add allowances
        BigDecimal allowances = payroll.getAllowances() != null ? payroll.getAllowances() : BigDecimal.ZERO;

        // Subtract deductions
        BigDecimal deductions = payroll.getDeductions() != null ? payroll.getDeductions() : BigDecimal.ZERO;

        // Calculate net salary
        BigDecimal netSalary = attendanceSalary.add(allowances).subtract(deductions);

        // Set net salary
        payroll.setNetSalary(netSalary.setScale(2, RoundingMode.HALF_UP));
    }

    // Update payroll
    public boolean updatePayroll(Payroll payroll) throws SQLException {
        // Recalculate net salary
        calculateNetSalary(payroll);

        // Update in database
        return payrollDAO.updatePayroll(payroll);
    }

    // Finalize payroll
    public boolean finalizePayroll(int payrollId) throws SQLException {
        return payrollDAO.updatePayrollStatus(payrollId, "FINALIZED");
    }

    // Mark payroll as paid
    public boolean markPayrollAsPaid(int payrollId) throws SQLException {
        return payrollDAO.updatePayrollStatus(payrollId, "PAID");
    }

    // Get payroll by ID
    public Payroll getPayrollById(int id) throws SQLException {
        return payrollDAO.getPayrollById(id);
    }

    // Get payrolls for an employee
    public List<Payroll> getPayrollsByEmployeeId(int employeeId) throws SQLException {
        return payrollDAO.getPayrollsByEmployeeId(employeeId);
    }

    // Get payrolls for a month
    public List<Payroll> getPayrollsByMonth(String month) throws SQLException {
        return payrollDAO.getPayrollsByMonth(month);
    }

    // Get all payrolls
    public List<Payroll> getAllPayrolls() throws SQLException {
        return payrollDAO.getAllPayrolls();
    }

    // Delete payroll
    public boolean deletePayroll(int id) throws SQLException {
        return payrollDAO.deletePayroll(id);
    }

    // Get count of payrolls by status and month
    public int getPayrollCountByStatus(String status, String month) throws SQLException {
        return payrollDAO.getPayrollCountByStatus(status, month);
    }
}
