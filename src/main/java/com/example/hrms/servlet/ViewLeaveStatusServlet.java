package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.LeaveDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.Leave;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "viewLeaveStatusServlet", value = {"/employee/leave/status", "/hr/leave/all", "/admin/leave/all"})
public class ViewLeaveStatusServlet extends HttpServlet {
    private LeaveDAO leaveDAO;
    private EmployeeDAO employeeDAO;
    
    @Override
    public void init() {
        leaveDAO = new LeaveDAO();
        employeeDAO = new EmployeeDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user's username and role from the session
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        
        if (username == null || role == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Handle based on role
        if (role.equals("EMPLOYEE")) {
            // Get the employee ID for the current user
            Employee employee = employeeDAO.getEmployeeByEmail(username);
            
            if (employee == null) {
                request.getSession().setAttribute("errorMessage", "Employee record not found for the current user");
                response.sendRedirect(request.getContextPath() + "/employee/dashboard");
                return;
            }
            
            // Get leave applications for this employee
            List<Leave> leaves = leaveDAO.getLeavesByEmployeeId(employee.getId());
            request.setAttribute("leaves", leaves);
            
            // Forward to employee leave status page
            request.getRequestDispatcher("/WEB-INF/employee/leave-status.jsp").forward(request, response);
        } else if (role.equals("HR") || role.equals("ADMIN")) {
            // Get all leave applications for HR/Admin
            List<Leave> leaves = leaveDAO.getAllLeaves();
            request.setAttribute("leaves", leaves);
            
            // Get pending leave count
            int pendingCount = leaveDAO.getPendingLeaveCount();
            request.setAttribute("pendingCount", pendingCount);
            
            // Forward to HR/Admin leave management page
            String requestURI = request.getRequestURI();
            if (requestURI.contains("/hr/")) {
                request.getRequestDispatcher("/WEB-INF/hr/leave-management.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/WEB-INF/admin/leave-management.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
