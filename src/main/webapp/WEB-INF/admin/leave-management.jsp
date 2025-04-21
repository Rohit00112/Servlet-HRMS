<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Leave Management" scope="request" />

<c:set var="mainContent">

                    <!-- Alert Messages -->
                    <c:if test="${not empty sessionScope.successMessage}">
                        <jsp:include page="/WEB-INF/components/alert.jsp">
                            <jsp:param name="type" value="success" />
                            <jsp:param name="message" value="${sessionScope.successMessage}" />
                            <jsp:param name="dismissible" value="true" />
                        </jsp:include>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <jsp:include page="/WEB-INF/components/alert.jsp">
                            <jsp:param name="type" value="error" />
                            <jsp:param name="message" value="${sessionScope.errorMessage}" />
                            <jsp:param name="dismissible" value="true" />
                        </jsp:include>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>

                    <!-- Leave Summary Cards -->
                    <div class="mt-6 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
                        <!-- Pending Leaves Card -->
                        <div class="backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 border border-blue-100/50 overflow-hidden shadow rounded-lg">
                            <div class="p-5">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 bg-yellow-100 rounded-md p-3">
                                        <svg class="h-6 w-6 text-yellow-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                    </div>
                                    <div class="ml-5 w-0 flex-1">
                                        <dl>
                                            <dt class="text-sm font-medium text-gray-500 truncate">
                                                Pending Leaves
                                            </dt>
                                            <dd>
                                                <div class="text-lg font-medium text-gray-900">${pendingCount}</div>
                                            </dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="bg-gray-50 px-5 py-3">
                                <div class="text-sm">
                                    <a href="#pending-section" class="font-medium text-primary-600 hover:text-primary-900">View all</a>
                                </div>
                            </div>
                        </div>

                        <!-- Total Leaves Card -->
                        <div class="backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 border border-blue-100/50 overflow-hidden shadow rounded-lg">
                            <div class="p-5">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 bg-blue-100 rounded-md p-3">
                                        <svg class="h-6 w-6 text-blue-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                        </svg>
                                    </div>
                                    <div class="ml-5 w-0 flex-1">
                                        <dl>
                                            <dt class="text-sm font-medium text-gray-500 truncate">
                                                Total Leave Applications
                                            </dt>
                                            <dd>
                                                <div class="text-lg font-medium text-gray-900">${leaves.size()}</div>
                                            </dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="bg-gray-50 px-5 py-3">
                                <div class="text-sm">
                                    <a href="#all-section" class="font-medium text-primary-600 hover:text-primary-900">View all</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Pending Leave Applications Section -->
                    <div class="mt-8 max-w-7xl mx-auto px-4 sm:px-6 md:px-8" id="pending-section">
                        <h2 class="text-lg font-medium text-gray-900">Pending Leave Applications</h2>
                        <div class="mt-4 backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 border border-blue-100/50 shadow overflow-hidden sm:rounded-lg">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Employee
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Applied Date
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Leave Period
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Duration
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Reason
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Actions
                                        </th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:set var="pendingFound" value="false" />
                                    <c:forEach var="leave" items="${leaves}">
                                        <c:if test="${leave.status == 'PENDING'}">
                                            <c:set var="pendingFound" value="true" />
                                            <tr>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="flex items-center">
                                                        <div class="flex-shrink-0 h-10 w-10">
                                                            <img class="h-10 w-10 rounded-full" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                                                        </div>
                                                        <div class="ml-4">
                                                            <div class="text-sm font-medium text-gray-900">${leave.employeeName}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="text-sm text-gray-900">${leave.appliedDate}</div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="text-sm text-gray-900">${leave.startDate} to ${leave.endDate}</div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="text-sm text-gray-900">${leave.duration} day<c:if test="${leave.duration > 1}">s</c:if></div>
                                                </td>
                                                <td class="px-6 py-4">
                                                    <div class="text-sm text-gray-900">${leave.reason}</div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                    <button onclick="openApproveModal(${leave.id})" class="text-green-600 hover:text-green-900 mr-4">Approve</button>
                                                    <button onclick="openRejectModal(${leave.id})" class="text-red-600 hover:text-red-900">Reject</button>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${!pendingFound}">
                                        <tr>
                                            <td colspan="6" class="px-6 py-4 text-center text-sm text-gray-500">
                                                No pending leave applications found
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- All Leave Applications Section -->
                    <div class="mt-8 max-w-7xl mx-auto px-4 sm:px-6 md:px-8" id="all-section">
                        <h2 class="text-lg font-medium text-gray-900">All Leave Applications</h2>
                        <div class="mt-4 backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 border border-blue-100/50 shadow overflow-hidden sm:rounded-lg">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Employee
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Applied Date
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Leave Period
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Duration
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Status
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Reason
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Comments
                                        </th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:choose>
                                        <c:when test="${empty leaves}">
                                            <tr>
                                                <td colspan="7" class="px-6 py-4 text-center text-sm text-gray-500">
                                                    No leave applications found
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="leave" items="${leaves}">
                                                <tr>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="flex items-center">
                                                            <div class="flex-shrink-0 h-10 w-10">
                                                                <img class="h-10 w-10 rounded-full" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                                                            </div>
                                                            <div class="ml-4">
                                                                <div class="text-sm font-medium text-gray-900">${leave.employeeName}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="text-sm text-gray-900">${leave.appliedDate}</div>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="text-sm text-gray-900">${leave.startDate} to ${leave.endDate}</div>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="text-sm text-gray-900">${leave.duration} day<c:if test="${leave.duration > 1}">s</c:if></div>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <c:choose>
                                                            <c:when test="${leave.status == 'PENDING'}">
                                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                                    Pending
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${leave.status == 'APPROVED'}">
                                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                                    Approved
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${leave.status == 'REJECTED'}">
                                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                                                    Rejected
                                                                </span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <div class="text-sm text-gray-900">${leave.reason}</div>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <div class="text-sm text-gray-900">${leave.comments}</div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
</c:set>

<c:set var="modals">
    <!-- Approve Leave Modal -->
    <div id="approveModal" class="hidden fixed z-10 inset-0 overflow-y-auto">
        <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
            </div>
            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
            <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                <form action="${pageContext.request.contextPath}/admin/leave/approve" method="post">
                    <input type="hidden" id="approveLeaveId" name="leaveId" value="">
                    <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                        <div class="sm:flex sm:items-start">
                            <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-green-100 sm:mx-0 sm:h-10 sm:w-10">
                                <svg class="h-6 w-6 text-green-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                </svg>
                            </div>
                            <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                                <h3 class="text-lg leading-6 font-medium text-gray-900">Approve Leave Application</h3>
                                <div class="mt-2">
                                    <p class="text-sm text-gray-500">Are you sure you want to approve this leave application? You can add optional comments below.</p>
                                </div>
                                <div class="mt-4">
                                    <label for="approveComments" class="block text-sm font-medium text-gray-700">Comments (Optional)</label>
                                    <div class="mt-1">
                                        <textarea id="approveComments" name="comments" rows="3" class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                        <button type="submit" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-green-600 text-base font-medium text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 sm:ml-3 sm:w-auto sm:text-sm">
                            Approve
                        </button>
                        <button type="button" onclick="closeApproveModal()" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                            Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Reject Leave Modal -->
    <div id="rejectModal" class="hidden fixed z-10 inset-0 overflow-y-auto">
        <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
            </div>
            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
            <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                <form action="${pageContext.request.contextPath}/admin/leave/reject" method="post" id="rejectForm">
                    <input type="hidden" id="rejectLeaveId" name="leaveId" value="">
                    <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                        <div class="sm:flex sm:items-start">
                            <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                                <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                                </svg>
                            </div>
                            <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                                <h3 class="text-lg leading-6 font-medium text-gray-900">Reject Leave Application</h3>
                                <div class="mt-2">
                                    <p class="text-sm text-gray-500">Are you sure you want to reject this leave application? Please provide a reason for rejection.</p>
                                </div>
                                <div class="mt-4">
                                    <label for="rejectComments" class="block text-sm font-medium text-gray-700">Reason for Rejection <span class="text-red-500">*</span></label>
                                    <div class="mt-1">
                                        <textarea id="rejectComments" name="comments" rows="3" required class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                        <button type="submit" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm">
                            Reject
                        </button>
                        <button type="button" onclick="closeRejectModal()" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                            Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:set>

<c:set var="additionalScripts">
    <script>
        function openApproveModal(leaveId) {
            document.getElementById('approveLeaveId').value = leaveId;
            document.getElementById('approveModal').classList.remove('hidden');
        }

        function closeApproveModal() {
            document.getElementById('approveModal').classList.add('hidden');
        }

        function openRejectModal(leaveId) {
            document.getElementById('rejectLeaveId').value = leaveId;
            document.getElementById('rejectModal').classList.remove('hidden');
        }

        function closeRejectModal() {
            document.getElementById('rejectModal').classList.add('hidden');
        }

        // Form validation for reject form
        document.getElementById('rejectForm').addEventListener('submit', function(event) {
            const comments = document.getElementById('rejectComments').value.trim();

            if (!comments) {
                event.preventDefault();
                alert('Please provide a reason for rejection');
            }
        });
    </script>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="admin" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="modals" value="${modals}" />
    <jsp:param name="additionalScripts" value="${additionalScripts}" />
</jsp:include>
