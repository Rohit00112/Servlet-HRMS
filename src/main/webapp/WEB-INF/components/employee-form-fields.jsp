<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Name Field -->
<jsp:include page="/WEB-INF/components/enhanced-input.jsp">
    <jsp:param name="id" value="name" />
    <jsp:param name="name" value="name" />
    <jsp:param name="type" value="text" />
    <jsp:param name="label" value="Full Name" />
    <jsp:param name="value" value="${employee.name}" />
    <jsp:param name="required" value="true" />
    <jsp:param name="placeholder" value="Enter full name" />
    <jsp:param name="colSpan" value="3" />
</jsp:include>

<!-- Email Field -->
<jsp:include page="/WEB-INF/components/enhanced-input.jsp">
    <jsp:param name="id" value="email" />
    <jsp:param name="name" value="email" />
    <jsp:param name="type" value="email" />
    <jsp:param name="label" value="Email Address" />
    <jsp:param name="value" value="${employee.email}" />
    <jsp:param name="required" value="true" />
    <jsp:param name="placeholder" value="Enter email address" />
    <jsp:param name="colSpan" value="3" />
</jsp:include>

<!-- Department Field -->
<div class="sm:col-span-3">
    <label for="departmentId" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Department <span class="text-red-500">*</span></label>
    <div class="relative">
        <select
            id="departmentId"
            name="departmentId"
            class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700 appearance-none bg-white dark:bg-gray-700 pr-10 cursor-pointer"
            required
        >
            <option value="">Select Department</option>
            <c:forEach var="department" items="${departments}">
                <option value="${department.id}" ${department.id eq employee.departmentId ? 'selected' : ''}>${department.name}</option>
            </c:forEach>
        </select>
        <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-gray-500 dark:text-gray-400">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
        </div>
    </div>
</div>

<!-- Designation Field -->
<div class="sm:col-span-3">
    <label for="designationId" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Designation <span class="text-red-500">*</span></label>
    <div class="relative">
        <select
            id="designationId"
            name="designationId"
            class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700 appearance-none bg-white dark:bg-gray-700 pr-10 cursor-pointer"
            required
        >
            <option value="">Select Designation</option>
            <c:forEach var="designation" items="${designations}">
                <option value="${designation.id}" ${designation.id eq employee.designationId ? 'selected' : ''}>${designation.title}</option>
            </c:forEach>
        </select>
        <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-gray-500 dark:text-gray-400">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
        </div>
    </div>
</div>

<!-- Join Date Field -->
<jsp:include page="/WEB-INF/components/enhanced-input.jsp">
    <jsp:param name="id" value="joinDate" />
    <jsp:param name="name" value="joinDate" />
    <jsp:param name="type" value="date" />
    <jsp:param name="label" value="Join Date" />
    <jsp:param name="value" value="${employee.joinDate}" />
    <jsp:param name="required" value="true" />
    <jsp:param name="colSpan" value="3" />
</jsp:include>

<c:if test="${empty employee.userId}">
    <!-- Create User Account Field -->
    <jsp:include page="/WEB-INF/components/form-field.jsp">
        <jsp:param name="type" value="checkbox" />
        <jsp:param name="name" value="createAccount" />
        <jsp:param name="label" value="Create User Account" />
        <jsp:param name="helpText" value="This will create a login account for the employee and send credentials via email." />
        <jsp:param name="colSpan" value="3" />
    </jsp:include>

    <!-- User Role Field -->
    <div class="sm:col-span-3" id="roleFieldContainer" style="display: none;">
        <jsp:include page="/WEB-INF/components/form-field.jsp">
            <jsp:param name="type" value="select" />
            <jsp:param name="name" value="role" />
            <jsp:param name="label" value="User Role" />
            <jsp:param name="colSpan" value="3" />
            <jsp:param name="options" value="[{\"value\":\"EMPLOYEE\",\"text\":\"Employee\"},{\"value\":\"HR\",\"text\":\"HR Manager\"}]" />
        </jsp:include>
    </div>
</c:if>

<c:if test="${not empty employee.userId}">
    <div class="sm:col-span-3">
        <div class="bg-blue-50 dark:bg-blue-900/30 border-l-4 border-blue-400 dark:border-blue-600 p-4 rounded-lg shadow-sm">
            <div class="flex">
                <div class="flex-shrink-0">
                    <svg class="h-5 w-5 text-blue-400 dark:text-blue-300" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
                    </svg>
                </div>
                <div class="ml-3">
                    <p class="text-sm text-blue-700 dark:text-blue-300">This employee already has a user account with role: <strong>${employee.role}</strong></p>
                </div>
            </div>
        </div>
    </div>
</c:if>

<script>
    // Toggle role field visibility based on checkbox
    document.addEventListener('DOMContentLoaded', function() {
        const createAccountCheckbox = document.getElementById('createAccount');
        if (createAccountCheckbox) {
            createAccountCheckbox.addEventListener('change', function() {
                const roleFieldContainer = document.getElementById('roleFieldContainer');
                const roleField = document.getElementById('role');

                if (this.checked) {
                    roleFieldContainer.style.display = 'block';
                    roleField.setAttribute('required', 'required');
                } else {
                    roleFieldContainer.style.display = 'none';
                    roleField.removeAttribute('required');
                }
            });
        }
    });
</script>
