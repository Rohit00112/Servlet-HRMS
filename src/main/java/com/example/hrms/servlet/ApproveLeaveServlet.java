package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.LeaveDAO;
import com.example.hrms.dao.NotificationDAO;
import com.example.hrms.dao.UserActivityDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.Leave;
import com.example.hrms.model.User;
import com.example.hrms.util.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "approveLeaveServlet", value = {"/hr/leave/approve", "/admin/leave/approve"})
public class ApproveLeaveServlet extends HttpServlet {
    private LeaveDAO leaveDAO;
    private EmployeeDAO employeeDAO;
    private NotificationDAO notificationDAO;
    private UserActivityDAO userActivityDAO;

    @Override
    public void init() {
        leaveDAO = new LeaveDAO();
        employeeDAO = new EmployeeDAO();
        notificationDAO = new NotificationDAO();
        userActivityDAO = new UserActivityDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || (!user.getRole().equals("HR") && !user.getRole().equals("ADMIN"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = user.getRole();

        // Get form data
        String leaveIdStr = request.getParameter("leaveId");
        String comments = request.getParameter("comments");

        // Validate form data
        if (leaveIdStr == null || leaveIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Leave ID is required");
            redirectBack(request, response, role);
            return;
        }

        try {
            int leaveId = Integer.parseInt(leaveIdStr);

            // Get the leave application
            Leave leave = leaveDAO.getLeaveById(leaveId);

            if (leave == null) {
                request.getSession().setAttribute("errorMessage", "Leave application not found");
                redirectBack(request, response, role);
                return;
            }

            // Check if leave is already processed
            if (!leave.getStatus().equals("PENDING")) {
                request.getSession().setAttribute("errorMessage", "Leave application has already been processed");
                redirectBack(request, response, role);
                return;
            }

            // Get the current user's ID from the session
            int userId = user.getId();

            // Update leave status
            boolean success = leaveDAO.updateLeaveStatus(leaveId, "APPROVED", userId, Date.valueOf(LocalDate.now()), comments);

            if (success) {
                // Get employee details
                Employee employee = employeeDAO.getEmployeeById(leave.getEmployeeId());

                if (employee != null) {
                    // Create notification
                    notificationDAO.createLeaveStatusNotification(
                        employee.getId(),
                        "APPROVED",
                        leave.getStartDate(),
                        leave.getEndDate()
                    );

                    // Send email notification if email is available
                    if (employee.getEmail() != null) {
                        try {
                            // Format dates for email
                            String startDateStr = leave.getStartDate().toLocalDate().toString();
                            String endDateStr = leave.getEndDate().toLocalDate().toString();

                            // Send email notification
                            EmailService.sendLeaveStatusNotification(
                                employee.getEmail(),
                                employee.getName(),
                                leave.getId(),
                                startDateStr,
                                endDateStr,
                                "APPROVED",
                                comments
                            );

                            System.out.println("Leave approval email sent to " + employee.getEmail());
                        } catch (Exception e) {
                            // Log the error but don't fail the request
                            System.err.println("Error sending email notification: " + e.getMessage());
                            e.printStackTrace();
                        }
                    }
                }

                // Log the activity
                userActivityDAO.logActivity(
                    user.getId(),
                    user.getUsername(),
                    user.getRole(),
                    "APPROVE",
                    user.getUsername() + " approved leave application for " + employee.getName(),
                    "LEAVE",
                    leave.getId(),
                    request.getRemoteAddr()
                );

                request.getSession().setAttribute("successMessage", "Leave application approved successfully");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to approve leave application");
            }

            // Redirect back to leave management page
            redirectBack(request, response, role);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid leave ID");
            redirectBack(request, response, role);
        }
    }

    private void redirectBack(HttpServletRequest request, HttpServletResponse response, String role) throws IOException {
        if (role.equals("HR")) {
            response.sendRedirect(request.getContextPath() + "/hr/leave/all");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/leave/all");
        }
    }
}
