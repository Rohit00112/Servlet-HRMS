package com.example.hrms.model;

import java.math.BigDecimal;
import java.util.Date;

public class Payroll {
    private int id;
    private int employeeId;
    private String employeeName; // Not stored in DB, used for display
    private String month; // Format: YYYY-MM
    private BigDecimal baseSalary;
    private int daysPresent;
    private int daysAbsent;
    private int daysLate;
    private int daysHalf;
    private BigDecimal allowances;
    private BigDecimal deductions;
    private BigDecimal netSalary;
    private Date generationDate;
    private String status; // DRAFT, FINALIZED, PAID
    private String notes;

    // Constructors
    public Payroll() {
    }

    public Payroll(int employeeId, String month, BigDecimal baseSalary, int daysPresent, int daysAbsent, 
                  int daysLate, int daysHalf, BigDecimal allowances, BigDecimal deductions, 
                  BigDecimal netSalary, Date generationDate, String status, String notes) {
        this.employeeId = employeeId;
        this.month = month;
        this.baseSalary = baseSalary;
        this.daysPresent = daysPresent;
        this.daysAbsent = daysAbsent;
        this.daysLate = daysLate;
        this.daysHalf = daysHalf;
        this.allowances = allowances;
        this.deductions = deductions;
        this.netSalary = netSalary;
        this.generationDate = generationDate;
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

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
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

    public BigDecimal getNetSalary() {
        return netSalary;
    }

    public void setNetSalary(BigDecimal netSalary) {
        this.netSalary = netSalary;
    }

    public Date getGenerationDate() {
        return generationDate;
    }

    public void setGenerationDate(Date generationDate) {
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

    // Helper methods
    public String getFormattedMonth() {
        if (month != null && month.length() == 7) {
            String year = month.substring(0, 4);
            String monthNum = month.substring(5, 7);
            String monthName = "";
            
            switch (monthNum) {
                case "01": monthName = "January"; break;
                case "02": monthName = "February"; break;
                case "03": monthName = "March"; break;
                case "04": monthName = "April"; break;
                case "05": monthName = "May"; break;
                case "06": monthName = "June"; break;
                case "07": monthName = "July"; break;
                case "08": monthName = "August"; break;
                case "09": monthName = "September"; break;
                case "10": monthName = "October"; break;
                case "11": monthName = "November"; break;
                case "12": monthName = "December"; break;
            }
            
            return monthName + " " + year;
        }
        return month;
    }

    public int getTotalWorkingDays() {
        return daysPresent + daysAbsent + daysHalf;
    }

    public BigDecimal getEffectiveWorkingDays() {
        // Count present days as 1, half days as 0.5, and late days as 0.9
        return BigDecimal.valueOf(daysPresent)
                .add(BigDecimal.valueOf(daysHalf).multiply(BigDecimal.valueOf(0.5)))
                .add(BigDecimal.valueOf(daysLate).multiply(BigDecimal.valueOf(0.9)));
    }

    @Override
    public String toString() {
        return "Payroll{" +
                "id=" + id +
                ", employeeId=" + employeeId +
                ", month='" + month + '\'' +
                ", baseSalary=" + baseSalary +
                ", daysPresent=" + daysPresent +
                ", daysAbsent=" + daysAbsent +
                ", daysLate=" + daysLate +
                ", daysHalf=" + daysHalf +
                ", allowances=" + allowances +
                ", deductions=" + deductions +
                ", netSalary=" + netSalary +
                ", generationDate=" + generationDate +
                ", status='" + status + '\'' +
                ", notes='" + notes + '\'' +
                '}';
    }
}
