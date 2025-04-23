package com.example.hrms.servlet;

import com.example.hrms.dao.AttendanceDAO;
import com.example.hrms.dao.DepartmentDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.model.Attendance;
import com.example.hrms.model.Department;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet(name = "attendanceReportServlet", value = {"/hr/attendance-report", "/admin/attendance-report"})
public class AttendanceReportServlet extends HttpServlet {
    private AttendanceDAO attendanceDAO;
    private DepartmentDAO departmentDAO;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        attendanceDAO = new AttendanceDAO();
        departmentDAO = new DepartmentDAO();
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
        String role = (String) session.getAttribute("role");

        // Only HR and Admin can access this page
        if (!"HR".equals(role) && !"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Get parameters
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String departmentIdStr = request.getParameter("departmentId");
        String employeeIdStr = request.getParameter("employeeId");

        // Set default date range to current month if not provided
        LocalDate today = LocalDate.now();
        LocalDate startDate = startDateStr != null ? LocalDate.parse(startDateStr) : today.withDayOfMonth(1);
        LocalDate endDate = endDateStr != null ? LocalDate.parse(endDateStr) : today;

        // Convert to SQL Date
        Date sqlStartDate = Date.valueOf(startDate);
        Date sqlEndDate = Date.valueOf(endDate);

        // Get department ID (0 means all departments)
        int departmentId = 0;
        if (departmentIdStr != null && !departmentIdStr.isEmpty()) {
            try {
                departmentId = Integer.parseInt(departmentIdStr);
            } catch (NumberFormatException e) {
                // Ignore and use default
            }
        }

        // Get employee ID (0 means all employees)
        int employeeId = 0;
        if (employeeIdStr != null && !employeeIdStr.isEmpty()) {
            try {
                employeeId = Integer.parseInt(employeeIdStr);
            } catch (NumberFormatException e) {
                // Ignore and use default
            }
        }

        // Get attendance data
        List<Attendance> attendanceList;
        if (employeeId > 0) {
            // Get attendance for specific employee
            attendanceList = attendanceDAO.getAdvancedAttendanceByEmployee(employeeId, sqlStartDate, sqlEndDate);
        } else {
            // Get attendance for all employees or specific department
            attendanceList = attendanceDAO.getAttendanceReport(sqlStartDate, sqlEndDate, departmentId);
        }

        // Get attendance summary
        Map<String, Object> summary = attendanceDAO.getAttendanceSummary(sqlStartDate, sqlEndDate, departmentId);

        // Get departments for filter
        List<Department> departments = departmentDAO.getAllDepartments();

        // Get employees for filter
        List<Employee> employees = employeeDAO.getAllEmployees();

        // Set attributes for JSP
        request.setAttribute("attendanceList", attendanceList);
        request.setAttribute("summary", summary);
        request.setAttribute("departments", departments);
        request.setAttribute("employees", employees);
        request.setAttribute("startDate", startDate.toString());
        request.setAttribute("endDate", endDate.toString());
        request.setAttribute("selectedDepartmentId", departmentId);
        request.setAttribute("selectedEmployeeId", employeeId);

        // Forward to JSP
        String jspPath = role.equals("ADMIN") ? "/WEB-INF/admin/attendance-report.jsp" : "/WEB-INF/hr/attendance-report.jsp";
        request.getRequestDispatcher(jspPath).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle any form submissions if needed
        doGet(request, response);
    }
}
