package com.example.hrms.dashboard.web;

import com.example.hrms.dao.AttendanceDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.LeaveDAO;
import com.example.hrms.dao.NotificationDAO;
import com.example.hrms.dao.UserActivityDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;
import com.example.hrms.model.UserActivity;
import com.example.hrms.service.PayrollService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "dashboardServlet", value = "/dashboard")
public class DashboardServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private LeaveDAO leaveDAO;
    private PayrollService payrollService;
    private AttendanceDAO attendanceDAO;
    private UserActivityDAO userActivityDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        leaveDAO = new LeaveDAO();
        payrollService = new PayrollService();
        attendanceDAO = new AttendanceDAO();
        userActivityDAO = new UserActivityDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = user.getRole();

        try {
            switch (role) {
                case "ADMIN" -> renderAdminDashboard(request, response);
                case "HR" -> renderHrDashboard(request, response, user);
                case "EMPLOYEE" -> renderEmployeeDashboard(request, response, user);
                default -> response.sendRedirect(request.getContextPath() + "/auth/login");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard data: " + e.getMessage());
            String fallbackView = switch (role) {
                case "HR" -> "/WEB-INF/hr/dashboard.jsp";
                case "EMPLOYEE" -> "/WEB-INF/employee/dashboard.jsp";
                default -> "/WEB-INF/admin/dashboard.jsp";
            };
            request.getRequestDispatcher(fallbackView).forward(request, response);
        }
    }

    private void renderAdminDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        request.setAttribute("employeeCount", employeeDAO.getEmployeeCount());
        request.setAttribute("pendingLeaveCount", leaveDAO.getPendingLeaveCount());
        request.setAttribute("approvedLeaveCount", leaveDAO.getLeaveCountByStatus("APPROVED"));

        LocalDate today = LocalDate.now();
        String formattedDate = today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        request.setAttribute("presentToday", attendanceDAO.getAttendanceCountByStatusAndDate("PRESENT", formattedDate));
        request.setAttribute("absentToday", attendanceDAO.getAttendanceCountByStatusAndDate("ABSENT", formattedDate));
        request.setAttribute("lateToday", attendanceDAO.getAttendanceCountByStatusAndDate("LATE", formattedDate));

        String currentMonth = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
        request.setAttribute("pendingPayrollCount", payrollService.getPayrollCountByStatus("DRAFT", currentMonth));
        request.setAttribute("finalizedPayrollCount", payrollService.getPayrollCountByStatus("FINALIZED", currentMonth));
        request.setAttribute("paidPayrollCount", payrollService.getPayrollCountByStatus("PAID", currentMonth));
        request.setAttribute("recentActivities", userActivityDAO.getRecentActivities(10));
        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
    }

    private void renderHrDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException, SQLException {
        Employee hrEmployee = findEmployee(user);
        if (hrEmployee != null) {
            request.setAttribute("hrEmployee", hrEmployee);
        }

        int employeeCount = employeeDAO.getEmployeeCount();
        request.setAttribute("employeeCount", employeeCount);
        request.setAttribute("pendingLeaveCount", leaveDAO.getPendingLeaveCount());
        request.setAttribute("approvedLeaveCount", leaveDAO.getLeaveCountByStatus("APPROVED"));

        LocalDate today = LocalDate.now();
        String formattedDate = today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        int presentToday = attendanceDAO.getAttendanceCountByStatusAndDate("PRESENT", formattedDate);
        request.setAttribute("presentToday", presentToday);
        request.setAttribute("absentToday", attendanceDAO.getAttendanceCountByStatusAndDate("ABSENT", formattedDate));
        request.setAttribute("lateToday", attendanceDAO.getAttendanceCountByStatusAndDate("LATE", formattedDate));
        request.setAttribute("attendanceRate", employeeCount > 0 ? String.format("%.1f", ((double) presentToday / employeeCount) * 100) : "0.0");

        String currentMonth = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
        request.setAttribute("pendingPayrollCount", payrollService.getPayrollCountByStatus("DRAFT", currentMonth));
        request.setAttribute("finalizedPayrollCount", payrollService.getPayrollCountByStatus("FINALIZED", currentMonth));
        request.setAttribute("paidPayrollCount", payrollService.getPayrollCountByStatus("PAID", currentMonth));
        request.setAttribute("recentActivities", userActivityDAO.getRecentActivitiesByRole("HR", 5));
        request.getRequestDispatcher("/WEB-INF/hr/dashboard.jsp").forward(request, response);
    }

    private void renderEmployeeDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        Employee employee = findEmployee(user);
        if (employee == null) {
            request.setAttribute("errorMessage", "No employee record found for your account. Please contact HR.");
            request.getRequestDispatcher("/WEB-INF/employee/dashboard.jsp").forward(request, response);
            return;
        }

        request.setAttribute("employee", employee);
        request.setAttribute("attendanceRate", attendanceDAO.getEmployeeAttendanceRate(employee.getId()));
        request.setAttribute("attendanceRateChange", attendanceDAO.getAttendanceRateChange(employee.getId()));
        request.setAttribute("leaveBalance", leaveDAO.getEmployeeLeaveBalance(employee.getId()));
        request.setAttribute("leaveBalanceChange", leaveDAO.getLeaveBalanceChange(employee.getId()));
        request.setAttribute("pendingLeaveCount", leaveDAO.getEmployeePendingLeaveCount(employee.getId()));
        request.setAttribute("nextPayrollDate", payrollService.getNextPayrollDate());
        request.setAttribute("daysUntilNextPayroll", payrollService.getDaysUntilNextPayroll());
        request.setAttribute("unreadNotificationCount", notificationDAO.getUnreadNotificationCount(employee.getId()));
        List<UserActivity> recentActivities = userActivityDAO.getRecentActivitiesByUserId(user.getId(), 5);
        request.setAttribute("recentActivities", recentActivities);
        request.getRequestDispatcher("/WEB-INF/employee/dashboard.jsp").forward(request, response);
    }

    private Employee findEmployee(User user) {
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());
        if (employee == null) {
            employee = employeeDAO.getEmployeeByEmail(user.getUsername() + "@company.com");
            if (employee != null && employee.getUserId() == null) {
                employee.setUserId(user.getId());
                employeeDAO.updateEmployee(employee);
            }
        }
        return employee;
    }
}
