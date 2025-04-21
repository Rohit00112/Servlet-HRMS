<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Profile" scope="request" />
<c:set var="userRole" value="admin" scope="request" />

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

    <div class="flex items-center justify-between mb-6">
        <h1 class="text-2xl font-semibold text-gray-900">My Profile</h1>
    </div>

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
                                    <span class='text-sm text-gray-600'>Joined <fmt:formatDate value='${employee.joinDate}' pattern='MMM d, yyyy' /></span>
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
            <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                <jsp:param name="title" value="Profile Details" />
                <jsp:param name="content" value="
                    <div class='mt-4'>
                        <form action='${pageContext.request.contextPath}/admin/profile' method='post' class='space-y-6'>
                            <div class='grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6'>
                                <div class='sm:col-span-3'>
                                    <label for='name' class='block text-sm font-medium text-gray-700'>Full Name</label>
                                    <div class='mt-1'>
                                        <input type='text' name='name' id='name' value='${employee.name}' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md'>
                                    </div>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='email' class='block text-sm font-medium text-gray-700'>Email Address</label>
                                    <div class='mt-1'>
                                        <input type='email' name='email' id='email' value='${employee.email}' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md'>
                                    </div>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='department' class='block text-sm font-medium text-gray-700'>Department</label>
                                    <div class='mt-1'>
                                        <input type='text' id='department' value='${department.name}' disabled class='bg-gray-50 shadow-sm block w-full sm:text-sm border-gray-300 rounded-md'>
                                    </div>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='designation' class='block text-sm font-medium text-gray-700'>Designation</label>
                                    <div class='mt-1'>
                                        <input type='text' id='designation' value='${designation.title}' disabled class='bg-gray-50 shadow-sm block w-full sm:text-sm border-gray-300 rounded-md'>
                                    </div>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='joinDate' class='block text-sm font-medium text-gray-700'>Join Date</label>
                                    <div class='mt-1'>
                                        <input type='text' id='joinDate' value='<fmt:formatDate value='${employee.joinDate}' pattern='MMM d, yyyy' />' disabled class='bg-gray-50 shadow-sm block w-full sm:text-sm border-gray-300 rounded-md'>
                                    </div>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='employeeId' class='block text-sm font-medium text-gray-700'>Employee ID</label>
                                    <div class='mt-1'>
                                        <input type='text' id='employeeId' value='${employee.id}' disabled class='bg-gray-50 shadow-sm block w-full sm:text-sm border-gray-300 rounded-md'>
                                    </div>
                                </div>
                            </div>

                            <div class='flex justify-end'>
                                <button type='submit' class='inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500'>
                                    Save Changes
                                </button>
                            </div>
                        </form>
                    </div>
                " />
            </jsp:include>
        </div>
    </div>

    <!-- Password Change Card -->
    <div class="mt-6">
        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
            <jsp:param name="icon" value="cog" />
            <jsp:param name="iconBgColor" value="gray" />
            <jsp:param name="title" value="Change Password" />
            <jsp:param name="content" value="
                <div class='mt-4'>
                    <form action='${pageContext.request.contextPath}/change-password' method='post' class='space-y-6'>
                        <div class='grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6'>
                            <div class='sm:col-span-6 md:col-span-2'>
                                <label for='currentPassword' class='block text-sm font-medium text-gray-700'>Current Password</label>
                                <div class='mt-1'>
                                    <input type='password' name='currentPassword' id='currentPassword' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md'>
                                </div>
                            </div>

                            <div class='sm:col-span-6 md:col-span-2'>
                                <label for='newPassword' class='block text-sm font-medium text-gray-700'>New Password</label>
                                <div class='mt-1'>
                                    <input type='password' name='newPassword' id='newPassword' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md'>
                                </div>
                            </div>

                            <div class='sm:col-span-6 md:col-span-2'>
                                <label for='confirmPassword' class='block text-sm font-medium text-gray-700'>Confirm New Password</label>
                                <div class='mt-1'>
                                    <input type='password' name='confirmPassword' id='confirmPassword' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md'>
                                </div>
                            </div>
                        </div>

                        <div class='flex justify-end'>
                            <button type='submit' class='inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-gray-600 hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500'>
                                Change Password
                            </button>
                        </div>
                    </form>
                </div>
            " />
        </jsp:include>
    </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
</jsp:include>
