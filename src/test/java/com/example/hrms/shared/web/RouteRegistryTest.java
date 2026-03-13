package com.example.hrms.shared.web;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class RouteRegistryTest {

    @Test
    void shouldNormalizeLegacyDashboardPath() {
        assertTrue(RouteRegistry.isLegacyRedirectCandidate("/admin/dashboard", "GET"));
        assertEquals("/dashboard", RouteRegistry.getCanonicalPath("/admin/dashboard"));
    }

    @Test
    void shouldAuthorizeCanonicalRoutesByRole() {
        assertTrue(RouteRegistry.isAuthorized("/dashboard", "EMPLOYEE"));
        assertTrue(RouteRegistry.isAuthorized("/attendance/report", "HR"));
        assertFalse(RouteRegistry.isAuthorized("/departments", "HR"));
        assertFalse(RouteRegistry.isAuthorized("/employees/delete", "EMPLOYEE"));
    }

    @Test
    void shouldTreatCanonicalAndLegacyPathsAsProtected() {
        assertTrue(RouteRegistry.isProtectedPath("/profile"));
        assertTrue(RouteRegistry.isProtectedPath("/employee/attendance/view"));
        assertFalse(RouteRegistry.isProtectedPath("/auth/login"));
    }
}
