package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.UserDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;
import com.example.hrms.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

/**
 * Servlet for creating test users for HR and Employee roles.
 * This servlet should only be used for testing purposes.
 */
@WebServlet(name = "createTestUsersServlet", value = "/admin/create-test-users")
public class CreateTestUsersServlet extends HttpServlet {
    private UserDAO userDAO;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if the user is an admin
        String role = (String) request.getSession().getAttribute("role");
        if (!"ADMIN".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // Create HR user if it doesn't exist
        User hrUser = userDAO.getUserByUsername("hr");
        if (hrUser == null) {
            hrUser = new User();
            hrUser.setUsername("hr");
            hrUser.setPasswordHash(PasswordUtil.hashPassword("hr123"));
            hrUser.setRole("HR");
            userDAO.createUser(hrUser);
            hrUser = userDAO.getUserByUsername("hr");
        }

        // Create HR employee if it doesn't exist
        Employee hrEmployee = employeeDAO.getEmployeeByEmail("hr@company.com");
        if (hrEmployee == null) {
            hrEmployee = new Employee();
            hrEmployee.setName("HR Manager");
            hrEmployee.setEmail("hr@company.com");
            hrEmployee.setDepartmentId(1); // Assuming department ID 1 exists
            hrEmployee.setDesignationId(1); // Assuming designation ID 1 exists
            hrEmployee.setJoinDate(new Date(System.currentTimeMillis()));
            hrEmployee.setUserId(hrUser.getId());
            employeeDAO.createEmployee(hrEmployee);
        } else if (hrEmployee.getUserId() == null) {
            hrEmployee.setUserId(hrUser.getId());
            employeeDAO.updateEmployee(hrEmployee);
        }

        // Create Employee user if it doesn't exist
        User empUser = userDAO.getUserByUsername("employee");
        if (empUser == null) {
            empUser = new User();
            empUser.setUsername("employee");
            empUser.setPasswordHash(PasswordUtil.hashPassword("emp123"));
            empUser.setRole("EMPLOYEE");
            userDAO.createUser(empUser);
            empUser = userDAO.getUserByUsername("employee");
        }

        // Create Employee record if it doesn't exist
        Employee employee = employeeDAO.getEmployeeByEmail("employee@company.com");
        if (employee == null) {
            employee = new Employee();
            employee.setName("Test Employee");
            employee.setEmail("employee@company.com");
            employee.setDepartmentId(1); // Assuming department ID 1 exists
            employee.setDesignationId(2); // Assuming designation ID 2 exists
            employee.setJoinDate(new Date(System.currentTimeMillis()));
            employee.setUserId(empUser.getId());
            employeeDAO.createEmployee(employee);
        } else if (employee.getUserId() == null) {
            employee.setUserId(empUser.getId());
            employeeDAO.updateEmployee(employee);
        }

        // Set success message
        request.getSession().setAttribute("successMessage", "Test users created successfully. HR: hr/hr123, Employee: employee/emp123");

        // Redirect back to admin dashboard
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
