<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 
Text Input:
<jsp:include page="/WEB-INF/components/form-field.jsp">
    <jsp:param name="type" value="text" />
    <jsp:param name="name" value="name" />
    <jsp:param name="label" value="Full Name" />
    <jsp:param name="value" value="${employee.name}" />
    <jsp:param name="required" value="true" />
    <jsp:param name="placeholder" value="Enter full name" />
    <jsp:param name="helpText" value="Enter your full name as it appears on official documents" />
    <jsp:param name="colSpan" value="3" />
</jsp:include>

Select Input:
<jsp:include page="/WEB-INF/components/form-field.jsp">
    <jsp:param name="type" value="select" />
    <jsp:param name="name" value="departmentId" />
    <jsp:param name="label" value="Department" />
    <jsp:param name="required" value="true" />
    <jsp:param name="colSpan" value="3" />
    <jsp:param name="options" value="departments" />
    <jsp:param name="optionValue" value="id" />
    <jsp:param name="optionText" value="name" />
    <jsp:param name="selectedValue" value="${employee.departmentId}" />
</jsp:include>

Checkbox Input:
<jsp:include page="/WEB-INF/components/form-field.jsp">
    <jsp:param name="type" value="checkbox" />
    <jsp:param name="name" value="createAccount" />
    <jsp:param name="label" value="Create User Account" />
    <jsp:param name="checked" value="${employee.userId != null}" />
    <jsp:param name="colSpan" value="3" />
</jsp:include>

Textarea Input:
<jsp:include page="/WEB-INF/components/form-field.jsp">
    <jsp:param name="type" value="textarea" />
    <jsp:param name="name" value="notes" />
    <jsp:param name="label" value="Notes" />
    <jsp:param name="value" value="${employee.notes}" />
    <jsp:param name="rows" value="3" />
    <jsp:param name="colSpan" value="6" />
</jsp:include>
--%>

<c:set var="colSpan" value="${param.colSpan != null ? param.colSpan : '3'}" />
<c:set var="required" value="${param.required == 'true' ? 'required' : ''}" />
<c:set var="readonly" value="${param.readonly == 'true' ? 'readonly' : ''}" />
<c:set var="disabled" value="${param.disabled == 'true' ? 'disabled' : ''}" />
<c:set var="checked" value="${param.checked == 'true' ? 'checked' : ''}" />
<c:set var="placeholder" value="${not empty param.placeholder ? param.placeholder : ''}" />
<c:set var="value" value="${not empty param.value ? param.value : ''}" />
<c:set var="rows" value="${not empty param.rows ? param.rows : '3'}" />
<c:set var="baseClass" value="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" />
<c:set var="readonlyClass" value="${param.readonly == 'true' ? 'bg-gray-100' : ''}" />

<div class="sm:col-span-${colSpan}">
    <c:choose>
        <c:when test="${param.type == 'checkbox'}">
            <div class="flex items-center">
                <input type="checkbox" id="${param.name}" name="${param.name}" ${checked} ${disabled} class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded">
                <label for="${param.name}" class="ml-2 block text-sm font-medium text-gray-700">${param.label}</label>
            </div>
            <c:if test="${not empty param.helpText}">
                <p class="mt-1 text-sm text-gray-500">${param.helpText}</p>
            </c:if>
        </c:when>
        <c:otherwise>
            <label for="${param.name}" class="block text-sm font-medium text-gray-700">${param.label}</label>
            <div class="mt-1">
                <c:choose>
                    <c:when test="${param.type == 'textarea'}">
                        <textarea id="${param.name}" name="${param.name}" rows="${rows}" ${required} ${readonly} ${disabled} placeholder="${placeholder}" class="${baseClass} ${readonlyClass}">${value}</textarea>
                    </c:when>
                    <c:when test="${param.type == 'select'}">
                        <select id="${param.name}" name="${param.name}" ${required} ${disabled} class="${baseClass}">
                            <option value="">Select ${param.label}</option>
                            <c:forEach var="option" items="${requestScope[param.options]}">
                                <option value="${option[param.optionValue]}" ${option[param.optionValue] == param.selectedValue ? 'selected' : ''}>${option[param.optionText]}</option>
                            </c:forEach>
                        </select>
                    </c:when>
                    <c:otherwise>
                        <input type="${param.type}" id="${param.name}" name="${param.name}" value="${value}" ${required} ${readonly} ${disabled} placeholder="${placeholder}" class="${baseClass} ${readonlyClass}">
                    </c:otherwise>
                </c:choose>
            </div>
            <c:if test="${not empty param.helpText}">
                <p class="mt-1 text-sm text-gray-500">${param.helpText}</p>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>
