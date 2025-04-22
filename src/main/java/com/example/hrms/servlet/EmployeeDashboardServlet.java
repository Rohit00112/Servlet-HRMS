package com.example.hrms.servlet;

import com.example.hrms.dao.AttendanceDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.LeaveDAO;
import com.example.hrms.dao.NotificationDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;
import com.example.hrms.service.PayrollService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "employeeDashboardServlet", value = "/employee/dashboard")
public class EmployeeDashboardServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private LeaveDAO leaveDAO;
    private AttendanceDAO attendanceDAO;
    private NotificationDAO notificationDAO;
    private PayrollService payrollService;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        leaveDAO = new LeaveDAO();
        attendanceDAO = new AttendanceDAO();
        notificationDAO = new NotificationDAO();
        payrollService = new PayrollService();
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

        if (employee != null) {
            // Get employee information for the dashboard
            request.setAttribute("employee", employee);

            // Get attendance rate for this employee
            double attendanceRate = attendanceDAO.getEmployeeAttendanceRate(employee.getId());
            request.setAttribute("attendanceRate", attendanceRate);

            // Get attendance rate change
            double attendanceRateChange = attendanceDAO.getAttendanceRateChange(employee.getId());
            request.setAttribute("attendanceRateChange", attendanceRateChange);

            // Get leave balance for this employee
            int leaveBalance = leaveDAO.getEmployeeLeaveBalance(employee.getId());
            request.setAttribute("leaveBalance", leaveBalance);

            // Get leave balance change
            int leaveBalanceChange = leaveDAO.getLeaveBalanceChange(employee.getId());
            request.setAttribute("leaveBalanceChange", leaveBalanceChange);

            // Get pending leave count for this employee
            int pendingLeaveCount = leaveDAO.getEmployeePendingLeaveCount(employee.getId());
            request.setAttribute("pendingLeaveCount", pendingLeaveCount);

            // Get next payroll date
            String nextPayrollDate = payrollService.getNextPayrollDate();
            request.setAttribute("nextPayrollDate", nextPayrollDate);

            // Get days until next payroll
            int daysUntilNextPayroll = payrollService.getDaysUntilNextPayroll();
            request.setAttribute("daysUntilNextPayroll", daysUntilNextPayroll);

            // Get unread notification count
            int unreadNotificationCount = notificationDAO.getUnreadNotificationCount(employee.getId());
            request.setAttribute("unreadNotificationCount", unreadNotificationCount);
        } else {
            // If employee not found, try to find by email (username)
            String username = user.getUsername();
            employee = employeeDAO.getEmployeeByEmail(username + "@company.com");

            if (employee != null) {
                // Set employee information for the dashboard
                request.setAttribute("employee", employee);

                // Get attendance rate for this employee
                double attendanceRate = attendanceDAO.getEmployeeAttendanceRate(employee.getId());
                request.setAttribute("attendanceRate", attendanceRate);

                // Get attendance rate change
                double attendanceRateChange = attendanceDAO.getAttendanceRateChange(employee.getId());
                request.setAttribute("attendanceRateChange", attendanceRateChange);

                // Get leave balance for this employee
                int leaveBalance = leaveDAO.getEmployeeLeaveBalance(employee.getId());
                request.setAttribute("leaveBalance", leaveBalance);

                // Get leave balance change
                int leaveBalanceChange = leaveDAO.getLeaveBalanceChange(employee.getId());
                request.setAttribute("leaveBalanceChange", leaveBalanceChange);

                // Get pending leave count for this employee
                int pendingLeaveCount = leaveDAO.getEmployeePendingLeaveCount(employee.getId());
                request.setAttribute("pendingLeaveCount", pendingLeaveCount);

                // Get next payroll date
                String nextPayrollDate = payrollService.getNextPayrollDate();
                request.setAttribute("nextPayrollDate", nextPayrollDate);

                // Get days until next payroll
                int daysUntilNextPayroll = payrollService.getDaysUntilNextPayroll();
                request.setAttribute("daysUntilNextPayroll", daysUntilNextPayroll);

                // Get unread notification count
                int unreadNotificationCount = notificationDAO.getUnreadNotificationCount(employee.getId());
                request.setAttribute("unreadNotificationCount", unreadNotificationCount);

                // Update the employee with the user ID for future reference
                employee.setUserId(user.getId());
                employeeDAO.updateEmployee(employee);
            } else {
                // No employee record found
                request.setAttribute("errorMessage", "No employee record found for your account. Please contact HR.");
            }
        }

        request.getRequestDispatcher("/WEB-INF/employee/dashboard.jsp").forward(request, response);
    }
}
