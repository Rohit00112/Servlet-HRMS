<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Form Component Usage:

<jsp:include page="/WEB-INF/components/form.jsp">
    <jsp:param name="formId" value="myForm" />
    <jsp:param name="formAction" value="/path/to/submit" />
    <jsp:param name="formMethod" value="post" />
    <jsp:param name="formTitle" value="Form Title" />
    <jsp:param name="formDescription" value="Optional form description" />
    <jsp:param name="submitButtonText" value="Submit" />
    <jsp:param name="cancelButtonUrl" value="/path/to/cancel" />
    <jsp:param name="cancelButtonText" value="Cancel" />
    <jsp:param name="columns" value="1|2|3" />
</jsp:include>

Then add your form fields after including the component:

<div class="col-span-1 sm:col-span-2">
    <label for="name" class="block text-sm font-medium text-gray-700">Name</label>
    <input type="text" name="name" id="name" class="mt-1 focus:ring-primary-500 focus:border-primary-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
</div>
--%>

<c:set var="formId" value="${param.formId}" />
<c:set var="formAction" value="${param.formAction}" />
<c:set var="formMethod" value="${param.formMethod}" />
<c:set var="formTitle" value="${param.formTitle}" />
<c:set var="formDescription" value="${param.formDescription}" />
<c:set var="submitButtonText" value="${param.submitButtonText}" />
<c:set var="cancelButtonUrl" value="${param.cancelButtonUrl}" />
<c:set var="cancelButtonText" value="${param.cancelButtonText}" />
<c:set var="columns" value="${param.columns}" />

<%-- Default values --%>
<c:if test="${empty formId}">
    <c:set var="formId" value="form-${System.currentTimeMillis()}" />
</c:if>
<c:if test="${empty formMethod}">
    <c:set var="formMethod" value="post" />
</c:if>
<c:if test="${empty submitButtonText}">
    <c:set var="submitButtonText" value="Submit" />
</c:if>
<c:if test="${empty cancelButtonText}">
    <c:set var="cancelButtonText" value="Cancel" />
</c:if>
<c:if test="${empty columns}">
    <c:set var="columns" value="1" />
</c:if>

<%-- Grid columns class based on columns parameter --%>
<c:choose>
    <c:when test="${columns eq '2'}">
        <c:set var="gridClass" value="grid-cols-1 sm:grid-cols-2" />
    </c:when>
    <c:when test="${columns eq '3'}">
        <c:set var="gridClass" value="grid-cols-1 sm:grid-cols-2 lg:grid-cols-3" />
    </c:when>
    <c:otherwise>
        <c:set var="gridClass" value="grid-cols-1" />
    </c:otherwise>
</c:choose>

<div class="bg-white shadow overflow-hidden sm:rounded-lg">
    <c:if test="${not empty formTitle}">
        <div class="px-4 py-5 sm:px-6">
            <h3 class="text-lg leading-6 font-medium text-gray-900">${formTitle}</h3>
            <c:if test="${not empty formDescription}">
                <p class="mt-1 max-w-2xl text-sm text-gray-500">${formDescription}</p>
            </c:if>
        </div>
    </c:if>
    
    <div class="border-t border-gray-200 px-4 py-5 sm:p-6">
        <form id="${formId}" action="${pageContext.request.contextPath}${formAction}" method="${formMethod}" class="space-y-6">
            <div class="grid ${gridClass} gap-6">
                <%-- Form fields will be provided by the user after including this component --%>
                <jsp:doBody />
            </div>
            
            <div class="flex justify-end pt-5">
                <c:if test="${not empty cancelButtonUrl}">
                    <a href="${pageContext.request.contextPath}${cancelButtonUrl}" class="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 mr-3">
                        ${cancelButtonText}
                    </a>
                </c:if>
                <button type="submit" class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                    ${submitButtonText}
                </button>
            </div>
        </form>
    </div>
</div>
