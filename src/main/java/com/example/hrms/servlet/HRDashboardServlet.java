package com.example.hrms.servlet;

import com.example.hrms.dao.EmployeeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "hrDashboardServlet", value = "/hr/dashboard")
public class HRDashboardServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get employee count for dashboard
        int employeeCount = employeeDAO.getEmployeeCount();
        request.setAttribute("employeeCount", employeeCount);

        request.getRequestDispatcher("/WEB-INF/hr/dashboard.jsp").forward(request, response);
    }
}
