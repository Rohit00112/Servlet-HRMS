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
        }
    }
}
