package com.example.hrms.servlet;

import com.example.hrms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "departmentStatisticsServlet", value = "/hr/department-statistics")
public class DepartmentStatisticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");

        // Only HR and Admin can access this page
        if (!"HR".equals(role) && !"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Forward to the department statistics JSP
        request.getRequestDispatcher("/WEB-INF/hr/department-statistics.jsp").forward(request, response);
    }
}
