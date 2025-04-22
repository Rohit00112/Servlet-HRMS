package com.example.hrms.service;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.UserDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;
import com.example.hrms.util.EmailUtil;
import com.example.hrms.util.PasswordUtil;

/**
 * Service class for user-related operations
 */
public class UserService {

    private UserDAO userDAO;
    private EmployeeDAO employeeDAO;

    public UserService() {
        userDAO = new UserDAO();
        employeeDAO = new EmployeeDAO();
    }

    /**
     * Create a new user account for an employee
     *
     * @param employee The employee to create a user account for
     * @param role The role of the user (HR, EMPLOYEE)
     * @return The created user
     */
    public User createUserForEmployee(Employee employee, String role) {
        // Generate username from email (before the @ symbol)
        String email = employee.getEmail();
        String username = email.substring(0, email.indexOf('@'));

        // Check if username already exists
        User existingUser = userDAO.getUserByUsername(username);
        if (existingUser != null) {
            // Append a number to make the username unique
            int suffix = 1;
            while (existingUser != null) {
                username = email.substring(0, email.indexOf('@')) + suffix;
                existingUser = userDAO.getUserByUsername(username);
                suffix++;
            }
        }

        // Generate a random password
        String password = PasswordUtil.generateRandomPassword(10);

        // Create the user
        User user = new User();
        user.setUsername(username);
        user.setPasswordHash(PasswordUtil.hashPassword(password));
        user.setRole(role);
        user.setPasswordChangeRequired(true); // Require password change on first login

        // Save the user
        boolean success = userDAO.createUser(user);

        if (success) {
            // Get the user ID
            user = userDAO.getUserByUsername(username);

            // Update the employee with the user ID
            employee.setUserId(user.getId());
            employee.setRole(role);
            employeeDAO.updateEmployee(employee);

            // Send email with credentials
            EmailUtil.sendAccountCreationEmail(employee.getEmail(), username, password, role);

            return user;
        }

        return null;
    }

    /**
     * Check if an employee already has a user account
     *
     * @param employeeId The employee ID
     * @return True if the employee has a user account
     */
    public boolean employeeHasUserAccount(int employeeId) {
        Employee employee = employeeDAO.getEmployeeById(employeeId);
        return employee != null && employee.getUserId() != null;
    }

    /**
     * Get a user by ID
     *
     * @param userId The user ID
     * @return The user, or null if not found
     */
    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }
}
