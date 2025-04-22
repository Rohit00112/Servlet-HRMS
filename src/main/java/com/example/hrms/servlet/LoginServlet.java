package com.example.hrms.servlet;

import com.example.hrms.dao.UserDAO;
import com.example.hrms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "loginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // User is already logged in, redirect to appropriate dashboard
            User user = (User) session.getAttribute("user");
            redirectToDashboard(response, user.getRole());
            return;
        }

        // Forward to login page
        request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate input
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
            return;
        }

        // Authenticate user
        if (userDAO.validateCredentials(username, password)) {
            User user = userDAO.getUserByUsername(username);

            // Create session and store user
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());

            // Check if password change is required
            if (user.isPasswordChangeRequired()) {
                // Redirect to password change page
                response.sendRedirect(request.getContextPath() + "/first-login-password-change");
            } else {
                // Redirect to appropriate dashboard based on role
                redirectToDashboard(response, user.getRole());
            }
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
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
