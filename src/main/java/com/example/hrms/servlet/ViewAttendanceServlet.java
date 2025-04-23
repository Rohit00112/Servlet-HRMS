package com.example.hrms.servlet;

import com.example.hrms.dao.AttendanceDAO;
import com.example.hrms.dao.DepartmentDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.UserActivityDAO;
import com.example.hrms.model.Attendance;
import com.example.hrms.model.Department;
import com.example.hrms.model.Employee;
import com.example.hrms.model.UserActivity;

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

@WebServlet(name = "viewAttendanceServlet", value = {
    "/employee/attendance/view",
    "/hr/attendance/view",
    "/admin/attendance/view"
})
public class ViewAttendanceServlet extends HttpServlet {
    private AttendanceDAO attendanceDAO;
    private EmployeeDAO employeeDAO;
    private DepartmentDAO departmentDAO;
    private UserActivityDAO userActivityDAO;

    @Override
    public void init() {
        attendanceDAO = new AttendanceDAO();
        employeeDAO = new EmployeeDAO();
        departmentDAO = new DepartmentDAO();
        userActivityDAO = new UserActivityDAO();
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

        String role = user.getRole();

        // Get filter parameters
        String employeeIdStr = request.getParameter("employeeId");
        String departmentIdStr = request.getParameter("departmentId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        // Set default date range to current month if not specified
        LocalDate today = LocalDate.now();
        LocalDate startOfMonth = today.withDayOfMonth(1);
        LocalDate endOfMonth = today.withDayOfMonth(today.lengthOfMonth());

        Date startDate = (startDateStr != null && !startDateStr.isEmpty())
                ? Date.valueOf(startDateStr)
                : Date.valueOf(startOfMonth);

        Date endDate = (endDateStr != null && !endDateStr.isEmpty())
                ? Date.valueOf(endDateStr)
                : Date.valueOf(endOfMonth);

        List<Attendance> attendanceList = null;

        // Handle based on role
        if (role.equals("EMPLOYEE")) {
            // For employees, only show their own attendance
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

            attendanceList = attendanceDAO.getAttendanceByEmployeeAndDateRange(employee.getId(), startDate, endDate);

            // Calculate attendance statistics
            Map<String, Integer> stats = attendanceDAO.getAttendanceStatsByEmployeeId(employee.getId(), startDate, endDate);
            double attendancePercentage = attendanceDAO.getAttendancePercentage(employee.getId(), startDate, endDate);

            request.setAttribute("employee", employee);
            request.setAttribute("stats", stats);
            request.setAttribute("attendancePercentage", attendancePercentage);

            // Get attendance-related activities for this user
            List<UserActivity> attendanceActivities = userActivityDAO.getRecentActivitiesByEntityType("ATTENDANCE", 10);
            request.setAttribute("recentActivities", attendanceActivities);

            // Forward to employee attendance view page
            request.setAttribute("attendanceList", attendanceList);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.getRequestDispatcher("/WEB-INF/employee/view-attendance.jsp").forward(request, response);

        } else if (role.equals("HR") || role.equals("ADMIN")) {
            // For HR/Admin, show all attendance or filtered by employee/department
            List<Employee> employees = employeeDAO.getAllEmployees();
            List<Department> departments = departmentDAO.getAllDepartments();

            request.setAttribute("employees", employees);
            request.setAttribute("departments", departments);

            // Apply filters
            if (employeeIdStr != null && !employeeIdStr.isEmpty()) {
                int employeeId = Integer.parseInt(employeeIdStr);
                attendanceList = attendanceDAO.getAttendanceByEmployeeAndDateRange(employeeId, startDate, endDate);

                // Get employee details
                Employee employee = employeeDAO.getEmployeeById(employeeId);
                request.setAttribute("selectedEmployee", employee);

                // Calculate attendance statistics
                Map<String, Integer> stats = attendanceDAO.getAttendanceStatsByEmployeeId(employeeId, startDate, endDate);
                double attendancePercentage = attendanceDAO.getAttendancePercentage(employeeId, startDate, endDate);

                request.setAttribute("stats", stats);
                request.setAttribute("attendancePercentage", attendancePercentage);

            } else if (departmentIdStr != null && !departmentIdStr.isEmpty()) {
                int departmentId = Integer.parseInt(departmentIdStr);
                attendanceList = attendanceDAO.getAttendanceByDepartmentId(departmentId);

                // Get department details
                Department department = departmentDAO.getDepartmentById(departmentId);
                request.setAttribute("selectedDepartment", department);

            } else {
                // No filters, show all attendance
                attendanceList = attendanceDAO.getAttendanceByDateRange(startDate, endDate);
            }

            // Forward to HR/Admin attendance view page
            request.setAttribute("attendanceList", attendanceList);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);

            // Get attendance-related activities
            List<UserActivity> attendanceActivities = userActivityDAO.getRecentActivitiesByEntityType("ATTENDANCE", 10);
            request.setAttribute("recentActivities", attendanceActivities);

            String requestURI = request.getRequestURI();
            if (requestURI.contains("/hr/")) {
                request.getRequestDispatcher("/WEB-INF/hr/view-attendance.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/WEB-INF/admin/view-attendance.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
