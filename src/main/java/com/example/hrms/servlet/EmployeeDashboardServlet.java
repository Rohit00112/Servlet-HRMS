package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.LeaveDAO;
import com.example.hrms.model.Employee;

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
        // Get the current user's username from the session
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get the employee ID for the current user
        Employee employee = employeeDAO.getEmployeeByEmail(username);

        if (employee != null) {
            // Get pending leave count for this employee
            int pendingLeaveCount = leaveDAO.getEmployeePendingLeaveCount(employee.getId());
            request.setAttribute("pendingLeaveCount", pendingLeaveCount);

            // Set employee information for the dashboard
            request.setAttribute("employee", employee);
        }

        request.getRequestDispatcher("/WEB-INF/employee/dashboard.jsp").forward(request, response);
    }
}
