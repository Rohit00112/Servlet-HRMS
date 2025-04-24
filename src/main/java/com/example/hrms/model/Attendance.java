package com.example.hrms.model;

import java.sql.Date;
import java.sql.Time;
import java.time.Duration;
import java.time.LocalTime;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class Attendance {
    private int id;
    private int employeeId;
    private Date date;
    private Time checkInTime;
    private Time checkOutTime;
    private String status;
    private String notes;

    // Geolocation fields
    private Double latitude;
    private Double longitude;
    private Boolean locationVerified;
    private String locationAddress;

    // Additional fields for display purposes
    private String employeeName;
    private String departmentName;
    private String designation;
    private boolean isLate;
    private boolean isEarlyDeparture;
    private int overtimeMinutes;
    private String formattedDate; // For display purposes

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

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Boolean getLocationVerified() {
        return locationVerified;
    }

    public void setLocationVerified(Boolean locationVerified) {
        this.locationVerified = locationVerified;
    }

    public String getLocationAddress() {
        return locationAddress;
    }

    public void setLocationAddress(String locationAddress) {
        this.locationAddress = locationAddress;
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

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public boolean isLate() {
        return isLate;
    }

    public void setLate(boolean late) {
        isLate = late;
    }

    public boolean isEarlyDeparture() {
        return isEarlyDeparture;
    }

    public void setEarlyDeparture(boolean earlyDeparture) {
        isEarlyDeparture = earlyDeparture;
    }

    public int getOvertimeMinutes() {
        return overtimeMinutes;
    }

    public void setOvertimeMinutes(int overtimeMinutes) {
        this.overtimeMinutes = overtimeMinutes;
    }

    public String getFormattedDate() {
        if (formattedDate == null && date != null) {
            LocalDate localDate = date.toLocalDate();
            formattedDate = localDate.format(DateTimeFormatter.ofPattern("MMM dd, yyyy"));
        }
        return formattedDate;
    }

    public void setFormattedDate(String formattedDate) {
        this.formattedDate = formattedDate;
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

    // Get work duration in minutes
    public int getWorkDurationMinutes() {
        if (checkInTime == null || checkOutTime == null) {
            return 0;
        }

        LocalTime startTime = checkInTime.toLocalTime();
        LocalTime endTime = checkOutTime.toLocalTime();

        // If check-out is before check-in (e.g., overnight shift), return 0
        if (endTime.isBefore(startTime)) {
            return 0;
        }

        Duration duration = Duration.between(startTime, endTime);
        return (int) duration.toMinutes();
    }

    // Get formatted check-in time
    public String getFormattedCheckInTime() {
        if (checkInTime == null) {
            return "-";
        }
        return checkInTime.toLocalTime().format(DateTimeFormatter.ofPattern("hh:mm a"));
    }

    // Get formatted check-out time
    public String getFormattedCheckOutTime() {
        if (checkOutTime == null) {
            return "-";
        }
        return checkOutTime.toLocalTime().format(DateTimeFormatter.ofPattern("hh:mm a"));
    }

    // Get formatted status with color class
    public String getStatusClass() {
        if (status == null) {
            return "";
        }

        switch (status) {
            case "PRESENT":
                return "bg-green-100 text-green-800";
            case "ABSENT":
                return "bg-red-100 text-red-800";
            case "LATE":
                return "bg-yellow-100 text-yellow-800";
            case "HALF_DAY":
                return "bg-orange-100 text-orange-800";
            default:
                return "bg-gray-100 text-gray-800";
        }
    }

    // Get formatted overtime
    public String getFormattedOvertime() {
        if (overtimeMinutes <= 0) {
            return "-";
        }

        int hours = overtimeMinutes / 60;
        int minutes = overtimeMinutes % 60;

        if (hours > 0) {
            return String.format("%d hrs %d mins", hours, minutes);
        } else {
            return String.format("%d mins", minutes);
        }
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
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", locationVerified=" + locationVerified +
                ", locationAddress='" + locationAddress + '\'' +
                '}';
    }
}
