<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Stats Card Component Usage:

<jsp:include page="/WEB-INF/components/stats-card.jsp">
    <jsp:param name="title" value="Total Employees" />
    <jsp:param name="value" value="125" />
    <jsp:param name="change" value="+12%" />
    <jsp:param name="changeType" value="increase|decrease|neutral" />
    <jsp:param name="icon" value="users|calendar|chart|money|document|bell" />
    <jsp:param name="iconBgColor" value="primary|blue|green|red|yellow|purple|gray" />
    <jsp:param name="period" value="from last month" />
</jsp:include>
--%>

<c:set var="cardTitle" value="${param.title}" />
<c:set var="cardValue" value="${param.value}" />
<c:set var="cardChange" value="${param.change}" />
<c:set var="cardChangeType" value="${param.changeType}" />
<c:set var="cardIcon" value="${param.icon}" />
<c:set var="cardIconBgColor" value="${param.iconBgColor}" />
<c:set var="cardPeriod" value="${param.period}" />

<%-- Default values --%>
<c:if test="${empty cardIconBgColor}">
    <c:set var="cardIconBgColor" value="primary" />
</c:if>
<c:if test="${empty cardChangeType}">
    <c:set var="cardChangeType" value="neutral" />
</c:if>

<%-- Icon background color --%>
<c:choose>
    <c:when test="${cardIconBgColor eq 'primary'}">
        <c:set var="iconBgStyle" value="bg-primary-100" />
        <c:set var="iconTextStyle" value="text-primary-600" />
    </c:when>
    <c:when test="${cardIconBgColor eq 'blue'}">
        <c:set var="iconBgStyle" value="bg-blue-100" />
        <c:set var="iconTextStyle" value="text-blue-600" />
    </c:when>
    <c:when test="${cardIconBgColor eq 'green'}">
        <c:set var="iconBgStyle" value="bg-green-100" />
        <c:set var="iconTextStyle" value="text-green-600" />
    </c:when>
    <c:when test="${cardIconBgColor eq 'red'}">
        <c:set var="iconBgStyle" value="bg-red-100" />
        <c:set var="iconTextStyle" value="text-red-600" />
    </c:when>
    <c:when test="${cardIconBgColor eq 'yellow'}">
        <c:set var="iconBgStyle" value="bg-yellow-100" />
        <c:set var="iconTextStyle" value="text-yellow-600" />
    </c:when>
    <c:when test="${cardIconBgColor eq 'purple'}">
        <c:set var="iconBgStyle" value="bg-purple-100" />
        <c:set var="iconTextStyle" value="text-purple-600" />
    </c:when>
    <c:when test="${cardIconBgColor eq 'gray'}">
        <c:set var="iconBgStyle" value="bg-gray-100" />
        <c:set var="iconTextStyle" value="text-gray-600" />
    </c:when>
    <c:otherwise>
        <c:set var="iconBgStyle" value="bg-primary-100" />
        <c:set var="iconTextStyle" value="text-primary-600" />
    </c:otherwise>
</c:choose>

<%-- Change type styles --%>
<c:choose>
    <c:when test="${cardChangeType eq 'increase'}">
        <c:set var="changeStyle" value="text-green-600" />
        <c:set var="changeIcon">
            <svg class="self-center flex-shrink-0 h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M5.293 9.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 7.414V15a1 1 0 11-2 0V7.414L6.707 9.707a1 1 0 01-1.414 0z" clip-rule="evenodd" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${cardChangeType eq 'decrease'}">
        <c:set var="changeStyle" value="text-red-600" />
        <c:set var="changeIcon">
            <svg class="self-center flex-shrink-0 h-5 w-5 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M14.707 10.293a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 111.414-1.414L9 12.586V5a1 1 0 012 0v7.586l2.293-2.293a1 1 0 011.414 0z" clip-rule="evenodd" />
            </svg>
        </c:set>
    </c:when>
    <c:otherwise>
        <c:set var="changeStyle" value="text-gray-600" />
        <c:set var="changeIcon">
            <svg class="self-center flex-shrink-0 h-5 w-5 text-gray-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M5 10a1 1 0 011-1h8a1 1 0 110 2H6a1 1 0 01-1-1z" clip-rule="evenodd" />
            </svg>
        </c:set>
    </c:otherwise>
</c:choose>

<%-- Icon SVG --%>
<c:set var="iconSvg" value="" />
<c:choose>
    <c:when test="${cardIcon eq 'users'}">
        <c:set var="iconSvg">
            <svg class="h-6 w-6 ${iconTextStyle}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${cardIcon eq 'calendar'}">
        <c:set var="iconSvg">
            <svg class="h-6 w-6 ${iconTextStyle}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${cardIcon eq 'chart'}">
        <c:set var="iconSvg">
            <svg class="h-6 w-6 ${iconTextStyle}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${cardIcon eq 'money'}">
        <c:set var="iconSvg">
            <svg class="h-6 w-6 ${iconTextStyle}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${cardIcon eq 'document'}">
        <c:set var="iconSvg">
            <svg class="h-6 w-6 ${iconTextStyle}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${cardIcon eq 'bell'}">
        <c:set var="iconSvg">
            <svg class="h-6 w-6 ${iconTextStyle}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
            </svg>
        </c:set>
    </c:when>
</c:choose>

<div class="bg-white overflow-hidden shadow rounded-lg">
    <div class="p-5">
        <div class="flex items-center">
            <c:if test="${not empty cardIcon}">
                <div class="flex-shrink-0 ${iconBgStyle} rounded-md p-3">
                    ${iconSvg}
                </div>
            </c:if>
            <div class="ml-5 w-0 flex-1">
                <dl>
                    <dt class="text-sm font-medium text-gray-500 truncate">${cardTitle}</dt>
                    <dd>
                        <div class="text-lg font-medium text-gray-900">${cardValue}</div>
                    </dd>
                </dl>
            </div>
        </div>
    </div>
    <c:if test="${not empty cardChange || not empty cardPeriod}">
        <div class="bg-gray-50 px-5 py-3">
            <div class="text-sm">
                <c:if test="${not empty cardChange}">
                    <span class="inline-flex items-center ${changeStyle} mr-1">
                        ${changeIcon}
                        ${cardChange}
                    </span>
                </c:if>
                <c:if test="${not empty cardPeriod}">
                    <span class="text-gray-500">${cardPeriod}</span>
                </c:if>
            </div>
        </div>
    </c:if>
</div>
