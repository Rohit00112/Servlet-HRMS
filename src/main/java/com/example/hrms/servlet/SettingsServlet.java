package com.example.hrms.servlet;

import com.example.hrms.model.User;
import com.example.hrms.util.PropertyLoader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

@WebServlet(name = "settingsServlet", value = "/settings")
public class SettingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load current settings
        Map<String, String> settings = loadSettings();
        request.setAttribute("settings", settings);

        // Add theme options for the form-field component
        List<Map<String, String>> themeOptions = new ArrayList<>();

        Map<String, String> lightOption = new HashMap<>();
        lightOption.put("value", "light");
        lightOption.put("text", "Light Mode");
        themeOptions.add(lightOption);

        Map<String, String> darkOption = new HashMap<>();
        darkOption.put("value", "dark");
        darkOption.put("text", "Dark Mode");
        themeOptions.add(darkOption);

        Map<String, String> systemOption = new HashMap<>();
        systemOption.put("value", "system");
        systemOption.put("text", "System Default");
        themeOptions.add(systemOption);

        request.setAttribute("themeOptions", themeOptions);

        // Forward to the appropriate view based on the user's role
        String role = user.getRole();
        if (role.equals("ADMIN")) {
            request.getRequestDispatcher("/WEB-INF/admin/settings.jsp").forward(request, response);
        } else if (role.equals("HR")) {
            request.getRequestDispatcher("/WEB-INF/hr/settings.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/employee/settings.jsp").forward(request, response);
        }
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

        // Only admin can change system settings
        if (!user.getRole().equals("ADMIN")) {
            session.setAttribute("errorMessage", "You don't have permission to change system settings");
            response.sendRedirect(request.getContextPath() + "/settings");
            return;
        }

        // Get form parameters
        String theme = request.getParameter("theme");
        String emailEnabled = request.getParameter("emailEnabled") != null ? "true" : "false";
        String emailHost = request.getParameter("emailHost");
        String emailPort = request.getParameter("emailPort");
        String emailUsername = request.getParameter("emailUsername");
        String emailPassword = request.getParameter("emailPassword");

        // Update settings in session
        session.setAttribute("theme", theme);

        // Save settings to application scope
        getServletContext().setAttribute("theme", theme);
        getServletContext().setAttribute("emailEnabled", emailEnabled);

        // Save email settings if provided
        if (emailHost != null && !emailHost.isEmpty()) {
            getServletContext().setAttribute("emailHost", emailHost);
        }

        if (emailPort != null && !emailPort.isEmpty()) {
            getServletContext().setAttribute("emailPort", emailPort);
        }

        if (emailUsername != null && !emailUsername.isEmpty()) {
            getServletContext().setAttribute("emailUsername", emailUsername);
        }

        // Only update password if a new one is provided
        if (emailPassword != null && !emailPassword.isEmpty()) {
            getServletContext().setAttribute("emailPassword", emailPassword);
        }

        // In a real application, you would save these settings to a database or properties file

        session.setAttribute("successMessage", "Settings updated successfully");
        response.sendRedirect(request.getContextPath() + "/settings");
    }

    private Map<String, String> loadSettings() {
        Map<String, String> settings = new HashMap<>();

        try {
            // Try to load from application scope first
            String emailEnabled = (String) getServletContext().getAttribute("emailEnabled");
            String emailHost = (String) getServletContext().getAttribute("emailHost");
            String emailPort = (String) getServletContext().getAttribute("emailPort");
            String emailUsername = (String) getServletContext().getAttribute("emailUsername");

            // If not found in application scope, try to load from properties file
            if (emailEnabled == null || emailHost == null || emailPort == null || emailUsername == null) {
                Properties emailProps = PropertyLoader.loadProperties("db.properties");

                if (emailEnabled == null) {
                    emailEnabled = emailProps.getProperty("mail.enabled", "false");
                }

                if (emailHost == null) {
                    emailHost = emailProps.getProperty("mail.smtp.host", "");
                }

                if (emailPort == null) {
                    emailPort = emailProps.getProperty("mail.smtp.port", "");
                }

                if (emailUsername == null) {
                    emailUsername = emailProps.getProperty("mail.username", "");
                }
            }

            // Set the values in the settings map
            settings.put("emailEnabled", emailEnabled != null ? emailEnabled : "false");
            settings.put("emailHost", emailHost != null ? emailHost : "");
            settings.put("emailPort", emailPort != null ? emailPort : "");
            settings.put("emailUsername", emailUsername != null ? emailUsername : "");

            // Load theme settings (from application scope or default)
            String theme = (String) getServletContext().getAttribute("theme");
            settings.put("theme", theme != null ? theme : "light");

        } catch (IOException e) {
            e.printStackTrace();

            // Set default values if an error occurs
            settings.put("emailEnabled", "false");
            settings.put("emailHost", "");
            settings.put("emailPort", "");
            settings.put("emailUsername", "");
            settings.put("theme", "light");
        }

        return settings;
    }
}
