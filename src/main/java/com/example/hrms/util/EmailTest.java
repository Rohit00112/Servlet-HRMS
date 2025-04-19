package com.example.hrms.util;

/**
 * Test class for email notifications
 * This class is for testing purposes only and should be removed in production
 */
public class EmailTest {
    
    public static void main(String[] args) {
        // Test leave status notification
        boolean leaveResult = EmailService.sendLeaveStatusNotification(
            "test@example.com",
            "John Doe",
            123,
            "2023-05-01",
            "2023-05-05",
            "APPROVED",
            "Your leave request has been approved. Enjoy your time off!"
        );
        
        System.out.println("Leave notification email sent: " + leaveResult);
        
        // Test payslip notification
        boolean payslipResult = EmailService.sendPayslipNotification(
            "test@example.com",
            "John Doe",
            "May 2023",
            "5000.00",
            456
        );
        
        System.out.println("Payslip notification email sent: " + payslipResult);
    }
}
