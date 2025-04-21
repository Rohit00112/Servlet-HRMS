package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.LeaveDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.Leave;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "applyLeaveServlet", value = "/employee/leave/apply")
public class ApplyLeaveServlet extends HttpServlet {
    private LeaveDAO leaveDAO;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        leaveDAO = new LeaveDAO();
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        com.example.hrms.model.User user = (com.example.hrms.model.User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get the employee for the current user
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());

        // If not found by user ID, try by email
        if (employee == null) {
            employee = employeeDAO.getEmployeeByEmail(user.getUsername() + "@company.com");
        }

        if (employee == null) {
            request.getSession().setAttribute("errorMessage", "Employee record not found for the current user");
            response.sendRedirect(request.getContextPath() + "/employee/dashboard");
            return;
        }

        request.setAttribute("employee", employee);
        request.getRequestDispatcher("/WEB-INF/employee/apply-leave.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        com.example.hrms.model.User user = (com.example.hrms.model.User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get the employee for the current user
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());

        // If not found by user ID, try by email
        if (employee == null) {
            employee = employeeDAO.getEmployeeByEmail(user.getUsername() + "@company.com");
        }

        if (employee == null) {
            request.getSession().setAttribute("errorMessage", "Employee record not found for the current user");
            response.sendRedirect(request.getContextPath() + "/employee/dashboard");
            return;
        }

        // Get form data
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String reason = request.getParameter("reason");

        // Validate form data
        if (startDateStr == null || startDateStr.trim().isEmpty() ||
            endDateStr == null || endDateStr.trim().isEmpty() ||
            reason == null || reason.trim().isEmpty()) {

            request.getSession().setAttribute("errorMessage", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/employee/leave/apply");
            return;
        }

        try {
            // Parse dates
            Date startDate = Date.valueOf(startDateStr);
            Date endDate = Date.valueOf(endDateStr);

            // Validate dates
            if (startDate.after(endDate)) {
                request.getSession().setAttribute("errorMessage", "Start date cannot be after end date");
                response.sendRedirect(request.getContextPath() + "/employee/leave/apply");
                return;
            }

            // Create leave object
            Leave leave = new Leave();
            leave.setEmployeeId(employee.getId());
            leave.setStartDate(startDate);
            leave.setEndDate(endDate);
            leave.setReason(reason);
            leave.setStatus("PENDING");
            leave.setAppliedDate(Date.valueOf(LocalDate.now()));

            // Save leave to database
            boolean success = leaveDAO.createLeave(leave);

            if (success) {
                request.getSession().setAttribute("successMessage", "Leave application submitted successfully");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to submit leave application");
            }

            // Redirect to leave status page
            response.sendRedirect(request.getContextPath() + "/employee/leave/status");

        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD");
            response.sendRedirect(request.getContextPath() + "/employee/leave/apply");
        }
    }
}
