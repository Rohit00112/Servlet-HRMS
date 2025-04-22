<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Modal Component Usage:

<jsp:include page="/WEB-INF/components/modal.jsp">
    <jsp:param name="modalId" value="myModal" />
    <jsp:param name="title" value="Modal Title" />
    <jsp:param name="size" value="sm|md|lg|xl" />
    <jsp:param name="type" value="info|success|warning|danger" />
    <jsp:param name="primaryButtonText" value="Confirm" />
    <jsp:param name="primaryButtonAction" value="confirmAction()" />
    <jsp:param name="secondaryButtonText" value="Cancel" />
    <jsp:param name="secondaryButtonAction" value="closeModal('myModal')" />
    <jsp:param name="content" value="<p>Modal content goes here</p>" />
</jsp:include>
--%>

<c:set var="modalId" value="${param.modalId}" />
<c:set var="modalTitle" value="${param.title}" />
<c:set var="modalSize" value="${param.size}" />
<c:set var="modalType" value="${param.type}" />
<c:set var="primaryButtonText" value="${param.primaryButtonText}" />
<c:set var="primaryButtonAction" value="${param.primaryButtonAction}" />
<c:set var="secondaryButtonText" value="${param.secondaryButtonText}" />
<c:set var="secondaryButtonAction" value="${param.secondaryButtonAction}" />
<c:set var="modalContent" value="${param.content}" />

<%-- Default values --%>
<c:if test="${empty modalId}">
    <c:set var="modalId" value="modal-${System.currentTimeMillis()}" />
</c:if>
<c:if test="${empty modalSize}">
    <c:set var="modalSize" value="md" />
</c:if>
<c:if test="${empty modalType}">
    <c:set var="modalType" value="info" />
</c:if>
<c:if test="${empty secondaryButtonText}">
    <c:set var="secondaryButtonText" value="Cancel" />
</c:if>
<c:if test="${empty secondaryButtonAction}">
    <c:set var="secondaryButtonAction" value="closeModal('${modalId}')" />
</c:if>

<%-- Modal size class --%>
<c:choose>
    <c:when test="${modalSize eq 'sm'}">
        <c:set var="sizeClass" value="sm:max-w-sm" />
    </c:when>
    <c:when test="${modalSize eq 'lg'}">
        <c:set var="sizeClass" value="sm:max-w-lg" />
    </c:when>
    <c:when test="${modalSize eq 'xl'}">
        <c:set var="sizeClass" value="sm:max-w-xl" />
    </c:when>
    <c:otherwise>
        <c:set var="sizeClass" value="sm:max-w-md" />
    </c:otherwise>
</c:choose>

<%-- Modal type styles --%>
<c:choose>
    <c:when test="${modalType eq 'success'}">
        <c:set var="iconBgClass" value="bg-green-100 dark:bg-green-900/50" />
        <c:set var="iconColorClass" value="text-green-600 dark:text-green-300" />
        <c:set var="primaryButtonClass" value="bg-green-600 hover:bg-green-700 focus:ring-green-500" />
        <c:set var="iconSvg">
            <svg class="h-6 w-6 ${iconColorClass}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${modalType eq 'warning'}">
        <c:set var="iconBgClass" value="bg-yellow-100 dark:bg-yellow-900/50" />
        <c:set var="iconColorClass" value="text-yellow-600 dark:text-yellow-300" />
        <c:set var="primaryButtonClass" value="bg-yellow-600 hover:bg-yellow-700 focus:ring-yellow-500" />
        <c:set var="iconSvg">
            <svg class="h-6 w-6 ${iconColorClass}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
        </c:set>
    </c:when>
    <c:when test="${modalType eq 'danger'}">
        <c:set var="iconBgClass" value="bg-red-100 dark:bg-red-900/50" />
        <c:set var="iconColorClass" value="text-red-600 dark:text-red-300" />
        <c:set var="primaryButtonClass" value="bg-red-600 hover:bg-red-700 focus:ring-red-500" />
        <c:set var="iconSvg">
            <svg class="h-6 w-6 ${iconColorClass}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
        </c:set>
    </c:when>
    <c:otherwise>
        <c:set var="iconBgClass" value="bg-blue-100 dark:bg-blue-900/50" />
        <c:set var="iconColorClass" value="text-blue-600 dark:text-blue-300" />
        <c:set var="primaryButtonClass" value="bg-primary-600 hover:bg-primary-700 focus:ring-primary-500" />
        <c:set var="iconSvg">
            <svg class="h-6 w-6 ${iconColorClass}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
        </c:set>
    </c:otherwise>
</c:choose>

<div id="${modalId}" class="hidden fixed z-10 inset-0 overflow-y-auto" aria-labelledby="${modalId}-title" role="dialog" aria-modal="true">
    <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <!-- Background overlay -->
        <div class="fixed inset-0 bg-gray-500 dark:bg-gray-800 bg-opacity-75 dark:bg-opacity-75 transition-opacity" aria-hidden="true"></div>

        <!-- Center modal -->
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <!-- Modal panel -->
        <div class="inline-block align-bottom bg-white dark:bg-gray-800 rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle ${sizeClass} sm:w-full">
            <div class="bg-white dark:bg-gray-800 px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                <div class="sm:flex sm:items-start">
                    <c:if test="${not empty iconSvg}">
                        <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full ${iconBgClass} sm:mx-0 sm:h-10 sm:w-10">
                            ${iconSvg}
                        </div>
                    </c:if>
                    <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left flex-1">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-white" id="${modalId}-title">
                            ${modalTitle}
                        </h3>
                        <div class="mt-2">
                            ${modalContent}
                        </div>
                    </div>
                </div>
            </div>
            <div class="bg-gray-50 dark:bg-gray-700 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                <c:if test="${not empty primaryButtonText}">
                    <button type="button"
                            class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 ${primaryButtonClass} text-base font-medium text-white focus:outline-none focus:ring-2 focus:ring-offset-2 sm:ml-3 sm:w-auto sm:text-sm"
                            onclick="${primaryButtonAction}">
                        ${primaryButtonText}
                    </button>
                </c:if>
                <button type="button"
                        class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 dark:border-gray-600 shadow-sm px-4 py-2 bg-white dark:bg-gray-700 text-base font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
                        onclick="${secondaryButtonAction}">
                    ${secondaryButtonText}
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // Function to open the modal
    function openModal(modalId) {
        document.getElementById(modalId).classList.remove('hidden');
    }

    // Function to close the modal
    function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
    }
</script>
