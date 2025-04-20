package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.LeaveDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;

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

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        leaveDAO = new LeaveDAO();
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
            // Get pending leave count for this employee
            int pendingLeaveCount = leaveDAO.getEmployeePendingLeaveCount(employee.getId());
            request.setAttribute("pendingLeaveCount", pendingLeaveCount);

            // Set employee information for the dashboard
            request.setAttribute("employee", employee);
        } else {
            // If employee not found, try to find by email (username)
            String username = user.getUsername();
            employee = employeeDAO.getEmployeeByEmail(username + "@company.com");

            if (employee != null) {
                // Get pending leave count for this employee
                int pendingLeaveCount = leaveDAO.getEmployeePendingLeaveCount(employee.getId());
                request.setAttribute("pendingLeaveCount", pendingLeaveCount);

                // Set employee information for the dashboard
                request.setAttribute("employee", employee);

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
