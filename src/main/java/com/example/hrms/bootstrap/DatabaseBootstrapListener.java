package com.example.hrms.bootstrap;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class DatabaseBootstrapListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            new DatabaseMigrationRunner().migrate();
            sce.getServletContext().log("Database bootstrap completed successfully");
        } catch (Exception e) {
            sce.getServletContext().log("Database bootstrap failed", e);
            throw new IllegalStateException("Database bootstrap failed", e);
        }
    }
}
