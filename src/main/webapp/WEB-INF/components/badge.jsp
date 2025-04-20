<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Badge Component Usage:

<jsp:include page="/WEB-INF/components/badge.jsp">
    <jsp:param name="type" value="success|info|warning|danger|primary|secondary" />
    <jsp:param name="text" value="Badge Text" />
    <jsp:param name="size" value="sm|md|lg" />
    <jsp:param name="rounded" value="full|md" />
</jsp:include>
--%>

<c:set var="badgeType" value="${param.type}" />
<c:set var="badgeText" value="${param.text}" />
<c:set var="badgeSize" value="${param.size}" />
<c:set var="badgeRounded" value="${param.rounded}" />

<%-- Default values --%>
<c:if test="${empty badgeType}">
    <c:set var="badgeType" value="primary" />
</c:if>
<c:if test="${empty badgeSize}">
    <c:set var="badgeSize" value="sm" />
</c:if>
<c:if test="${empty badgeRounded}">
    <c:set var="badgeRounded" value="full" />
</c:if>

<%-- Badge styles based on type --%>
<c:choose>
    <c:when test="${badgeType eq 'success'}">
        <c:set var="badgeStyle" value="bg-green-100 text-green-800" />
    </c:when>
    <c:when test="${badgeType eq 'info'}">
        <c:set var="badgeStyle" value="bg-blue-100 text-blue-800" />
    </c:when>
    <c:when test="${badgeType eq 'warning'}">
        <c:set var="badgeStyle" value="bg-yellow-100 text-yellow-800" />
    </c:when>
    <c:when test="${badgeType eq 'danger'}">
        <c:set var="badgeStyle" value="bg-red-100 text-red-800" />
    </c:when>
    <c:when test="${badgeType eq 'secondary'}">
        <c:set var="badgeStyle" value="bg-gray-100 text-gray-800" />
    </c:when>
    <c:otherwise>
        <c:set var="badgeStyle" value="bg-primary-100 text-primary-800" />
    </c:otherwise>
</c:choose>

<%-- Badge size --%>
<c:choose>
    <c:when test="${badgeSize eq 'md'}">
        <c:set var="sizeStyle" value="px-3 py-1 text-sm" />
    </c:when>
    <c:when test="${badgeSize eq 'lg'}">
        <c:set var="sizeStyle" value="px-4 py-1.5 text-base" />
    </c:when>
    <c:otherwise>
        <c:set var="sizeStyle" value="px-2 py-0.5 text-xs" />
    </c:otherwise>
</c:choose>

<%-- Badge rounded --%>
<c:choose>
    <c:when test="${badgeRounded eq 'md'}">
        <c:set var="roundedStyle" value="rounded-md" />
    </c:when>
    <c:otherwise>
        <c:set var="roundedStyle" value="rounded-full" />
    </c:otherwise>
</c:choose>

<span class="inline-flex items-center ${sizeStyle} font-medium ${badgeStyle} ${roundedStyle}">
    ${badgeText}
</span>
