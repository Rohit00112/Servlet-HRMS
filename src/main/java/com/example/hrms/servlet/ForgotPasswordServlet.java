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
        String email = request.getParameter("email");

        // Validate input
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email address is required");
            request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
            return;
        }

        // Find employee by email
        Employee employee = employeeDAO.getEmployeeByEmail(email);
        if (employee == null || employee.getUserId() == null) {
            request.setAttribute("error", "No account found with this email address");
            request.getRequestDispatcher("/WEB-INF/forgot-password.jsp").forward(request, response);
            return;
        }

        // Get user account
        User user = userDAO.getUserById(employee.getUserId());
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
            EmailService.sendPasswordResetNotification(
                email,
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
