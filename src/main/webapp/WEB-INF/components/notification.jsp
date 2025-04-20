<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Notification Component Usage:

<jsp:include page="/WEB-INF/components/notification.jsp">
    <jsp:param name="id" value="successNotification" />
    <jsp:param name="type" value="success" />
    <jsp:param name="title" value="Success!" />
    <jsp:param name="message" value="Your changes have been saved successfully." />
    <jsp:param name="show" value="true" />
    <jsp:param name="autoClose" value="true" />
    <jsp:param name="autoCloseDelay" value="5000" />
</jsp:include>

JavaScript usage:
showNotification('successNotification');
hideNotification('successNotification');
--%>

<c:set var="notificationId" value="${param.id}" />
<c:set var="notificationType" value="${param.type}" />
<c:set var="notificationTitle" value="${param.title}" />
<c:set var="notificationMessage" value="${param.message}" />
<c:set var="notificationShow" value="${param.show}" />
<c:set var="notificationAutoClose" value="${param.autoClose}" />
<c:set var="notificationAutoCloseDelay" value="${param.autoCloseDelay}" />

<%-- Default values --%>
<c:if test="${empty notificationId}">
    <c:set var="notificationId" value="notification-${System.currentTimeMillis()}" />
</c:if>
<c:if test="${empty notificationType}">
    <c:set var="notificationType" value="info" />
</c:if>
<c:if test="${empty notificationShow}">
    <c:set var="notificationShow" value="false" />
</c:if>
<c:if test="${empty notificationAutoClose}">
    <c:set var="notificationAutoClose" value="false" />
</c:if>
<c:if test="${empty notificationAutoCloseDelay}">
    <c:set var="notificationAutoCloseDelay" value="5000" />
</c:if>

<%-- Notification type styles --%>
<c:choose>
    <c:when test="${notificationType eq 'success'}">
        <c:set var="bgColor" value="bg-green-50" />
        <c:set var="iconBgColor" value="bg-green-100" />
        <c:set var="iconColor" value="text-green-500" />
        <c:set var="borderColor" value="border-green-400" />
        <c:set var="titleColor" value="text-green-800" />
        <c:set var="messageColor" value="text-green-700" />
        <c:set var="iconSvg">
            <svg class="h-5 w-5 ${iconColor}" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${notificationType eq 'warning'}">
        <c:set var="bgColor" value="bg-yellow-50" />
        <c:set var="iconBgColor" value="bg-yellow-100" />
        <c:set var="iconColor" value="text-yellow-500" />
        <c:set var="borderColor" value="border-yellow-400" />
        <c:set var="titleColor" value="text-yellow-800" />
        <c:set var="messageColor" value="text-yellow-700" />
        <c:set var="iconSvg">
            <svg class="h-5 w-5 ${iconColor}" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${notificationType eq 'error'}">
        <c:set var="bgColor" value="bg-red-50" />
        <c:set var="iconBgColor" value="bg-red-100" />
        <c:set var="iconColor" value="text-red-500" />
        <c:set var="borderColor" value="border-red-400" />
        <c:set var="titleColor" value="text-red-800" />
        <c:set var="messageColor" value="text-red-700" />
        <c:set var="iconSvg">
            <svg class="h-5 w-5 ${iconColor}" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
            </svg>
        </c:set>
    </c:when>
    <c:otherwise>
        <c:set var="bgColor" value="bg-blue-50" />
        <c:set var="iconBgColor" value="bg-blue-100" />
        <c:set var="iconColor" value="text-blue-500" />
        <c:set var="borderColor" value="border-blue-400" />
        <c:set var="titleColor" value="text-blue-800" />
        <c:set var="messageColor" value="text-blue-700" />
        <c:set var="iconSvg">
            <svg class="h-5 w-5 ${iconColor}" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
            </svg>
        </c:set>
    </c:otherwise>
</c:choose>

<div id="${notificationId}" class="notification-container fixed inset-0 flex items-end justify-center px-4 py-6 pointer-events-none sm:p-6 sm:items-start sm:justify-end z-50 ${notificationShow eq 'true' ? '' : 'hidden'}">
    <div class="max-w-sm w-full ${bgColor} shadow-lg rounded-lg pointer-events-auto border-l-4 ${borderColor} transform transition-all duration-300 ease-in-out">
        <div class="p-4">
            <div class="flex items-start">
                <div class="flex-shrink-0">
                    <div class="h-8 w-8 rounded-full ${iconBgColor} flex items-center justify-center">
                        ${iconSvg}
                    </div>
                </div>
                <div class="ml-3 w-0 flex-1 pt-0.5">
                    <c:if test="${not empty notificationTitle}">
                        <p class="text-sm font-medium ${titleColor}">${notificationTitle}</p>
                    </c:if>
                    <c:if test="${not empty notificationMessage}">
                        <p class="mt-1 text-sm ${messageColor}">${notificationMessage}</p>
                    </c:if>
                </div>
                <div class="ml-4 flex-shrink-0 flex">
                    <button onclick="hideNotification('${notificationId}')" class="inline-flex text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                        <span class="sr-only">Close</span>
                        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Auto-close notification if enabled
    <c:if test="${notificationAutoClose eq 'true' && notificationShow eq 'true'}">
        setTimeout(function() {
            hideNotification('${notificationId}');
        }, ${notificationAutoCloseDelay});
    </c:if>
    
    // Show notification function
    function showNotification(id) {
        const notification = document.getElementById(id);
        if (notification) {
            notification.classList.remove('hidden');
            
            // Add entrance animation
            const notificationContent = notification.querySelector('div');
            notificationContent.classList.add('animate-notification-in');
            
            // Remove animation class after animation completes
            setTimeout(() => {
                notificationContent.classList.remove('animate-notification-in');
            }, 300);
        }
    }
    
    // Hide notification function
    function hideNotification(id) {
        const notification = document.getElementById(id);
        if (notification) {
            // Add exit animation
            const notificationContent = notification.querySelector('div');
            notificationContent.classList.add('animate-notification-out');
            
            // Hide after animation completes
            setTimeout(() => {
                notification.classList.add('hidden');
                notificationContent.classList.remove('animate-notification-out');
            }, 300);
        }
    }
</script>

<style>
    @keyframes notificationIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes notificationOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
    
    .animate-notification-in {
        animation: notificationIn 0.3s ease-out forwards;
    }
    
    .animate-notification-out {
        animation: notificationOut 0.3s ease-in forwards;
    }
</style>
