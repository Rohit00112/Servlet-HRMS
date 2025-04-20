<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Get the current URI for active link highlighting --%>
<c:set var="currentUri" value="${pageContext.request.servletPath}" />

<div class="hidden md:flex md:flex-shrink-0">
    <div class="flex flex-col w-64 bg-white border-r border-gray-200">
        <div class="flex items-center justify-center h-16 px-4 bg-primary-700 text-white">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
            </svg>
            <span class="text-xl font-semibold">HRMS</span>
        </div>
        <div class="flex flex-col flex-grow px-4 py-4 overflow-y-auto">
            <div class="space-y-4">
                <c:choose>
                    <c:when test="${sessionScope.role eq 'ADMIN'}">
                        <div class="px-2 py-2 text-xs font-semibold text-gray-400 uppercase tracking-wider">
                            MAIN
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="${currentUri.contains('/admin/dashboard') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/admin/dashboard') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                            </svg>
                            Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/employees" class="${currentUri.contains('/admin/employees') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/admin/employees') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                            </svg>
                            Employees
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/departments" class="${currentUri.contains('/admin/departments') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/admin/departments') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                            </svg>
                            Departments
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.role eq 'HR'}">
                        <div class="px-2 py-2 text-xs font-semibold text-gray-400 uppercase tracking-wider">
                            HR MANAGEMENT
                        </div>
                        <a href="${pageContext.request.contextPath}/hr/dashboard" class="${currentUri.contains('/hr/dashboard') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/hr/dashboard') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                            </svg>
                            Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/hr/employees" class="${currentUri.contains('/hr/employees') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/hr/employees') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                            </svg>
                            Employees
                        </a>
                        <a href="${pageContext.request.contextPath}/hr/leave/all" class="${currentUri.contains('/hr/leave') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/hr/leave') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            Leave Management
                        </a>
                        <a href="${pageContext.request.contextPath}/hr/attendance/view" class="${currentUri.contains('/hr/attendance') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/hr/attendance') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                            </svg>
                            Attendance Management
                        </a>
                        <a href="${pageContext.request.contextPath}/hr/payroll/generate" class="${currentUri.contains('/hr/payroll') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/hr/payroll') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" />
                            </svg>
                            Payroll Management
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.role eq 'EMPLOYEE'}">
                        <div class="px-2 py-2 text-xs font-semibold text-gray-400 uppercase tracking-wider">
                            EMPLOYEE
                        </div>
                        <a href="${pageContext.request.contextPath}/employee/dashboard" class="${currentUri.contains('/employee/dashboard') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/employee/dashboard') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                            </svg>
                            Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/employee/profile" class="${currentUri.contains('/employee/profile') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/employee/profile') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                            </svg>
                            My Profile
                        </a>
                        <a href="${pageContext.request.contextPath}/employee/attendance/mark" class="${currentUri.contains('/employee/attendance/mark') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/employee/attendance/mark') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                            Mark Attendance
                        </a>
                        <a href="${pageContext.request.contextPath}/employee/attendance/view" class="${currentUri.contains('/employee/attendance/view') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/employee/attendance/view') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                            </svg>
                            View Attendance
                        </a>
                        <a href="${pageContext.request.contextPath}/employee/leave/apply" class="${currentUri.contains('/employee/leave/apply') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/employee/leave/apply') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            Apply for Leave
                        </a>
                        <a href="${pageContext.request.contextPath}/employee/leave/status" class="${currentUri.contains('/employee/leave/status') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/employee/leave/status') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                            </svg>
                            Leave Status
                        </a>
                        <a href="${pageContext.request.contextPath}/employee/payroll/view" class="${currentUri.contains('/employee/payroll') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                            <svg class="mr-3 h-6 w-6 ${currentUri.contains('/employee/payroll') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" />
                            </svg>
                            Payslips
                        </a>
                    </c:when>
                </c:choose>

                <div class="px-2 py-2 mt-6 text-xs font-semibold text-gray-400 uppercase tracking-wider">
                    SETTINGS
                </div>
                <a href="${pageContext.request.contextPath}/settings" class="${currentUri.contains('/settings') ? 'flex items-center px-2 py-2 text-sm font-medium text-white bg-primary-600 rounded-md group' : 'flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group'}">
                    <svg class="mr-3 h-6 w-6 ${currentUri.contains('/settings') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                    Settings
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="flex items-center px-2 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 group">
                    <svg class="mr-3 h-6 w-6 text-gray-500 group-hover:text-gray-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                    </svg>
                    Logout
                </a>
            </div>
        </div>
    </div>
</div>
