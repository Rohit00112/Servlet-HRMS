package com.example.hrms.servlet;

import com.example.hrms.dao.UserDAO;
import com.example.hrms.model.User;
import com.example.hrms.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "changePasswordServlet", value = "/change-password")
public class ChangePasswordServlet extends HttpServlet {
    private UserDAO userDAO;
    private UserService userService;

    @Override
    public void init() {
        userDAO = new UserDAO();
        userService = new UserService();
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
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            session.setAttribute("errorMessage", "All password fields are required");
            redirectBack(request, response, user.getRole());
            return;
        }

        // Check if new password and confirm password match
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("errorMessage", "New password and confirm password do not match");
            redirectBack(request, response, user.getRole());
            return;
        }

        // Verify current password
        if (!userService.verifyPassword(currentPassword, user.getPasswordHash())) {
            session.setAttribute("errorMessage", "Current password is incorrect");
            redirectBack(request, response, user.getRole());
            return;
        }

        // Update password
        String newPasswordHash = userService.hashPassword(newPassword);
        user.setPasswordHash(newPasswordHash);
        boolean success = userDAO.updateUserPassword(user.getId(), newPasswordHash);

        if (success) {
            session.setAttribute("successMessage", "Password changed successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to change password");
        }

        redirectBack(request, response, user.getRole());
    }

    private void redirectBack(HttpServletRequest request, HttpServletResponse response, String role) throws IOException {
        String redirectUrl;
        if (role.equals("ADMIN")) {
            redirectUrl = request.getContextPath() + "/admin/profile";
        } else if (role.equals("HR")) {
            redirectUrl = request.getContextPath() + "/hr/profile";
        } else {
            redirectUrl = request.getContextPath() + "/employee/profile";
        }
        response.sendRedirect(redirectUrl);
    }
}
