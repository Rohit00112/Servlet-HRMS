package com.example.hrms.shared.web;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter(urlPatterns = "/*")
public class LegacyRouteRedirectFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = RouteRegistry.getPath(httpRequest);
        if (RouteRegistry.isLegacyRedirectCandidate(path, httpRequest.getMethod())) {
            String canonicalPath = RouteRegistry.getCanonicalPath(path);
            StringBuilder redirectTarget = new StringBuilder(httpRequest.getContextPath()).append(canonicalPath);
            if (httpRequest.getQueryString() != null && !httpRequest.getQueryString().isBlank()) {
                redirectTarget.append('?').append(httpRequest.getQueryString());
            }
            httpResponse.sendRedirect(redirectTarget.toString());
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
