package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.NotificationDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.Notification;
import com.example.hrms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "notificationServlet", urlPatterns = {"/notifications", "/notifications/mark-read", "/notifications/mark-all-read"})
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        notificationDAO = new NotificationDAO();
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = user.getRole();

        // Get employee ID
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());
        if (employee == null) {
            response.sendRedirect(request.getContextPath() + "/" + role.toLowerCase() + "/dashboard");
            return;
        }

        int employeeId = employee.getId();

        // Check if it's an AJAX request for notification dropdown
        String requestType = request.getParameter("type");
        if ("dropdown".equals(requestType)) {
            // Return notifications for dropdown
            List<Notification> notifications = notificationDAO.getNotificationsByEmployeeId(employeeId);
            int unreadCount = notificationDAO.getUnreadNotificationCount(employeeId);

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();

            StringBuilder json = new StringBuilder();
            json.append("{\"unreadCount\":").append(unreadCount).append(",\"notifications\":[");

            for (int i = 0; i < notifications.size(); i++) {
                Notification notification = notifications.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{")
                    .append("\"id\":").append(notification.getId()).append(",")
                    .append("\"title\":\"").append(escapeJson(notification.getTitle())).append("\",")
                    .append("\"message\":\"").append(escapeJson(notification.getMessage())).append("\",")
                    .append("\"type\":\"").append(notification.getType()).append("\",")
                    .append("\"createdAt\":\"").append(notification.getCreatedAt()).append("\"")
                    .append("}");
            }

            json.append("]}");
            out.print(json.toString());
            return;
        }

        // Handle pagination for full notifications page
        int page = 1;
        int limit = 10;

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            }
        } catch (NumberFormatException e) {
            // Use default page 1
        }

        int offset = (page - 1) * limit;

        // Get notifications with pagination
        List<Notification> notifications = notificationDAO.getAllNotificationsByEmployeeId(employeeId, limit, offset);
        int totalNotifications = notificationDAO.getTotalNotificationCount(employeeId);
        int totalPages = (int) Math.ceil((double) totalNotifications / limit);

        // Set attributes for JSP
        request.setAttribute("notifications", notifications);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalNotifications", totalNotifications);

        // Forward to notifications page
        request.getRequestDispatcher("/WEB-INF/" + role.toLowerCase() + "/notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get employee ID
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());
        if (employee == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Employee not found");
            return;
        }

        int employeeId = employee.getId();
        String action = request.getServletPath();

        // Log for debugging
        System.out.println("Processing notification action: " + action + " for employee ID: " + employeeId);

        if ("/notifications/mark-read".equals(action)) {
            // Mark a single notification as read
            String notificationIdParam = request.getParameter("id");
            if (notificationIdParam != null && !notificationIdParam.isEmpty()) {
                try {
                    int notificationId = Integer.parseInt(notificationIdParam);
                    boolean success = notificationDAO.markNotificationAsRead(notificationId);

                    if (success) {
                        response.setStatus(HttpServletResponse.SC_OK);
                    } else {
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    }
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if ("/notifications/mark-all-read".equals(action)) {
            // Mark all notifications as read
            boolean success = notificationDAO.markAllNotificationsAsRead(employeeId);

            // Log for debugging
            System.out.println("Mark all notifications as read for employee ID: " + employeeId + ", success: " + success);

            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                // Even if there are no notifications to mark as read, return OK
                response.setStatus(HttpServletResponse.SC_OK);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
