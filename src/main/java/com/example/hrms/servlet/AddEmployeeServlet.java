package com.example.hrms.servlet;

import com.example.hrms.dao.DepartmentDAO;
import com.example.hrms.dao.DesignationDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.model.Department;
import com.example.hrms.model.Designation;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;
import com.example.hrms.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "addEmployeeServlet", value = {"/admin/employees/add", "/hr/employees/add"})
public class AddEmployeeServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private DepartmentDAO departmentDAO;
    private DesignationDAO designationDAO;
    private UserService userService;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        departmentDAO = new DepartmentDAO();
        designationDAO = new DesignationDAO();
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get departments and designations for dropdowns
        List<Department> departments = departmentDAO.getAllDepartments();
        List<Designation> designations = designationDAO.getAllDesignations();

        request.setAttribute("departments", departments);
        request.setAttribute("designations", designations);

        // Forward to the appropriate view based on the user's role
        String requestURI = request.getRequestURI();
        if (requestURI.contains("/admin/")) {
            request.getRequestDispatcher("/WEB-INF/admin/add-employee.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/hr/add-employee.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String departmentIdStr = request.getParameter("departmentId");
        String designationIdStr = request.getParameter("designationId");
        String joinDateStr = request.getParameter("joinDate");

        // Validate form data
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            departmentIdStr == null || departmentIdStr.trim().isEmpty() ||
            designationIdStr == null || designationIdStr.trim().isEmpty() ||
            joinDateStr == null || joinDateStr.trim().isEmpty()) {

            request.getSession().setAttribute("errorMessage", "All fields are required");

            // Redirect back to the form
            if (request.getRequestURI().contains("/admin/")) {
                response.sendRedirect(request.getContextPath() + "/admin/employees/add");
            } else {
                response.sendRedirect(request.getContextPath() + "/hr/employees/add");
            }
            return;
        }

        try {
            // Parse form data
            int departmentId = Integer.parseInt(departmentIdStr);
            int designationId = Integer.parseInt(designationIdStr);
            Date joinDate = Date.valueOf(joinDateStr);

            // Create employee object
            Employee employee = new Employee();
            employee.setName(name);
            employee.setEmail(email);
            employee.setDepartmentId(departmentId);
            employee.setDesignationId(designationId);
            employee.setJoinDate(joinDate);

            // Save employee to database
            boolean success = employeeDAO.createEmployee(employee);

            if (success) {
                // Check if we need to create a user account
                String createAccountParam = request.getParameter("createAccount");
                boolean createAccount = "on".equals(createAccountParam);

                if (createAccount) {
                    String role = request.getParameter("role");
                    if (role != null && !role.isEmpty()) {
                        // Create user account
                        User user = userService.createUserForEmployee(employee, role);

                        if (user != null) {
                            request.getSession().setAttribute("successMessage", "Employee added successfully with user account");
                        } else {
                            request.getSession().setAttribute("successMessage", "Employee added successfully, but failed to create user account");
                        }
                    } else {
                        request.getSession().setAttribute("successMessage", "Employee added successfully, but no role specified for user account");
                    }
                } else {
                    request.getSession().setAttribute("successMessage", "Employee added successfully");
                }
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to add employee");
            }

            // Redirect to employee list
            if (request.getRequestURI().contains("/admin/")) {
                response.sendRedirect(request.getContextPath() + "/admin/employees");
            } else {
                response.sendRedirect(request.getContextPath() + "/hr/employees");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid department or designation");

            // Redirect back to the form
            if (request.getRequestURI().contains("/admin/")) {
                response.sendRedirect(request.getContextPath() + "/admin/employees/add");
            } else {
                response.sendRedirect(request.getContextPath() + "/hr/employees/add");
            }
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD");

            // Redirect back to the form
            if (request.getRequestURI().contains("/admin/")) {
                response.sendRedirect(request.getContextPath() + "/admin/employees/add");
            } else {
                response.sendRedirect(request.getContextPath() + "/hr/employees/add");
            }
        }
    }
}
