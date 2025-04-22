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
<c:set var="checked" value="${param.checked eq 'true' ? 'checked' : ''}" />
<c:if test="${param.checked eq true}"><c:set var="checked" value="checked" /></c:if>
<c:set var="placeholder" value="${not empty param.placeholder ? param.placeholder : ''}" />
<c:set var="value" value="${not empty param.value ? param.value : ''}" />
<c:set var="rows" value="${not empty param.rows ? param.rows : '3'}" />
<c:set var="baseClass" value="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700" />
<c:set var="readonlyClass" value="${param.readonly == 'true' ? 'bg-gray-100 dark:bg-gray-600' : ''}" />
<c:set var="selectClass" value="appearance-none bg-white dark:bg-gray-700 pr-10 cursor-pointer" />
<c:set var="checkboxClass" value="h-5 w-5 text-primary-600 focus:ring-primary-500 focus:ring-offset-1 border-gray-300 dark:border-gray-600 rounded transition-all duration-200 ease-in-out cursor-pointer" />

<div class="sm:col-span-${colSpan}">
    <c:choose>
        <c:when test="${param.type == 'checkbox'}">
            <!-- Debug info -->
            <div class="text-xs text-gray-500 mb-1">
                Checked param: ${param.checked}
                Checked value: ${checked}
            </div>
            <div class="flex items-center">
                <input type="checkbox" id="${param.name}" name="${param.name}" ${checked} ${disabled} class="${checkboxClass}">
                <label for="${param.name}" class="ml-3 block text-sm font-medium text-gray-700 dark:text-gray-300 cursor-pointer">${param.label}</label>
            </div>
            <c:if test="${not empty param.helpText}">
                <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">${param.helpText}</p>
            </c:if>
        </c:when>
        <c:otherwise>
            <label for="${param.name}" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">${param.label}</label>
            <div class="relative">
                <c:choose>
                    <c:when test="${param.type == 'textarea'}">
                        <textarea id="${param.name}" name="${param.name}" rows="${rows}" ${required} ${readonly} ${disabled} placeholder="${placeholder}" class="${baseClass} ${readonlyClass} resize-none">${value}</textarea>
                    </c:when>
                    <c:when test="${param.type == 'select'}">
                        <div class="relative">
                            <!-- Debug info -->
                            <div class="text-xs text-gray-500 mb-1">
                                Options: ${not empty requestScope[param.options] ? 'Available' : 'Not Available'}
                                Selected: ${param.selectedValue}
                            </div>
                            <select id="${param.name}" name="${param.name}" ${required} ${disabled} class="${baseClass} ${selectClass}">
                                <option value="">Select ${param.label}</option>
                                <c:if test="${not empty requestScope[param.options]}">
                                    <c:forEach var="option" items="${requestScope[param.options]}">
                                        <option value="${option[param.optionValue]}" ${option[param.optionValue] eq param.selectedValue ? 'selected' : ''}>${option[param.optionText]}</option>
                                    </c:forEach>
                                </c:if>
                                <!-- Fallback options if the list is empty -->
                                <c:if test="${empty requestScope[param.options] && param.name == 'theme'}">
                                    <option value="light" ${param.selectedValue eq 'light' ? 'selected' : ''}>Light Mode</option>
                                    <option value="dark" ${param.selectedValue eq 'dark' ? 'selected' : ''}>Dark Mode</option>
                                    <option value="system" ${param.selectedValue eq 'system' ? 'selected' : ''}>System Default</option>
                                </c:if>
                            </select>
                            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-gray-500 dark:text-gray-400">
                                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                    <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                                </svg>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${param.type == 'email'}">
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                            <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z" />
                                            <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z" />
                                        </svg>
                                    </div>
                                    <input type="email" id="${param.name}" name="${param.name}" value="${value}" ${required} ${readonly} ${disabled} placeholder="${placeholder}" class="${baseClass} ${readonlyClass} pl-10">
                                </div>
                            </c:when>
                            <c:when test="${param.type == 'password'}">
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                            <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                                        </svg>
                                    </div>
                                    <input type="password" id="${param.name}" name="${param.name}" value="${value}" ${required} ${readonly} ${disabled} placeholder="${placeholder}" class="${baseClass} ${readonlyClass} pl-10">
                                </div>
                            </c:when>
                            <c:when test="${param.type == 'search'}">
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                            <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
                                        </svg>
                                    </div>
                                    <input type="search" id="${param.name}" name="${param.name}" value="${value}" ${required} ${readonly} ${disabled} placeholder="${placeholder}" class="${baseClass} ${readonlyClass} pl-10">
                                </div>
                            </c:when>
                            <c:when test="${param.type == 'tel'}">
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                            <path d="M2 3a1 1 0 011-1h2.153a1 1 0 01.986.836l.74 4.435a1 1 0 01-.54 1.06l-1.548.773a11.037 11.037 0 006.105 6.105l.774-1.548a1 1 0 011.059-.54l4.435.74a1 1 0 01.836.986V17a1 1 0 01-1 1h-2C7.82 18 2 12.18 2 5V3z" />
                                        </svg>
                                    </div>
                                    <input type="tel" id="${param.name}" name="${param.name}" value="${value}" ${required} ${readonly} ${disabled} placeholder="${placeholder}" class="${baseClass} ${readonlyClass} pl-10">
                                </div>
                            </c:when>
                            <c:when test="${param.type == 'date'}">
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                            <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd" />
                                        </svg>
                                    </div>
                                    <input type="date" id="${param.name}" name="${param.name}" value="${value}" ${required} ${readonly} ${disabled} placeholder="${placeholder}" class="${baseClass} ${readonlyClass} pl-10">
                                </div>
                            </c:when>
                            <c:otherwise>
                                <input type="${param.type}" id="${param.name}" name="${param.name}" value="${value}" ${required} ${readonly} ${disabled} placeholder="${placeholder}" class="${baseClass} ${readonlyClass}">
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>
            <c:if test="${not empty param.helpText}">
                <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">${param.helpText}</p>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>
