package com.example.hrms.servlet;

import com.example.hrms.dao.AttendanceDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.LeaveDAO;
import com.example.hrms.dao.UserActivityDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;
import com.example.hrms.model.UserActivity;
import com.example.hrms.service.PayrollService;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "hrDashboardServlet", value = "/hr/dashboard")
public class HRDashboardServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private LeaveDAO leaveDAO;
    private PayrollService payrollService;
    private AttendanceDAO attendanceDAO;
    private UserActivityDAO userActivityDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        leaveDAO = new LeaveDAO();
        payrollService = new PayrollService();
        attendanceDAO = new AttendanceDAO();
        userActivityDAO = new UserActivityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get the current user from the session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Get the HR employee for the current user
            Employee hrEmployee = employeeDAO.getEmployeeByUserId(user.getId());

            if (hrEmployee != null) {
                request.setAttribute("hrEmployee", hrEmployee);
            }

            // Get employee count for dashboard
            int employeeCount = employeeDAO.getEmployeeCount();
            request.setAttribute("employeeCount", employeeCount);

            // Get leave statistics
            int pendingLeaveCount = leaveDAO.getPendingLeaveCount();
            request.setAttribute("pendingLeaveCount", pendingLeaveCount);

            int approvedLeaveCount = leaveDAO.getLeaveCountByStatus("APPROVED");
            request.setAttribute("approvedLeaveCount", approvedLeaveCount);

            // Get attendance statistics for today
            LocalDate today = LocalDate.now();
            String formattedDate = today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

            int presentToday = attendanceDAO.getAttendanceCountByStatusAndDate("PRESENT", formattedDate);
            request.setAttribute("presentToday", presentToday);

            int absentToday = attendanceDAO.getAttendanceCountByStatusAndDate("ABSENT", formattedDate);
            request.setAttribute("absentToday", absentToday);

            int lateToday = attendanceDAO.getAttendanceCountByStatusAndDate("LATE", formattedDate);
            request.setAttribute("lateToday", lateToday);

            // Calculate attendance rate
            double attendanceRate = 0.0;
            if (employeeCount > 0) {
                attendanceRate = ((double) presentToday / employeeCount) * 100;
            }
            request.setAttribute("attendanceRate", String.format("%.1f", attendanceRate));

            // Get payroll statistics
            String currentMonth = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            int pendingPayrollCount = payrollService.getPayrollCountByStatus("DRAFT", currentMonth);
            request.setAttribute("pendingPayrollCount", pendingPayrollCount);

            int finalizedPayrollCount = payrollService.getPayrollCountByStatus("FINALIZED", currentMonth);
            request.setAttribute("finalizedPayrollCount", finalizedPayrollCount);

            int paidPayrollCount = payrollService.getPayrollCountByStatus("PAID", currentMonth);
            request.setAttribute("paidPayrollCount", paidPayrollCount);

            // Get recent activities for HR dashboard
            List<UserActivity> recentActivities = userActivityDAO.getRecentActivitiesByRole("HR", 5);
            request.setAttribute("recentActivities", recentActivities);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard data: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/hr/dashboard.jsp").forward(request, response);
    }
}
