package com.example.hrms.listener;

import com.example.hrms.util.PropertyLoader;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.io.IOException;
import java.util.Properties;

/**
 * Application Lifecycle Listener for email configuration
 */
@WebListener
public class EmailConfigListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Initializing email configuration...");
        try {
            Properties properties = PropertyLoader.loadProperties("db.properties");
            boolean emailEnabled = Boolean.parseBoolean(properties.getProperty("mail.enabled", "false"));
            
            if (emailEnabled) {
                System.out.println("Email notifications are enabled");
                
                // Log email configuration (without password)
                System.out.println("SMTP Host: " + properties.getProperty("mail.smtp.host"));
                System.out.println("SMTP Port: " + properties.getProperty("mail.smtp.port"));
                System.out.println("From: " + properties.getProperty("mail.from"));
                System.out.println("Reply-To: " + properties.getProperty("mail.reply-to"));
            } else {
                System.out.println("Email notifications are disabled");
            }
        } catch (IOException e) {
            System.err.println("Error loading email configuration: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nothing to clean up
    }
}
