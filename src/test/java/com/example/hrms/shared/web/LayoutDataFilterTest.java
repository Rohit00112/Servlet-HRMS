package com.example.hrms.shared.web;

import com.example.hrms.model.User;
import com.example.hrms.shared.view.LayoutDataResolver;
import com.example.hrms.shared.view.LayoutViewData;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;

class LayoutDataFilterTest {

    @Test
    void shouldPopulateLayoutAttributeForProtectedRoute() throws Exception {
        User user = new User();
        user.setId(1);
        user.setUsername("employee");
        user.setRole("EMPLOYEE");

        LayoutViewData expectedLayout = new LayoutViewData(user, null, null, 0);
        RecordingResolver resolver = new RecordingResolver(expectedLayout);
        LayoutDataFilter filter = new LayoutDataFilter(resolver);

        Map<String, Object> requestAttributes = new HashMap<>();
        HttpSession session = sessionWithUser(user);
        HttpServletRequest request = request("/hrms/dashboard", "/hrms", session, requestAttributes);
        AtomicBoolean chainCalled = new AtomicBoolean(false);
        FilterChain chain = chain(chainCalled);

        filter.doFilter(request, response(), chain);

        assertEquals(1, resolver.calls);
        assertSame(expectedLayout, requestAttributes.get("layout"));
        assertTrue(chainCalled.get());
    }

    @Test
    void shouldSkipResolverForPublicRoute() throws Exception {
        RecordingResolver resolver = new RecordingResolver(null);
        LayoutDataFilter filter = new LayoutDataFilter(resolver);
        AtomicBoolean chainCalled = new AtomicBoolean(false);

        HttpServletRequest request = request("/hrms/auth/login", "/hrms", null, new HashMap<>());
        filter.doFilter(request, response(), chain(chainCalled));

        assertEquals(0, resolver.calls);
        assertTrue(chainCalled.get());
    }

    private HttpServletRequest request(String uri, String contextPath, HttpSession session, Map<String, Object> attributes) {
        return (HttpServletRequest) Proxy.newProxyInstance(
                HttpServletRequest.class.getClassLoader(),
                new Class[]{HttpServletRequest.class},
                (proxy, method, args) -> switch (method.getName()) {
                    case "getRequestURI" -> uri;
                    case "getContextPath" -> contextPath;
                    case "getSession" -> session;
                    case "setAttribute" -> {
                        attributes.put((String) args[0], args[1]);
                        yield null;
                    }
                    case "getAttribute" -> attributes.get(args[0]);
                    default -> defaultValue(method.getReturnType());
                }
        );
    }

    private HttpSession sessionWithUser(User user) {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("user", user);
        return (HttpSession) Proxy.newProxyInstance(
                HttpSession.class.getClassLoader(),
                new Class[]{HttpSession.class},
                (proxy, method, args) -> switch (method.getName()) {
                    case "getAttribute" -> sessionAttributes.get(args[0]);
                    case "setAttribute" -> {
                        sessionAttributes.put((String) args[0], args[1]);
                        yield null;
                    }
                    default -> defaultValue(method.getReturnType());
                }
        );
    }

    private jakarta.servlet.http.HttpServletResponse response() {
        return (jakarta.servlet.http.HttpServletResponse) Proxy.newProxyInstance(
                jakarta.servlet.http.HttpServletResponse.class.getClassLoader(),
                new Class[]{jakarta.servlet.http.HttpServletResponse.class},
                (proxy, method, args) -> defaultValue(method.getReturnType())
        );
    }

    private FilterChain chain(AtomicBoolean called) {
        return (ServletRequest request, ServletResponse response) -> called.set(true);
    }

    private Object defaultValue(Class<?> returnType) {
        if (!returnType.isPrimitive()) {
            return null;
        }
        if (returnType == boolean.class) {
            return false;
        }
        if (returnType == int.class) {
            return 0;
        }
        if (returnType == long.class) {
            return 0L;
        }
        if (returnType == double.class) {
            return 0.0d;
        }
        if (returnType == float.class) {
            return 0.0f;
        }
        if (returnType == short.class) {
            return (short) 0;
        }
        if (returnType == byte.class) {
            return (byte) 0;
        }
        if (returnType == char.class) {
            return '\0';
        }
        return null;
    }

    private static final class RecordingResolver implements LayoutDataResolver {
        private final LayoutViewData response;
        private int calls;

        private RecordingResolver(LayoutViewData response) {
            this.response = response;
        }

        @Override
        public LayoutViewData resolve(User user) {
            calls++;
            return response;
        }
    }
}
