package com.example.hrms.servlet.payroll;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.Payroll;
import com.example.hrms.service.PayrollService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ViewPayslipServlet", urlPatterns = {
    "/admin/payroll/view",
    "/hr/payroll/view",
    "/employee/payroll/view"
})
public class ViewPayslipServlet extends HttpServlet {
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
            String action = request.getParameter("action");

            if (idParam != null && !idParam.isEmpty()) {
                // View a specific payslip
                int payrollId = Integer.parseInt(idParam);
                Payroll payroll = payrollService.getPayrollById(payrollId);

                if (payroll != null) {
                    // Check if employee is viewing their own payslip
                    if (role.equals("EMPLOYEE")) {
                        // Get the employee for the current user
                        Employee currentEmployee = employeeDAO.getEmployeeByUserId(user.getId());

                        // If not found by user ID, try by email
                        if (currentEmployee == null) {
                            currentEmployee = employeeDAO.getEmployeeByEmail(user.getUsername() + "@company.com");
                        }

                        if (currentEmployee == null || payroll.getEmployeeId() != currentEmployee.getId()) {
                            response.sendRedirect(request.getContextPath() + "/access-denied");
                            return;
                        }
                    }

                    // Get employee details
                    Employee employee = employeeDAO.getEmployeeById(payroll.getEmployeeId());
                    request.setAttribute("employee", employee);
                    request.setAttribute("payroll", payroll);

                    // Check if this is an edit request
                    if ("edit".equals(action) && !role.equals("EMPLOYEE") && !"PAID".equals(payroll.getStatus())) {
                        // Forward to the edit payslip form
                        String editJspPath = "/WEB-INF/" + role.toLowerCase() + "/edit-payslip.jsp";
                        request.getRequestDispatcher(editJspPath).forward(request, response);
                        return;
                    }

                    // Forward to the payslip view
                    String jspPath = "/WEB-INF/" + role.toLowerCase() + "/view-payslip.jsp";
                    request.getRequestDispatcher(jspPath).forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Payslip not found");
                    request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
                }
            } else if (role.equals("EMPLOYEE")) {
                // Employee viewing their payslips
                // Get the employee for the current user
                Employee employee = employeeDAO.getEmployeeByUserId(user.getId());

                // If not found by user ID, try by email
                if (employee == null) {
                    employee = employeeDAO.getEmployeeByEmail(user.getUsername() + "@company.com");
                }

                if (employee == null) {
                    request.getSession().setAttribute("errorMessage", "Employee record not found for the current user");
                    response.sendRedirect(request.getContextPath() + "/employee/dashboard");
                    return;
                }

                List<Payroll> payrolls = payrollService.getPayrollsByEmployeeId(employee.getId());

                request.setAttribute("payrolls", payrolls);
                request.getRequestDispatcher("/WEB-INF/employee/payroll-list.jsp").forward(request, response);
            } else {
                // Admin or HR viewing all payslips
                List<Payroll> payrolls = payrollService.getAllPayrolls();
                request.setAttribute("payrolls", payrolls);

                String jspPath = "/WEB-INF/" + role.toLowerCase() + "/payroll-list.jsp";
                request.getRequestDispatcher(jspPath).forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid payroll ID");
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // This servlet primarily handles GET requests
        // Any POST requests will be redirected to the appropriate action in GeneratePayrollServlet
        response.sendRedirect(request.getContextPath() + "/admin/payroll/generate");
    }
}
