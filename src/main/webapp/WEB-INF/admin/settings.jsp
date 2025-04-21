<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="System Settings" scope="request" />
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
        <h1 class="text-2xl font-semibold text-gray-900">System Settings</h1>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Theme Settings Card -->
        <div class="lg:col-span-1">
            <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                <jsp:param name="icon" value="cog" />
                <jsp:param name="iconBgColor" value="primary" />
                <jsp:param name="title" value="Theme Settings" />
                <jsp:param name="content" value="
                    <div class='mt-4'>
                        <form action='${pageContext.request.contextPath}/settings' method='post' class='space-y-6'>
                            <div class='space-y-4'>
                                <div>
                                    <label for='theme' class='block text-sm font-medium text-gray-700'>Theme Mode</label>
                                    <div class='mt-1'>
                                        <select id='theme' name='theme' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md'>
                                            <option value='light' ${settings.theme == 'light' ? 'selected' : ''}>Light Mode</option>
                                            <option value='dark' ${settings.theme == 'dark' ? 'selected' : ''}>Dark Mode</option>
                                            <option value='system' ${settings.theme == 'system' ? 'selected' : ''}>System Default</option>
                                        </select>
                                    </div>
                                    <p class='mt-2 text-sm text-gray-500'>Choose the theme mode for the application.</p>
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

        <!-- Email Settings Card -->
        <div class="lg:col-span-2">
            <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                <jsp:param name="icon" value="mail" />
                <jsp:param name="iconBgColor" value="blue" />
                <jsp:param name="title" value="Email Settings" />
                <jsp:param name="content" value="
                    <div class='mt-4'>
                        <form action='${pageContext.request.contextPath}/settings' method='post' class='space-y-6'>
                            <div class='grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6'>
                                <div class='sm:col-span-6'>
                                    <div class='flex items-center'>
                                        <input id='emailEnabled' name='emailEnabled' type='checkbox' ${settings.emailEnabled == 'true' ? 'checked' : ''} class='h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded'>
                                        <label for='emailEnabled' class='ml-2 block text-sm font-medium text-gray-700'>Enable Email Notifications</label>
                                    </div>
                                    <p class='mt-2 text-sm text-gray-500'>When enabled, the system will send email notifications for various events.</p>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='emailHost' class='block text-sm font-medium text-gray-700'>SMTP Host</label>
                                    <div class='mt-1'>
                                        <input type='text' name='emailHost' id='emailHost' value='${settings.emailHost}' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md'>
                                    </div>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='emailPort' class='block text-sm font-medium text-gray-700'>SMTP Port</label>
                                    <div class='mt-1'>
                                        <input type='text' name='emailPort' id='emailPort' value='${settings.emailPort}' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md'>
                                    </div>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='emailUsername' class='block text-sm font-medium text-gray-700'>Email Username</label>
                                    <div class='mt-1'>
                                        <input type='text' name='emailUsername' id='emailUsername' value='${settings.emailUsername}' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md'>
                                    </div>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='emailPassword' class='block text-sm font-medium text-gray-700'>Email Password</label>
                                    <div class='mt-1'>
                                        <input type='password' name='emailPassword' id='emailPassword' placeholder='••••••••' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md'>
                                    </div>
                                    <p class='mt-2 text-xs text-gray-500'>Leave blank to keep current password</p>
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

    <!-- System Information Card -->
    <div class="mt-6">
        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
            <jsp:param name="icon" value="chart" />
            <jsp:param name="iconBgColor" value="gray" />
            <jsp:param name="title" value="System Information" />
            <jsp:param name="content" value="
                <div class='mt-4'>
                    <div class='bg-gray-50 rounded-lg p-4'>
                        <div class='grid grid-cols-1 md:grid-cols-2 gap-4'>
                            <div>
                                <h3 class='text-sm font-medium text-gray-500'>Java Version</h3>
                                <p class='mt-1 text-sm text-gray-900'>${System.getProperty('java.version')}</p>
                            </div>
                            <div>
                                <h3 class='text-sm font-medium text-gray-500'>Operating System</h3>
                                <p class='mt-1 text-sm text-gray-900'>${System.getProperty('os.name')} ${System.getProperty('os.version')}</p>
                            </div>
                            <div>
                                <h3 class='text-sm font-medium text-gray-500'>Server Info</h3>
                                <p class='mt-1 text-sm text-gray-900'>${pageContext.servletContext.serverInfo}</p>
                            </div>
                            <div>
                                <h3 class='text-sm font-medium text-gray-500'>Database</h3>
                                <p class='mt-1 text-sm text-gray-900'>PostgreSQL</p>
                            </div>
                        </div>
                    </div>
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
