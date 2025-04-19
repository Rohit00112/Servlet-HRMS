package com.hrms.models;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Payroll {
    private int id;
    private int empId;
    private String month; // Format: YYYY-MM
    private int year;
    private BigDecimal baseSalary;
    private int daysPresent;
    private int daysAbsent;
    private int daysLate;
    private int daysHalf;
    private BigDecimal allowances;
    private BigDecimal deductions;
    private BigDecimal grossSalary;
    private BigDecimal netSalary;
    private BigDecimal taxAmount;
    private Timestamp generationDate;
    private String status;
    private String notes;
    
    // Employee details
    private String employeeName;
    private String employeeEmail;
    private String departmentName;
    private String designationTitle;
    
    // Payroll items
    private List<PayrollItem> payrollItems = new ArrayList<>();

    // Constructors
    public Payroll() {
    }

    public Payroll(int empId, String month, int year, BigDecimal baseSalary, int daysPresent, 
                  int daysAbsent, int daysLate, int daysHalf, BigDecimal allowances, 
                  BigDecimal deductions, BigDecimal grossSalary, BigDecimal netSalary, 
                  BigDecimal taxAmount, String status, String notes) {
        this.empId = empId;
        this.month = month;
        this.year = year;
        this.baseSalary = baseSalary;
        this.daysPresent = daysPresent;
        this.daysAbsent = daysAbsent;
        this.daysLate = daysLate;
        this.daysHalf = daysHalf;
        this.allowances = allowances;
        this.deductions = deductions;
        this.grossSalary = grossSalary;
        this.netSalary = netSalary;
        this.taxAmount = taxAmount;
        this.status = status;
        this.notes = notes;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getEmpId() {
        return empId;
    }

    public void setEmpId(int empId) {
        this.empId = empId;
    }

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public BigDecimal getBaseSalary() {
        return baseSalary;
    }

    public void setBaseSalary(BigDecimal baseSalary) {
        this.baseSalary = baseSalary;
    }

    public int getDaysPresent() {
        return daysPresent;
    }

    public void setDaysPresent(int daysPresent) {
        this.daysPresent = daysPresent;
    }

    public int getDaysAbsent() {
        return daysAbsent;
    }

    public void setDaysAbsent(int daysAbsent) {
        this.daysAbsent = daysAbsent;
    }

    public int getDaysLate() {
        return daysLate;
    }

    public void setDaysLate(int daysLate) {
        this.daysLate = daysLate;
    }

    public int getDaysHalf() {
        return daysHalf;
    }

    public void setDaysHalf(int daysHalf) {
        this.daysHalf = daysHalf;
    }

    public BigDecimal getAllowances() {
        return allowances;
    }

    public void setAllowances(BigDecimal allowances) {
        this.allowances = allowances;
    }

    public BigDecimal getDeductions() {
        return deductions;
    }

    public void setDeductions(BigDecimal deductions) {
        this.deductions = deductions;
    }

    public BigDecimal getGrossSalary() {
        return grossSalary;
    }

    public void setGrossSalary(BigDecimal grossSalary) {
        this.grossSalary = grossSalary;
    }

    public BigDecimal getNetSalary() {
        return netSalary;
    }

    public void setNetSalary(BigDecimal netSalary) {
        this.netSalary = netSalary;
    }

    public BigDecimal getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(BigDecimal taxAmount) {
        this.taxAmount = taxAmount;
    }

    public Timestamp getGenerationDate() {
        return generationDate;
    }

    public void setGenerationDate(Timestamp generationDate) {
        this.generationDate = generationDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    public String getEmployeeEmail() {
        return employeeEmail;
    }

    public void setEmployeeEmail(String employeeEmail) {
        this.employeeEmail = employeeEmail;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getDesignationTitle() {
        return designationTitle;
    }

    public void setDesignationTitle(String designationTitle) {
        this.designationTitle = designationTitle;
    }

    public List<PayrollItem> getPayrollItems() {
        return payrollItems;
    }

    public void setPayrollItems(List<PayrollItem> payrollItems) {
        this.payrollItems = payrollItems;
    }
    
    public void addPayrollItem(PayrollItem item) {
        this.payrollItems.add(item);
    }
    
    // Helper methods
    public int getTotalWorkingDays() {
        return daysPresent + daysAbsent + daysLate + daysHalf;
    }
    
    public BigDecimal getAttendancePercentage() {
        int totalDays = getTotalWorkingDays();
        if (totalDays == 0) return BigDecimal.ZERO;
        
        // Calculate effective days (present + 0.5*half + 0.75*late)
        BigDecimal effectiveDays = BigDecimal.valueOf(daysPresent)
                .add(BigDecimal.valueOf(daysHalf).multiply(new BigDecimal("0.5")))
                .add(BigDecimal.valueOf(daysLate).multiply(new BigDecimal("0.75")));
        
        return effectiveDays.multiply(new BigDecimal("100")).divide(BigDecimal.valueOf(totalDays), 2, BigDecimal.ROUND_HALF_UP);
    }
    
    // Method to calculate total allowances from payroll items
    public BigDecimal calculateTotalAllowances() {
        return payrollItems.stream()
                .filter(item -> "ALLOWANCE".equals(item.getItemType()) || "BONUS".equals(item.getItemType()))
                .map(PayrollItem::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
    
    // Method to calculate total deductions from payroll items
    public BigDecimal calculateTotalDeductions() {
        return payrollItems.stream()
                .filter(item -> "DEDUCTION".equals(item.getItemType()) || "TAX".equals(item.getItemType()))
                .map(PayrollItem::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
    
    @Override
    public String toString() {
        return "Payroll{" +
                "id=" + id +
                ", empId=" + empId +
                ", month='" + month + '\'' +
                ", year=" + year +
                ", baseSalary=" + baseSalary +
                ", daysPresent=" + daysPresent +
                ", daysAbsent=" + daysAbsent +
                ", grossSalary=" + grossSalary +
                ", netSalary=" + netSalary +
                ", status='" + status + '\'' +
                '}';
    }
}
