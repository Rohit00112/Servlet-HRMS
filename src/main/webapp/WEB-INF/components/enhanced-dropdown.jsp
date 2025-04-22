<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Enhanced Dropdown Component
Parameters:
- id: The ID of the select element
- name: The name of the select element
- label: The label text
- helpText: Optional help text to display below the dropdown
- required: Whether the field is required (true/false)
- colSpan: Number of columns to span in a grid (1-6)
- options: The collection of options to display
- optionValue: The property to use for option values
- optionText: The property to use for option display text
- selectedValue: The currently selected value
- placeholder: Optional placeholder text

NOTE: This component can be used in two ways:
1. By providing the options as a request attribute and specifying optionValue and optionText
2. By directly using the component without options and adding the option tags in your JSP

Do NOT add option tags directly inside the jsp:include tag as it will cause errors.
Instead, use the component directly in your JSP as shown in the examples.
--%>

<div class="sm:col-span-${param.colSpan != null ? param.colSpan : '6'}">
    <label for="${param.id}" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">${param.label} ${param.required == 'true' ? '<span class="text-red-500">*</span>' : ''}</label>
    <div class="relative">
        <select
            id="${param.id}"
            name="${param.name}"
            class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700 appearance-none bg-white dark:bg-gray-700 pr-10 cursor-pointer"
            ${param.required == 'true' ? 'required' : ''}
        >
            <c:if test="${not empty param.placeholder}">
                <option value="" ${empty param.selectedValue ? 'selected' : ''}>${param.placeholder}</option>
            </c:if>

            <c:if test="${not empty options}">
                <c:forEach var="option" items="${options}">
                    <c:choose>
                        <c:when test="${not empty param.optionValue && not empty param.optionText}">
                            <c:set var="value" value="${option[param.optionValue]}" />
                            <c:set var="text" value="${option[param.optionText]}" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="value" value="${option}" />
                            <c:set var="text" value="${option}" />
                        </c:otherwise>
                    </c:choose>
                    <option value="${value}" ${value eq param.selectedValue ? 'selected' : ''}>${text}</option>
                </c:forEach>
            </c:if>
        </select>
        <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-gray-500 dark:text-gray-400">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
        </div>
    </div>
    <c:if test="${not empty param.helpText}">
        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">${param.helpText}</p>
    </c:if>
</div>
