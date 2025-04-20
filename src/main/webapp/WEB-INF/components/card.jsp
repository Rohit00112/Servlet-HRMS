<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Card Component Usage:

<jsp:include page="/WEB-INF/components/card.jsp">
    <jsp:param name="title" value="Card Title" />
    <jsp:param name="subtitle" value="Optional subtitle" />
    <jsp:param name="icon" value="user|calendar|chart|document|bell|cog" />
    <jsp:param name="iconBgColor" value="primary|blue|green|red|yellow|purple|gray" />
    <jsp:param name="footerContent" value="<div>Footer content here</div>" />
    <jsp:param name="content" value="<div>Main content here</div>" />
</jsp:include>
--%>

<c:set var="cardTitle" value="${param.title}" />
<c:set var="cardSubtitle" value="${param.subtitle}" />
<c:set var="cardIcon" value="${param.icon}" />
<c:set var="cardIconBgColor" value="${param.iconBgColor}" />
<c:set var="cardFooterContent" value="${param.footerContent}" />
<c:set var="cardContent" value="${param.content}" />

<%-- Default values --%>
<c:if test="${empty cardIconBgColor}">
    <c:set var="cardIconBgColor" value="primary" />
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

<%-- Icon SVG --%>
<c:set var="iconSvg" value="" />
<c:choose>
    <c:when test="${cardIcon eq 'user'}">
        <c:set var="iconSvg">
            <svg class="h-6 w-6 ${iconTextStyle}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
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
    <c:when test="${cardIcon eq 'cog'}">
        <c:set var="iconSvg">
            <svg class="h-6 w-6 ${iconTextStyle}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
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
</c:choose>

<div class="bg-white overflow-hidden shadow rounded-lg w-full">
    <div class="p-5">
        <c:if test="${not empty cardTitle || not empty cardIcon}">
            <div class="flex items-center">
                <c:if test="${not empty cardIcon}">
                    <div class="flex-shrink-0 ${iconBgStyle} rounded-md p-3">
                        ${iconSvg}
                    </div>
                </c:if>
                <c:if test="${not empty cardTitle}">
                    <div class="ml-5 w-0 flex-1">
                        <h3 class="text-lg font-medium text-gray-900 truncate">${cardTitle}</h3>
                        <c:if test="${not empty cardSubtitle}">
                            <p class="mt-1 text-sm text-gray-500">${cardSubtitle}</p>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </c:if>

        <c:if test="${not empty cardContent}">
            <div class="mt-4">
                ${cardContent}
            </div>
        </c:if>
    </div>

    <c:if test="${not empty cardFooterContent}">
        <div class="bg-gray-50 px-5 py-3">
            ${cardFooterContent}
        </div>
    </c:if>
</div>
