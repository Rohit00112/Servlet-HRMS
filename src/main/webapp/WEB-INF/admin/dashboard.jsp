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
                            <jsp:param name="content" value="<div class='mt-4'><a href='#' class='inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-purple-600 hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500'>Manage Departments</a></div>" />
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
                            <li>
                                <div class="px-4 py-4 sm:px-6">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-10 w-10 rounded-full bg-primary-100 flex items-center justify-center">
                                                <svg class="h-6 w-6 text-primary-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
                                                </svg>
                                            </div>
                                            <div class="ml-4">
                                                <div class="text-sm font-medium text-gray-800">New employee added</div>
                                                <div class="text-sm text-gray-600">John Doe was added to the system</div>
                                            </div>
                                        </div>
                                        <div class="ml-2 flex-shrink-0 flex">
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Just now</span>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="px-4 py-4 sm:px-6">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-10 w-10 rounded-full bg-yellow-100 flex items-center justify-center">
                                                <svg class="h-6 w-6 text-yellow-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                                                </svg>
                                            </div>
                                            <div class="ml-4">
                                                <div class="text-sm font-medium text-gray-800">Leave request pending</div>
                                                <div class="text-sm text-gray-600">Jane Smith requested 3 days of leave</div>
                                            </div>
                                        </div>
                                        <div class="ml-2 flex-shrink-0 flex">
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">2 hours ago</span>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="px-4 py-4 sm:px-6">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-10 w-10 rounded-full bg-red-100 flex items-center justify-center">
                                                <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                                                </svg>
                                            </div>
                                            <div class="ml-4">
                                                <div class="text-sm font-medium text-gray-800">System alert</div>
                                                <div class="text-sm text-gray-600">Database backup completed successfully</div>
                                            </div>
                                        </div>
                                        <div class="ml-2 flex-shrink-0 flex">
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">1 day ago</span>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="mainContent" value="${mainContent}" />
</jsp:include>
