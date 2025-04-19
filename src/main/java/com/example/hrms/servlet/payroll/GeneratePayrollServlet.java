package com.example.hrms.servlet.payroll;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.Payroll;
import com.example.hrms.service.PayrollService;
import com.example.hrms.util.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "GeneratePayrollServlet", urlPatterns = {
    "/admin/payroll/generate",
    "/hr/payroll/generate"
})
public class GeneratePayrollServlet extends HttpServlet {
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
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!role.equals("ADMIN") && !role.equals("HR")) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return;
        }

        try {
            // Get all employees for the dropdown
            List<Employee> employees = employeeDAO.getAllEmployees();
            request.setAttribute("employees", employees);

            // Get current month in YYYY-MM format
            LocalDate today = LocalDate.now();
            String currentMonth = today.format(DateTimeFormatter.ofPattern("yyyy-MM"));
            request.setAttribute("currentMonth", currentMonth);

            // Get previous month
            LocalDate previousMonth = today.minusMonths(1);
            String prevMonth = previousMonth.format(DateTimeFormatter.ofPattern("yyyy-MM"));
            request.setAttribute("previousMonth", prevMonth);

            // Get list of months for dropdown (last 12 months)
            String[] months = new String[12];
            for (int i = 0; i < 12; i++) {
                LocalDate month = today.minusMonths(i);
                months[i] = month.format(DateTimeFormatter.ofPattern("yyyy-MM"));
            }
            request.setAttribute("months", months);

            // Check if we're viewing existing payrolls for a month
            String viewMonth = request.getParameter("month");
            if (viewMonth != null && !viewMonth.isEmpty()) {
                List<Payroll> payrolls = payrollService.getPayrollsByMonth(viewMonth);
                request.setAttribute("payrolls", payrolls);
                request.setAttribute("selectedMonth", viewMonth);

                // Format month for display
                YearMonth ym = YearMonth.parse(viewMonth);
                String formattedMonth = ym.format(DateTimeFormatter.ofPattern("MMMM yyyy"));
                request.setAttribute("formattedMonth", formattedMonth);
            }

            // Forward to the JSP page
            String jspPath = role.equals("ADMIN") ? "/WEB-INF/admin/generate-payroll.jsp" : "/WEB-INF/hr/generate-payroll.jsp";
            request.getRequestDispatcher(jspPath).forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!role.equals("ADMIN") && !role.equals("HR")) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return;
        }

        try {
            String action = request.getParameter("action");

            if ("generate".equals(action)) {
                // Generate payroll for a specific employee or all employees
                String employeeIdParam = request.getParameter("employeeId");
                String month = request.getParameter("month");

                if (month == null || month.isEmpty()) {
                    // Default to current month
                    month = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
                }

                if (employeeIdParam != null && !employeeIdParam.isEmpty() && !employeeIdParam.equals("all")) {
                    // Generate for a specific employee
                    int employeeId = Integer.parseInt(employeeIdParam);
                    Payroll payroll = payrollService.generatePayroll(employeeId, month);

                    // Redirect to view the generated payroll
                    response.sendRedirect(request.getContextPath() + "/" + role.toLowerCase() + "/payroll/view?id=" + payroll.getId());
                } else {
                    // Generate for all employees
                    payrollService.generatePayrollForAllEmployees(month);

                    // Redirect to view all payrolls for the month
                    response.sendRedirect(request.getContextPath() + "/" + role.toLowerCase() + "/payroll/generate?month=" + month);
                }
            } else if ("update".equals(action)) {
                // Update an existing payroll
                int payrollId = Integer.parseInt(request.getParameter("payrollId"));
                Payroll payroll = payrollService.getPayrollById(payrollId);

                if (payroll != null) {
                    // Update payroll details
                    BigDecimal baseSalary = new BigDecimal(request.getParameter("baseSalary"));
                    BigDecimal allowances = new BigDecimal(request.getParameter("allowances"));
                    BigDecimal deductions = new BigDecimal(request.getParameter("deductions"));
                    String notes = request.getParameter("notes");

                    payroll.setBaseSalary(baseSalary);
                    payroll.setAllowances(allowances);
                    payroll.setDeductions(deductions);
                    payroll.setNotes(notes);

                    payrollService.updatePayroll(payroll);

                    // Redirect to view the updated payroll
                    response.sendRedirect(request.getContextPath() + "/" + role.toLowerCase() + "/payroll/view?id=" + payrollId);
                } else {
                    request.setAttribute("errorMessage", "Payroll not found");
                    request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
                }
            } else if ("finalize".equals(action)) {
                // Finalize a payroll
                int payrollId = Integer.parseInt(request.getParameter("payrollId"));
                boolean success = payrollService.finalizePayroll(payrollId);

                if (success) {
                    // Send email notification
                    try {
                        // Get payroll details
                        Payroll payroll = payrollService.getPayrollById(payrollId);
                        if (payroll != null) {
                            // Get employee details
                            Employee employee = employeeDAO.getEmployeeById(payroll.getEmployeeId());
                            if (employee != null && employee.getEmail() != null) {
                                // Format month for display
                                String formattedMonth = payroll.getFormattedMonth();

                                // Format net salary
                                String netSalary = payroll.getNetSalary().toString();

                                // Send email notification
                                EmailService.sendPayslipNotification(
                                    employee.getEmail(),
                                    employee.getName(),
                                    formattedMonth,
                                    netSalary,
                                    payrollId
                                );

                                System.out.println("Payslip notification email sent to " + employee.getEmail());
                            }
                        }
                    } catch (Exception e) {
                        // Log the error but don't fail the request
                        System.err.println("Error sending email notification: " + e.getMessage());
                        e.printStackTrace();
                    }
                }

                // Redirect back to the payroll view
                response.sendRedirect(request.getContextPath() + "/" + role.toLowerCase() + "/payroll/view?id=" + payrollId);
            } else if ("markPaid".equals(action)) {
                // Mark a payroll as paid
                int payrollId = Integer.parseInt(request.getParameter("payrollId"));
                payrollService.markPayrollAsPaid(payrollId);

                // Redirect back to the payroll view
                response.sendRedirect(request.getContextPath() + "/" + role.toLowerCase() + "/payroll/view?id=" + payrollId);
            } else if ("delete".equals(action)) {
                // Delete a payroll
                int payrollId = Integer.parseInt(request.getParameter("payrollId"));
                String month = request.getParameter("month");
                payrollService.deletePayroll(payrollId);

                // Redirect back to the payroll list
                response.sendRedirect(request.getContextPath() + "/" + role.toLowerCase() + "/payroll/generate?month=" + month);
            } else {
                request.setAttribute("errorMessage", "Invalid action");
                request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid number format: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        }
    }
}
