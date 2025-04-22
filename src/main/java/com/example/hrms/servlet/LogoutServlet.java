package com.example.hrms.servlet;

import com.example.hrms.dao.UserActivityDAO;
import com.example.hrms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "logoutServlet", value = "/logout")
public class LogoutServlet extends HttpServlet {
    private UserActivityDAO userActivityDAO;

    @Override
    public void init() {
        userActivityDAO = new UserActivityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Log the logout activity if user is logged in
            User user = (User) session.getAttribute("user");
            if (user != null) {
                userActivityDAO.logActivity(
                    user.getId(),
                    user.getUsername(),
                    user.getRole(),
                    "LOGOUT",
                    user.getUsername() + " logged out",
                    "USER",
                    user.getId(),
                    request.getRemoteAddr()
                );
            }

            // Invalidate the session
            session.invalidate();
        }

        // Redirect to login page
        response.sendRedirect("login");
    }
}
