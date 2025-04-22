package com.example.hrms.util;

import java.io.FileWriter;
import java.io.IOException;

/**
 * Test class for email templates
 * This class is for testing purposes only and should be removed in production
 */
public class EmailTemplateTest {
    
    public static void main(String[] args) {
        try {
            // Generate leave approval template
            String leaveApprovalTemplate = EmailTemplates.getLeaveStatusTemplate(
                "John Doe",
                123,
                "2023-05-01",
                "2023-05-05",
                "APPROVED",
                "Your leave request has been approved. Enjoy your time off!"
            );
            
            // Generate leave rejection template
            String leaveRejectionTemplate = EmailTemplates.getLeaveStatusTemplate(
                "Jane Smith",
                124,
                "2023-06-10",
                "2023-06-15",
                "REJECTED",
                "We cannot approve your leave request due to upcoming project deadlines."
            );
            
            // Generate payslip template
            String payslipTemplate = EmailTemplates.getPayslipTemplate(
                "John Doe",
                "May 2023",
                "5,000.00",
                456
            );
            
            // Generate account creation template
            String accountCreationTemplate = EmailTemplates.getAccountCreationTemplate(
                "Sarah Johnson",
                "sarah.johnson",
                "P@ssw0rd123",
                "EMPLOYEE"
            );
            
            // Save templates to files for preview
            saveToFile("leave_approval_template.html", leaveApprovalTemplate);
            saveToFile("leave_rejection_template.html", leaveRejectionTemplate);
            saveToFile("payslip_template.html", payslipTemplate);
            saveToFile("account_creation_template.html", accountCreationTemplate);
            
            System.out.println("Email templates generated successfully!");
            System.out.println("Files saved in the project root directory.");
            
        } catch (Exception e) {
            System.err.println("Error generating email templates: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void saveToFile(String fileName, String content) throws IOException {
        try (FileWriter writer = new FileWriter(fileName)) {
            writer.write(content);
        }
    }
}
