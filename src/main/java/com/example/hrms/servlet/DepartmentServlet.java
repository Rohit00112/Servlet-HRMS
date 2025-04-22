package com.example.hrms.servlet;

import com.example.hrms.dao.DepartmentDAO;
import com.example.hrms.model.Department;
import com.example.hrms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "departmentServlet", value = {"/admin/departments"})
public class DepartmentServlet extends HttpServlet {
    private DepartmentDAO departmentDAO;
    
    @Override
    public void init() {
        departmentDAO = new DepartmentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.getRole().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get all departments
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        
        // Forward to the departments page
        request.getRequestDispatcher("/WEB-INF/admin/departments.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.getRole().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get form parameters
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            // Add a new department
            String name = request.getParameter("name");
            
            if (name != null && !name.trim().isEmpty()) {
                Department department = new Department();
                department.setName(name);
                
                boolean success = departmentDAO.createDepartment(department);
                if (success) {
                    request.setAttribute("successMessage", "Department added successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to add department");
                }
            } else {
                request.setAttribute("errorMessage", "Department name cannot be empty");
            }
        } else if ("update".equals(action)) {
            // Update an existing department
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            
            if (idStr != null && name != null && !name.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    Department department = new Department();
                    department.setId(id);
                    department.setName(name);
                    
                    boolean success = departmentDAO.updateDepartment(department);
                    if (success) {
                        request.setAttribute("successMessage", "Department updated successfully");
                    } else {
                        request.setAttribute("errorMessage", "Failed to update department");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid department ID");
                }
            } else {
                request.setAttribute("errorMessage", "Department ID and name are required");
            }
        } else if ("delete".equals(action)) {
            // Delete a department
            String idStr = request.getParameter("id");
            
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    boolean success = departmentDAO.deleteDepartment(id);
                    if (success) {
                        request.setAttribute("successMessage", "Department deleted successfully");
                    } else {
                        request.setAttribute("errorMessage", "Failed to delete department");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid department ID");
                }
            } else {
                request.setAttribute("errorMessage", "Department ID is required");
            }
        }
        
        // Redirect back to the departments page
        response.sendRedirect(request.getContextPath() + "/admin/departments");
    }
}
