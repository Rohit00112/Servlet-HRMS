package com.example.hrms.servlet;

import com.example.hrms.dao.DepartmentDAO;
import com.example.hrms.model.Department;
import com.example.hrms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "departmentServlet", value = {"/admin/departments"})
public class DepartmentServlet extends BaseServlet {
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

        // Transfer any messages from the session to request attributes
        transferMessagesFromSessionToRequest(request);

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
                    setSuccessMessage(request, "Department \"" + name + "\" has been added successfully");
                } else {
                    setErrorMessage(request, "Failed to add department. Please try again or contact system administrator.");
                }
            } else {
                setErrorMessage(request, "Department name cannot be empty. Please provide a valid name.");
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
                        setSuccessMessage(request, "Department \"" + name + "\" has been updated successfully");
                    } else {
                        setErrorMessage(request, "Failed to update department. Please try again or contact system administrator.");
                    }
                } catch (NumberFormatException e) {
                    setErrorMessage(request, "Invalid department ID. Please try again with a valid ID.");
                }
            } else {
                setErrorMessage(request, "Department ID and name are required. Please provide both values.");
            }
        } else if ("delete".equals(action)) {
            // Delete a department
            String idStr = request.getParameter("id");

            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    // Get department name before deleting for better message
                    Department department = departmentDAO.getDepartmentById(id);
                    String departmentName = department != null ? department.getName() : "Unknown";

                    boolean success = departmentDAO.deleteDepartment(id);
                    if (success) {
                        setSuccessMessage(request, "Department \"" + departmentName + "\" has been deleted successfully");
                    } else {
                        setErrorMessage(request, "Failed to delete department. It may be in use by employees or other records.");
                    }
                } catch (NumberFormatException e) {
                    setErrorMessage(request, "Invalid department ID. Please try again with a valid ID.");
                }
            } else {
                setErrorMessage(request, "Department ID is required. Please provide a valid ID.");
            }
        }

        // Redirect back to the departments page
        response.sendRedirect(request.getContextPath() + "/admin/departments");
    }
}
