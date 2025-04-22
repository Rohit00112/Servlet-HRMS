package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.model.Employee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "viewEmployeesServlet", value = {"/admin/employees", "/hr/employees"})
public class ViewEmployeesServlet extends BaseServlet {
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchTerm = request.getParameter("search");
        List<Employee> employees;

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            employees = employeeDAO.searchEmployees(searchTerm);
            request.setAttribute("searchTerm", searchTerm);
        } else {
            employees = employeeDAO.getAllEmployees();
        }

        request.setAttribute("employees", employees);

        // Transfer any messages from the session to request attributes
        transferMessagesFromSessionToRequest(request);

        // Forward to the appropriate view based on the user's role
        String requestURI = request.getRequestURI();
        if (requestURI.contains("/admin/")) {
            request.getRequestDispatcher("/WEB-INF/admin/employees.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/hr/employees.jsp").forward(request, response);
        }
    }
}
