<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Glassmorphism Component Usage:

<jsp:include page="/WEB-INF/components/glassmorphism.jsp">
    <jsp:param name="title" value="Card Title" />
    <jsp:param name="subtitle" value="Optional subtitle" />
    <jsp:param name="icon" value="user|calendar|chart|document|bell|cog" />
    <jsp:param name="iconBgColor" value="primary|blue|green|red|yellow|purple|gray" />
    <jsp:param name="content" value="<div>Main content here</div>" />
    <jsp:param name="footerContent" value="<div>Footer content here</div>" />
    <jsp:param name="blurIntensity" value="sm|md|lg|xl|2xl|3xl" /> <!-- Optional, default is lg -->
    <jsp:param name="bgOpacity" value="5|10|20|30|40|50" /> <!-- Optional, default is 20 -->
    <jsp:param name="borderOpacity" value="10|20|30" /> <!-- Optional, default is 20 -->
</jsp:include>
--%>

<c:set var="cardTitle" value="${param.title}" />
<c:set var="cardSubtitle" value="${param.subtitle}" />
<c:set var="cardIcon" value="${param.icon}" />
<c:set var="cardIconBgColor" value="${param.iconBgColor}" />
<c:set var="cardContent" value="${param.content}" />
<c:set var="cardFooterContent" value="${param.footerContent}" />
<c:set var="blurIntensity" value="${param.blurIntensity}" />
<c:set var="bgOpacity" value="${param.bgOpacity}" />
<c:set var="borderOpacity" value="${param.borderOpacity}" />

<%-- Default values --%>
<c:if test="${empty cardIconBgColor}">
    <c:set var="cardIconBgColor" value="primary" />
</c:if>

<c:if test="${empty blurIntensity}">
    <c:set var="blurIntensity" value="lg" />
</c:if>

<c:if test="${empty bgOpacity}">
    <c:set var="bgOpacity" value="20" />
</c:if>

<c:if test="${empty borderOpacity}">
    <c:set var="borderOpacity" value="20" />
</c:if>

<%-- Map icon to SVG --%>
<c:choose>
    <c:when test="${cardIcon eq 'user'}">
        <c:set var="iconSvg">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${cardIcon eq 'calendar'}">
        <c:set var="iconSvg">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${cardIcon eq 'chart'}">
        <c:set var="iconSvg">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${cardIcon eq 'document'}">
        <c:set var="iconSvg">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${cardIcon eq 'bell'}">
        <c:set var="iconSvg">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${cardIcon eq 'cog'}">
        <c:set var="iconSvg">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
        </c:set>
    </c:when>
    <c:otherwise>
        <c:set var="iconSvg">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
        </c:set>
    </c:otherwise>
</c:choose>

<%-- Map icon background color --%>
<c:choose>
    <c:when test="${cardIconBgColor eq 'primary'}">
        <c:set var="iconBgClass" value="bg-primary-100 text-primary-600" />
    </c:when>
    <c:when test="${cardIconBgColor eq 'blue'}">
        <c:set var="iconBgClass" value="bg-blue-100 text-blue-600" />
    </c:when>
    <c:when test="${cardIconBgColor eq 'green'}">
        <c:set var="iconBgClass" value="bg-green-100 text-green-600" />
    </c:when>
    <c:when test="${cardIconBgColor eq 'red'}">
        <c:set var="iconBgClass" value="bg-red-100 text-red-600" />
    </c:when>
    <c:when test="${cardIconBgColor eq 'yellow'}">
        <c:set var="iconBgClass" value="bg-yellow-100 text-yellow-600" />
    </c:when>
    <c:when test="${cardIconBgColor eq 'purple'}">
        <c:set var="iconBgClass" value="bg-purple-100 text-purple-600" />
    </c:when>
    <c:otherwise>
        <c:set var="iconBgClass" value="bg-gray-100 text-gray-600" />
    </c:otherwise>
</c:choose>

<%-- Glassmorphism card --%>
<div class="backdrop-blur-${blurIntensity} bg-white/${bgOpacity} border border-white/${borderOpacity} rounded-xl shadow-lg p-6">
    <c:if test="${not empty cardIcon or not empty cardTitle or not empty cardSubtitle}">
        <div class="flex items-center mb-4">
            <c:if test="${not empty cardIcon}">
                <div class="flex-shrink-0 p-3 rounded-lg ${iconBgClass}">
                    ${iconSvg}
                </div>
            </c:if>
            <c:if test="${not empty cardTitle or not empty cardSubtitle}">
                <div class="ml-4">
                    <c:if test="${not empty cardTitle}">
                        <h3 class="text-lg font-medium text-gray-900">${cardTitle}</h3>
                    </c:if>
                    <c:if test="${not empty cardSubtitle}">
                        <p class="text-sm text-gray-500">${cardSubtitle}</p>
                    </c:if>
                </div>
            </c:if>
        </div>
    </c:if>
    
    <c:if test="${not empty cardContent}">
        <div class="mt-2">
            ${cardContent}
        </div>
    </c:if>
    
    <c:if test="${not empty cardFooterContent}">
        <div class="mt-4 pt-4 border-t border-gray-200">
            ${cardFooterContent}
        </div>
    </c:if>
</div>
