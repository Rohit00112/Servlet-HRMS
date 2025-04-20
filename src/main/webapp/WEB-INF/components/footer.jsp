<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<footer class="px-3 py-3">
    <c:set var="footerGlassClasses">
        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
            <jsp:param name="type" value="header" />
            <jsp:param name="blur" value="lg" />
            <jsp:param name="opacity" value="5" />
            <jsp:param name="border" value="light" />
            <jsp:param name="shadow" value="md" />
            <jsp:param name="rounded" value="xl" />
        </jsp:include>
    </c:set>
    <div class="${footerGlassClasses} py-3">
        <div class="w-full px-4">
            <p class="text-center text-sm text-white/70">&copy; 2023 HRMS System. All rights reserved.</p>
        </div>
    </div>
</footer>
