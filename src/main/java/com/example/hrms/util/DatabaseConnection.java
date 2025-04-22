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
                    "department_id INTEGER REFERENCES departments(id), " +
                    "designation_id INTEGER REFERENCES designations(id), " +
                    "join_date DATE NOT NULL" +
                    ")";
            stmt.executeUpdate(createEmployeesTable);

            // Create leaves table if it doesn't exist
            String createLeavesTable = "CREATE TABLE IF NOT EXISTS leaves (" +
                    "id SERIAL PRIMARY KEY, " +
                    "employee_id INTEGER REFERENCES employees(id), " +
                    "start_date DATE NOT NULL, " +
                    "end_date DATE NOT NULL, " +
                    "reason TEXT NOT NULL, " +
                    "status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED')), " +
                    "applied_date DATE NOT NULL, " +
                    "reviewed_by INTEGER REFERENCES users(id), " +
                    "reviewed_date DATE, " +
                    "comments TEXT" +
                    ")";
            stmt.executeUpdate(createLeavesTable);

            // Create attendance table if it doesn't exist
            String createAttendanceTable = "CREATE TABLE IF NOT EXISTS attendance (" +
                    "id SERIAL PRIMARY KEY, " +
                    "employee_id INTEGER REFERENCES employees(id), " +
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
                    "employee_id INTEGER REFERENCES employees(id), " +
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

            System.out.println("Database update scripts executed successfully");
        }
    }
}
