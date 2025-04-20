<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Alert Component Usage:

<jsp:include page="/WEB-INF/components/alert.jsp">
    <jsp:param name="type" value="success|info|warning|error" />
    <jsp:param name="message" value="Your alert message here" />
    <jsp:param name="dismissible" value="true|false" />
    <jsp:param name="icon" value="true|false" />
</jsp:include>
--%>

<c:set var="alertType" value="${param.type}" />
<c:set var="alertMessage" value="${param.message}" />
<c:set var="alertDismissible" value="${param.dismissible}" />
<c:set var="alertIcon" value="${param.icon}" />

<%-- Default values --%>
<c:if test="${empty alertType}">
    <c:set var="alertType" value="info" />
</c:if>
<c:if test="${empty alertDismissible}">
    <c:set var="alertDismissible" value="true" />
</c:if>
<c:if test="${empty alertIcon}">
    <c:set var="alertIcon" value="true" />
</c:if>

<%-- Alert styles based on type --%>
<c:choose>
    <c:when test="${alertType eq 'success'}">
        <c:set var="bgColor" value="bg-green-50" />
        <c:set var="textColor" value="text-green-800" />
        <c:set var="borderColor" value="border-green-400" />
        <c:set var="iconBgColor" value="bg-green-400" />
        <c:set var="iconColor" value="text-white" />
        <c:set var="buttonColor" value="text-green-500 hover:bg-green-100" />
    </c:when>
    <c:when test="${alertType eq 'warning'}">
        <c:set var="bgColor" value="bg-yellow-50" />
        <c:set var="textColor" value="text-yellow-800" />
        <c:set var="borderColor" value="border-yellow-400" />
        <c:set var="iconBgColor" value="bg-yellow-400" />
        <c:set var="iconColor" value="text-white" />
        <c:set var="buttonColor" value="text-yellow-500 hover:bg-yellow-100" />
    </c:when>
    <c:when test="${alertType eq 'error'}">
        <c:set var="bgColor" value="bg-red-50" />
        <c:set var="textColor" value="text-red-800" />
        <c:set var="borderColor" value="border-red-400" />
        <c:set var="iconBgColor" value="bg-red-400" />
        <c:set var="iconColor" value="text-white" />
        <c:set var="buttonColor" value="text-red-500 hover:bg-red-100" />
    </c:when>
    <c:otherwise>
        <c:set var="bgColor" value="bg-blue-50" />
        <c:set var="textColor" value="text-blue-800" />
        <c:set var="borderColor" value="border-blue-400" />
        <c:set var="iconBgColor" value="bg-blue-400" />
        <c:set var="iconColor" value="text-white" />
        <c:set var="buttonColor" value="text-blue-500 hover:bg-blue-100" />
    </c:otherwise>
</c:choose>

<%-- Alert icon based on type --%>
<c:set var="alertIconSvg" value="" />
<c:choose>
    <c:when test="${alertType eq 'success'}">
        <c:set var="alertIconSvg">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${alertType eq 'warning'}">
        <c:set var="alertIconSvg">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${alertType eq 'error'}">
        <c:set var="alertIconSvg">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
            </svg>
        </c:set>
    </c:when>
    <c:otherwise>
        <c:set var="alertIconSvg">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
            </svg>
        </c:set>
    </c:otherwise>
</c:choose>

<div class="rounded-md ${bgColor} p-4 border ${borderColor} mb-4 alert-component">
    <div class="flex">
        <c:if test="${alertIcon eq 'true'}">
            <div class="flex-shrink-0">
                <div class="flex items-center justify-center h-8 w-8 rounded-full ${iconBgColor} ${iconColor}">
                    ${alertIconSvg}
                </div>
            </div>
        </c:if>
        <div class="ml-3 flex-1">
            <p class="text-sm font-medium ${textColor}">${alertMessage}</p>
        </div>
        <c:if test="${alertDismissible eq 'true'}">
            <div class="ml-auto pl-3">
                <div class="-mx-1.5 -my-1.5">
                    <button type="button" class="inline-flex ${buttonColor} rounded-md p-1.5 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-${alertType}-50 focus:ring-${alertType}-600 alert-dismiss-button">
                        <span class="sr-only">Dismiss</span>
                        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                        </svg>
                    </button>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script>
    // Add event listener to dismiss buttons
    document.querySelectorAll('.alert-dismiss-button').forEach(button => {
        button.addEventListener('click', function() {
            const alert = this.closest('.alert-component');
            if (alert) {
                alert.style.display = 'none';
            }
        });
    });
</script>
