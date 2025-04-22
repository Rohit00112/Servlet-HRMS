package com.example.hrms.servlet;

import com.example.hrms.dao.AttendanceDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.LeaveDAO;
import com.example.hrms.dao.UserActivityDAO;
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
import java.io.IOException;

@WebServlet(name = "adminDashboardServlet", value = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
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

            // Get payroll statistics
            String currentMonth = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            int pendingPayrollCount = payrollService.getPayrollCountByStatus("DRAFT", currentMonth);
            request.setAttribute("pendingPayrollCount", pendingPayrollCount);

            int finalizedPayrollCount = payrollService.getPayrollCountByStatus("FINALIZED", currentMonth);
            request.setAttribute("finalizedPayrollCount", finalizedPayrollCount);

            int paidPayrollCount = payrollService.getPayrollCountByStatus("PAID", currentMonth);
            request.setAttribute("paidPayrollCount", paidPayrollCount);

            // Get recent activities for admin dashboard
            List<UserActivity> recentActivities = userActivityDAO.getRecentActivities(10);
            request.setAttribute("recentActivities", recentActivities);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard data: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
    }
}
