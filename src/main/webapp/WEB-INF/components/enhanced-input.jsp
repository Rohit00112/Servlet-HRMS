<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Enhanced Input Component
Parameters:
- id: The ID of the input element
- name: The name of the input element
- type: The type of input (text, email, password, number, date, textarea, etc.)
- label: The label text
- value: The current value of the input
- placeholder: Optional placeholder text
- helpText: Optional help text to display below the input
- required: Whether the field is required (true/false)
- colSpan: Number of columns to span in a grid (1-6)
- min: Minimum value (for number inputs)
- max: Maximum value (for number inputs)
- step: Step value (for number inputs)
- pattern: Validation pattern
- readonly: Whether the field is readonly (true/false)
- disabled: Whether the field is disabled (true/false)
- rows: Number of rows for textarea (default: 4)
--%>

<div class="sm:col-span-${param.colSpan != null ? param.colSpan : '6'}">
    <label for="${param.id}" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">${param.label} ${param.required == 'true' ? '<span class="text-red-500">*</span>' : ''}</label>
    <div class="relative">
        <c:choose>
            <c:when test="${param.type == 'textarea'}">
                <textarea
                    id="${param.id}"
                    name="${param.name}"
                    placeholder="${param.placeholder}"
                    rows="${param.rows != null ? param.rows : '4'}"
                    class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700 resize-none"
                    ${param.required == 'true' ? 'required' : ''}
                    ${param.readonly == 'true' ? 'readonly' : ''}
                    ${param.disabled == 'true' ? 'disabled' : ''}>${param.value}</textarea>
            </c:when>
            <c:otherwise>
                <input
                    type="${param.type != null ? param.type : 'text'}"
                    id="${param.id}"
                    name="${param.name}"
                    value="${param.value}"
                    placeholder="${param.placeholder}"
                    class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700"
                    ${param.required == 'true' ? 'required' : ''}
                    ${param.min != null ? 'min="'.concat(param.min).concat('"') : ''}
                    ${param.max != null ? 'max="'.concat(param.max).concat('"') : ''}
                    ${param.step != null ? 'step="'.concat(param.step).concat('"') : ''}
                    ${param.pattern != null ? 'pattern="'.concat(param.pattern).concat('"') : ''}
                    ${param.readonly == 'true' ? 'readonly' : ''}
                    ${param.disabled == 'true' ? 'disabled' : ''}
                />
            </c:otherwise>
        </c:choose>
        <c:if test="${param.type == 'date'}">
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-gray-500 dark:text-gray-400">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd" />
                </svg>
            </div>
        </c:if>
    </div>
    <c:if test="${not empty param.helpText}">
        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">${param.helpText}</p>
    </c:if>
</div>
