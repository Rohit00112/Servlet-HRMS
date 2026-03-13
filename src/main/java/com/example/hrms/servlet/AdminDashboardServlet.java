package com.example.hrms.servlet;

import com.example.hrms.dao.AttendanceDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.LeaveDAO;
import com.example.hrms.dao.UserActivityDAO;
import com.example.hrms.model.UserActivity;
import com.example.hrms.service.PayrollService;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "adminDashboardServlet", value = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private LeaveDAO leaveDAO;
    private PayrollService payrollService;
    private AttendanceDAO attendanceDAO;
    private UserActivityDAO userActivityDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        leaveDAO = new LeaveDAO();
        payrollService = new PayrollService();
        attendanceDAO = new AttendanceDAO();
        userActivityDAO = new UserActivityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}
