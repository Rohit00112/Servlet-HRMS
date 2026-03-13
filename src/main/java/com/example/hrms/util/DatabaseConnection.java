package com.example.hrms.util;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * Backward-compatible facade. New code should use com.example.hrms.shared.util.DatabaseConnection.
 */
public final class DatabaseConnection {

    private DatabaseConnection() {
    }

    public static Connection getConnection() throws SQLException {
        return com.example.hrms.shared.util.DatabaseConnection.getConnection();
    }
}
