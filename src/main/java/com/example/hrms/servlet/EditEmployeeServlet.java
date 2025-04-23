package com.example.hrms.servlet;

import com.example.hrms.dao.DepartmentDAO;
import com.example.hrms.dao.DesignationDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.UserActivityDAO;
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

@WebServlet(name = "editEmployeeServlet", value = {"/admin/employees/edit", "/hr/employees/edit"})
public class EditEmployeeServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private DepartmentDAO departmentDAO;
    private DesignationDAO designationDAO;
    private UserService userService;
    private UserActivityDAO userActivityDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        departmentDAO = new DepartmentDAO();
        designationDAO = new DesignationDAO();
        userService = new UserService();
        userActivityDAO = new UserActivityDAO();
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

            // Check if employee has a user account
            if (employee.getUserId() != null) {
                // Get the user role
                User user = userService.getUserById(employee.getUserId());
                if (user != null) {
                    employee.setRole(user.getRole());
                }
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

            // Get the existing employee to preserve the userId
            Employee existingEmployee = employeeDAO.getEmployeeById(employeeId);
            if (existingEmployee != null && existingEmployee.getUserId() != null) {
                employee.setUserId(existingEmployee.getUserId());
            }

            // Update employee in database
            boolean success = employeeDAO.updateEmployee(employee);

            if (success) {
                // Check if we need to create a user account
                String createAccountParam = request.getParameter("createAccount");
                boolean createAccount = "on".equals(createAccountParam);

                if (createAccount && employee.getUserId() == null) {
                    String role = request.getParameter("role");
                    if (role != null && !role.isEmpty()) {
                        // Create user account
                        User user = userService.createUserForEmployee(employee, role);

                        if (user != null) {
                            // Log the activity
                            HttpSession session = request.getSession();
                            User currentUser = (User) session.getAttribute("user");
                            userActivityDAO.logActivity(
                                currentUser.getId(),
                                currentUser.getUsername(),
                                currentUser.getRole(),
                                "UPDATE",
                                currentUser.getUsername() + " updated employee: " + name + " and created user account",
                                "EMPLOYEE",
                                employee.getId(),
                                request.getRemoteAddr()
                            );

                            request.getSession().setAttribute("successMessage", "Employee updated successfully with new user account");
                        } else {
                            request.getSession().setAttribute("successMessage", "Employee updated successfully, but failed to create user account");
                        }
                    } else {
                        request.getSession().setAttribute("successMessage", "Employee updated successfully, but no role specified for user account");
                    }
                } else {
                    // Log the activity
                    HttpSession session = request.getSession();
                    User currentUser = (User) session.getAttribute("user");
                    userActivityDAO.logActivity(
                        currentUser.getId(),
                        currentUser.getUsername(),
                        currentUser.getRole(),
                        "UPDATE",
                        currentUser.getUsername() + " updated employee: " + name,
                        "EMPLOYEE",
                        employee.getId(),
                        request.getRemoteAddr()
                    );

                    request.getSession().setAttribute("successMessage", "Employee updated successfully");
                }
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
