package com.example.hrms.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.IOException;
import java.util.Date;
import java.util.Properties;

/**
 * Utility class for sending email notifications
 */
public class EmailService {
    private static final String PROPERTIES_FILE = "db.properties";
    private static String SMTP_HOST;
    private static String SMTP_PORT;
    private static String SMTP_AUTH;
    private static String SMTP_STARTTLS;
    private static String EMAIL_USERNAME;
    private static String EMAIL_PASSWORD;
    private static String EMAIL_FROM;
    private static String EMAIL_REPLY_TO;
    private static boolean EMAIL_ENABLED;

    static {
        try {
            // Load email properties
            Properties properties = PropertyLoader.loadProperties(PROPERTIES_FILE);

            // Get email properties
            SMTP_HOST = properties.getProperty("mail.smtp.host");
            SMTP_PORT = properties.getProperty("mail.smtp.port");
            SMTP_AUTH = properties.getProperty("mail.smtp.auth");
            SMTP_STARTTLS = properties.getProperty("mail.smtp.starttls.enable");
            EMAIL_USERNAME = properties.getProperty("mail.username");
            EMAIL_PASSWORD = properties.getProperty("mail.password");
            EMAIL_FROM = properties.getProperty("mail.from");
            EMAIL_REPLY_TO = properties.getProperty("mail.reply-to");
            EMAIL_ENABLED = Boolean.parseBoolean(properties.getProperty("mail.enabled", "false"));

        } catch (IOException e) {
            System.err.println("Error loading email properties: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Send an email notification
     *
     * @param to      Recipient email address
     * @param subject Email subject
     * @param content Email content (HTML or plain text)
     * @param isHtml  Whether the content is HTML
     * @return true if email was sent successfully, false otherwise
     */
    public static boolean sendEmail(String to, String subject, String content, boolean isHtml) {
        // If email is disabled, log the email and return success
        if (!EMAIL_ENABLED) {
            System.out.println("Email sending is disabled. Would have sent:");
            System.out.println("To: " + to);
            System.out.println("Subject: " + subject);
            System.out.println("Content: " + content);
            return true;
        }

        try {
            // Set up mail server properties
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", SMTP_AUTH);
            props.put("mail.smtp.starttls.enable", SMTP_STARTTLS);

            // Create a mail session with authentication
            Authenticator auth = new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                }
            };

            Session session = Session.getInstance(props, auth);

            // Create a message
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(EMAIL_FROM));
            InternetAddress[] toAddresses = {new InternetAddress(to)};
            msg.setRecipients(Message.RecipientType.TO, toAddresses);
            msg.setSubject(subject);
            msg.setSentDate(new Date());

            // Set content type based on isHtml flag
            if (isHtml) {
                msg.setContent(content, "text/html; charset=utf-8");
            } else {
                msg.setText(content);
            }

            // Send the message
            Transport.send(msg);
            System.out.println("Email sent successfully to " + to);
            return true;

        } catch (MessagingException e) {
            System.err.println("Error sending email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Send a leave status notification email
     *
     * @param to           Recipient email address
     * @param employeeName Employee name
     * @param leaveId      Leave ID
     * @param startDate    Leave start date
     * @param endDate      Leave end date
     * @param status       Leave status (APPROVED/REJECTED)
     * @param comments     Comments from reviewer
     * @return true if email was sent successfully, false otherwise
     */
    public static boolean sendLeaveStatusNotification(String to, String employeeName, int leaveId, 
                                                     String startDate, String endDate, 
                                                     String status, String comments) {
        String subject = "Leave Request " + status + " - HRMS";
        
        // Create HTML content
        StringBuilder content = new StringBuilder();
        content.append("<html><body style='font-family: Arial, sans-serif;'>");
        content.append("<div style='max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px;'>");
        content.append("<h2 style='color: #333;'>Leave Request ").append(status).append("</h2>");
        content.append("<p>Dear ").append(employeeName).append(",</p>");
        
        if (status.equals("APPROVED")) {
            content.append("<p>We're pleased to inform you that your leave request has been <strong style='color: green;'>approved</strong>.</p>");
        } else {
            content.append("<p>We regret to inform you that your leave request has been <strong style='color: red;'>rejected</strong>.</p>");
        }
        
        content.append("<div style='background-color: #f9f9f9; padding: 15px; margin: 15px 0; border-left: 4px solid #0ea5e9;'>");
        content.append("<h3 style='margin-top: 0;'>Leave Details</h3>");
        content.append("<p><strong>Leave ID:</strong> ").append(leaveId).append("</p>");
        content.append("<p><strong>Period:</strong> ").append(startDate).append(" to ").append(endDate).append("</p>");
        content.append("<p><strong>Status:</strong> ").append(status).append("</p>");
        
        if (comments != null && !comments.isEmpty()) {
            content.append("<p><strong>Comments:</strong> ").append(comments).append("</p>");
        }
        
        content.append("</div>");
        content.append("<p>You can view the details of your leave request by logging into the HRMS portal.</p>");
        content.append("<p>Thank you,<br>HR Department</p>");
        content.append("</div></body></html>");
        
        return sendEmail(to, subject, content.toString(), true);
    }

    /**
     * Send a payslip generation notification email
     *
     * @param to           Recipient email address
     * @param employeeName Employee name
     * @param month        Payroll month
     * @param netSalary    Net salary amount
     * @param payrollId    Payroll ID
     * @return true if email was sent successfully, false otherwise
     */
    public static boolean sendPayslipNotification(String to, String employeeName, String month, 
                                                 String netSalary, int payrollId) {
        String subject = "Your Payslip for " + month + " is Ready - HRMS";
        
        // Create HTML content
        StringBuilder content = new StringBuilder();
        content.append("<html><body style='font-family: Arial, sans-serif;'>");
        content.append("<div style='max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px;'>");
        content.append("<h2 style='color: #333;'>Your Payslip is Ready</h2>");
        content.append("<p>Dear ").append(employeeName).append(",</p>");
        content.append("<p>Your payslip for <strong>").append(month).append("</strong> has been generated and is now available for viewing.</p>");
        
        content.append("<div style='background-color: #f9f9f9; padding: 15px; margin: 15px 0; border-left: 4px solid #0ea5e9;'>");
        content.append("<h3 style='margin-top: 0;'>Payslip Summary</h3>");
        content.append("<p><strong>Month:</strong> ").append(month).append("</p>");
        content.append("<p><strong>Net Salary:</strong> $").append(netSalary).append("</p>");
        content.append("</div>");
        
        content.append("<p>Please log in to the HRMS portal to view your complete payslip details and download a copy for your records.</p>");
        content.append("<p>If you have any questions regarding your payslip, please contact the HR department.</p>");
        content.append("<p>Thank you,<br>HR Department</p>");
        content.append("</div></body></html>");
        
        return sendEmail(to, subject, content.toString(), true);
    }
}
