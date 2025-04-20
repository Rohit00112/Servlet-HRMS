<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Employee Management" scope="request" />

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:body>
        <div class="flex justify-between items-center">
            <h1 class="text-2xl font-semibold text-gray-900">Employee Management</h1>
            <jsp:include page="/WEB-INF/components/button.jsp">
                <jsp:param name="type" value="primary" />
                <jsp:param name="text" value="Add Employee" />
                <jsp:param name="icon" value="add" />
                <jsp:param name="url" value="/admin/employees/add" />
            </jsp:include>
        </div>

        <!-- Search Form -->
        <jsp:include page="/WEB-INF/components/search-form.jsp">
            <jsp:param name="searchUrl" value="/admin/employees" />
            <jsp:param name="searchPlaceholder" value="Search employees..." />
        </jsp:include>

        <!-- Employee Table -->
        <jsp:include page="/WEB-INF/components/table.jsp">
            <jsp:param name="tableId" value="employeesTable" />
            <jsp:param name="items" value="employees" />
            <jsp:param name="emptyMessage" value="No employees found" />
            <jsp:param name="columns" value="Name,Email,Department,Designation,Join Date,Actions" />
            <jsp:param name="columnWidths" value="20%,20%,15%,15%,15%,15%" />
            <jsp:attribute name="tableContent">
                <c:forEach var="employee" items="${employees}">
                    <tr class="bg-white border-b hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${employee.name}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${employee.email}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${employee.departmentName}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${employee.designationTitle}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${employee.joinDate}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                            <a href="${pageContext.request.contextPath}/admin/employees/edit?id=${employee.id}" class="text-primary-600 hover:text-primary-900 mr-4">Edit</a>
                            <a href="#" onclick="confirmDelete(${employee.id})" class="text-red-600 hover:text-red-900">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </jsp:attribute>
        </jsp:include>
        <!-- Delete Confirmation Modal -->
        <div id="deleteModal" class="hidden fixed z-10 inset-0 overflow-y-auto">
            <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                    <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
                </div>
                <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
                <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                    <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                        <div class="sm:flex sm:items-start">
                            <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                                <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                                </svg>
                            </div>
                            <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                                <h3 class="text-lg leading-6 font-medium text-gray-900">Delete Employee</h3>
                                <div class="mt-2">
                                    <p class="text-sm text-gray-500">Are you sure you want to delete this employee? This action cannot be undone.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                        <a id="confirmDeleteBtn" href="#" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm">
                            Delete
                        </a>
                        <button type="button" onclick="closeModal()" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                            Cancel
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function confirmDelete(employeeId) {
                const modal = document.getElementById('deleteModal');
                const confirmBtn = document.getElementById('confirmDeleteBtn');

                modal.classList.remove('hidden');
                confirmBtn.href = '${pageContext.request.contextPath}/admin/employees/delete?id=' + employeeId;
            }

            function closeModal() {
                const modal = document.getElementById('deleteModal');
                modal.classList.add('hidden');
            }
        </script>
    </jsp:body>
</jsp:include>
