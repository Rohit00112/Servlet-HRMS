<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Employee Dashboard" scope="request" />
<c:set var="userRole" value="employee" scope="request" />

<c:set var="mainContent">
                <!-- Alert Message -->
                <c:if test="${not empty errorMessage}">
                    <jsp:include page="/WEB-INF/components/alert.jsp">
                        <jsp:param name="type" value="error" />
                        <jsp:param name="message" value="${errorMessage}" />
                        <jsp:param name="dismissible" value="true" />
                    </jsp:include>
                </c:if>

                <!-- Stats Overview -->
                <div class="mt-6 w-full">
                    <h2 class="text-xl font-semibold text-gray-900 mb-4">Overview</h2>
                    <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 w-full max-w-full">
                        <!-- Stat Card 1 -->
                        <jsp:include page="/WEB-INF/components/card.jsp">
                            <jsp:param name="title" value="Attendance Rate" />
                            <jsp:param name="icon" value="calendar" />
                            <jsp:param name="iconBgColor" value="primary" />
                            <jsp:param name="content" value="
                                <div class='flex items-baseline'>
                                    <div class='text-2xl font-semibold text-gray-900'>${String.format('%.1f', attendanceRate)}%</div>
                                    <div class='ml-2 flex items-baseline text-sm font-semibold ${attendanceRateChange >= 0 ? 'text-green-600' : 'text-red-600'}'>
                                        <svg class='self-center flex-shrink-0 h-5 w-5 ${attendanceRateChange >= 0 ? 'text-green-500' : 'text-red-500'}' fill='currentColor' viewBox='0 0 20 20' aria-hidden='true'>
                                            <path fill-rule='evenodd' d='${attendanceRateChange >= 0 ? 'M5.293 9.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 7.414V15a1 1 0 11-2 0V7.414L6.707 9.707a1 1 0 01-1.414 0z' : 'M14.707 10.293a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 111.414-1.414L9 12.586V5a1 1 0 012 0v7.586l2.293-2.293a1 1 0 011.414 0z'}' clip-rule='evenodd' />
                                        </svg>
                                        <span class='sr-only'>${attendanceRateChange >= 0 ? 'Increased' : 'Decreased'} by</span>
                                        ${Math.abs(attendanceRateChange)}%
                                    </div>
                                </div>
                            " />
                        </jsp:include>

                        <!-- Stat Card 2 -->
                        <jsp:include page="/WEB-INF/components/card.jsp">
                            <jsp:param name="title" value="Leave Balance" />
                            <jsp:param name="icon" value="document" />
                            <jsp:param name="iconBgColor" value="purple" />
                            <jsp:param name="content" value="
                                <div class='flex items-baseline'>
                                    <div class='text-2xl font-semibold text-gray-900'>${leaveBalance} days</div>
                                    <div class='ml-2 flex items-baseline text-sm font-semibold ${leaveBalanceChange >= 0 ? 'text-green-600' : 'text-red-600'}'>
                                        <svg class='self-center flex-shrink-0 h-5 w-5 ${leaveBalanceChange >= 0 ? 'text-green-500' : 'text-red-500'}' fill='currentColor' viewBox='0 0 20 20' aria-hidden='true'>
                                            <path fill-rule='evenodd' d='${leaveBalanceChange >= 0 ? 'M5.293 9.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 7.414V15a1 1 0 11-2 0V7.414L6.707 9.707a1 1 0 01-1.414 0z' : 'M14.707 10.293a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 111.414-1.414L9 12.586V5a1 1 0 012 0v7.586l2.293-2.293a1 1 0 011.414 0z'}' clip-rule='evenodd' />
                                        </svg>
                                        <span class='sr-only'>${leaveBalanceChange >= 0 ? 'Increased' : 'Decreased'} by</span>
                                        ${Math.abs(leaveBalanceChange)} days
                                    </div>
                                </div>
                            " />
                        </jsp:include>

                        <!-- Stat Card 3 -->
                        <jsp:include page="/WEB-INF/components/card.jsp">
                            <jsp:param name="title" value="Next Payroll" />
                            <jsp:param name="icon" value="money" />
                            <jsp:param name="iconBgColor" value="green" />
                            <jsp:param name="content" value="
                                <div class='flex items-baseline'>
                                    <div class='text-2xl font-semibold text-gray-900'>${nextPayrollDate}</div>
                                    <div class='ml-2 flex items-baseline text-sm font-semibold text-gray-600'>
                                        <span>In ${daysUntilNextPayroll} days</span>
                                    </div>
                                </div>
                            " />
                        </jsp:include>

                        <!-- Stat Card 4 -->
                        <jsp:include page="/WEB-INF/components/card.jsp">
                            <jsp:param name="title" value="Notifications" />
                            <jsp:param name="icon" value="bell" />
                            <jsp:param name="iconBgColor" value="yellow" />
                            <jsp:param name="content" value="
                                <div class='flex items-baseline'>
                                    <div class='text-2xl font-semibold text-gray-900'>${unreadNotificationCount}</div>
                                    <div class='ml-2 flex items-baseline text-sm font-semibold text-yellow-600'>
                                        <span>Unread</span>
                                    </div>
                                </div>
                            " />
                        </jsp:include>
                    </div>
                </div>

                <!-- Quick Access Cards -->
                <div class="mt-8 w-full">
                    <h2 class="text-xl font-semibold text-gray-900 mb-4">Quick Access</h2>
                    <div class="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 w-full max-w-full">
                        <!-- Card 1: My Profile -->
                        <div class="bg-white overflow-hidden shadow-md hover:shadow-lg transition-shadow duration-300 rounded-lg">
                            <div class="p-5">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 bg-primary-100 rounded-md p-3">
                                        <svg class="h-6 w-6 text-primary-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                        </svg>
                                    </div>
                                    <div class="ml-5 w-0 flex-1">
                                        <h3 class="text-lg font-medium text-gray-900 truncate">My Profile</h3>
                                        <p class="mt-1 text-sm text-gray-500">View and update your personal information</p>
                                    </div>
                                </div>
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/employee/profile" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                                        View Profile
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Card 2: Leave Requests -->
                        <div class="bg-white overflow-hidden shadow-md hover:shadow-lg transition-shadow duration-300 rounded-lg">
                            <div class="p-5">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 bg-green-100 rounded-md p-3">
                                        <svg class="h-6 w-6 text-green-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                        </svg>
                                    </div>
                                    <div class="ml-5 w-0 flex-1">
                                        <h3 class="text-lg font-medium text-gray-900 truncate">Leave Requests</h3>
                                        <p class="mt-1 text-sm text-gray-500">Submit and track your leave requests</p>
                                    </div>
                                </div>
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/employee/leave/apply" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                                        Apply for Leave
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Card 3: Attendance -->
                        <div class="bg-white overflow-hidden shadow-md hover:shadow-lg transition-shadow duration-300 rounded-lg">
                            <div class="p-5">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 bg-yellow-100 rounded-md p-3">
                                        <svg class="h-6 w-6 text-yellow-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                    </div>
                                    <div class="ml-5 w-0 flex-1">
                                        <h3 class="text-lg font-medium text-gray-900 truncate">Attendance</h3>
                                        <p class="mt-1 text-sm text-gray-500">Mark your daily attendance</p>
                                    </div>
                                </div>
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/employee/attendance/mark" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-yellow-600 hover:bg-yellow-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500">
                                        Mark Attendance
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Card 4: Payslips -->
                        <div class="bg-white overflow-hidden shadow-md hover:shadow-lg transition-shadow duration-300 rounded-lg">
                            <div class="p-5">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 bg-indigo-100 rounded-md p-3">
                                        <svg class="h-6 w-6 text-indigo-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" />
                                        </svg>
                                    </div>
                                    <div class="ml-5 w-0 flex-1">
                                        <h3 class="text-lg font-medium text-gray-900 truncate">Payslips</h3>
                                        <p class="mt-1 text-sm text-gray-500">View and download your payslips</p>
                                    </div>
                                </div>
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/employee/payroll/view" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                                        View Payslips
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="mt-8 w-full">
                    <h2 class="text-xl font-semibold text-gray-900 mb-4">Recent Activity</h2>
                    <div class="mt-4 bg-white shadow-md overflow-hidden sm:rounded-lg w-full max-w-full">
                        <ul class="divide-y divide-gray-200">
                            <c:choose>
                                <c:when test="${not empty recentActivities}">
                                    <c:forEach var="activity" items="${recentActivities}">
                                        <li class="hover:bg-gray-50 transition-colors duration-150">
                                            <div class="px-4 py-4 sm:px-6">
                                                <div class="flex items-center justify-between">
                                                    <div class="flex items-center">
                                                        <div class="flex-shrink-0 h-10 w-10 rounded-full bg-${activity.colorClass}-100 flex items-center justify-center">
                                                            <svg class="h-6 w-6 text-${activity.colorClass}-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                                <c:choose>
                                                                    <c:when test="${activity.iconClass == 'login'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" />
                                                                    </c:when>
                                                                    <c:when test="${activity.iconClass == 'logout'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                                                                    </c:when>
                                                                    <c:when test="${activity.iconClass == 'plus'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                                                                    </c:when>
                                                                    <c:when test="${activity.iconClass == 'pencil'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                                                                    </c:when>
                                                                    <c:when test="${activity.iconClass == 'trash'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                                                    </c:when>
                                                                    <c:when test="${activity.iconClass == 'check'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                                                    </c:when>
                                                                    <c:when test="${activity.iconClass == 'x'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                                                                    </c:when>
                                                                    <c:when test="${activity.iconClass == 'eye'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                                                    </c:when>
                                                                    <c:when test="${activity.iconClass == 'download'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                                                                    </c:when>
                                                                    <c:when test="${activity.iconClass == 'upload'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
                                                                    </c:when>
                                                                    <c:when test="${activity.iconClass == 'clock'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                                    </c:when>
                                                                    <c:when test="${activity.iconClass == 'calendar'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                                                    </c:when>
                                                                    <c:when test="${activity.iconClass == 'currency-dollar'}">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </svg>
                                                        </div>
                                                        <div class="ml-4">
                                                            <div class="text-sm font-medium text-gray-900">${activity.activityType}</div>
                                                            <div class="text-sm text-gray-500">${activity.description}</div>
                                                        </div>
                                                    </div>
                                                    <div class="ml-2 flex-shrink-0 flex">
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-${activity.colorClass}-100 text-${activity.colorClass}-800">${activity.formattedTimestamp}</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li class="py-8">
                                        <div class="text-center">
                                            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                                            </svg>
                                            <h3 class="mt-2 text-sm font-medium text-gray-900">No recent activities</h3>
                                            <p class="mt-1 text-sm text-gray-500">Your recent activities will appear here.</p>
                                        </div>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>
            </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
</jsp:include>
