package com.example.hrms.servlet.payroll;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.Payroll;
import com.example.hrms.service.PayrollService;
import com.example.hrms.util.PDFService;
import com.itextpdf.text.DocumentException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.SQLException;

@WebServlet(name = "DownloadPayslipServlet", urlPatterns = {
    "/admin/payroll/download",
    "/hr/payroll/download",
    "/employee/payroll/download"
})
public class DownloadPayslipServlet extends HttpServlet {
    private PayrollService payrollService;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        payrollService = new PayrollService();
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        com.example.hrms.model.User user = (com.example.hrms.model.User) session.getAttribute("user");
        String role = user.getRole();

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Payroll ID is required");
                request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
                return;
            }

            int payrollId = Integer.parseInt(idParam);
            Payroll payroll = payrollService.getPayrollById(payrollId);

            if (payroll == null) {
                request.setAttribute("errorMessage", "Payroll not found");
                request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
                return;
            }

            // Check access permissions
            if (role.equals("EMPLOYEE")) {
                // Employees can only view their own payslips
                // Get the employee for the current user
                Employee employee = employeeDAO.getEmployeeByUserId(user.getId());

                // If not found by user ID, try by email
                if (employee == null) {
                    employee = employeeDAO.getEmployeeByEmail(user.getUsername() + "@company.com");
                }

                if (employee == null || employee.getId() != payroll.getEmployeeId()) {
                    request.setAttribute("errorMessage", "Access denied");
                    request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
                    return;
                }
            }

            // Get employee details
            Employee employee = employeeDAO.getEmployeeById(payroll.getEmployeeId());

            if (employee == null) {
                request.setAttribute("errorMessage", "Employee not found");
                request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
                return;
            }

            // Generate PDF
            byte[] pdfBytes = PDFService.generatePayslipPDF(payroll, employee);

            // Set response headers
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"Payslip_" + employee.getName().replaceAll("\\s+", "_") + "_" + payroll.getMonth() + ".pdf\"");
            response.setContentLength(pdfBytes.length);

            // Write PDF to response
            try (OutputStream out = response.getOutputStream()) {
                out.write(pdfBytes);
                out.flush();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid payroll ID");
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        } catch (DocumentException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating PDF: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        }
    }
}
