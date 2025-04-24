package com.example.hrms.util;

import java.io.IOException;
import java.sql.*;
import java.util.Properties;

public class DatabaseConnection {
    private static final String PROPERTIES_FILE = "db.properties";
    private static String DB_URL;
    private static String DB_NAME;
    private static String DB_USER;
    private static String DB_PASSWORD;
    private static String DB_FULL_URL;

    static {
        try {
            // Load database properties
            Properties properties = PropertyLoader.loadProperties(PROPERTIES_FILE);

            // Get database properties
            DB_URL = properties.getProperty("db.url");
            DB_NAME = properties.getProperty("db.name");
            DB_USER = properties.getProperty("db.user");
            DB_PASSWORD = properties.getProperty("db.password");
            DB_FULL_URL = DB_URL + DB_NAME;

            // Load JDBC driver
            Class.forName("org.postgresql.Driver");

            // Initialize database
            createDatabaseIfNotExists();
            createTablesIfNotExist();
            executeUpdateScripts();

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            System.err.println("Error loading database properties: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_FULL_URL, DB_USER, DB_PASSWORD);
    }

    private static void createDatabaseIfNotExists() throws SQLException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            Statement stmt = conn.createStatement();

            // Check if database exists
            ResultSet rs = stmt.executeQuery("SELECT 1 FROM pg_database WHERE datname = '" + DB_NAME + "'");
            if (!rs.next()) {
                // Database doesn't exist, create it
                stmt.executeUpdate("CREATE DATABASE " + DB_NAME);
                System.out.println("Database created successfully");
            }
        }
    }

    private static void createTablesIfNotExist() throws SQLException {
        try (Connection conn = getConnection()) {
            Statement stmt = conn.createStatement();

            // Create users table if it doesn't exist
            String createUsersTable = "CREATE TABLE IF NOT EXISTS users (" +
                    "id SERIAL PRIMARY KEY, " +
                    "username VARCHAR(50) UNIQUE NOT NULL, " +
                    "password_hash VARCHAR(100) NOT NULL, " +
                    "role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'HR', 'EMPLOYEE'))" +
                    ")";
            stmt.executeUpdate(createUsersTable);

            // Create departments table if it doesn't exist
            String createDepartmentsTable = "CREATE TABLE IF NOT EXISTS departments (" +
                    "id SERIAL PRIMARY KEY, " +
                    "name VARCHAR(100) UNIQUE NOT NULL" +
                    ")";
            stmt.executeUpdate(createDepartmentsTable);

            // Create designations table if it doesn't exist
            String createDesignationsTable = "CREATE TABLE IF NOT EXISTS designations (" +
                    "id SERIAL PRIMARY KEY, " +
                    "title VARCHAR(100) UNIQUE NOT NULL" +
                    ")";
            stmt.executeUpdate(createDesignationsTable);

            // Create employees table if it doesn't exist
            String createEmployeesTable = "CREATE TABLE IF NOT EXISTS employees (" +
                    "id SERIAL PRIMARY KEY, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "email VARCHAR(100) UNIQUE NOT NULL, " +
                    "department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL, " +
                    "designation_id INTEGER REFERENCES designations(id) ON DELETE SET NULL, " +
                    "join_date DATE NOT NULL" +
                    ")";
            stmt.executeUpdate(createEmployeesTable);

            // Create leaves table if it doesn't exist
            String createLeavesTable = "CREATE TABLE IF NOT EXISTS leaves (" +
                    "id SERIAL PRIMARY KEY, " +
                    "employee_id INTEGER REFERENCES employees(id) ON DELETE CASCADE, " +
                    "start_date DATE NOT NULL, " +
                    "end_date DATE NOT NULL, " +
                    "reason TEXT NOT NULL, " +
                    "status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED')), " +
                    "applied_date DATE NOT NULL, " +
                    "reviewed_by INTEGER REFERENCES users(id) ON DELETE SET NULL, " +
                    "reviewed_date DATE, " +
                    "comments TEXT" +
                    ")";
            stmt.executeUpdate(createLeavesTable);

            // Create attendance table if it doesn't exist
            String createAttendanceTable = "CREATE TABLE IF NOT EXISTS attendance (" +
                    "id SERIAL PRIMARY KEY, " +
                    "employee_id INTEGER REFERENCES employees(id) ON DELETE CASCADE, " +
                    "date DATE NOT NULL, " +
                    "check_in_time TIME, " +
                    "check_out_time TIME, " +
                    "status VARCHAR(20) NOT NULL CHECK (status IN ('PRESENT', 'ABSENT', 'HALF_DAY', 'LATE')), " +
                    "notes TEXT, " +
                    "UNIQUE(employee_id, date)" +
                    ")";
            stmt.executeUpdate(createAttendanceTable);

            // Create payroll table if it doesn't exist
            String createPayrollTable = "CREATE TABLE IF NOT EXISTS payroll (" +
                    "id SERIAL PRIMARY KEY, " +
                    "employee_id INTEGER REFERENCES employees(id) ON DELETE CASCADE, " +
                    "month VARCHAR(7) NOT NULL, " + // Format: YYYY-MM
                    "base_salary DECIMAL(10, 2) NOT NULL, " +
                    "days_present INTEGER NOT NULL, " +
                    "days_absent INTEGER NOT NULL, " +
                    "days_late INTEGER NOT NULL, " +
                    "days_half INTEGER NOT NULL, " +
                    "allowances DECIMAL(10, 2) DEFAULT 0, " +
                    "deductions DECIMAL(10, 2) DEFAULT 0, " +
                    "net_salary DECIMAL(10, 2) NOT NULL, " +
                    "generation_date DATE NOT NULL, " +
                    "status VARCHAR(20) NOT NULL CHECK (status IN ('DRAFT', 'FINALIZED', 'PAID')), " +
                    "notes TEXT, " +
                    "UNIQUE(employee_id, month)" +
                    ")";
            stmt.executeUpdate(createPayrollTable);

            // Create notifications table if it doesn't exist
            String createNotificationsTable = "CREATE TABLE IF NOT EXISTS notifications (" +
                    "id SERIAL PRIMARY KEY, " +
                    "employee_id INTEGER REFERENCES employees(id) ON DELETE CASCADE, " +
                    "title VARCHAR(255) NOT NULL, " +
                    "message TEXT NOT NULL, " +
                    "type VARCHAR(50) NOT NULL, " + // INFO, SUCCESS, WARNING, ERROR
                    "is_read BOOLEAN DEFAULT FALSE, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")";
            stmt.executeUpdate(createNotificationsTable);

            // Create indexes for notifications table
            stmt.executeUpdate("CREATE INDEX IF NOT EXISTS idx_notifications_employee_id ON notifications(employee_id)");
            stmt.executeUpdate("CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read)");

            // Create user_activities table if it doesn't exist
            String createUserActivitiesTable = "CREATE TABLE IF NOT EXISTS user_activities (" +
                    "id SERIAL PRIMARY KEY, " +
                    "user_id INTEGER REFERENCES users(id) ON DELETE CASCADE, " +
                    "username VARCHAR(50) NOT NULL, " +
                    "user_role VARCHAR(20) NOT NULL, " +
                    "activity_type VARCHAR(50) NOT NULL, " + // LOGIN, LOGOUT, CREATE, UPDATE, DELETE, etc.
                    "description TEXT NOT NULL, " +
                    "entity_type VARCHAR(50), " + // EMPLOYEE, LEAVE, ATTENDANCE, PAYROLL, etc.
                    "entity_id INTEGER, " + // ID of the related entity (if applicable)
                    "timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "ip_address VARCHAR(50)" +
                    ")";
            stmt.executeUpdate(createUserActivitiesTable);

            // Create indexes for user_activities table
            stmt.executeUpdate("CREATE INDEX IF NOT EXISTS idx_user_activities_user_id ON user_activities(user_id)");
            stmt.executeUpdate("CREATE INDEX IF NOT EXISTS idx_user_activities_timestamp ON user_activities(timestamp)");
            stmt.executeUpdate("CREATE INDEX IF NOT EXISTS idx_user_activities_entity ON user_activities(entity_type, entity_id)");

            // Check if admin user exists, if not create default admin
            String checkAdmin = "SELECT COUNT(*) FROM users WHERE role = 'ADMIN'";
            ResultSet rs = stmt.executeQuery(checkAdmin);
            rs.next();
            int adminCount = rs.getInt(1);

            if (adminCount == 0) {
                // Create default admin user with password 'admin123'
                // In a real application, you would use a more secure password and prompt for it
                String hashedPassword = at.favre.lib.crypto.bcrypt.BCrypt.withDefaults().hashToString(12, "admin123".toCharArray());
                String insertAdmin = "INSERT INTO users (username, password_hash, role) VALUES ('admin', ?, 'ADMIN')";

                PreparedStatement pstmt = conn.prepareStatement(insertAdmin);
                pstmt.setString(1, hashedPassword);
                pstmt.executeUpdate();

                System.out.println("Default admin user created");
            }

            // Add some default departments if none exist
            String checkDepartments = "SELECT COUNT(*) FROM departments";
            rs = stmt.executeQuery(checkDepartments);
            rs.next();
            int departmentCount = rs.getInt(1);

            if (departmentCount == 0) {
                String[] defaultDepartments = {"Human Resources", "Information Technology", "Finance", "Marketing", "Operations"};
                for (String dept : defaultDepartments) {
                    String insertDept = "INSERT INTO departments (name) VALUES (?)";
                    PreparedStatement pstmt = conn.prepareStatement(insertDept);
                    pstmt.setString(1, dept);
                    pstmt.executeUpdate();
                }
                System.out.println("Default departments created");
            }

            // Add some default designations if none exist
            String checkDesignations = "SELECT COUNT(*) FROM designations";
            rs = stmt.executeQuery(checkDesignations);
            rs.next();
            int designationCount = rs.getInt(1);

            if (designationCount == 0) {
                String[] defaultDesignations = {"Manager", "Team Lead", "Senior Developer", "Junior Developer", "HR Specialist", "Financial Analyst", "Marketing Specialist"};
                for (String desig : defaultDesignations) {
                    String insertDesig = "INSERT INTO designations (title) VALUES (?)";
                    PreparedStatement pstmt = conn.prepareStatement(insertDesig);
                    pstmt.setString(1, desig);
                    pstmt.executeUpdate();
                }
                System.out.println("Default designations created");
            }

            // Add some sample notifications if none exist
            String checkNotifications = "SELECT COUNT(*) FROM notifications";
            rs = stmt.executeQuery(checkNotifications);
            rs.next();
            int notificationCount = rs.getInt(1);

            if (notificationCount == 0) {
                // Get the first employee ID (if any)
                String getFirstEmployee = "SELECT id FROM employees LIMIT 1";
                rs = stmt.executeQuery(getFirstEmployee);

                if (rs.next()) {
                    int employeeId = rs.getInt("id");

                    // Insert sample notifications
                    String insertNotification1 = "INSERT INTO notifications (employee_id, title, message, type, is_read, created_at) " +
                                               "VALUES (?, 'Leave Approved', 'Your leave request for May 25-26 has been approved', 'SUCCESS', false, NOW() - INTERVAL '1 day')";

                    String insertNotification2 = "INSERT INTO notifications (employee_id, title, message, type, is_read, created_at) " +
                                               "VALUES (?, 'Payslip Generated', 'Your April 2023 payslip is now available', 'INFO', false, NOW() - INTERVAL '3 days')";

                    String insertNotification3 = "INSERT INTO notifications (employee_id, title, message, type, is_read, created_at) " +
                                               "VALUES (?, 'Attendance Marked', 'You checked in at 9:02 AM today', 'INFO', false, NOW())";

                    PreparedStatement pstmt1 = conn.prepareStatement(insertNotification1);
                    pstmt1.setInt(1, employeeId);
                    pstmt1.executeUpdate();

                    PreparedStatement pstmt2 = conn.prepareStatement(insertNotification2);
                    pstmt2.setInt(1, employeeId);
                    pstmt2.executeUpdate();

                    PreparedStatement pstmt3 = conn.prepareStatement(insertNotification3);
                    pstmt3.setInt(1, employeeId);
                    pstmt3.executeUpdate();

                    System.out.println("Sample notifications created");
                }
            }

            // Add some sample user activities if none exist
            String checkUserActivities = "SELECT COUNT(*) FROM user_activities";
            rs = stmt.executeQuery(checkUserActivities);
            rs.next();
            int userActivityCount = rs.getInt(1);

            if (userActivityCount == 0) {
                // Get admin user ID
                String getAdminUser = "SELECT id FROM users WHERE role = 'ADMIN' LIMIT 1";
                rs = stmt.executeQuery(getAdminUser);

                if (rs.next()) {
                    int adminId = rs.getInt("id");

                    // Insert sample admin activities
                    String insertAdminActivity1 = "INSERT INTO user_activities (user_id, username, user_role, activity_type, description, entity_type, entity_id, timestamp, ip_address) " +
                                                "VALUES (?, 'admin', 'ADMIN', 'LOGIN', 'admin logged in', 'USER', ?, NOW() - INTERVAL '1 hour', '127.0.0.1')";

                    String insertAdminActivity2 = "INSERT INTO user_activities (user_id, username, user_role, activity_type, description, entity_type, entity_id, timestamp, ip_address) " +
                                                "VALUES (?, 'admin', 'ADMIN', 'CREATE', 'Created a new department: IT', 'DEPARTMENT', 1, NOW() - INTERVAL '55 minutes', '127.0.0.1')";

                    String insertAdminActivity3 = "INSERT INTO user_activities (user_id, username, user_role, activity_type, description, entity_type, entity_id, timestamp, ip_address) " +
                                                "VALUES (?, 'admin', 'ADMIN', 'CREATE', 'Added a new employee: John Doe', 'EMPLOYEE', 1, NOW() - INTERVAL '45 minutes', '127.0.0.1')";

                    PreparedStatement pstmtAdmin1 = conn.prepareStatement(insertAdminActivity1);
                    pstmtAdmin1.setInt(1, adminId);
                    pstmtAdmin1.setInt(2, adminId);
                    pstmtAdmin1.executeUpdate();

                    PreparedStatement pstmtAdmin2 = conn.prepareStatement(insertAdminActivity2);
                    pstmtAdmin2.setInt(1, adminId);
                    pstmtAdmin2.executeUpdate();

                    PreparedStatement pstmtAdmin3 = conn.prepareStatement(insertAdminActivity3);
                    pstmtAdmin3.setInt(1, adminId);
                    pstmtAdmin3.executeUpdate();
                }

                // Get HR user ID
                String getHrUser = "SELECT id FROM users WHERE role = 'HR' LIMIT 1";
                rs = stmt.executeQuery(getHrUser);

                if (rs.next()) {
                    int hrId = rs.getInt("id");

                    // Insert sample HR activities
                    String insertHrActivity1 = "INSERT INTO user_activities (user_id, username, user_role, activity_type, description, entity_type, entity_id, timestamp, ip_address) " +
                                             "VALUES (?, 'hr', 'HR', 'LOGIN', 'hr logged in', 'USER', ?, NOW() - INTERVAL '2 hours', '127.0.0.1')";

                    String insertHrActivity2 = "INSERT INTO user_activities (user_id, username, user_role, activity_type, description, entity_type, entity_id, timestamp, ip_address) " +
                                             "VALUES (?, 'hr', 'HR', 'VIEW', 'Viewed employee list', 'EMPLOYEE', NULL, NOW() - INTERVAL '1 hour 55 minutes', '127.0.0.1')";

                    String insertHrActivity3 = "INSERT INTO user_activities (user_id, username, user_role, activity_type, description, entity_type, entity_id, timestamp, ip_address) " +
                                             "VALUES (?, 'hr', 'HR', 'APPROVE', 'Approved leave request for: John Doe', 'LEAVE', 1, NOW() - INTERVAL '1 hour 35 minutes', '127.0.0.1')";

                    PreparedStatement pstmtHr1 = conn.prepareStatement(insertHrActivity1);
                    pstmtHr1.setInt(1, hrId);
                    pstmtHr1.setInt(2, hrId);
                    pstmtHr1.executeUpdate();

                    PreparedStatement pstmtHr2 = conn.prepareStatement(insertHrActivity2);
                    pstmtHr2.setInt(1, hrId);
                    pstmtHr2.executeUpdate();

                    PreparedStatement pstmtHr3 = conn.prepareStatement(insertHrActivity3);
                    pstmtHr3.setInt(1, hrId);
                    pstmtHr3.executeUpdate();
                }

                // Get employee user ID
                String getEmployeeUser = "SELECT id FROM users WHERE role = 'EMPLOYEE' LIMIT 1";
                rs = stmt.executeQuery(getEmployeeUser);

                if (rs.next()) {
                    int employeeId = rs.getInt("id");

                    // Insert sample employee activities
                    String insertEmployeeActivity1 = "INSERT INTO user_activities (user_id, username, user_role, activity_type, description, entity_type, entity_id, timestamp, ip_address) " +
                                                   "VALUES (?, 'employee', 'EMPLOYEE', 'LOGIN', 'employee logged in', 'USER', ?, NOW() - INTERVAL '3 hours', '127.0.0.1')";

                    String insertEmployeeActivity2 = "INSERT INTO user_activities (user_id, username, user_role, activity_type, description, entity_type, entity_id, timestamp, ip_address) " +
                                                   "VALUES (?, 'employee', 'EMPLOYEE', 'MARK_ATTENDANCE', 'Marked attendance for today', 'ATTENDANCE', 1, NOW() - INTERVAL '2 hours 55 minutes', '127.0.0.1')";

                    String insertEmployeeActivity3 = "INSERT INTO user_activities (user_id, username, user_role, activity_type, description, entity_type, entity_id, timestamp, ip_address) " +
                                                   "VALUES (?, 'employee', 'EMPLOYEE', 'APPLY_LEAVE', 'Applied for leave from 2023-05-01 to 2023-05-03', 'LEAVE', 1, NOW() - INTERVAL '2 hours 45 minutes', '127.0.0.1')";

                    PreparedStatement pstmtEmployee1 = conn.prepareStatement(insertEmployeeActivity1);
                    pstmtEmployee1.setInt(1, employeeId);
                    pstmtEmployee1.setInt(2, employeeId);
                    pstmtEmployee1.executeUpdate();

                    PreparedStatement pstmtEmployee2 = conn.prepareStatement(insertEmployeeActivity2);
                    pstmtEmployee2.setInt(1, employeeId);
                    pstmtEmployee2.executeUpdate();

                    PreparedStatement pstmtEmployee3 = conn.prepareStatement(insertEmployeeActivity3);
                    pstmtEmployee3.setInt(1, employeeId);
                    pstmtEmployee3.executeUpdate();
                }

                System.out.println("Sample user activities created");
            }
        }
    }

    private static void executeUpdateScripts() throws SQLException {
        try (Connection conn = getConnection()) {
            Statement stmt = conn.createStatement();

            // Execute the password change required update script
            String addPasswordChangeRequiredColumn = "ALTER TABLE users ADD COLUMN IF NOT EXISTS password_change_required BOOLEAN DEFAULT FALSE";
            stmt.executeUpdate(addPasswordChangeRequiredColumn);

            // Update existing users to not require password change
            String updateExistingUsers = "UPDATE users SET password_change_required = FALSE WHERE password_change_required IS NULL";
            stmt.executeUpdate(updateExistingUsers);

            // Execute the cascade delete update script

            // Drop existing foreign key constraints
            stmt.executeUpdate("ALTER TABLE IF EXISTS leaves DROP CONSTRAINT IF EXISTS leaves_employee_id_fkey");
            stmt.executeUpdate("ALTER TABLE IF EXISTS leaves DROP CONSTRAINT IF EXISTS leaves_reviewed_by_fkey");
            stmt.executeUpdate("ALTER TABLE IF EXISTS attendance DROP CONSTRAINT IF EXISTS attendance_employee_id_fkey");
            stmt.executeUpdate("ALTER TABLE IF EXISTS payroll DROP CONSTRAINT IF EXISTS payroll_employee_id_fkey");
            stmt.executeUpdate("ALTER TABLE IF EXISTS notifications DROP CONSTRAINT IF EXISTS notifications_employee_id_fkey");
            stmt.executeUpdate("ALTER TABLE IF EXISTS user_activities DROP CONSTRAINT IF EXISTS user_activities_user_id_fkey");
            stmt.executeUpdate("ALTER TABLE IF EXISTS employees DROP CONSTRAINT IF EXISTS employees_department_id_fkey");
            stmt.executeUpdate("ALTER TABLE IF EXISTS employees DROP CONSTRAINT IF EXISTS employees_designation_id_fkey");

            // Re-add constraints with ON DELETE CASCADE or ON DELETE SET NULL as appropriate
            stmt.executeUpdate("ALTER TABLE leaves ADD CONSTRAINT leaves_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE");
            stmt.executeUpdate("ALTER TABLE leaves ADD CONSTRAINT leaves_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL");
            stmt.executeUpdate("ALTER TABLE attendance ADD CONSTRAINT attendance_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE");
            stmt.executeUpdate("ALTER TABLE payroll ADD CONSTRAINT payroll_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE");
            stmt.executeUpdate("ALTER TABLE notifications ADD CONSTRAINT notifications_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE");
            stmt.executeUpdate("ALTER TABLE user_activities ADD CONSTRAINT user_activities_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE");
            stmt.executeUpdate("ALTER TABLE employees ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL");
            stmt.executeUpdate("ALTER TABLE employees ADD CONSTRAINT employees_designation_id_fkey FOREIGN KEY (designation_id) REFERENCES designations(id) ON DELETE SET NULL");

            // Remove geolocation fields
            try {
                // Remove geolocation fields from attendance table
                stmt.executeUpdate("ALTER TABLE attendance DROP COLUMN IF EXISTS latitude");
                stmt.executeUpdate("ALTER TABLE attendance DROP COLUMN IF EXISTS longitude");
                stmt.executeUpdate("ALTER TABLE attendance DROP COLUMN IF EXISTS location_verified");
                stmt.executeUpdate("ALTER TABLE attendance DROP COLUMN IF EXISTS location_address");

                // Drop allowed_locations table
                stmt.executeUpdate("DROP TABLE IF EXISTS allowed_locations");

                System.out.println("Geolocation fields and tables removed successfully");
            } catch (SQLException e) {
                System.out.println("Error removing geolocation fields: " + e.getMessage());
                // Continue execution even if there's an error
            }

            System.out.println("Database update scripts executed successfully");
        }
    }
}
