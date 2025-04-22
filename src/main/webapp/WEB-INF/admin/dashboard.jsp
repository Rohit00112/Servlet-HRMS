<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Admin Dashboard" scope="request" />

<c:set var="mainContent">

                <!-- Stats Overview -->
                <div class="mt-6">
                    <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
                        <!-- Stat Card 1: Total Employees -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="user" />
                            <jsp:param name="iconBgColor" value="primary" />
                            <jsp:param name="title" value="Total Employees" />
                            <jsp:param name="content" value="<div class='text-2xl font-semibold text-gray-900'>${employeeCount}</div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>

                        <!-- Stat Card 2: Present Today -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="calendar" />
                            <jsp:param name="iconBgColor" value="green" />
                            <jsp:param name="title" value="Present Today" />
                            <jsp:param name="content" value="<div class='text-2xl font-semibold text-gray-900'>${presentToday}</div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>

                        <!-- Stat Card 3: On Leave -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="calendar" />
                            <jsp:param name="iconBgColor" value="red" />
                            <jsp:param name="title" value="On Leave" />
                            <jsp:param name="content" value="<div class='text-2xl font-semibold text-gray-900'>${approvedLeaveCount}</div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>

                        <!-- Stat Card 4: Pending Requests -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="bell" />
                            <jsp:param name="iconBgColor" value="yellow" />
                            <jsp:param name="title" value="Pending Requests" />
                            <jsp:param name="content" value="<div class='text-2xl font-semibold text-gray-900'>${pendingLeaveCount}</div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>
                    </div>
                </div>

                <!-- Additional Stats -->
                <div class="mt-6">
                    <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
                        <!-- Payroll Stats: Draft -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="document" />
                            <jsp:param name="iconBgColor" value="blue" />
                            <jsp:param name="title" value="Draft Payrolls" />
                            <jsp:param name="content" value="<div class='text-2xl font-semibold text-gray-900'>${pendingPayrollCount}</div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>

                        <!-- Payroll Stats: Finalized -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="document" />
                            <jsp:param name="iconBgColor" value="primary" />
                            <jsp:param name="title" value="Finalized Payrolls" />
                            <jsp:param name="content" value="<div class='text-2xl font-semibold text-gray-900'>${finalizedPayrollCount}</div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>

                        <!-- Payroll Stats: Paid -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="document" />
                            <jsp:param name="iconBgColor" value="green" />
                            <jsp:param name="title" value="Paid Payrolls" />
                            <jsp:param name="content" value="<div class='text-2xl font-semibold text-gray-900'>${paidPayrollCount}</div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>
                    </div>
                </div>

                <!-- Quick Access Cards -->
                <div class="mt-8">
                    <h2 class="text-lg font-semibold text-gray-700 backdrop-blur-md bg-blue-50/80 inline-block px-3 py-1 rounded-lg shadow-sm border border-blue-100/50">Quick Access</h2>
                    <div class="mt-4 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
                        <!-- Card 1: Employee Management -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="user" />
                            <jsp:param name="iconBgColor" value="primary" />
                            <jsp:param name="title" value="Employee Management" />
                            <jsp:param name="subtitle" value="Create, update, and manage employee records" />
                            <jsp:param name="content" value="<div class='mt-4'><a href='${pageContext.request.contextPath}/admin/employees' class='inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500'>Manage Employees</a></div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>

                        <!-- Card 2: Leave Management -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="calendar" />
                            <jsp:param name="iconBgColor" value="green" />
                            <jsp:param name="title" value="Leave Management" />
                            <jsp:param name="subtitle" value="Review and manage employee leave requests" />
                            <jsp:param name="content" value="<div class='mt-4'><a href='${pageContext.request.contextPath}/admin/leave/all' class='inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500'>Manage Leave Requests</a></div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>

                        <!-- Card 3: Payroll Management -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="document" />
                            <jsp:param name="iconBgColor" value="blue" />
                            <jsp:param name="title" value="Payroll Management" />
                            <jsp:param name="subtitle" value="Generate and manage employee payrolls" />
                            <jsp:param name="content" value="<div class='mt-4'><a href='${pageContext.request.contextPath}/admin/payroll/generate' class='inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500'>Manage Payroll</a></div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>

                        <!-- Card 4: Attendance Management -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="chart" />
                            <jsp:param name="iconBgColor" value="yellow" />
                            <jsp:param name="title" value="Attendance Management" />
                            <jsp:param name="subtitle" value="Track and manage employee attendance" />
                            <jsp:param name="content" value="<div class='mt-4'><a href='${pageContext.request.contextPath}/admin/attendance/view' class='inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-yellow-600 hover:bg-yellow-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500'>View Attendance</a></div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>

                        <!-- Card 5: Department Management -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="user" />
                            <jsp:param name="iconBgColor" value="purple" />
                            <jsp:param name="title" value="Department Management" />
                            <jsp:param name="subtitle" value="Manage company departments and structure" />
                            <jsp:param name="content" value="<div class='mt-4'><a href='${pageContext.request.contextPath}/admin/departments' class='inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-purple-600 hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500'>Manage Departments</a></div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>

                        <!-- Card 6: System Settings -->
                        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                            <jsp:param name="icon" value="cog" />
                            <jsp:param name="iconBgColor" value="gray" />
                            <jsp:param name="title" value="System Settings" />
                            <jsp:param name="subtitle" value="Configure system parameters and settings" />
                            <jsp:param name="content" value="<div class='mt-4'><a href='#' class='inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-gray-600 hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500'>Settings</a></div>" />
                            <jsp:param name="blurIntensity" value="xl" />
                            <jsp:param name="bgOpacity" value="15" />
                        </jsp:include>
                    </div>
                </div>

                <!-- Test Users (For Development) -->
                <div class="mt-8 backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 p-4 rounded-xl border border-blue-100/50 shadow-lg">
                    <div class="flex justify-between items-center">
                        <h2 class="text-lg font-semibold text-gray-800">Test Users (For Development)</h2>
                        <a href="${pageContext.request.contextPath}/admin/create-test-users" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            Create Test Users
                        </a>
                    </div>
                    <p class="mt-2 text-sm text-gray-600">Click the button to create test users for HR and Employee roles. This will create users with the following credentials:</p>
                    <div class="mt-2 grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="backdrop-blur-lg bg-white/70 p-3 rounded-lg border border-blue-100/50 shadow">
                            <p class="font-medium">HR User</p>
                            <p class="text-sm">Username: <span class="font-mono">hr</span></p>
                            <p class="text-sm">Password: <span class="font-mono">hr123</span></p>
                        </div>
                        <div class="backdrop-blur-lg bg-white/70 p-3 rounded-lg border border-blue-100/50 shadow">
                            <p class="font-medium">Employee User</p>
                            <p class="text-sm">Username: <span class="font-mono">employee</span></p>
                            <p class="text-sm">Password: <span class="font-mono">emp123</span></p>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="mt-8">
                    <h2 class="text-lg font-semibold text-gray-700 backdrop-blur-md bg-blue-50/80 inline-block px-3 py-1 rounded-lg shadow-sm border border-blue-100/50">Recent Activity</h2>
                    <div class="mt-4 backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 border border-blue-100/50 overflow-hidden sm:rounded-xl shadow-lg">
                        <ul class="divide-y divide-blue-100/30">
                            <c:choose>
                                <c:when test="${not empty recentActivities}">
                                    <c:forEach var="activity" items="${recentActivities}">
                                        <li class="hover:bg-blue-50/50 transition-colors duration-150">
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
                                                            <div class="text-sm font-medium text-gray-800">${activity.activityType}</div>
                                                            <div class="text-sm text-gray-600">${activity.description}</div>
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
                                            <p class="mt-1 text-sm text-gray-500">System activities will appear here.</p>
                                        </div>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="mainContent" value="${mainContent}" />
</jsp:include>
