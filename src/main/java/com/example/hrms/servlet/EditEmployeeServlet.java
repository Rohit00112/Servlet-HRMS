package com.example.hrms.servlet;

import com.example.hrms.dao.DepartmentDAO;
import com.example.hrms.dao.DesignationDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.model.Department;
import com.example.hrms.model.Designation;
import com.example.hrms.model.Employee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "editEmployeeServlet", value = {"/admin/employees/edit", "/hr/employees/edit"})
public class EditEmployeeServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private DepartmentDAO departmentDAO;
    private DesignationDAO designationDAO;
    
    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        departmentDAO = new DepartmentDAO();
        designationDAO = new DesignationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get employee ID from request parameter
        String employeeIdStr = request.getParameter("id");
        
        if (employeeIdStr == null || employeeIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Employee ID is required");
            
            // Redirect to employee list
            if (request.getRequestURI().contains("/admin/")) {
                response.sendRedirect(request.getContextPath() + "/admin/employees");
            } else {
                response.sendRedirect(request.getContextPath() + "/hr/employees");
            }
            return;
        }
        
        try {
            int employeeId = Integer.parseInt(employeeIdStr);
            
            // Get employee from database
            Employee employee = employeeDAO.getEmployeeById(employeeId);
            
            if (employee == null) {
                request.getSession().setAttribute("errorMessage", "Employee not found");
                
                // Redirect to employee list
                if (request.getRequestURI().contains("/admin/")) {
                    response.sendRedirect(request.getContextPath() + "/admin/employees");
                } else {
                    response.sendRedirect(request.getContextPath() + "/hr/employees");
                }
                return;
            }
            
            // Get departments and designations for dropdowns
            List<Department> departments = departmentDAO.getAllDepartments();
            List<Designation> designations = designationDAO.getAllDesignations();
            
            request.setAttribute("employee", employee);
            request.setAttribute("departments", departments);
            request.setAttribute("designations", designations);
            
            // Forward to the appropriate view based on the user's role
            if (request.getRequestURI().contains("/admin/")) {
                request.getRequestDispatcher("/WEB-INF/admin/edit-employee.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/WEB-INF/hr/edit-employee.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid employee ID");
            
            // Redirect to employee list
            if (request.getRequestURI().contains("/admin/")) {
                response.sendRedirect(request.getContextPath() + "/admin/employees");
            } else {
                response.sendRedirect(request.getContextPath() + "/hr/employees");
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String employeeIdStr = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String departmentIdStr = request.getParameter("departmentId");
        String designationIdStr = request.getParameter("designationId");
        String joinDateStr = request.getParameter("joinDate");
        
        // Validate form data
        if (employeeIdStr == null || employeeIdStr.trim().isEmpty() ||
            name == null || name.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            departmentIdStr == null || departmentIdStr.trim().isEmpty() || 
            designationIdStr == null || designationIdStr.trim().isEmpty() || 
            joinDateStr == null || joinDateStr.trim().isEmpty()) {
            
            request.getSession().setAttribute("errorMessage", "All fields are required");
            
            // Redirect back to the form
            if (request.getRequestURI().contains("/admin/")) {
                response.sendRedirect(request.getContextPath() + "/admin/employees/edit?id=" + employeeIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/hr/employees/edit?id=" + employeeIdStr);
            }
            return;
        }
        
        try {
            // Parse form data
            int employeeId = Integer.parseInt(employeeIdStr);
            int departmentId = Integer.parseInt(departmentIdStr);
            int designationId = Integer.parseInt(designationIdStr);
            Date joinDate = Date.valueOf(joinDateStr);
            
            // Create employee object
            Employee employee = new Employee();
            employee.setId(employeeId);
            employee.setName(name);
            employee.setEmail(email);
            employee.setDepartmentId(departmentId);
            employee.setDesignationId(designationId);
            employee.setJoinDate(joinDate);
            
            // Update employee in database
            boolean success = employeeDAO.updateEmployee(employee);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Employee updated successfully");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update employee");
            }
            
            // Redirect to employee list
            if (request.getRequestURI().contains("/admin/")) {
                response.sendRedirect(request.getContextPath() + "/admin/employees");
            } else {
                response.sendRedirect(request.getContextPath() + "/hr/employees");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid employee, department, or designation ID");
            
            // Redirect back to the form
            if (request.getRequestURI().contains("/admin/")) {
                response.sendRedirect(request.getContextPath() + "/admin/employees/edit?id=" + employeeIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/hr/employees/edit?id=" + employeeIdStr);
            }
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD");
            
            // Redirect back to the form
            if (request.getRequestURI().contains("/admin/")) {
                response.sendRedirect(request.getContextPath() + "/admin/employees/edit?id=" + employeeIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/hr/employees/edit?id=" + employeeIdStr);
            }
        }
    }
}
