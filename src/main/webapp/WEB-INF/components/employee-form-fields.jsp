<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Name Field -->
<jsp:include page="/WEB-INF/components/form-field.jsp">
    <jsp:param name="type" value="text" />
    <jsp:param name="name" value="name" />
    <jsp:param name="label" value="Full Name" />
    <jsp:param name="value" value="${employee.name}" />
    <jsp:param name="required" value="true" />
    <jsp:param name="placeholder" value="Enter full name" />
    <jsp:param name="colSpan" value="3" />
</jsp:include>

<!-- Email Field -->
<jsp:include page="/WEB-INF/components/form-field.jsp">
    <jsp:param name="type" value="email" />
    <jsp:param name="name" value="email" />
    <jsp:param name="label" value="Email Address" />
    <jsp:param name="value" value="${employee.email}" />
    <jsp:param name="required" value="true" />
    <jsp:param name="placeholder" value="Enter email address" />
    <jsp:param name="colSpan" value="3" />
</jsp:include>

<!-- Department Field -->
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

<!-- Designation Field -->
<jsp:include page="/WEB-INF/components/form-field.jsp">
    <jsp:param name="type" value="select" />
    <jsp:param name="name" value="designationId" />
    <jsp:param name="label" value="Designation" />
    <jsp:param name="required" value="true" />
    <jsp:param name="colSpan" value="3" />
    <jsp:param name="options" value="designations" />
    <jsp:param name="optionValue" value="id" />
    <jsp:param name="optionText" value="title" />
    <jsp:param name="selectedValue" value="${employee.designationId}" />
</jsp:include>

<!-- Join Date Field -->
<jsp:include page="/WEB-INF/components/form-field.jsp">
    <jsp:param name="type" value="date" />
    <jsp:param name="name" value="joinDate" />
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
