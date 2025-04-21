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
import java.util.HashMap;
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
        String emailEnabled = request.getParameter("emailEnabled");
        
        // Update settings in session
        session.setAttribute("theme", theme);
        
        // Save settings to application scope
        getServletContext().setAttribute("theme", theme);
        
        // In a real application, you would save these settings to a database or properties file
        
        session.setAttribute("successMessage", "Settings updated successfully");
        response.sendRedirect(request.getContextPath() + "/settings");
    }

    private Map<String, String> loadSettings() {
        Map<String, String> settings = new HashMap<>();
        
        try {
            // Load email settings
            Properties emailProps = PropertyLoader.loadProperties("db.properties");
            settings.put("emailEnabled", emailProps.getProperty("mail.enabled", "false"));
            settings.put("emailHost", emailProps.getProperty("mail.smtp.host", ""));
            settings.put("emailPort", emailProps.getProperty("mail.smtp.port", ""));
            settings.put("emailUsername", emailProps.getProperty("mail.username", ""));
            
            // Load theme settings (from application scope or default)
            String theme = (String) getServletContext().getAttribute("theme");
            settings.put("theme", theme != null ? theme : "light");
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        return settings;
    }
}
