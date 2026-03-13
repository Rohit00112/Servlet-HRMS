package com.example.hrms.shared.web;

import jakarta.servlet.http.HttpServletRequest;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

public final class RouteRegistry {
    private static final Set<String> ALL_ROLES = Set.of("ADMIN", "HR", "EMPLOYEE");
    private static final Set<String> HR_AND_EMPLOYEE = Set.of("HR", "EMPLOYEE");
    private static final Set<String> HR_ONLY = Set.of("HR");
    private static final Set<String> EMPLOYEE_ONLY = Set.of("EMPLOYEE");

    private static final Map<String, String> LEGACY_GET_REDIRECTS = new LinkedHashMap<>();
    private static final Map<String, Set<String>> EXACT_POLICIES = new LinkedHashMap<>();

    static {
        LEGACY_GET_REDIRECTS.put("/login", "/auth/login");
        LEGACY_GET_REDIRECTS.put("/logout", "/auth/logout");
        LEGACY_GET_REDIRECTS.put("/forgot-password", "/auth/password/forgot");
        LEGACY_GET_REDIRECTS.put("/change-password", "/auth/password/change");
        LEGACY_GET_REDIRECTS.put("/first-login-password-change", "/auth/password/first-login");
        LEGACY_GET_REDIRECTS.put("/admin/dashboard", "/dashboard");
        LEGACY_GET_REDIRECTS.put("/hr/dashboard", "/dashboard");
        LEGACY_GET_REDIRECTS.put("/employee/dashboard", "/dashboard");
        LEGACY_GET_REDIRECTS.put("/admin/employees", "/employees");
        LEGACY_GET_REDIRECTS.put("/hr/employees", "/employees");
        LEGACY_GET_REDIRECTS.put("/admin/departments", "/departments");
        LEGACY_GET_REDIRECTS.put("/employee/profile", "/profile");
        LEGACY_GET_REDIRECTS.put("/hr/profile", "/profile");
        LEGACY_GET_REDIRECTS.put("/admin/profile", "/profile");
        LEGACY_GET_REDIRECTS.put("/employee/attendance/view", "/attendance");
        LEGACY_GET_REDIRECTS.put("/hr/attendance/view", "/attendance");
        LEGACY_GET_REDIRECTS.put("/admin/attendance/view", "/attendance");
        LEGACY_GET_REDIRECTS.put("/employee/attendance/mark", "/attendance/mark");
        LEGACY_GET_REDIRECTS.put("/hr/attendance-report", "/attendance/report");
        LEGACY_GET_REDIRECTS.put("/admin/attendance-report", "/attendance/report");
        LEGACY_GET_REDIRECTS.put("/employee/leave/status", "/leaves");
        LEGACY_GET_REDIRECTS.put("/hr/leave/all", "/leaves");
        LEGACY_GET_REDIRECTS.put("/admin/leave/all", "/leaves");
        LEGACY_GET_REDIRECTS.put("/employee/leave/apply", "/leaves/apply");
        LEGACY_GET_REDIRECTS.put("/admin/payroll/view", "/payroll/view");
        LEGACY_GET_REDIRECTS.put("/hr/payroll/view", "/payroll/view");
        LEGACY_GET_REDIRECTS.put("/employee/payroll/view", "/payroll/view");
        LEGACY_GET_REDIRECTS.put("/admin/payroll/download", "/payroll/download");
        LEGACY_GET_REDIRECTS.put("/hr/payroll/download", "/payroll/download");
        LEGACY_GET_REDIRECTS.put("/employee/payroll/download", "/payroll/download");
        LEGACY_GET_REDIRECTS.put("/admin/payroll/generate", "/payroll/generate");
        LEGACY_GET_REDIRECTS.put("/hr/payroll/generate", "/payroll/generate");

        EXACT_POLICIES.put("/dashboard", ALL_ROLES);
        EXACT_POLICIES.put("/dashboard/analytics", Set.of("ADMIN", "HR"));
        EXACT_POLICIES.put("/employees", Set.of("ADMIN", "HR"));
        EXACT_POLICIES.put("/employees/add", Set.of("ADMIN", "HR"));
        EXACT_POLICIES.put("/employees/edit", Set.of("ADMIN", "HR"));
        EXACT_POLICIES.put("/employees/delete", Set.of("ADMIN", "HR"));
        EXACT_POLICIES.put("/attendance", ALL_ROLES);
        EXACT_POLICIES.put("/attendance/mark", Set.of("ADMIN", "EMPLOYEE"));
        EXACT_POLICIES.put("/attendance/report", Set.of("ADMIN", "HR"));
        EXACT_POLICIES.put("/leaves", ALL_ROLES);
        EXACT_POLICIES.put("/leaves/apply", Set.of("ADMIN", "EMPLOYEE"));
        EXACT_POLICIES.put("/leaves/approve", Set.of("ADMIN", "HR"));
        EXACT_POLICIES.put("/leaves/reject", Set.of("ADMIN", "HR"));
        EXACT_POLICIES.put("/payroll/view", ALL_ROLES);
        EXACT_POLICIES.put("/payroll/download", ALL_ROLES);
        EXACT_POLICIES.put("/payroll/generate", Set.of("ADMIN", "HR"));
        EXACT_POLICIES.put("/notifications", ALL_ROLES);
        EXACT_POLICIES.put("/notifications/mark-read", ALL_ROLES);
        EXACT_POLICIES.put("/notifications/mark-all-read", ALL_ROLES);
        EXACT_POLICIES.put("/departments", Set.of("ADMIN"));
        EXACT_POLICIES.put("/profile", ALL_ROLES);
        EXACT_POLICIES.put("/settings", ALL_ROLES);
    }

    private RouteRegistry() {
    }

    public static String getPath(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        return uri.startsWith(contextPath) ? uri.substring(contextPath.length()) : uri;
    }

    public static boolean isLegacyRedirectCandidate(String path, String method) {
        return ("GET".equalsIgnoreCase(method) || "HEAD".equalsIgnoreCase(method))
                && LEGACY_GET_REDIRECTS.containsKey(path);
    }

    public static String getCanonicalPath(String path) {
        return LEGACY_GET_REDIRECTS.getOrDefault(path, path);
    }

    public static boolean isProtectedPath(String path) {
        return resolveAllowedRoles(path) != null || isLegacyProtectedPrefix(path);
    }

    public static boolean isAuthorized(String path, String role) {
        if (role == null || role.isBlank()) {
            return false;
        }

        if ("ADMIN".equals(role)) {
            return isProtectedPath(path);
        }

        Set<String> allowedRoles = resolveAllowedRoles(path);
        if (allowedRoles != null) {
            return allowedRoles.contains(role);
        }

        if (path.startsWith("/hr/")) {
            return HR_ONLY.contains(role);
        }

        if (path.startsWith("/employee/")) {
            return HR_AND_EMPLOYEE.contains(role);
        }

        return false;
    }

    public static boolean isPublicPath(String path) {
        return path.equals("/auth/login")
                || path.equals("/auth/logout")
                || path.equals("/auth/password/forgot")
                || path.equals("/auth/password/change")
                || path.equals("/auth/password/first-login")
                || path.equals("/login")
                || path.equals("/logout")
                || path.equals("/forgot-password")
                || path.equals("/change-password")
                || path.equals("/first-login-password-change");
    }

    private static Set<String> resolveAllowedRoles(String path) {
        String normalized = getCanonicalPath(path);
        Set<String> roles = EXACT_POLICIES.get(normalized);
        if (roles != null) {
            return roles;
        }

        if (path.startsWith("/admin/")) {
            return Set.of("ADMIN");
        }
        if (path.startsWith("/hr/")) {
            return Set.of("ADMIN", "HR");
        }
        if (path.startsWith("/employee/")) {
            return Set.of("ADMIN", "HR", "EMPLOYEE");
        }
        if (path.startsWith("/export/")) {
            return Set.of("ADMIN", "HR");
        }
        return null;
    }

    private static boolean isLegacyProtectedPrefix(String path) {
        return path.startsWith("/admin/")
                || path.startsWith("/hr/")
                || path.startsWith("/employee/")
                || path.startsWith("/export/");
    }
}
