package com.example.hrms.util;

/**
 * Class containing HTML email templates for the HRMS system
 */
public class EmailTemplates {

    /**
     * Get the base HTML template with header and footer
     * 
     * @param title The email title
     * @param content The email content
     * @return The complete HTML email template
     */
    public static String getBaseTemplate(String title, String content) {
        return "<!DOCTYPE html>\n" +
               "<html lang=\"en\">\n" +
               "<head>\n" +
               "    <meta charset=\"UTF-8\">\n" +
               "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
               "    <title>" + title + "</title>\n" +
               "</head>\n" +
               "<body style=\"margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f9fafb; color: #1f2937;\">\n" +
               "    <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); margin-top: 20px; margin-bottom: 20px;\">\n" +
               "        <!-- Header -->\n" +
               "        <tr>\n" +
               "            <td style=\"background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); padding: 30px 20px; text-align: center;\">\n" +
               "                <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n" +
               "                    <tr>\n" +
               "                        <td>\n" +
               "                            <h1 style=\"color: #ffffff; margin: 0; font-weight: 600; font-size: 24px; text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);\">HRMS</h1>\n" +
               "                        </td>\n" +
               "                    </tr>\n" +
               "                    <tr>\n" +
               "                        <td>\n" +
               "                            <p style=\"color: #e0e7ff; margin: 5px 0 0 0; font-size: 14px;\">Human Resource Management System</p>\n" +
               "                        </td>\n" +
               "                    </tr>\n" +
               "                </table>\n" +
               "            </td>\n" +
               "        </tr>\n" +
               "        <!-- Content -->\n" +
               "        <tr>\n" +
               "            <td style=\"padding: 30px 20px;\">\n" +
               "                " + content + "\n" +
               "            </td>\n" +
               "        </tr>\n" +
               "        <!-- Footer -->\n" +
               "        <tr>\n" +
               "            <td style=\"background-color: #f3f4f6; padding: 20px; text-align: center; border-top: 1px solid #e5e7eb;\">\n" +
               "                <p style=\"margin: 0; color: #6b7280; font-size: 12px;\">© " + java.time.Year.now().getValue() + " HRMS. All rights reserved.</p>\n" +
               "                <p style=\"margin: 8px 0 0 0; color: #6b7280; font-size: 12px;\">This is an automated email. Please do not reply.</p>\n" +
               "                <div style=\"margin-top: 15px;\">\n" +
               "                    <a href=\"#\" style=\"display: inline-block; margin: 0 5px; color: #4b5563; text-decoration: none; font-size: 12px;\">Privacy Policy</a>\n" +
               "                    <span style=\"color: #9ca3af;\">|</span>\n" +
               "                    <a href=\"#\" style=\"display: inline-block; margin: 0 5px; color: #4b5563; text-decoration: none; font-size: 12px;\">Terms of Service</a>\n" +
               "                    <span style=\"color: #9ca3af;\">|</span>\n" +
               "                    <a href=\"#\" style=\"display: inline-block; margin: 0 5px; color: #4b5563; text-decoration: none; font-size: 12px;\">Contact Us</a>\n" +
               "                </div>\n" +
               "            </td>\n" +
               "        </tr>\n" +
               "    </table>\n" +
               "</body>\n" +
               "</html>";
    }

    /**
     * Get the leave status notification template
     * 
     * @param employeeName Employee name
     * @param leaveId Leave ID
     * @param startDate Leave start date
     * @param endDate Leave end date
     * @param status Leave status (APPROVED/REJECTED)
     * @param comments Comments from reviewer
     * @return The HTML email template for leave status notification
     */
    public static String getLeaveStatusTemplate(String employeeName, int leaveId, String startDate, String endDate, String status, String comments) {
        String statusColor = status.equals("APPROVED") ? "#10b981" : "#ef4444";
        String statusBgColor = status.equals("APPROVED") ? "#d1fae5" : "#fee2e2";
        String statusIcon = status.equals("APPROVED") 
            ? "https://img.icons8.com/ios-filled/50/10b981/checkmark--v1.png" 
            : "https://img.icons8.com/ios-filled/50/ef4444/multiply.png";
        
        String content = "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n" +
                "    <tr>\n" +
                "        <td>\n" +
                "            <h2 style=\"margin: 0 0 20px 0; color: #1f2937; font-weight: 600; font-size: 20px;\">Leave Request " + status + "</h2>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td>\n" +
                "            <p style=\"margin: 0 0 20px 0; color: #4b5563; line-height: 1.5;\">Dear <span style=\"font-weight: 600;\">" + employeeName + "</span>,</p>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding: 20px; background-color: " + statusBgColor + "; border-radius: 8px; margin-bottom: 20px;\">\n" +
                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n" +
                "                <tr>\n" +
                "                    <td width=\"60\" valign=\"top\">\n" +
                "                        <img src=\"" + statusIcon + "\" alt=\"" + status + "\" width=\"40\" height=\"40\" style=\"display: block;\">\n" +
                "                    </td>\n" +
                "                    <td valign=\"middle\">\n" +
                "                        <p style=\"margin: 0; color: " + statusColor + "; font-weight: 600; font-size: 16px;\">\n" +
                "                            Your leave request has been <span style=\"text-transform: lowercase;\">" + status + "</span>\n" +
                "                        </p>\n" +
                "                    </td>\n" +
                "                </tr>\n" +
                "            </table>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding: 20px 0;\">\n" +
                "            <h3 style=\"margin: 0 0 15px 0; color: #1f2937; font-weight: 600; font-size: 16px;\">Leave Details</h3>\n" +
                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: separate; border-spacing: 0 8px;\">\n" +
                "                <tr>\n" +
                "                    <td width=\"120\" style=\"color: #6b7280; font-size: 14px;\">Leave ID:</td>\n" +
                "                    <td style=\"color: #1f2937; font-weight: 500; font-size: 14px;\">" + leaveId + "</td>\n" +
                "                </tr>\n" +
                "                <tr>\n" +
                "                    <td width=\"120\" style=\"color: #6b7280; font-size: 14px;\">Start Date:</td>\n" +
                "                    <td style=\"color: #1f2937; font-weight: 500; font-size: 14px;\">" + startDate + "</td>\n" +
                "                </tr>\n" +
                "                <tr>\n" +
                "                    <td width=\"120\" style=\"color: #6b7280; font-size: 14px;\">End Date:</td>\n" +
                "                    <td style=\"color: #1f2937; font-weight: 500; font-size: 14px;\">" + endDate + "</td>\n" +
                "                </tr>\n" +
                "                <tr>\n" +
                "                    <td width=\"120\" style=\"color: #6b7280; font-size: 14px;\">Status:</td>\n" +
                "                    <td>\n" +
                "                        <span style=\"display: inline-block; padding: 4px 8px; background-color: " + statusBgColor + "; color: " + statusColor + "; border-radius: 4px; font-size: 12px; font-weight: 600;\">" + status + "</span>\n" +
                "                    </td>\n" +
                "                </tr>\n";
        
        if (comments != null && !comments.isEmpty()) {
            content += "                <tr>\n" +
                    "                    <td width=\"120\" style=\"color: #6b7280; font-size: 14px; vertical-align: top;\">Comments:</td>\n" +
                    "                    <td style=\"color: #1f2937; font-size: 14px;\">" + comments + "</td>\n" +
                    "                </tr>\n";
        }
        
        content += "            </table>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding: 20px; background-color: #f3f4f6; border-radius: 8px; margin-top: 20px;\">\n" +
                "            <p style=\"margin: 0; color: #4b5563; font-size: 14px;\">\n" +
                "                You can view the details of your leave request by logging into the HRMS portal.\n" +
                "            </p>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding-top: 30px;\">\n" +
                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n" +
                "                <tr>\n" +
                "                    <td>\n" +
                "                        <a href=\"#\" style=\"display: inline-block; padding: 12px 24px; background-color: #3b82f6; color: #ffffff; text-decoration: none; font-weight: 600; border-radius: 6px; font-size: 14px; text-align: center;\">View in HRMS Portal</a>\n" +
                "                    </td>\n" +
                "                </tr>\n" +
                "            </table>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding-top: 30px;\">\n" +
                "            <p style=\"margin: 0; color: #4b5563; line-height: 1.5;\">\n" +
                "                Thank you,<br>\n" +
                "                <span style=\"font-weight: 600;\">HR Department</span>\n" +
                "            </p>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "</table>";
        
        return getBaseTemplate("Leave Request " + status, content);
    }

    /**
     * Get the payslip notification template
     * 
     * @param employeeName Employee name
     * @param month Payroll month
     * @param netSalary Net salary amount
     * @param payrollId Payroll ID
     * @return The HTML email template for payslip notification
     */
    public static String getPayslipTemplate(String employeeName, String month, String netSalary, int payrollId) {
        String content = "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n" +
                "    <tr>\n" +
                "        <td>\n" +
                "            <h2 style=\"margin: 0 0 20px 0; color: #1f2937; font-weight: 600; font-size: 20px;\">Your Payslip is Ready</h2>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td>\n" +
                "            <p style=\"margin: 0 0 20px 0; color: #4b5563; line-height: 1.5;\">Dear <span style=\"font-weight: 600;\">" + employeeName + "</span>,</p>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding: 20px; background-color: #dbeafe; border-radius: 8px; margin-bottom: 20px;\">\n" +
                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n" +
                "                <tr>\n" +
                "                    <td width=\"60\" valign=\"top\">\n" +
                "                        <img src=\"https://img.icons8.com/ios-filled/50/3b82f6/document.png\" alt=\"Payslip\" width=\"40\" height=\"40\" style=\"display: block;\">\n" +
                "                    </td>\n" +
                "                    <td valign=\"middle\">\n" +
                "                        <p style=\"margin: 0; color: #1e40af; font-weight: 600; font-size: 16px;\">\n" +
                "                            Your payslip for " + month + " has been generated\n" +
                "                        </p>\n" +
                "                    </td>\n" +
                "                </tr>\n" +
                "            </table>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding: 20px 0;\">\n" +
                "            <h3 style=\"margin: 0 0 15px 0; color: #1f2937; font-weight: 600; font-size: 16px;\">Payslip Summary</h3>\n" +
                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: separate; border-spacing: 0 8px;\">\n" +
                "                <tr>\n" +
                "                    <td width=\"120\" style=\"color: #6b7280; font-size: 14px;\">Payroll ID:</td>\n" +
                "                    <td style=\"color: #1f2937; font-weight: 500; font-size: 14px;\">" + payrollId + "</td>\n" +
                "                </tr>\n" +
                "                <tr>\n" +
                "                    <td width=\"120\" style=\"color: #6b7280; font-size: 14px;\">Month:</td>\n" +
                "                    <td style=\"color: #1f2937; font-weight: 500; font-size: 14px;\">" + month + "</td>\n" +
                "                </tr>\n" +
                "                <tr>\n" +
                "                    <td width=\"120\" style=\"color: #6b7280; font-size: 14px;\">Net Salary:</td>\n" +
                "                    <td style=\"color: #1f2937; font-weight: 700; font-size: 16px;\">$" + netSalary + "</td>\n" +
                "                </tr>\n" +
                "            </table>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding: 20px; background-color: #f3f4f6; border-radius: 8px; margin-top: 20px;\">\n" +
                "            <p style=\"margin: 0; color: #4b5563; font-size: 14px;\">\n" +
                "                Please log in to the HRMS portal to view your complete payslip details and download a copy for your records.\n" +
                "            </p>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding-top: 30px;\">\n" +
                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n" +
                "                <tr>\n" +
                "                    <td align=\"center\">\n" +
                "                        <a href=\"#\" style=\"display: inline-block; padding: 12px 24px; background-color: #3b82f6; color: #ffffff; text-decoration: none; font-weight: 600; border-radius: 6px; font-size: 14px; text-align: center; margin-right: 10px;\">View Payslip</a>\n" +
                "                        <a href=\"#\" style=\"display: inline-block; padding: 12px 24px; background-color: #ffffff; color: #3b82f6; text-decoration: none; font-weight: 600; border-radius: 6px; font-size: 14px; text-align: center; border: 1px solid #3b82f6;\">Download PDF</a>\n" +
                "                    </td>\n" +
                "                </tr>\n" +
                "            </table>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding-top: 30px;\">\n" +
                "            <p style=\"margin: 0; color: #4b5563; line-height: 1.5;\">\n" +
                "                If you have any questions regarding your payslip, please contact the HR department.\n" +
                "            </p>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding-top: 20px;\">\n" +
                "            <p style=\"margin: 0; color: #4b5563; line-height: 1.5;\">\n" +
                "                Thank you,<br>\n" +
                "                <span style=\"font-weight: 600;\">HR Department</span>\n" +
                "            </p>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "</table>";
        
        return getBaseTemplate("Your Payslip for " + month + " is Ready", content);
    }

    /**
     * Get the account creation notification template
     * 
     * @param employeeName Employee name
     * @param username Username
     * @param password Password
     * @param role User role
     * @return The HTML email template for account creation notification
     */
    public static String getAccountCreationTemplate(String employeeName, String username, String password, String role) {
        String content = "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n" +
                "    <tr>\n" +
                "        <td>\n" +
                "            <h2 style=\"margin: 0 0 20px 0; color: #1f2937; font-weight: 600; font-size: 20px;\">Welcome to HRMS</h2>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td>\n" +
                "            <p style=\"margin: 0 0 20px 0; color: #4b5563; line-height: 1.5;\">Dear <span style=\"font-weight: 600;\">" + employeeName + "</span>,</p>\n" +
                "            <p style=\"margin: 0 0 20px 0; color: #4b5563; line-height: 1.5;\">Your account has been created in the Human Resource Management System. Below are your login credentials:</p>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding: 20px; background-color: #f3f4f6; border-radius: 8px; margin-bottom: 20px;\">\n" +
                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: separate; border-spacing: 0 8px;\">\n" +
                "                <tr>\n" +
                "                    <td width=\"120\" style=\"color: #6b7280; font-size: 14px;\">Username:</td>\n" +
                "                    <td style=\"color: #1f2937; font-weight: 600; font-size: 14px;\">" + username + "</td>\n" +
                "                </tr>\n" +
                "                <tr>\n" +
                "                    <td width=\"120\" style=\"color: #6b7280; font-size: 14px;\">Password:</td>\n" +
                "                    <td style=\"color: #1f2937; font-weight: 600; font-size: 14px;\">" + password + "</td>\n" +
                "                </tr>\n" +
                "                <tr>\n" +
                "                    <td width=\"120\" style=\"color: #6b7280; font-size: 14px;\">Role:</td>\n" +
                "                    <td>\n" +
                "                        <span style=\"display: inline-block; padding: 4px 8px; background-color: #dbeafe; color: #1e40af; border-radius: 4px; font-size: 12px; font-weight: 600;\">" + role + "</span>\n" +
                "                    </td>\n" +
                "                </tr>\n" +
                "            </table>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding: 20px 0;\">\n" +
                "            <div style=\"padding: 15px; border-left: 4px solid #fbbf24; background-color: #fffbeb;\">\n" +
                "                <p style=\"margin: 0; color: #92400e; font-size: 14px;\">\n" +
                "                    <strong>Important:</strong> For security reasons, you will be required to change your password when you first log in.\n" +
                "                </p>\n" +
                "            </div>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding-top: 10px;\">\n" +
                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n" +
                "                <tr>\n" +
                "                    <td>\n" +
                "                        <a href=\"#\" style=\"display: inline-block; padding: 12px 24px; background-color: #3b82f6; color: #ffffff; text-decoration: none; font-weight: 600; border-radius: 6px; font-size: 14px; text-align: center;\">Login to HRMS</a>\n" +
                "                    </td>\n" +
                "                </tr>\n" +
                "            </table>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding-top: 30px;\">\n" +
                "            <p style=\"margin: 0; color: #4b5563; line-height: 1.5;\">\n" +
                "                If you have any questions or need assistance, please contact the HR department.\n" +
                "            </p>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "    <tr>\n" +
                "        <td style=\"padding-top: 20px;\">\n" +
                "            <p style=\"margin: 0; color: #4b5563; line-height: 1.5;\">\n" +
                "                Thank you,<br>\n" +
                "                <span style=\"font-weight: 600;\">HR Department</span>\n" +
                "            </p>\n" +
                "        </td>\n" +
                "    </tr>\n" +
                "</table>";
        
        return getBaseTemplate("Welcome to HRMS - Your Account Details", content);
    }
}
