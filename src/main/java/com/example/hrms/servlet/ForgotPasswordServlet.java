package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.UserDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;
import com.example.hrms.util.EmailService;
import com.example.hrms.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet for handling password reset requests
 */
@WebServlet(name = "forgotPasswordServlet", value = "/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward to forgot password page
        request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String resetMethod = request.getParameter("reset-method");
        String email = request.getParameter("email");
        String username = request.getParameter("username");

        Employee employee = null;
        User user = null;

        // Validate input and find user based on reset method
        if ("email".equals(resetMethod)) {
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Email address is required");
                request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
                return;
            }

            // Find employee by email
            employee = employeeDAO.getEmployeeByEmail(email);
            if (employee == null || employee.getUserId() == null) {
                request.setAttribute("error", "No account found with this email address");
                request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
                return;
            }

            // Get user account
            user = userDAO.getUserById(employee.getUserId());
        } else if ("username".equals(resetMethod)) {
            if (username == null || username.trim().isEmpty()) {
                request.setAttribute("error", "Username is required");
                request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
                return;
            }

            // Find user by username
            user = userDAO.getUserByUsername(username);
            if (user == null) {
                request.setAttribute("error", "No account found with this username");
                request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
                return;
            }

            // Get employee details
            employee = employeeDAO.getEmployeeByUserId(user.getId());
            if (employee == null) {
                request.setAttribute("error", "Employee details not found for this username");
                request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
                return;
            }
        } else {
            request.setAttribute("error", "Invalid reset method");
            request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
            return;
        }

        // Verify user account exists
        if (user == null) {
            request.setAttribute("error", "User account not found");
            request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
            return;
        }

        // Generate a new random password
        String newPassword = PasswordUtil.generateRandomPassword(10);

        // Update user password and set password change required flag
        user.setPasswordHash(PasswordUtil.hashPassword(newPassword));
        user.setPasswordChangeRequired(true);

        boolean updated = userDAO.updateUser(user);
        if (!updated) {
            request.setAttribute("error", "Failed to reset password. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
            return;
        }

        // Send password reset email
        try {
            // Get employee email for sending notification
            String employeeEmail = employee.getEmail();
            if (employeeEmail == null || employeeEmail.trim().isEmpty()) {
                request.setAttribute("error", "Employee email not found. Please contact HR.");
                request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
                return;
            }

            EmailService.sendPasswordResetNotification(
                employeeEmail,
                employee.getName(),
                user.getUsername(),
                newPassword
            );

            // Set success message as a session attribute so it persists through the redirect
            request.getSession().setAttribute("message", "Password reset successful! Check your email for the new password.");
            request.getSession().setAttribute("messageType", "success");

            // Redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to send password reset email. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
        }
    }
}
