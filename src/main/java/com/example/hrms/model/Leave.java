package com.example.hrms.model;

import java.sql.Date;

public class Leave {
    private int id;
    private int employeeId;
    private Date startDate;
    private Date endDate;
    private String reason;
    private String status;
    private Date appliedDate;
    private Integer reviewedBy;
    private Date reviewedDate;
    private String comments;
    
    // Additional fields for display purposes
    private String employeeName;
    private String reviewerName;
    
    public Leave() {
    }
    
    public Leave(int id, int employeeId, Date startDate, Date endDate, String reason, String status, Date appliedDate) {
        this.id = id;
        this.employeeId = employeeId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.reason = reason;
        this.status = status;
        this.appliedDate = appliedDate;
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
    
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public String getReason() {
        return reason;
    }
    
    public void setReason(String reason) {
        this.reason = reason;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Date getAppliedDate() {
        return appliedDate;
    }
    
    public void setAppliedDate(Date appliedDate) {
        this.appliedDate = appliedDate;
    }
    
    public Integer getReviewedBy() {
        return reviewedBy;
    }
    
    public void setReviewedBy(Integer reviewedBy) {
        this.reviewedBy = reviewedBy;
    }
    
    public Date getReviewedDate() {
        return reviewedDate;
    }
    
    public void setReviewedDate(Date reviewedDate) {
        this.reviewedDate = reviewedDate;
    }
    
    public String getComments() {
        return comments;
    }
    
    public void setComments(String comments) {
        this.comments = comments;
    }
    
    public String getEmployeeName() {
        return employeeName;
    }
    
    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }
    
    public String getReviewerName() {
        return reviewerName;
    }
    
    public void setReviewerName(String reviewerName) {
        this.reviewerName = reviewerName;
    }
    
    // Calculate the number of days between start and end dates
    public int getDuration() {
        if (startDate == null || endDate == null) {
            return 0;
        }
        
        long diff = endDate.getTime() - startDate.getTime();
        return (int) (diff / (1000 * 60 * 60 * 24)) + 1; // +1 to include both start and end dates
    }
    
    @Override
    public String toString() {
        return "Leave{" +
                "id=" + id +
                ", employeeId=" + employeeId +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", reason='" + reason + '\'' +
                ", status='" + status + '\'' +
                ", appliedDate=" + appliedDate +
                '}';
    }
}
