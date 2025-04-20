<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Get the current URI for active link highlighting --%>
<c:set var="currentUri" value="${pageContext.request.servletPath}" />

<div id="mobile-sidebar" class="fixed inset-0 flex z-40 md:hidden" style="display: none;">
    <div class="fixed inset-0 bg-gray-600 bg-opacity-75" id="mobile-sidebar-backdrop"></div>
    
    <div class="relative flex-1 flex flex-col max-w-xs w-full bg-white">
        <div class="absolute top-0 right-0 -mr-12 pt-2">
            <button id="close-mobile-sidebar" class="ml-1 flex items-center justify-center h-10 w-10 rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white">
                <span class="sr-only">Close sidebar</span>
                <svg class="h-6 w-6 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>
        </div>
        
        <div class="flex-1 h-0 pt-5 pb-4 overflow-y-auto">
            <div class="flex-shrink-0 flex items-center px-4 bg-primary-700 text-white py-4">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
                <span class="text-xl font-semibold">HRMS</span>
            </div>
            <nav class="mt-5 px-2 space-y-1">
                <c:choose>
                    <c:when test="${sessionScope.role eq 'ADMIN'}">
                        <div class="px-2 py-2 text-xs font-semibold text-gray-400 uppercase tracking-wider">
                            MAIN
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="${currentUri.contains('/admin/dashboard') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/admin/dashboard') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                            </svg>
                            Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/employees" class="${currentUri.contains('/admin/employees') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/admin/employees') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                            </svg>
                            Employees
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/departments" class="${currentUri.contains('/admin/departments') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/admin/departments') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                            </svg>
                            Departments
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/leave/all" class="${currentUri.contains('/admin/leave') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/admin/leave') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            Leave Management
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/attendance/view" class="${currentUri.contains('/admin/attendance') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/admin/attendance') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                            </svg>
                            Attendance
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/payroll/generate" class="${currentUri.contains('/admin/payroll') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/admin/payroll') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" />
                            </svg>
                            Payroll
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.role eq 'HR'}">
                        <div class="px-2 py-2 text-xs font-semibold text-gray-400 uppercase tracking-wider">
                            HR MANAGEMENT
                        </div>
                        <a href="${pageContext.request.contextPath}/hr/dashboard" class="${currentUri.contains('/hr/dashboard') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/hr/dashboard') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                            </svg>
                            Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/hr/employees" class="${currentUri.contains('/hr/employees') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/hr/employees') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                            </svg>
                            Employees
                        </a>
                        <a href="${pageContext.request.contextPath}/hr/leave/all" class="${currentUri.contains('/hr/leave') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/hr/leave') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            Leave Management
                        </a>
                        <a href="${pageContext.request.contextPath}/hr/attendance/view" class="${currentUri.contains('/hr/attendance') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/hr/attendance') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                            </svg>
                            Attendance
                        </a>
                        <a href="${pageContext.request.contextPath}/hr/payroll/generate" class="${currentUri.contains('/hr/payroll') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/hr/payroll') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" />
                            </svg>
                            Payroll
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.role eq 'EMPLOYEE'}">
                        <div class="px-2 py-2 text-xs font-semibold text-gray-400 uppercase tracking-wider">
                            EMPLOYEE
                        </div>
                        <a href="${pageContext.request.contextPath}/employee/dashboard" class="${currentUri.contains('/employee/dashboard') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/employee/dashboard') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                            </svg>
                            Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/employee/profile" class="${currentUri.contains('/employee/profile') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/employee/profile') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                            </svg>
                            My Profile
                        </a>
                        <a href="${pageContext.request.contextPath}/employee/attendance/mark" class="${currentUri.contains('/employee/attendance/mark') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/employee/attendance/mark') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                            Mark Attendance
                        </a>
                        <a href="${pageContext.request.contextPath}/employee/leave/apply" class="${currentUri.contains('/employee/leave/apply') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/employee/leave/apply') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            Apply for Leave
                        </a>
                        <a href="${pageContext.request.contextPath}/employee/payroll/view" class="${currentUri.contains('/employee/payroll') ? 'bg-primary-600 text-white' : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'} group flex items-center px-2 py-2 text-base font-medium rounded-md">
                            <svg class="mr-4 h-6 w-6 ${currentUri.contains('/employee/payroll') ? 'text-white' : 'text-gray-500 group-hover:text-gray-600'}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" />
                            </svg>
                            Payslips
                        </a>
                    </c:when>
                </c:choose>
                
                <div class="px-2 py-2 mt-6 text-xs font-semibold text-gray-400 uppercase tracking-wider">
                    SETTINGS
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="text-gray-700 hover:bg-gray-100 hover:text-gray-900 group flex items-center px-2 py-2 text-base font-medium rounded-md">
                    <svg class="mr-4 h-6 w-6 text-gray-500 group-hover:text-gray-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                    </svg>
                    Logout
                </a>
            </nav>
        </div>
    </div>
</div>
