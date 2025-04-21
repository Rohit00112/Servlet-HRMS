package com.example.hrms.servlet;

import com.example.hrms.dao.AttendanceDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.model.Attendance;
import com.example.hrms.model.Employee;

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

    @Override
    public void init() {
        attendanceDAO = new AttendanceDAO();
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        com.example.hrms.model.User user = (com.example.hrms.model.User) session.getAttribute("user");

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

        request.getRequestDispatcher("/WEB-INF/employee/mark-attendance.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        com.example.hrms.model.User user = (com.example.hrms.model.User) session.getAttribute("user");

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
            attendance.setNotes(notes);

            success = attendanceDAO.markAttendance(attendance);

            if (success) {
                request.getSession().setAttribute("successMessage", "Check-in recorded successfully at " + now);
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
                request.getSession().setAttribute("successMessage", "Check-out recorded successfully at " + now);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to record check-out");
            }
        }

        response.sendRedirect(request.getContextPath() + "/employee/attendance/mark");
    }
}
