package com.example.hrms.shared.web;

import com.example.hrms.model.User;
import com.example.hrms.shared.view.DefaultLayoutDataResolver;
import com.example.hrms.shared.view.LayoutDataResolver;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = "/*")
public class LayoutDataFilter implements Filter {
    private final LayoutDataResolver layoutDataResolver;

    public LayoutDataFilter() {
        this(new DefaultLayoutDataResolver());
    }

    LayoutDataFilter(LayoutDataResolver layoutDataResolver) {
        this.layoutDataResolver = layoutDataResolver;
    }

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String path = RouteRegistry.getPath(httpRequest);

        if (RouteRegistry.isProtectedPath(path)) {
            HttpSession session = httpRequest.getSession(false);
            if (session != null) {
                User user = (User) session.getAttribute("user");
                if (user != null) {
                    request.setAttribute("layout", layoutDataResolver.resolve(user));
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
