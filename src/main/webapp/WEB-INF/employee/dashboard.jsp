<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Employee Dashboard" scope="request" />
<c:set var="userRole" value="employee" scope="request" />

<c:set var="additionalHead">
    <!-- Chart.js and plugins -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
</c:set>

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

                <!-- Analytics Section -->
                <div class="mt-8 w-full">
                    <!-- Attendance Analytics -->
                    <h2 class="text-xl font-semibold text-gray-900 dark:text-gray-100 mb-4">Attendance Analytics</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                        <!-- Weekly Attendance Chart -->
                        <div class="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
                            <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-4">Weekly Attendance</h3>
                            <div class="h-64">
                                <canvas id="weeklyAttendanceChart"></canvas>
                            </div>
                        </div>

                        <!-- Monthly Attendance Chart -->
                        <div class="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
                            <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-4">Monthly Attendance</h3>
                            <div class="h-64">
                                <canvas id="monthlyAttendanceChart"></canvas>
                            </div>
                        </div>

                        <!-- Attendance Trend Chart -->
                        <div class="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md md:col-span-2">
                            <div class="flex justify-between items-center mb-4">
                                <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100">Attendance Trend (Last 6 Months)</h3>
                                <div class="flex space-x-2">
                                    <a href="${pageContext.request.contextPath}/export/attendance-trend/pdf" class="inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-600 text-xs font-medium rounded text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none">
                                        <svg class="-ml-0.5 mr-1 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                                        </svg>
                                        PDF
                                    </a>
                                    <a href="${pageContext.request.contextPath}/export/attendance-trend/excel" class="inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-600 text-xs font-medium rounded text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none">
                                        <svg class="-ml-0.5 mr-1 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                        </svg>
                                        Excel
                                    </a>
                                </div>
                            </div>
                            <div class="h-64">
                                <canvas id="attendanceTrendChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Leave Analytics -->
                    <h2 class="text-xl font-semibold text-gray-900 dark:text-gray-100 mb-4">Leave Analytics</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Leave Usage by Month Chart -->
                        <div class="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
                            <div class="flex justify-between items-center mb-4">
                                <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100">Leave Usage by Month</h3>
                                <div class="flex space-x-2">
                                    <a href="${pageContext.request.contextPath}/export/leave-usage-by-month/pdf" class="inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-600 text-xs font-medium rounded text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none">
                                        <svg class="-ml-0.5 mr-1 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                                        </svg>
                                        PDF
                                    </a>
                                    <a href="${pageContext.request.contextPath}/export/leave-usage-by-month/excel" class="inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-600 text-xs font-medium rounded text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none">
                                        <svg class="-ml-0.5 mr-1 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                        </svg>
                                        Excel
                                    </a>
                                </div>
                            </div>
                            <div class="h-64">
                                <canvas id="leaveUsageByMonthChart"></canvas>
                            </div>
                        </div>

                        <!-- Leave Usage by Type Chart -->
                        <div class="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
                            <div class="flex justify-between items-center mb-4">
                                <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100">Leave Usage by Type</h3>
                                <div class="flex space-x-2">
                                    <a href="${pageContext.request.contextPath}/export/leave-usage-by-type/pdf" class="inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-600 text-xs font-medium rounded text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none">
                                        <svg class="-ml-0.5 mr-1 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                                        </svg>
                                        PDF
                                    </a>
                                    <a href="${pageContext.request.contextPath}/export/leave-usage-by-type/excel" class="inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-600 text-xs font-medium rounded text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none">
                                        <svg class="-ml-0.5 mr-1 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                        </svg>
                                        Excel
                                    </a>
                                </div>
                            </div>
                            <div class="h-64">
                                <canvas id="leaveUsageByTypeChart"></canvas>
                            </div>
                        </div>

                        <!-- Leave Status Distribution Chart -->
                        <div class="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md md:col-span-2">
                            <div class="flex justify-between items-center mb-4">
                                <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100">Leave Status Distribution</h3>
                                <div class="flex space-x-2">
                                    <a href="${pageContext.request.contextPath}/export/leave-status-distribution/pdf" class="inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-600 text-xs font-medium rounded text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none">
                                        <svg class="-ml-0.5 mr-1 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                                        </svg>
                                        PDF
                                    </a>
                                    <a href="${pageContext.request.contextPath}/export/leave-status-distribution/excel" class="inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-600 text-xs font-medium rounded text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none">
                                        <svg class="-ml-0.5 mr-1 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                        </svg>
                                        Excel
                                    </a>
                                </div>
                            </div>
                            <div class="h-64">
                                <canvas id="leaveStatusDistributionChart"></canvas>
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

<c:set var="additionalScripts">
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Register Chart.js DataLabels plugin
        Chart.register(ChartDataLabels);
        // Function to set chart colors based on status
        function getStatusColor(status) {
            switch(status) {
                case 'PRESENT': return 'rgba(34, 197, 94, 0.7)'; // Green
                case 'LATE': return 'rgba(234, 179, 8, 0.7)';    // Yellow
                case 'HALF_DAY': return 'rgba(59, 130, 246, 0.7)'; // Blue
                case 'ABSENT': return 'rgba(239, 68, 68, 0.7)';   // Red
                default: return 'rgba(156, 163, 175, 0.7)';      // Gray
            }
        }

        function getStatusBorderColor(status) {
            switch(status) {
                case 'PRESENT': return 'rgb(22, 163, 74)';      // Darker Green
                case 'LATE': return 'rgb(202, 138, 4)';         // Darker Yellow
                case 'HALF_DAY': return 'rgb(37, 99, 235)';     // Darker Blue
                case 'ABSENT': return 'rgb(220, 38, 38)';       // Darker Red
                default: return 'rgb(107, 114, 128)';           // Darker Gray
            }
        }

        // Load Weekly Attendance Data
        fetch('${pageContext.request.contextPath}/dashboard/analytics?type=weekly-attendance')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('weeklyAttendanceChart').getContext('2d');

                // Convert data to arrays
                const labels = Object.keys(data.labels);
                const statuses = Object.values(data.data);

                // Create background colors based on status
                const backgroundColors = statuses.map(status => getStatusColor(status));
                const borderColors = statuses.map(status => getStatusBorderColor(status));

                // Create a legend for status colors
                const statusLegend = document.createElement('div');
                statusLegend.className = 'flex flex-wrap gap-3 mt-2 justify-center';

                const uniqueStatuses = [...new Set(statuses)];
                uniqueStatuses.forEach(status => {
                    const legendItem = document.createElement('div');
                    legendItem.className = 'flex items-center';

                    const colorBox = document.createElement('div');
                    colorBox.className = 'w-4 h-4 mr-1 rounded';
                    colorBox.style.backgroundColor = getStatusColor(status);

                    const label = document.createElement('span');
                    label.className = 'text-xs font-medium';
                    label.textContent = status;

                    legendItem.appendChild(colorBox);
                    legendItem.appendChild(label);
                    statusLegend.appendChild(legendItem);
                });

                // Add the legend below the chart
                document.getElementById('weeklyAttendanceChart').parentNode.appendChild(statusLegend);

                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Attendance Status',
                            data: statuses.map(status => 1), // Each day has one status
                            backgroundColor: backgroundColors,
                            borderColor: borderColors,
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        indexAxis: 'y', // Horizontal bar chart for better readability
                        scales: {
                            x: {
                                display: false // Hide x-axis
                            },
                            y: {
                                grid: {
                                    display: false // Hide grid lines
                                }
                            }
                        },
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    title: function(context) {
                                        return labels[context[0].dataIndex];
                                    },
                                    label: function(context) {
                                        return 'Status: ' + statuses[context.dataIndex];
                                    }
                                }
                            },
                            legend: {
                                display: false
                            },
                            // Add status text directly on the bars
                            datalabels: {
                                color: '#fff',
                                font: {
                                    weight: 'bold'
                                },
                                formatter: function(value, context) {
                                    return statuses[context.dataIndex];
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                });
            })
            .catch(error => console.error('Error loading weekly attendance data:', error));

        // Load Monthly Attendance Data
        fetch('${pageContext.request.contextPath}/dashboard/analytics?type=monthly-attendance')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('monthlyAttendanceChart').getContext('2d');

                // Convert data to arrays
                const labels = Object.keys(data.labels);
                const values = Object.values(data.data);

                // Create background colors based on status
                const backgroundColors = labels.map(status => getStatusColor(status));
                const borderColors = labels.map(status => getStatusBorderColor(status));

                // Calculate total for percentage
                const total = values.reduce((sum, value) => sum + value, 0);

                // Create percentage labels
                const percentageLabels = labels.map((label, index) => {
                    const percentage = total > 0 ? Math.round((values[index] / total) * 100) : 0;
                    return `${label}: ${values[index]} (${percentage}%)`;
                });

                new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: percentageLabels,
                        datasets: [{
                            data: values,
                            backgroundColor: backgroundColors,
                            borderColor: borderColors,
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'right',
                                labels: {
                                    font: {
                                        size: 11
                                    },
                                    padding: 15,
                                    boxWidth: 15
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const value = context.parsed;
                                        const percentage = total > 0 ? Math.round((value / total) * 100) : 0;
                                        return `${context.label.split(':')[0]}: ${value} days (${percentage}%)`;
                                    }
                                }
                            },
                            datalabels: {
                                color: '#fff',
                                font: {
                                    weight: 'bold',
                                    size: 11
                                },
                                formatter: function(value, context) {
                                    return value > 0 ? value : '';
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                });
            })
            .catch(error => console.error('Error loading monthly attendance data:', error));

        // Load Attendance Trend Data
        fetch('${pageContext.request.contextPath}/dashboard/analytics?type=attendance-trend')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('attendanceTrendChart').getContext('2d');

                // Convert data to arrays
                const labels = Object.keys(data.labels);
                const values = Object.values(data.data);

                // Add a title above the chart
                const chartTitle = document.createElement('div');
                chartTitle.className = 'text-sm text-center text-gray-500 mb-2';
                chartTitle.textContent = 'Your attendance rate over the last 6 months';
                document.getElementById('attendanceTrendChart').parentNode.insertBefore(chartTitle, document.getElementById('attendanceTrendChart'));

                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Attendance Percentage',
                            data: values,
                            backgroundColor: 'rgba(59, 130, 246, 0.2)',
                            borderColor: 'rgba(59, 130, 246, 1)',
                            borderWidth: 2,
                            tension: 0.3,
                            fill: true,
                            pointBackgroundColor: 'rgba(59, 130, 246, 1)',
                            pointBorderColor: '#fff',
                            pointBorderWidth: 2,
                            pointRadius: 4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                max: 100,
                                ticks: {
                                    callback: function(value) {
                                        return value + '%';
                                    }
                                },
                                title: {
                                    display: true,
                                    text: 'Attendance Rate (%)',
                                    font: {
                                        size: 12
                                    }
                                }
                            },
                            x: {
                                title: {
                                    display: true,
                                    text: 'Month',
                                    font: {
                                        size: 12
                                    }
                                }
                            }
                        },
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        return context.parsed.y.toFixed(1) + '%';
                                    }
                                }
                            },
                            datalabels: {
                                align: 'top',
                                anchor: 'end',
                                color: function(context) {
                                    return context.dataset.borderColor;
                                },
                                font: {
                                    weight: 'bold',
                                    size: 10
                                },
                                formatter: function(value) {
                                    return value.toFixed(0) + '%';
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                });
            })
            .catch(error => console.error('Error loading attendance trend data:', error));

        // Load Leave Usage by Month Data
        fetch('${pageContext.request.contextPath}/dashboard/analytics?type=leave-usage-by-month')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('leaveUsageByMonthChart').getContext('2d');

                // Convert data to arrays
                const labels = Object.keys(data.labels);
                const values = Object.values(data.data);

                // Add a title above the chart
                const chartTitle = document.createElement('div');
                chartTitle.className = 'text-sm text-center text-gray-500 mb-2';
                chartTitle.textContent = 'Number of leave days taken each month this year';
                document.getElementById('leaveUsageByMonthChart').parentNode.insertBefore(chartTitle, document.getElementById('leaveUsageByMonthChart'));

                // Calculate total leave days
                const totalLeaveDays = values.reduce((sum, value) => sum + value, 0);

                // Add a summary below the chart
                const chartSummary = document.createElement('div');
                chartSummary.className = 'text-sm text-center font-medium mt-2';
                chartSummary.textContent = `Total leave days taken this year: ${totalLeaveDays}`;

                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Leave Days Taken',
                            data: values,
                            backgroundColor: 'rgba(16, 185, 129, 0.7)',
                            borderColor: 'rgba(16, 185, 129, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    precision: 0,
                                    stepSize: 1
                                },
                                title: {
                                    display: true,
                                    text: 'Days',
                                    font: {
                                        size: 12
                                    }
                                }
                            },
                            x: {
                                title: {
                                    display: true,
                                    text: 'Month',
                                    font: {
                                        size: 12
                                    }
                                }
                            }
                        },
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const value = context.parsed.y;
                                        return value + (value === 1 ? ' day' : ' days');
                                    }
                                }
                            },
                            datalabels: {
                                align: 'top',
                                anchor: 'end',
                                color: function(context) {
                                    return context.dataset.data[context.dataIndex] > 0 ? 'rgba(16, 185, 129, 1)' : 'transparent';
                                },
                                font: {
                                    weight: 'bold'
                                },
                                formatter: function(value) {
                                    return value > 0 ? value : '';
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                });

                // Add the summary after the chart
                document.getElementById('leaveUsageByMonthChart').parentNode.appendChild(chartSummary);
            })
            .catch(error => console.error('Error loading leave usage by month data:', error));

        // Load Leave Usage by Type Data
        fetch('${pageContext.request.contextPath}/dashboard/analytics?type=leave-usage-by-type')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('leaveUsageByTypeChart').getContext('2d');

                // Convert data to arrays
                const labels = Object.keys(data.labels);
                const values = Object.values(data.data);

                // Define colors for different leave types
                const backgroundColors = [
                    'rgba(79, 70, 229, 0.7)',  // Indigo for Annual
                    'rgba(239, 68, 68, 0.7)',  // Red for Sick
                    'rgba(245, 158, 11, 0.7)', // Amber for Personal
                    'rgba(107, 114, 128, 0.7)' // Gray for Other
                ];

                const borderColors = [
                    'rgba(79, 70, 229, 1)',
                    'rgba(239, 68, 68, 1)',
                    'rgba(245, 158, 11, 1)',
                    'rgba(107, 114, 128, 1)'
                ];

                // Add a title above the chart
                const chartTitle = document.createElement('div');
                chartTitle.className = 'text-sm text-center text-gray-500 mb-2';
                chartTitle.textContent = 'Distribution of leave days by type';
                document.getElementById('leaveUsageByTypeChart').parentNode.insertBefore(chartTitle, document.getElementById('leaveUsageByTypeChart'));

                // Calculate total for percentage
                const total = values.reduce((sum, value) => sum + value, 0);

                // Create percentage labels
                const percentageLabels = labels.map((label, index) => {
                    const percentage = total > 0 ? Math.round((values[index] / total) * 100) : 0;
                    return `${label}: ${values[index]} (${percentage}%)`;
                });

                new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: percentageLabels,
                        datasets: [{
                            data: values,
                            backgroundColor: backgroundColors,
                            borderColor: borderColors,
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'right',
                                labels: {
                                    font: {
                                        size: 11
                                    },
                                    padding: 15,
                                    boxWidth: 15
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const value = context.parsed;
                                        const percentage = total > 0 ? Math.round((value / total) * 100) : 0;
                                        return `${context.label.split(':')[0]}: ${value} days (${percentage}%)`;
                                    }
                                }
                            },
                            datalabels: {
                                color: '#fff',
                                font: {
                                    weight: 'bold',
                                    size: 11
                                },
                                formatter: function(value, context) {
                                    if (value === 0) return '';
                                    const percentage = Math.round((value / total) * 100);
                                    return percentage > 5 ? percentage + '%' : '';
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                });

                // Add a summary below the chart
                if (total > 0) {
                    const chartSummary = document.createElement('div');
                    chartSummary.className = 'text-sm text-center font-medium mt-2';
                    chartSummary.textContent = `Total leave days by type: ${total}`;
                    document.getElementById('leaveUsageByTypeChart').parentNode.appendChild(chartSummary);
                }
            })
            .catch(error => console.error('Error loading leave usage by type data:', error));

        // Load Leave Status Distribution Data
        fetch('${pageContext.request.contextPath}/dashboard/analytics?type=leave-status-distribution')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('leaveStatusDistributionChart').getContext('2d');

                // Convert data to arrays
                const labels = Object.keys(data.labels);
                const values = Object.values(data.data);

                // Define colors for different status types
                const backgroundColors = {
                    'APPROVED': 'rgba(16, 185, 129, 0.7)',  // Green
                    'PENDING': 'rgba(245, 158, 11, 0.7)',  // Amber
                    'REJECTED': 'rgba(239, 68, 68, 0.7)'   // Red
                };

                const borderColors = {
                    'APPROVED': 'rgba(16, 185, 129, 1)',
                    'PENDING': 'rgba(245, 158, 11, 1)',
                    'REJECTED': 'rgba(239, 68, 68, 1)'
                };

                // Create datasets with colors matching status
                const backgroundColor = labels.map(label => backgroundColors[label] || 'rgba(107, 114, 128, 0.7)');
                const borderColor = labels.map(label => borderColors[label] || 'rgba(107, 114, 128, 1)');

                // Add a title above the chart
                const chartTitle = document.createElement('div');
                chartTitle.className = 'text-sm text-center text-gray-500 mb-2';
                chartTitle.textContent = 'Status of your leave requests this year';
                document.getElementById('leaveStatusDistributionChart').parentNode.insertBefore(chartTitle, document.getElementById('leaveStatusDistributionChart'));

                // Calculate total leave requests
                const totalRequests = values.reduce((sum, value) => sum + value, 0);

                // Create a status description map
                const statusDescriptions = {
                    'APPROVED': 'Approved leave requests',
                    'PENDING': 'Pending leave requests',
                    'REJECTED': 'Rejected leave requests'
                };

                // Create a horizontal bar chart for better readability
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels.map(label => statusDescriptions[label] || label),
                        datasets: [{
                            axis: 'y',
                            label: 'Number of Leaves',
                            data: values,
                            backgroundColor: backgroundColor,
                            borderColor: borderColor,
                            borderWidth: 1
                        }]
                    },
                    options: {
                        indexAxis: 'y',
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: {
                                beginAtZero: true,
                                ticks: {
                                    precision: 0,
                                    stepSize: 1
                                },
                                title: {
                                    display: true,
                                    text: 'Number of Requests',
                                    font: {
                                        size: 12
                                    }
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const value = context.parsed.x;
                                        return value + (value === 1 ? ' request' : ' requests');
                                    }
                                }
                            },
                            datalabels: {
                                align: 'end',
                                anchor: 'end',
                                color: function(context) {
                                    return context.dataset.borderColor[context.dataIndex];
                                },
                                font: {
                                    weight: 'bold'
                                },
                                formatter: function(value) {
                                    return value > 0 ? value : '';
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                });

                // Add a summary below the chart
                if (totalRequests > 0) {
                    const chartSummary = document.createElement('div');
                    chartSummary.className = 'text-sm text-center font-medium mt-2';
                    chartSummary.textContent = `Total leave requests this year: ${totalRequests}`;
                    document.getElementById('leaveStatusDistributionChart').parentNode.appendChild(chartSummary);
                }
            })
            .catch(error => console.error('Error loading leave status distribution data:', error));
    });
</script>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="additionalHead" value="${additionalHead}" />
    <jsp:param name="additionalScripts" value="${additionalScripts}" />
</jsp:include>
