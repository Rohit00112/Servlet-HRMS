package com.example.hrms.model;

import java.sql.Date;
import java.sql.Time;
import java.time.Duration;
import java.time.LocalTime;

public class Attendance {
    private int id;
    private int employeeId;
    private Date date;
    private Time checkInTime;
    private Time checkOutTime;
    private String status;
    private String notes;
    
    // Additional fields for display purposes
    private String employeeName;
    private String departmentName;
    
    public Attendance() {
    }
    
    public Attendance(int id, int employeeId, Date date, Time checkInTime, Time checkOutTime, String status, String notes) {
        this.id = id;
        this.employeeId = employeeId;
        this.date = date;
        this.checkInTime = checkInTime;
        this.checkOutTime = checkOutTime;
        this.status = status;
        this.notes = notes;
    }
    
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
    
    public Date getDate() {
        return date;
    }
    
    public void setDate(Date date) {
        this.date = date;
    }
    
    public Time getCheckInTime() {
        return checkInTime;
    }
    
    public void setCheckInTime(Time checkInTime) {
        this.checkInTime = checkInTime;
    }
    
    public Time getCheckOutTime() {
        return checkOutTime;
    }
    
    public void setCheckOutTime(Time checkOutTime) {
        this.checkOutTime = checkOutTime;
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
    
    public String getDepartmentName() {
        return departmentName;
    }
    
    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
    
    // Calculate the duration between check-in and check-out times
    public String getWorkDuration() {
        if (checkInTime == null || checkOutTime == null) {
            return "-";
        }
        
        LocalTime startTime = checkInTime.toLocalTime();
        LocalTime endTime = checkOutTime.toLocalTime();
        
        // If check-out is before check-in (e.g., overnight shift), return "-"
        if (endTime.isBefore(startTime)) {
            return "-";
        }
        
        Duration duration = Duration.between(startTime, endTime);
        long hours = duration.toHours();
        long minutes = duration.toMinutesPart();
        
        return String.format("%d hrs %d mins", hours, minutes);
    }
    
    @Override
    public String toString() {
        return "Attendance{" +
                "id=" + id +
                ", employeeId=" + employeeId +
                ", date=" + date +
                ", checkInTime=" + checkInTime +
                ", checkOutTime=" + checkOutTime +
                ", status='" + status + '\'' +
                ", notes='" + notes + '\'' +
                '}';
    }
}
