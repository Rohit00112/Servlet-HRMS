package com.example.hrms.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Utility class for email operations
 */
public class EmailUtil {
    
    private static Properties emailProperties;
    
    static {
        emailProperties = new Properties();
        try (InputStream input = EmailUtil.class.getClassLoader().getResourceAsStream("email.properties")) {
            if (input != null) {
                emailProperties.load(input);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Send an email
     * 
     * @param to The recipient email address
     * @param subject The email subject
     * @param body The email body (HTML)
     * @return True if the email was sent successfully
     */
    public static boolean sendEmail(String to, String subject, String body) {
        try {
            // Get email properties
            String host = emailProperties.getProperty("mail.smtp.host");
            String port = emailProperties.getProperty("mail.smtp.port");
            String username = emailProperties.getProperty("mail.smtp.username");
            String password = emailProperties.getProperty("mail.smtp.password");
            
            // Set up mail session
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
            
            // Create session
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });
            
            // Create message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(body, "text/html");
            
            // Send message
            Transport.send(message);
            
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Send account creation email with credentials
     * 
     * @param to The recipient email address
     * @param username The username
     * @param password The password
     * @param role The user role
     * @return True if the email was sent successfully
     */
    public static boolean sendAccountCreationEmail(String to, String username, String password, String role) {
        String subject = "Your HRMS Account Has Been Created";
        
        String body = "<html><body>"
                + "<h2>Welcome to HRMS System</h2>"
                + "<p>Your account has been created with the following details:</p>"
                + "<p><strong>Username:</strong> " + username + "</p>"
                + "<p><strong>Password:</strong> " + password + "</p>"
                + "<p><strong>Role:</strong> " + role + "</p>"
                + "<p>Please login at <a href=\"http://localhost:8080/hrms/login\">http://localhost:8080/hrms/login</a></p>"
                + "<p>For security reasons, please change your password after your first login.</p>"
                + "<p>Thank you,<br>HRMS Admin</p>"
                + "</body></html>";
        
        return sendEmail(to, subject, body);
    }
}
