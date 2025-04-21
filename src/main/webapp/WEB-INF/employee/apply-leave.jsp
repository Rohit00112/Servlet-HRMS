<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Apply for Leave" scope="request" />
<c:set var="userRole" value="employee" scope="request" />
<c:set var="backUrl" value="/employee/leave/status" scope="request" />
<c:set var="backLabel" value="Back to Leave Status" scope="request" />

<c:set var="mainContent">
                    <div class="flex items-center justify-between">
                        <h1 class="text-2xl font-semibold text-gray-900">Apply for Leave</h1>
                        <a href="${pageContext.request.contextPath}/employee/leave/status" class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md shadow-sm text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                            <svg class="-ml-1 mr-2 h-5 w-5 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                            </svg>
                            View Leave Status
                        </a>
                    </div>

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

                    <!-- Apply Leave Form -->
                    <div class="mt-6 backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 border border-blue-100/50 shadow overflow-hidden sm:rounded-lg">
                        <form action="${pageContext.request.contextPath}/employee/leave/apply" method="post" class="p-6" id="leaveForm">
                            <div class="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                                <!-- Employee Info (Read-only) -->
                                <div class="sm:col-span-3">
                                    <label class="block text-sm font-medium text-gray-700">Employee Name</label>
                                    <div class="mt-1">
                                        <input type="text" value="${employee.name}" readonly class="bg-gray-100 shadow-sm block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>

                                <div class="sm:col-span-3">
                                    <label class="block text-sm font-medium text-gray-700">Email</label>
                                    <div class="mt-1">
                                        <input type="text" value="${employee.email}" readonly class="bg-gray-100 shadow-sm block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>

                                <!-- Start Date Field -->
                                <div class="sm:col-span-3">
                                    <label for="startDate" class="block text-sm font-medium text-gray-700">Start Date</label>
                                    <div class="mt-1">
                                        <input type="date" name="startDate" id="startDate" required class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>

                                <!-- End Date Field -->
                                <div class="sm:col-span-3">
                                    <label for="endDate" class="block text-sm font-medium text-gray-700">End Date</label>
                                    <div class="mt-1">
                                        <input type="date" name="endDate" id="endDate" required class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                    </div>
                                </div>

                                <!-- Reason Field -->
                                <div class="sm:col-span-6">
                                    <label for="reason" class="block text-sm font-medium text-gray-700">Reason for Leave</label>
                                    <div class="mt-1">
                                        <textarea id="reason" name="reason" rows="4" required class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"></textarea>
                                    </div>
                                    <p class="mt-2 text-sm text-gray-500">Brief explanation for your leave request.</p>
                                </div>
                            </div>

                            <div class="mt-6 flex justify-end">
                                <a href="${pageContext.request.contextPath}/employee/dashboard" class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md shadow-sm text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 mr-3">
                                    Cancel
                                </a>
                                <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                                    Submit Leave Request
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="backUrl" value="${backUrl}" />
    <jsp:param name="backLabel" value="${backLabel}" />
</jsp:include>

<script>
    // Client-side form validation
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('leaveForm').addEventListener('submit', function(event) {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            const reason = document.getElementById('reason').value.trim();

            let isValid = true;
            let errorMessage = '';

            if (!startDate) {
                isValid = false;
                errorMessage += 'Start date is required. ';
            }

            if (!endDate) {
                isValid = false;
                errorMessage += 'End date is required. ';
            }

            if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
                isValid = false;
                errorMessage += 'Start date cannot be after end date. ';
            }

            if (!reason) {
                isValid = false;
                errorMessage += 'Reason is required. ';
            }

            if (!isValid) {
                event.preventDefault();
                alert('Please correct the following errors: ' + errorMessage);
            }
        });
    });
</script>
