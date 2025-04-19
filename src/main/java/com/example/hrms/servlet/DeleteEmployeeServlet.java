package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "deleteEmployeeServlet", value = {"/admin/employees/delete", "/hr/employees/delete"})
public class DeleteEmployeeServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    
    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get employee ID from request parameter
        String employeeIdStr = request.getParameter("id");
        
        if (employeeIdStr == null || employeeIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Employee ID is required");
        } else {
            try {
                int employeeId = Integer.parseInt(employeeIdStr);
                
                // Delete employee from database
                boolean success = employeeDAO.deleteEmployee(employeeId);
                
                if (success) {
                    request.getSession().setAttribute("successMessage", "Employee deleted successfully");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to delete employee");
                }
                
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid employee ID");
            }
        }
        
        // Redirect to employee list
        if (request.getRequestURI().contains("/admin/")) {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
        } else {
            response.sendRedirect(request.getContextPath() + "/hr/employees");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle POST requests the same way as GET
        doGet(request, response);
    }
}
