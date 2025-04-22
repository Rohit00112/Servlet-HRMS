package com.example.hrms.servlet;

import com.example.hrms.dao.UserDAO;
import com.example.hrms.dao.UserActivityDAO;
import com.example.hrms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "loginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;
    private UserActivityDAO userActivityDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        userActivityDAO = new UserActivityDAO();
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

        // Check for remember me cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            String rememberedUsername = null;
            String rememberedToken = null;

            for (Cookie cookie : cookies) {
                if ("remember_username".equals(cookie.getName())) {
                    rememberedUsername = cookie.getValue();
                } else if ("remember_token".equals(cookie.getName())) {
                    rememberedToken = cookie.getValue();
                }
            }

            // If both cookies exist, try to auto-login
            if (rememberedUsername != null && rememberedToken != null) {
                User user = userDAO.getUserByUsername(rememberedUsername);

                if (user != null && validateRememberMeToken(rememberedToken, user)) {
                    // Create session and store user
                    session = request.getSession(true);
                    session.setAttribute("user", user);
                    session.setAttribute("username", user.getUsername());
                    session.setAttribute("role", user.getRole());

                    // Log the auto-login activity
                    userActivityDAO.logActivity(
                        user.getId(),
                        user.getUsername(),
                        user.getRole(),
                        "AUTO_LOGIN",
                        user.getUsername() + " auto-logged in via remember me cookie",
                        "USER",
                        user.getId(),
                        request.getRemoteAddr()
                    );

                    // Redirect to appropriate dashboard
                    redirectToDashboard(response, user.getRole());
                    return;
                } else {
                    // Invalid token, clear cookies
                    clearRememberMeCookies(response);
                }
            }
        }

        // Forward to login page
        request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember_me");

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

            // Handle remember me functionality
            if (rememberMe != null && rememberMe.equals("on")) {
                // Generate a remember me token
                String token = generateRememberMeToken(user);

                // Set cookies for username and token
                Cookie usernameCookie = new Cookie("remember_username", username);
                Cookie tokenCookie = new Cookie("remember_token", token);

                // Set cookie expiration to 30 minutes (1800 seconds)
                usernameCookie.setMaxAge(1800);
                tokenCookie.setMaxAge(1800);

                // Set cookie path to root
                usernameCookie.setPath("/");
                tokenCookie.setPath("/");

                // Add cookies to response
                response.addCookie(usernameCookie);
                response.addCookie(tokenCookie);
            } else {
                // Clear any existing remember me cookies
                clearRememberMeCookies(response);
            }

            // Log the login activity
            userActivityDAO.logActivity(
                user.getId(),
                user.getUsername(),
                user.getRole(),
                "LOGIN",
                user.getUsername() + " logged in",
                "USER",
                user.getId(),
                request.getRemoteAddr()
            );

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

    /**
     * Generate a remember me token for the user
     * This is a simple implementation - in a production environment, you would want to use a more secure method
     *
     * @param user The user to generate a token for
     * @return The generated token
     */
    private String generateRememberMeToken(User user) {
        // Simple token generation - in production, use a more secure method
        long timestamp = System.currentTimeMillis();
        return user.getId() + "_" + timestamp + "_" + user.getPasswordHash().substring(0, 10);
    }

    /**
     * Validate a remember me token against a user
     *
     * @param token The token to validate
     * @param user The user to validate against
     * @return True if the token is valid, false otherwise
     */
    private boolean validateRememberMeToken(String token, User user) {
        try {
            // Simple token validation - in production, use a more secure method
            String[] parts = token.split("_");
            if (parts.length != 3) {
                return false;
            }

            int userId = Integer.parseInt(parts[0]);
            String passwordFragment = parts[2];

            return userId == user.getId() &&
                   user.getPasswordHash().startsWith(passwordFragment);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Clear remember me cookies
     *
     * @param response The HTTP response
     */
    private void clearRememberMeCookies(HttpServletResponse response) {
        Cookie usernameCookie = new Cookie("remember_username", "");
        Cookie tokenCookie = new Cookie("remember_token", "");

        usernameCookie.setMaxAge(0); // Expire immediately
        tokenCookie.setMaxAge(0);     // Expire immediately

        usernameCookie.setPath("/");
        tokenCookie.setPath("/");

        response.addCookie(usernameCookie);
        response.addCookie(tokenCookie);
    }
}
