package com.example.hrms.servlet;

import com.example.hrms.dao.AttendanceDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.LeaveDAO;
import com.example.hrms.dao.NotificationDAO;
import com.example.hrms.dao.UserActivityDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;
import com.example.hrms.model.UserActivity;
import com.example.hrms.service.PayrollService;

import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "employeeDashboardServlet", value = "/employee/dashboard")
public class EmployeeDashboardServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private LeaveDAO leaveDAO;
    private AttendanceDAO attendanceDAO;
    private NotificationDAO notificationDAO;
    private PayrollService payrollService;
    private UserActivityDAO userActivityDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        leaveDAO = new LeaveDAO();
        attendanceDAO = new AttendanceDAO();
        notificationDAO = new NotificationDAO();
        payrollService = new PayrollService();
        userActivityDAO = new UserActivityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}
