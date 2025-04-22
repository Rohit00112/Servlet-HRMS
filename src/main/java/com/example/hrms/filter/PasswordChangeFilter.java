package com.example.hrms.filter;

import com.example.hrms.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * Filter to check if a user needs to change their password
 * If so, redirect them to the password change page
 */
@WebFilter(urlPatterns = {"/employee/*", "/hr/*", "/admin/*"})
public class PasswordChangeFilter implements Filter {

    // List of URLs that are exempt from the password change requirement
    private static final List<String> EXEMPT_URLS = Arrays.asList(
            "/first-login-password-change",
            "/change-password",
            "/logout"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Get the current request path
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Check if the URL is exempt
        boolean isExempt = EXEMPT_URLS.stream().anyMatch(path::contains);
        
        // If the user is logged in and password change is required
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            
            // If password change is required and the URL is not exempt
            if (user.isPasswordChangeRequired() && !isExempt) {
                // Redirect to the password change page
                httpResponse.sendRedirect(contextPath + "/first-login-password-change");
                return;
            }
        }
        
        // Continue with the request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}
