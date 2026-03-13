package com.example.hrms.filter;

import com.example.hrms.model.User;
import com.example.hrms.shared.web.RouteRegistry;

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
@WebFilter(urlPatterns = "/*")
public class PasswordChangeFilter implements Filter {

    // List of URLs that are exempt from the password change requirement
    private static final List<String> EXEMPT_URLS = Arrays.asList(
            "/first-login-password-change",
            "/change-password",
            "/logout",
            "/auth/password/first-login",
            "/auth/password/change",
            "/auth/logout"
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
        String path = RouteRegistry.getPath(httpRequest);
        boolean isExempt = EXEMPT_URLS.stream().anyMatch(path::contains);

        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");

            if (user.isPasswordChangeRequired() && !isExempt) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/password/first-login");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}
