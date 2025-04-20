<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Name Field -->
<div class="sm:col-span-3">
    <label for="name" class="block text-sm font-medium text-gray-700">Full Name</label>
    <div class="mt-1">
        <input type="text" name="name" id="name" value="${employee.name}" required class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md">
    </div>
</div>

<!-- Email Field -->
<div class="sm:col-span-3">
    <label for="email" class="block text-sm font-medium text-gray-700">Email Address</label>
    <div class="mt-1">
        <input type="email" name="email" id="email" value="${employee.email}" required class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md">
    </div>
</div>

<!-- Department Field -->
<div class="sm:col-span-3">
    <label for="departmentId" class="block text-sm font-medium text-gray-700">Department</label>
    <div class="mt-1">
        <select id="departmentId" name="departmentId" required class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md">
            <option value="">Select Department</option>
            <c:forEach var="department" items="${departments}">
                <option value="${department.id}" ${employee.departmentId == department.id ? 'selected' : ''}>${department.name}</option>
            </c:forEach>
        </select>
    </div>
</div>

<!-- Designation Field -->
<div class="sm:col-span-3">
    <label for="designationId" class="block text-sm font-medium text-gray-700">Designation</label>
    <div class="mt-1">
        <select id="designationId" name="designationId" required class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md">
            <option value="">Select Designation</option>
            <c:forEach var="designation" items="${designations}">
                <option value="${designation.id}" ${employee.designationId == designation.id ? 'selected' : ''}>${designation.title}</option>
            </c:forEach>
        </select>
    </div>
</div>

<!-- Join Date Field -->
<div class="sm:col-span-3">
    <label for="joinDate" class="block text-sm font-medium text-gray-700">Join Date</label>
    <div class="mt-1">
        <input type="date" name="joinDate" id="joinDate" value="${employee.joinDate}" required class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md">
    </div>
</div>

<c:if test="${empty employee.userId}">
    <!-- Create User Account Field -->
    <div class="sm:col-span-3">
        <div class="flex items-center">
            <input id="createAccount" name="createAccount" type="checkbox" class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded">
            <label for="createAccount" class="ml-2 block text-sm text-gray-700">Create User Account</label>
        </div>
        <p class="mt-1 text-xs text-gray-500">This will create a login account for the employee and send credentials via email.</p>
    </div>
    
    <!-- User Role Field -->
    <div class="sm:col-span-3" id="roleFieldContainer" style="display: none;">
        <label for="role" class="block text-sm font-medium text-gray-700">User Role</label>
        <div class="mt-1">
            <select id="role" name="role" class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md">
                <option value="EMPLOYEE">Employee</option>
                <option value="HR">HR Manager</option>
            </select>
        </div>
    </div>
</c:if>

<c:if test="${not empty employee.userId}">
    <div class="sm:col-span-3">
        <div class="bg-blue-50 border-l-4 border-blue-400 p-4">
            <div class="flex">
                <div class="flex-shrink-0">
                    <svg class="h-5 w-5 text-blue-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
                    </svg>
                </div>
                <div class="ml-3">
                    <p class="text-sm text-blue-700">This employee already has a user account with role: <strong>${employee.role}</strong></p>
                </div>
            </div>
        </div>
    </div>
</c:if>

<script>
    // Toggle role field visibility based on checkbox
    document.getElementById('createAccount')?.addEventListener('change', function() {
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
</script>
