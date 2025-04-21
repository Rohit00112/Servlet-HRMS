package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.DepartmentDAO;
import com.example.hrms.dao.DesignationDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.Department;
import com.example.hrms.model.Designation;
import com.example.hrms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "profileServlet", value = {"/employee/profile", "/hr/profile", "/admin/profile"})
public class ProfileServlet extends HttpServlet {
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
        // Get the current user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get the employee for the current user
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());

        // If not found by user ID, try by email
        if (employee == null) {
            employee = employeeDAO.getEmployeeByEmail(user.getUsername() + "@company.com");
        }

        if (employee == null) {
            request.setAttribute("errorMessage", "Employee profile not found. Please contact HR.");
        } else {
            // Get department and designation details
            Department department = departmentDAO.getDepartmentById(employee.getDepartmentId());
            Designation designation = designationDAO.getDesignationById(employee.getDesignationId());
            
            request.setAttribute("employee", employee);
            request.setAttribute("department", department);
            request.setAttribute("designation", designation);
        }

        // Forward to the appropriate view based on the user's role
        String role = user.getRole();
        String requestURI = request.getRequestURI();
        
        if (role.equals("ADMIN") || requestURI.contains("/admin/")) {
            request.getRequestDispatcher("/WEB-INF/admin/profile.jsp").forward(request, response);
        } else if (role.equals("HR") || requestURI.contains("/hr/")) {
            request.getRequestDispatcher("/WEB-INF/hr/profile.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/employee/profile.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get the employee for the current user
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());

        // If not found by user ID, try by email
        if (employee == null) {
            employee = employeeDAO.getEmployeeByEmail(user.getUsername() + "@company.com");
        }

        if (employee == null) {
            request.setAttribute("errorMessage", "Employee profile not found. Please contact HR.");
            doGet(request, response);
            return;
        }

        // Update basic profile information
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        
        if (name != null && !name.trim().isEmpty()) {
            employee.setName(name);
        }
        
        if (email != null && !email.trim().isEmpty()) {
            employee.setEmail(email);
        }
        
        // Update employee in database
        boolean success = employeeDAO.updateEmployee(employee);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Profile updated successfully");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to update profile");
        }
        
        // Redirect to profile page
        response.sendRedirect(request.getRequestURI());
    }
}
