<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Profile" scope="request" />
<c:set var="userRole" value="employee" scope="request" />

<c:set var="mainContent">
    <!-- Alert Message -->
    <c:if test="${not empty successMessage}">
        <jsp:include page="/WEB-INF/components/alert.jsp">
            <jsp:param name="type" value="success" />
            <jsp:param name="message" value="${successMessage}" />
            <jsp:param name="dismissible" value="true" />
        </jsp:include>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <jsp:include page="/WEB-INF/components/alert.jsp">
            <jsp:param name="type" value="error" />
            <jsp:param name="message" value="${errorMessage}" />
            <jsp:param name="dismissible" value="true" />
        </jsp:include>
    </c:if>

    <!-- Page title is displayed by layout.jsp -->

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Profile Summary Card -->
        <div class="lg:col-span-1">
            <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                <jsp:param name="icon" value="user" />
                <jsp:param name="iconBgColor" value="primary" />
                <jsp:param name="title" value="Profile Summary" />
                <jsp:param name="content" value="
                    <div class='flex flex-col items-center mt-4'>
                        <div class='w-32 h-32 rounded-full overflow-hidden bg-gray-100 mb-4'>
                            <img src='https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80' alt='Profile' class='w-full h-full object-cover'>
                        </div>
                        <h3 class='text-lg font-medium text-gray-900'>${employee.name}</h3>
                        <p class='text-sm text-gray-500'>${designation.title}</p>
                        <p class='text-sm text-gray-500'>${department.name} Department</p>
                        <div class='mt-4 w-full'>
                            <div class='bg-gray-100 rounded-lg p-4'>
                                <div class='flex items-center mb-2'>
                                    <svg class='h-5 w-5 text-gray-500 mr-2' xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor'>
                                        <path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z' />
                                    </svg>
                                    <span class='text-sm text-gray-600'>${employee.email}</span>
                                </div>
                                <div class='flex items-center mb-2'>
                                    <svg class='h-5 w-5 text-gray-500 mr-2' xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor'>
                                        <path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z' />
                                    </svg>
                                    <span class='text-sm text-gray-600'>Joined ${employee.joinDate}</span>
                                </div>
                                <div class='flex items-center'>
                                    <svg class='h-5 w-5 text-gray-500 mr-2' xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor'>
                                        <path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z' />
                                    </svg>
                                    <span class='text-sm text-gray-600'>Employee ID: ${employee.id}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                " />
            </jsp:include>
        </div>

        <!-- Profile Details Card -->
        <div class="lg:col-span-2">
            <div class="backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 border border-blue-100/50 shadow-lg rounded-lg overflow-hidden">
                <div class="px-4 py-5 sm:px-6 border-b border-gray-200/50">
                    <h3 class="text-lg leading-6 font-medium text-gray-900">Profile Details</h3>
                </div>
                <div class="p-6">
                    <form action="${pageContext.request.contextPath}/employee/profile" method="post" class="space-y-6">
                        <div class="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                            <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                <jsp:param name="id" value="name" />
                                <jsp:param name="name" value="name" />
                                <jsp:param name="type" value="text" />
                                <jsp:param name="label" value="Full Name" />
                                <jsp:param name="value" value="${employee.name}" />
                                <jsp:param name="required" value="true" />
                                <jsp:param name="colSpan" value="3" />
                            </jsp:include>

                            <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                <jsp:param name="id" value="email" />
                                <jsp:param name="name" value="email" />
                                <jsp:param name="type" value="email" />
                                <jsp:param name="label" value="Email Address" />
                                <jsp:param name="value" value="${employee.email}" />
                                <jsp:param name="required" value="true" />
                                <jsp:param name="colSpan" value="3" />
                            </jsp:include>

                            <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                <jsp:param name="id" value="department" />
                                <jsp:param name="name" value="department" />
                                <jsp:param name="type" value="text" />
                                <jsp:param name="label" value="Department" />
                                <jsp:param name="value" value="${department.name}" />
                                <jsp:param name="readonly" value="true" />
                                <jsp:param name="colSpan" value="3" />
                            </jsp:include>

                            <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                <jsp:param name="id" value="designation" />
                                <jsp:param name="name" value="designation" />
                                <jsp:param name="type" value="text" />
                                <jsp:param name="label" value="Designation" />
                                <jsp:param name="value" value="${designation.title}" />
                                <jsp:param name="readonly" value="true" />
                                <jsp:param name="colSpan" value="3" />
                            </jsp:include>

                            <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                <jsp:param name="id" value="joinDate" />
                                <jsp:param name="name" value="joinDate" />
                                <jsp:param name="type" value="text" />
                                <jsp:param name="label" value="Join Date" />
                                <jsp:param name="value" value="${employee.joinDate}" />
                                <jsp:param name="readonly" value="true" />
                                <jsp:param name="colSpan" value="3" />
                            </jsp:include>

                            <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                <jsp:param name="id" value="employeeId" />
                                <jsp:param name="name" value="employeeId" />
                                <jsp:param name="type" value="text" />
                                <jsp:param name="label" value="Employee ID" />
                                <jsp:param name="value" value="${employee.id}" />
                                <jsp:param name="readonly" value="true" />
                                <jsp:param name="colSpan" value="3" />
                            </jsp:include>
                        </div>

                        <div class="flex justify-end">
                            <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200">
                                Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Password Change Card -->
    <div class="mt-6">
        <div class="backdrop-blur-xl bg-gradient-to-br from-gray-50/80 to-slate-50/80 border border-gray-200/50 shadow-lg rounded-lg overflow-hidden">
            <div class="px-4 py-5 sm:px-6 border-b border-gray-200/50 flex items-center">
                <div class="flex-shrink-0 bg-gray-500 rounded-md p-2 mr-3">
                    <svg class="h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                </div>
                <h3 class="text-lg leading-6 font-medium text-gray-900">Change Password</h3>
            </div>
            <div class="p-6">
                <form action="${pageContext.request.contextPath}/change-password" method="post" class="space-y-6">
                    <div class="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                        <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                            <jsp:param name="id" value="currentPassword" />
                            <jsp:param name="name" value="currentPassword" />
                            <jsp:param name="type" value="password" />
                            <jsp:param name="label" value="Current Password" />
                            <jsp:param name="required" value="true" />
                            <jsp:param name="colSpan" value="6" />
                            <jsp:param name="colSpan" value="2" />
                        </jsp:include>

                        <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                            <jsp:param name="id" value="newPassword" />
                            <jsp:param name="name" value="newPassword" />
                            <jsp:param name="type" value="password" />
                            <jsp:param name="label" value="New Password" />
                            <jsp:param name="required" value="true" />
                            <jsp:param name="colSpan" value="6" />
                            <jsp:param name="colSpan" value="2" />
                        </jsp:include>

                        <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                            <jsp:param name="id" value="confirmPassword" />
                            <jsp:param name="name" value="confirmPassword" />
                            <jsp:param name="type" value="password" />
                            <jsp:param name="label" value="Confirm New Password" />
                            <jsp:param name="required" value="true" />
                            <jsp:param name="colSpan" value="6" />
                            <jsp:param name="colSpan" value="2" />
                        </jsp:include>
                    </div>

                    <div class="flex justify-end">
                        <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg shadow-sm text-white bg-gray-600 hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500 transition-all duration-200">
                            Change Password
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
</jsp:include>
