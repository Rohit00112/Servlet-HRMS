<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Apply for Leave" scope="request" />
<c:set var="userRole" value="employee" scope="request" />
<c:set var="backUrl" value="/employee/leave/status" scope="request" />
<c:set var="backLabel" value="Back to Leave Status" scope="request" />

<c:set var="mainContent">
                    <div class="flex justify-end">
                        <a href="${pageContext.request.contextPath}/employee/leave/status" class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-lg shadow-sm text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
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
                                <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                    <jsp:param name="id" value="employeeName" />
                                    <jsp:param name="name" value="employeeName" />
                                    <jsp:param name="type" value="text" />
                                    <jsp:param name="label" value="Employee Name" />
                                    <jsp:param name="value" value="${employee.name}" />
                                    <jsp:param name="readonly" value="true" />
                                    <jsp:param name="colSpan" value="3" />
                                </jsp:include>

                                <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                    <jsp:param name="id" value="employeeEmail" />
                                    <jsp:param name="name" value="employeeEmail" />
                                    <jsp:param name="type" value="email" />
                                    <jsp:param name="label" value="Email" />
                                    <jsp:param name="value" value="${employee.email}" />
                                    <jsp:param name="readonly" value="true" />
                                    <jsp:param name="colSpan" value="3" />
                                </jsp:include>

                                <!-- Start Date Field -->
                                <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                    <jsp:param name="id" value="startDate" />
                                    <jsp:param name="name" value="startDate" />
                                    <jsp:param name="type" value="date" />
                                    <jsp:param name="label" value="Start Date" />
                                    <jsp:param name="required" value="true" />
                                    <jsp:param name="colSpan" value="3" />
                                </jsp:include>

                                <!-- End Date Field -->
                                <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                    <jsp:param name="id" value="endDate" />
                                    <jsp:param name="name" value="endDate" />
                                    <jsp:param name="type" value="date" />
                                    <jsp:param name="label" value="End Date" />
                                    <jsp:param name="required" value="true" />
                                    <jsp:param name="colSpan" value="3" />
                                </jsp:include>

                                <!-- Reason Field -->
                                <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                    <jsp:param name="id" value="reason" />
                                    <jsp:param name="name" value="reason" />
                                    <jsp:param name="type" value="textarea" />
                                    <jsp:param name="label" value="Reason for Leave" />
                                    <jsp:param name="required" value="true" />
                                    <jsp:param name="colSpan" value="6" />
                                    <jsp:param name="helpText" value="Brief explanation for your leave request." />
                                </jsp:include>
                            </div>

                            <div class="mt-6 flex justify-end">
                                <a href="${pageContext.request.contextPath}/employee/dashboard" class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-lg shadow-sm text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 mr-3">
                                    Cancel
                                </a>
                                <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
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
