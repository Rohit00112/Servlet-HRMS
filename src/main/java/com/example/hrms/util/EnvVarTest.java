package com.example.hrms.util;

import java.io.IOException;
import java.util.Properties;

/**
 * Test class for environment variable override functionality
 * This class is for testing purposes only and should be removed in production
 */
public class EnvVarTest {
    
    public static void main(String[] args) {
        try {
            System.out.println("Testing environment variable override functionality...");
            System.out.println("Note: This test will only show the override if you have set the environment variables.");
            System.out.println("Required environment variables for testing:");
            System.out.println("  HRMS_MAIL_USERNAME");
            System.out.println("  HRMS_MAIL_PASSWORD");
            System.out.println();
            
            // Load properties from file
            Properties properties = PropertyLoader.loadProperties("db.properties");
            
            // Print email properties
            System.out.println("Email Properties (sensitive values masked):");
            System.out.println("  mail.smtp.host: " + properties.getProperty("mail.smtp.host"));
            System.out.println("  mail.smtp.port: " + properties.getProperty("mail.smtp.port"));
            System.out.println("  mail.username: " + maskString(properties.getProperty("mail.username")));
            System.out.println("  mail.password: " + maskString(properties.getProperty("mail.password")));
            System.out.println("  mail.from: " + properties.getProperty("mail.from"));
            System.out.println("  mail.enabled: " + properties.getProperty("mail.enabled"));
            
        } catch (IOException e) {
            System.err.println("Error loading properties: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Mask a string for display (show only first and last character)
     * 
     * @param input The string to mask
     * @return The masked string
     */
    private static String maskString(String input) {
        if (input == null || input.isEmpty()) {
            return "[empty]";
        }
        
        if (input.length() <= 2) {
            return "*".repeat(input.length());
        }
        
        return input.charAt(0) + "*".repeat(input.length() - 2) + input.charAt(input.length() - 1);
    }
}
