package com.example.hrms.shared.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Pure connection factory. Database creation and migrations run elsewhere.
 */
public final class DatabaseConnection {
    private static final String PROPERTIES_FILE = "db.properties";
    private static final DatabaseConfig CONFIG = loadConfig();

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private DatabaseConnection() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(CONFIG.fullUrl(), CONFIG.username(), CONFIG.password());
    }

    public static Connection getServerConnection() throws SQLException {
        return DriverManager.getConnection(CONFIG.serverUrl(), CONFIG.username(), CONFIG.password());
    }

    public static String getDatabaseName() {
        return CONFIG.databaseName();
    }

    public static boolean isSeedEnabled() {
        return CONFIG.seedEnabled();
    }

    private static DatabaseConfig loadConfig() {
        try {
            Properties properties = PropertyLoader.loadProperties(PROPERTIES_FILE);
            String serverUrl = properties.getProperty("db.url");
            String databaseName = properties.getProperty("db.name");
            String username = properties.getProperty("db.user");
            String password = properties.getProperty("db.password");
            boolean seedEnabled = Boolean.parseBoolean(properties.getProperty("db.seed", "false"));

            return new DatabaseConfig(serverUrl, databaseName, serverUrl + databaseName, username, password, seedEnabled);
        } catch (IOException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private record DatabaseConfig(
            String serverUrl,
            String databaseName,
            String fullUrl,
            String username,
            String password,
            boolean seedEnabled
    ) {
    }
}
