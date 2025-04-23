package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.NotificationDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.Notification;
import com.example.hrms.model.User;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "notificationServlet", urlPatterns = {"/api/notifications", "/api/notifications/mark-read", "/api/notifications/mark-all-read"})
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO;
    private EmployeeDAO employeeDAO;
    private Gson gson;

    @Override
    public void init() {
        notificationDAO = new NotificationDAO();
        employeeDAO = new EmployeeDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User user = (User) session.getAttribute("user");
        
        // Get employee ID from user
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());
        if (employee == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Get notifications for the employee
        List<Notification> notifications = notificationDAO.getNotificationsByEmployeeId(employee.getId());
        int unreadCount = notificationDAO.getUnreadNotificationCount(employee.getId());

        // Create response JSON
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.add("notifications", gson.toJsonTree(notifications));
        jsonResponse.addProperty("unreadCount", unreadCount);

        // Send response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(jsonResponse.toString());
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User user = (User) session.getAttribute("user");
        
        // Get employee ID from user
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());
        if (employee == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String pathInfo = request.getServletPath();
        
        if (pathInfo.equals("/api/notifications/mark-read")) {
            // Mark a single notification as read
            String notificationIdStr = request.getParameter("id");
            if (notificationIdStr == null || notificationIdStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            
            try {
                int notificationId = Integer.parseInt(notificationIdStr);
                boolean success = notificationDAO.markNotificationAsRead(notificationId);
                
                JsonObject jsonResponse = new JsonObject();
                jsonResponse.addProperty("success", success);
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(jsonResponse.toString());
                out.flush();
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.equals("/api/notifications/mark-all-read")) {
            // Mark all notifications as read for the employee
            boolean success = notificationDAO.markAllNotificationsAsRead(employee.getId());
            
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", success);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(jsonResponse.toString());
            out.flush();
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
