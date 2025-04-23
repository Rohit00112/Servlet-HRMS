package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.NotificationDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Calendar;

@WebServlet(name = "sampleNotificationsServlet", urlPatterns = {"/api/sample-notifications"})
public class SampleNotificationsServlet extends HttpServlet {
    private NotificationDAO notificationDAO;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        notificationDAO = new NotificationDAO();
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User user = (User) session.getAttribute("user");
        
        // Get employee ID from user
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());
        if (employee == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Create sample notifications
        createSampleNotifications(employee.getId());
        
        // Redirect back to the dashboard
        String role = user.getRole().toLowerCase();
        response.sendRedirect(request.getContextPath() + "/" + role + "/dashboard");
    }
    
    private void createSampleNotifications(int employeeId) {
        Calendar calendar = Calendar.getInstance();
        
        // Create a notification from just now
        notificationDAO.createNotification(
            employeeId,
            "Welcome to HRMS",
            "Welcome to the Human Resource Management System. We're glad to have you here!",
            "INFO"
        );
        
        // Create a notification from 1 hour ago
        calendar.add(Calendar.HOUR, -1);
        notificationDAO.createNotification(
            employeeId,
            "Profile Updated",
            "Your profile information has been updated successfully.",
            "SUCCESS",
            false,
            new Timestamp(calendar.getTimeInMillis())
        );
        
        // Create a notification from 1 day ago
        calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, -1);
        notificationDAO.createNotification(
            employeeId,
            "Leave Request Approved",
            "Your leave request for next week has been approved by HR.",
            "SUCCESS",
            false,
            new Timestamp(calendar.getTimeInMillis())
        );
        
        // Create a notification from 2 days ago
        calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, -2);
        notificationDAO.createNotification(
            employeeId,
            "Attendance Reminder",
            "Please remember to mark your attendance daily.",
            "WARNING",
            true, // Already read
            new Timestamp(calendar.getTimeInMillis())
        );
        
        // Create a notification from 3 days ago
        calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, -3);
        notificationDAO.createNotification(
            employeeId,
            "Payslip Generated",
            "Your payslip for the previous month has been generated and is ready for download.",
            "INFO",
            true, // Already read
            new Timestamp(calendar.getTimeInMillis())
        );
    }
}
