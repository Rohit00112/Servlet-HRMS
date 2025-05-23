package com.example.hrms.servlet;

import com.example.hrms.dao.AttendanceDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.NotificationDAO;
import com.example.hrms.dao.UserActivityDAO;
import com.example.hrms.model.Attendance;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;
import com.example.hrms.model.UserActivity;

import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet(name = "markAttendanceServlet", value = "/employee/attendance/mark")
public class MarkAttendanceServlet extends HttpServlet {
    private AttendanceDAO attendanceDAO;
    private EmployeeDAO employeeDAO;
    private NotificationDAO notificationDAO;
    private UserActivityDAO userActivityDAO;

    @Override
    public void init() {
        attendanceDAO = new AttendanceDAO();
        employeeDAO = new EmployeeDAO();
        notificationDAO = new NotificationDAO();
        userActivityDAO = new UserActivityDAO();
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

        // Get the employee for the current user
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());

        // If not found by user ID, try by email
        if (employee == null) {
            employee = employeeDAO.getEmployeeByEmail(user.getUsername() + "@company.com");
        }

        if (employee == null) {
            request.getSession().setAttribute("errorMessage", "Employee record not found for the current user");
            response.sendRedirect(request.getContextPath() + "/employee/dashboard");
            return;
        }

        // Get today's date
        LocalDate today = LocalDate.now();
        Date sqlToday = Date.valueOf(today);

        // Check if attendance is already marked for today
        Attendance todayAttendance = attendanceDAO.getAttendanceByEmployeeAndDate(employee.getId(), sqlToday);

        request.setAttribute("employee", employee);
        request.setAttribute("today", today);
        request.setAttribute("todayAttendance", todayAttendance);

        // Get attendance-related activities for this user
        List<UserActivity> attendanceActivities = userActivityDAO.getRecentActivitiesByEntityType("ATTENDANCE", 5);
        request.setAttribute("recentActivities", attendanceActivities);

        request.getRequestDispatcher("/WEB-INF/employee/mark-attendance.jsp").forward(request, response);
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

        // Get the employee for the current user
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());

        // If not found by user ID, try by email
        if (employee == null) {
            employee = employeeDAO.getEmployeeByEmail(user.getUsername() + "@company.com");
        }

        if (employee == null) {
            request.getSession().setAttribute("errorMessage", "Employee record not found for the current user");
            response.sendRedirect(request.getContextPath() + "/employee/dashboard");
            return;
        }

        // Get form data
        String action = request.getParameter("action");
        String notes = request.getParameter("notes");
        String workType = request.getParameter("workType");

        // Get today's date and current time
        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();
        Date sqlToday = Date.valueOf(today);
        Time sqlNow = Time.valueOf(now);

        boolean success = false;

        if ("check-in".equals(action)) {
            // Check if already checked in
            Attendance existingAttendance = attendanceDAO.getAttendanceByEmployeeAndDate(employee.getId(), sqlToday);

            if (existingAttendance != null && existingAttendance.getCheckInTime() != null) {
                request.getSession().setAttribute("errorMessage", "You have already checked in today");
                response.sendRedirect(request.getContextPath() + "/employee/attendance/mark");
                return;
            }

            // Determine status based on check-in time
            String status = "PRESENT";
            LocalTime lateThreshold = LocalTime.of(9, 30); // 9:30 AM

            if (now.isAfter(lateThreshold)) {
                status = "LATE";
            }

            // Create new attendance record
            Attendance attendance = new Attendance();
            attendance.setEmployeeId(employee.getId());
            attendance.setDate(sqlToday);
            attendance.setCheckInTime(sqlNow);
            attendance.setStatus(status);

            // Add work type to notes if provided
            if (workType != null && !workType.isEmpty()) {
                String workTypeNote = "Work Type: " + workType;
                notes = (notes != null && !notes.isEmpty()) ?
                        notes + " | " + workTypeNote :
                        workTypeNote;
            }

            attendance.setNotes(notes);

            success = attendanceDAO.markAttendance(attendance);

            if (success) {
                // Create notification for attendance
                notificationDAO.createAttendanceNotification(employee.getId(), status, sqlNow);

                // Log the activity
                String activityDescription = user.getUsername() + " checked in with status: " + status;
                if (workType != null && !workType.isEmpty()) {
                    activityDescription += " | Work Type: " + workType;
                }

                userActivityDAO.logActivity(
                    user.getId(),
                    user.getUsername(),
                    user.getRole(),
                    "MARK_ATTENDANCE",
                    activityDescription,
                    "ATTENDANCE",
                    null,
                    request.getRemoteAddr()
                );

                String successMessage = "Check-in recorded successfully at " + now;
                request.getSession().setAttribute("successMessage", successMessage);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to record check-in");
            }

        } else if ("check-out".equals(action)) {
            // Check if already checked out
            Attendance existingAttendance = attendanceDAO.getAttendanceByEmployeeAndDate(employee.getId(), sqlToday);

            if (existingAttendance == null) {
                request.getSession().setAttribute("errorMessage", "You need to check in first before checking out");
                response.sendRedirect(request.getContextPath() + "/employee/attendance/mark");
                return;
            }

            if (existingAttendance.getCheckOutTime() != null) {
                request.getSession().setAttribute("errorMessage", "You have already checked out today");
                response.sendRedirect(request.getContextPath() + "/employee/attendance/mark");
                return;
            }

            // Update check-out time
            success = attendanceDAO.markCheckOut(employee.getId(), sqlToday, sqlNow);

            if (success) {
                // Log the activity
                userActivityDAO.logActivity(
                    user.getId(),
                    user.getUsername(),
                    user.getRole(),
                    "MARK_ATTENDANCE",
                    user.getUsername() + " checked out",
                    "ATTENDANCE",
                    null,
                    request.getRemoteAddr()
                );

                request.getSession().setAttribute("successMessage", "Check-out recorded successfully at " + now);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to record check-out");
            }
        }

        response.sendRedirect(request.getContextPath() + "/employee/attendance/mark");
    }
}
