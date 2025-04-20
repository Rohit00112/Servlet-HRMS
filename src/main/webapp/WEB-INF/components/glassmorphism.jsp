<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Glassmorphism Component Usage:

<jsp:include page="/WEB-INF/components/glassmorphism.jsp">
    <jsp:param name="type" value="card|sidebar|header|form" />
    <jsp:param name="blur" value="sm|md|lg" />
    <jsp:param name="opacity" value="5|10|20|30|40|50" />
    <jsp:param name="border" value="none|light|medium|heavy" />
    <jsp:param name="shadow" value="none|sm|md|lg|xl" />
    <jsp:param name="rounded" value="none|sm|md|lg|xl|full" />
    <jsp:param name="hoverEffect" value="true|false" />
    <jsp:param name="additionalClasses" value="additional tailwind classes" />
</jsp:include>
--%>

<c:set var="type" value="${param.type}" />
<c:set var="blur" value="${param.blur}" />
<c:set var="opacity" value="${param.opacity}" />
<c:set var="border" value="${param.border}" />
<c:set var="shadow" value="${param.shadow}" />
<c:set var="rounded" value="${param.rounded}" />
<c:set var="hoverEffect" value="${param.hoverEffect}" />
<c:set var="additionalClasses" value="${param.additionalClasses}" />

<%-- Default values --%>
<c:if test="${empty type}">
    <c:set var="type" value="card" />
</c:if>
<c:if test="${empty blur}">
    <c:set var="blur" value="md" />
</c:if>
<c:if test="${empty opacity}">
    <c:set var="opacity" value="20" />
</c:if>
<c:if test="${empty border}">
    <c:set var="border" value="light" />
</c:if>
<c:if test="${empty shadow}">
    <c:set var="shadow" value="md" />
</c:if>
<c:if test="${empty rounded}">
    <c:set var="rounded" value="lg" />
</c:if>
<c:if test="${empty hoverEffect}">
    <c:set var="hoverEffect" value="false" />
</c:if>

<%-- Blur classes --%>
<c:choose>
    <c:when test="${blur eq 'sm'}">
        <c:set var="blurClass" value="backdrop-blur-sm" />
    </c:when>
    <c:when test="${blur eq 'md'}">
        <c:set var="blurClass" value="backdrop-blur-md" />
    </c:when>
    <c:when test="${blur eq 'lg'}">
        <c:set var="blurClass" value="backdrop-blur-lg" />
    </c:when>
    <c:otherwise>
        <c:set var="blurClass" value="backdrop-blur-md" />
    </c:otherwise>
</c:choose>

<%-- Background opacity classes --%>
<c:choose>
    <c:when test="${opacity eq '5'}">
        <c:set var="bgClass" value="bg-white/5" />
    </c:when>
    <c:when test="${opacity eq '10'}">
        <c:set var="bgClass" value="bg-white/10" />
    </c:when>
    <c:when test="${opacity eq '20'}">
        <c:set var="bgClass" value="bg-white/20" />
    </c:when>
    <c:when test="${opacity eq '30'}">
        <c:set var="bgClass" value="bg-white/30" />
    </c:when>
    <c:when test="${opacity eq '40'}">
        <c:set var="bgClass" value="bg-white/40" />
    </c:when>
    <c:when test="${opacity eq '50'}">
        <c:set var="bgClass" value="bg-white/50" />
    </c:when>
    <c:otherwise>
        <c:set var="bgClass" value="bg-white/20" />
    </c:otherwise>
</c:choose>

<%-- Border classes --%>
<c:choose>
    <c:when test="${border eq 'none'}">
        <c:set var="borderClass" value="" />
    </c:when>
    <c:when test="${border eq 'light'}">
        <c:set var="borderClass" value="border border-white/20" />
    </c:when>
    <c:when test="${border eq 'medium'}">
        <c:set var="borderClass" value="border-2 border-white/30" />
    </c:when>
    <c:when test="${border eq 'heavy'}">
        <c:set var="borderClass" value="border-2 border-white/40" />
    </c:when>
    <c:otherwise>
        <c:set var="borderClass" value="border border-white/20" />
    </c:otherwise>
</c:choose>

<%-- Shadow classes --%>
<c:choose>
    <c:when test="${shadow eq 'none'}">
        <c:set var="shadowClass" value="" />
    </c:when>
    <c:when test="${shadow eq 'sm'}">
        <c:set var="shadowClass" value="shadow-sm" />
    </c:when>
    <c:when test="${shadow eq 'md'}">
        <c:set var="shadowClass" value="shadow-md" />
    </c:when>
    <c:when test="${shadow eq 'lg'}">
        <c:set var="shadowClass" value="shadow-lg" />
    </c:when>
    <c:when test="${shadow eq 'xl'}">
        <c:set var="shadowClass" value="shadow-xl" />
    </c:when>
    <c:otherwise>
        <c:set var="shadowClass" value="shadow-md" />
    </c:otherwise>
</c:choose>

<%-- Rounded classes --%>
<c:choose>
    <c:when test="${rounded eq 'none'}">
        <c:set var="roundedClass" value="" />
    </c:when>
    <c:when test="${rounded eq 'sm'}">
        <c:set var="roundedClass" value="rounded-sm" />
    </c:when>
    <c:when test="${rounded eq 'md'}">
        <c:set var="roundedClass" value="rounded-md" />
    </c:when>
    <c:when test="${rounded eq 'lg'}">
        <c:set var="roundedClass" value="rounded-lg" />
    </c:when>
    <c:when test="${rounded eq 'xl'}">
        <c:set var="roundedClass" value="rounded-xl" />
    </c:when>
    <c:when test="${rounded eq 'full'}">
        <c:set var="roundedClass" value="rounded-full" />
    </c:when>
    <c:otherwise>
        <c:set var="roundedClass" value="rounded-lg" />
    </c:otherwise>
</c:choose>

<%-- Hover effect classes --%>
<c:set var="hoverClass" value="" />
<c:if test="${hoverEffect eq 'true'}">
    <c:set var="hoverClass" value="hover:bg-white/30 transition-all duration-300 ease-in-out" />
</c:if>

<%-- Type-specific classes --%>
<c:choose>
    <c:when test="${type eq 'sidebar'}">
        <c:set var="typeClass" value="flex flex-col h-full" />
    </c:when>
    <c:when test="${type eq 'header'}">
        <c:set var="typeClass" value="w-full" />
    </c:when>
    <c:when test="${type eq 'form'}">
        <c:set var="typeClass" value="p-6" />
    </c:when>
    <c:otherwise>
        <c:set var="typeClass" value="" />
    </c:otherwise>
</c:choose>

<%-- Combine all classes --%>
<c:set var="glassClasses" value="${blurClass} ${bgClass} ${borderClass} ${shadowClass} ${roundedClass} ${hoverClass} ${typeClass} ${additionalClasses}" />

${glassClasses}
