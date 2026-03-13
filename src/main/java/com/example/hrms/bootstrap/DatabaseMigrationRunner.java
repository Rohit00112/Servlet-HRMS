package com.example.hrms.bootstrap;

import com.example.hrms.shared.util.DatabaseConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

public final class DatabaseMigrationRunner {
    private static final String MIGRATIONS_TABLE = "schema_migrations";
    private static final List<String> MIGRATIONS = List.of(
            "db/migrations/V1__baseline.sql",
            "db/migrations/V2__users_password_flag.sql",
            "db/migrations/V3__employee_user_link.sql",
            "db/migrations/V4__normalize_foreign_keys.sql",
            "db/migrations/V5__remove_geolocation.sql"
    );
    private static final String DEV_SEED = "db/seed/dev_seed.sql";

    private final SqlScriptExecutor sqlScriptExecutor;

    public DatabaseMigrationRunner() {
        this(new SqlScriptExecutor());
    }

    DatabaseMigrationRunner(SqlScriptExecutor sqlScriptExecutor) {
        this.sqlScriptExecutor = sqlScriptExecutor;
    }

    public void migrate() throws SQLException, IOException {
        ensureDatabaseExists();
        try (Connection connection = DatabaseConnection.getConnection()) {
            ensureMigrationsTable(connection);

            for (String migration : MIGRATIONS) {
                if (isApplied(connection, migration)) {
                    continue;
                }
                sqlScriptExecutor.execute(connection, migration);
                recordAppliedMigration(connection, migration);
            }

            if (DatabaseConnection.isSeedEnabled() && !isApplied(connection, "seed:" + DEV_SEED)) {
                sqlScriptExecutor.execute(connection, DEV_SEED);
                recordAppliedMigration(connection, "seed:" + DEV_SEED);
            }
        }
    }

    private void ensureDatabaseExists() throws SQLException {
        try (Connection connection = DatabaseConnection.getServerConnection();
             PreparedStatement checkStatement = connection.prepareStatement(
                     "SELECT 1 FROM pg_database WHERE datname = ?")) {
            checkStatement.setString(1, DatabaseConnection.getDatabaseName());
            try (ResultSet resultSet = checkStatement.executeQuery()) {
                if (resultSet.next()) {
                    return;
                }
            }

            try (Statement statement = connection.createStatement()) {
                statement.execute("CREATE DATABASE " + DatabaseConnection.getDatabaseName());
            }
        }
    }

    private void ensureMigrationsTable(Connection connection) throws SQLException {
        try (Statement statement = connection.createStatement()) {
            statement.execute("""
                    CREATE TABLE IF NOT EXISTS schema_migrations (
                        script_name VARCHAR(255) PRIMARY KEY,
                        applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
                    )
                    """);
        }
    }

    private boolean isApplied(Connection connection, String scriptName) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(
                "SELECT 1 FROM " + MIGRATIONS_TABLE + " WHERE script_name = ?")) {
            statement.setString(1, scriptName);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        }
    }

    private void recordAppliedMigration(Connection connection, String scriptName) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(
                "INSERT INTO " + MIGRATIONS_TABLE + " (script_name) VALUES (?)")) {
            statement.setString(1, scriptName);
            statement.executeUpdate();
        }
    }
}
