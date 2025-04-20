package com.example.hrms.model;

import java.sql.Date;

public class Employee {
    private int id;
    private String name;
    private String email;
    private int departmentId;
    private int designationId;
    private Date joinDate;
    private Integer userId; // Reference to User entity
    
    // Additional fields for display purposes
    private String departmentName;
    private String designationTitle;
    private String role; // User role (HR, EMPLOYEE)
    
    public Employee() {
    }
    
    public Employee(int id, String name, String email, int departmentId, int designationId, Date joinDate) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.departmentId = departmentId;
        this.designationId = designationId;
        this.joinDate = joinDate;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public int getDepartmentId() {
        return departmentId;
    }
    
    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }
    
    public int getDesignationId() {
        return designationId;
    }
    
    public void setDesignationId(int designationId) {
        this.designationId = designationId;
    }
    
    public Date getJoinDate() {
        return joinDate;
    }
    
    public void setJoinDate(Date joinDate) {
        this.joinDate = joinDate;
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
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    @Override
    public String toString() {
        return "Employee{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", departmentId=" + departmentId +
                ", designationId=" + designationId +
                ", joinDate=" + joinDate +
                ", userId=" + userId +
                ", role='" + role + '\'' +
                '}';
    }
}
