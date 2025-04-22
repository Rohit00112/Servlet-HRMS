package com.example.hrms.servlet;

import com.example.hrms.dao.UserDAO;
import com.example.hrms.model.User;
import com.example.hrms.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet to handle password change on first login
 */
@WebServlet(name = "firstLoginPasswordChangeServlet", value = "/first-login-password-change")
public class FirstLoginPasswordChangeServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // If password change is not required, redirect to dashboard
        if (!user.isPasswordChangeRequired()) {
            redirectToDashboard(response, user.getRole());
            return;
        }

        // Forward to the password change page
        request.getRequestDispatcher("/WEB-INF/first-login-password-change.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form parameters
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (newPassword == null || confirmPassword == null ||
            newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All password fields are required");
            request.getRequestDispatcher("/WEB-INF/first-login-password-change.jsp").forward(request, response);
            return;
        }

        // Check if new password and confirm password match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New password and confirm password do not match");
            request.getRequestDispatcher("/WEB-INF/first-login-password-change.jsp").forward(request, response);
            return;
        }

        // Update password
        String newPasswordHash = PasswordUtil.hashPassword(newPassword);
        user.setPasswordHash(newPasswordHash);
        user.setPasswordChangeRequired(false);
        boolean success = userDAO.updateUserPassword(user.getId(), newPasswordHash);

        if (success) {
            // Update the user in the session
            session.setAttribute("user", user);
            
            // Set success message
            session.setAttribute("successMessage", "Password changed successfully");
            
            // Redirect to dashboard
            redirectToDashboard(response, user.getRole());
        } else {
            request.setAttribute("errorMessage", "Failed to change password");
            request.getRequestDispatcher("/WEB-INF/first-login-password-change.jsp").forward(request, response);
        }
    }

    private void redirectToDashboard(HttpServletResponse response, String role) throws IOException {
        switch (role) {
            case "ADMIN":
                response.sendRedirect("admin/dashboard");
                break;
            case "HR":
                response.sendRedirect("hr/dashboard");
                break;
            case "EMPLOYEE":
                response.sendRedirect("employee/dashboard");
                break;
            default:
                response.sendRedirect("login");
        }
    }
}
