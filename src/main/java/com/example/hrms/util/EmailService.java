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

        // Get the HTML template
        String content = EmailTemplates.getLeaveStatusTemplate(employeeName, leaveId, startDate, endDate, status, comments);

        return sendEmail(to, subject, content, true);
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

        // Get the HTML template
        String content = EmailTemplates.getPayslipTemplate(employeeName, month, netSalary, payrollId);

        return sendEmail(to, subject, content, true);
    }

    /**
     * Send an account creation notification email
     *
     * @param to           Recipient email address
     * @param employeeName Employee name
     * @param username     Username
     * @param password     Password
     * @param role         User role
     * @return true if email was sent successfully, false otherwise
     */
    public static boolean sendAccountCreationNotification(String to, String employeeName, String username,
                                                        String password, String role) {
        String subject = "Welcome to HRMS - Your Account Details";

        // Get the HTML template
        String content = EmailTemplates.getAccountCreationTemplate(employeeName, username, password, role);

        return sendEmail(to, subject, content, true);
    }

    /**
     * Send a password reset notification email
     *
     * @param to           Recipient email address
     * @param employeeName Employee name
     * @param username     Username
     * @param password     New password
     * @return true if email was sent successfully, false otherwise
     */
    public static boolean sendPasswordResetNotification(String to, String employeeName, String username,
                                                      String password) {
        String subject = "Password Reset - HRMS";

        // Get the HTML template
        String content = EmailTemplates.getPasswordResetTemplate(employeeName, username, password);

        return sendEmail(to, subject, content, true);
    }
}
