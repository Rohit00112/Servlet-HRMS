package com.example.hrms.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/hr/*", "/employee/*"})
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        if (!isLoggedIn) {
            // User is not logged in, redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        
        // Get the requested URL and user role
        String requestURI = httpRequest.getRequestURI();
        String role = (String) session.getAttribute("role");
        
        // Check if user has permission to access the requested resource
        if (requestURI.contains("/admin/") && !"ADMIN".equals(role)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        } else if (requestURI.contains("/hr/") && !("HR".equals(role) || "ADMIN".equals(role))) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        } else if (requestURI.contains("/employee/") && 
                !("EMPLOYEE".equals(role) || "HR".equals(role) || "ADMIN".equals(role))) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        // User has permission, continue with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
