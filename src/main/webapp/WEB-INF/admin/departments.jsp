<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Department Management" scope="request" />

<c:set var="mainContent">
    <div class="flex justify-between items-center">
        <h1 class="text-2xl font-semibold text-gray-900 dark:text-white">Department Management</h1>
        <button onclick="openModal('addDepartmentModal')" class="inline-flex items-center px-5 py-3 border border-transparent text-sm font-medium rounded-lg shadow-md text-white bg-gradient-to-r from-primary-500 to-primary-600 hover:from-primary-600 hover:to-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 dark:hover:text-white transform transition-all duration-200 hover:translate-y-[-1px] hover:shadow-lg active:translate-y-[1px]">
            <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
            </svg>
            Add Department
        </button>
    </div>

    <!-- Success/Error Messages -->
    <jsp:include page="/WEB-INF/components/message.jsp">
        <jsp:param name="successMessage" value="${successMessage}" />
        <jsp:param name="errorMessage" value="${errorMessage}" />
        <jsp:param name="infoMessage" value="${infoMessage}" />
        <jsp:param name="warningMessage" value="${warningMessage}" />
    </jsp:include>

    <!-- Departments Table -->
    <div class="mt-6 bg-white dark:bg-gray-800 shadow-lg overflow-hidden sm:rounded-lg border border-gray-200 dark:border-gray-700">
        <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
            <thead class="bg-gray-50 dark:bg-gray-700">
                <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">ID</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Department Name</th>
                    <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Actions</th>
                </tr>
            </thead>
            <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                <c:forEach var="department" items="${departments}">
                    <tr class="hover:bg-gray-50 dark:hover:bg-gray-700">
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">${department.id}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white">${department.name}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                            <button onclick="openEditModal(${department.id}, '${department.name}')" class="text-primary-600 hover:text-primary-900 dark:text-primary-400 dark:hover:text-primary-300 mr-3">Edit</button>
                            <button onclick="openDeleteModal(${department.id}, '${department.name}')" class="text-red-600 hover:text-red-900 dark:text-red-400 dark:hover:text-red-300">Delete</button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty departments}">
                    <tr>
                        <td colspan="3" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300 text-center">No departments found</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Add Department Modal -->
    <jsp:include page="/WEB-INF/components/modal.jsp">
        <jsp:param name="modalId" value="addDepartmentModal" />
        <jsp:param name="title" value="Add New Department" />
        <jsp:param name="size" value="md" />
        <jsp:param name="type" value="info" />
        <jsp:param name="primaryButtonText" value="Add Department" />
        <jsp:param name="primaryButtonAction" value="document.getElementById('addDepartmentForm').submit()" />
        <jsp:param name="secondaryButtonText" value="Cancel" />
        <jsp:param name="secondaryButtonAction" value="closeModal('addDepartmentModal')" />
        <jsp:param name="content" value="
            <form id='addDepartmentForm' action='${pageContext.request.contextPath}/admin/departments' method='post'>
                <input type='hidden' name='action' value='add'>
                <div class='mt-2'>
                    <label for='name' class='block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2'>Department Name</label>
                    <input type='text' name='name' id='name' required class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700'>
                </div>
            </form>
        " />
    </jsp:include>

    <!-- Edit Department Modal -->
    <jsp:include page="/WEB-INF/components/modal.jsp">
        <jsp:param name="modalId" value="editDepartmentModal" />
        <jsp:param name="title" value="Edit Department" />
        <jsp:param name="size" value="md" />
        <jsp:param name="type" value="info" />
        <jsp:param name="primaryButtonText" value="Update Department" />
        <jsp:param name="primaryButtonAction" value="document.getElementById('editDepartmentForm').submit()" />
        <jsp:param name="secondaryButtonText" value="Cancel" />
        <jsp:param name="secondaryButtonAction" value="closeModal('editDepartmentModal')" />
        <jsp:param name="content" value="
            <form id='editDepartmentForm' action='${pageContext.request.contextPath}/admin/departments' method='post'>
                <input type='hidden' name='action' value='update'>
                <input type='hidden' name='id' id='editDepartmentId'>
                <div class='mt-2'>
                    <label for='editName' class='block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2'>Department Name</label>
                    <input type='text' name='name' id='editName' required class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700'>
                </div>
            </form>
        " />
    </jsp:include>

    <!-- Delete Department Modal -->
    <jsp:include page="/WEB-INF/components/modal.jsp">
        <jsp:param name="modalId" value="deleteDepartmentModal" />
        <jsp:param name="title" value="Delete Department" />
        <jsp:param name="size" value="md" />
        <jsp:param name="type" value="danger" />
        <jsp:param name="primaryButtonText" value="Delete" />
        <jsp:param name="primaryButtonAction" value="document.getElementById('deleteDepartmentForm').submit()" />
        <jsp:param name="secondaryButtonText" value="Cancel" />
        <jsp:param name="secondaryButtonAction" value="closeModal('deleteDepartmentModal')" />
        <jsp:param name="content" value="
            <form id='deleteDepartmentForm' action='${pageContext.request.contextPath}/admin/departments' method='post'>
                <input type='hidden' name='action' value='delete'>
                <input type='hidden' name='id' id='deleteDepartmentId'>
                <p class='text-sm text-gray-500 dark:text-gray-400'>Are you sure you want to delete the department <span id='deleteDepartmentName' class='font-medium'></span>? This action cannot be undone.</p>
            </form>
        " />
    </jsp:include>

    <script>
        function openEditModal(id, name) {
            document.getElementById('editDepartmentId').value = id;
            document.getElementById('editName').value = name;
            openModal('editDepartmentModal');
        }

        function openDeleteModal(id, name) {
            document.getElementById('deleteDepartmentId').value = id;
            document.getElementById('deleteDepartmentName').textContent = name;
            openModal('deleteDepartmentModal');
        }
    </script>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="mainContent" value="${mainContent}" />
</jsp:include>
