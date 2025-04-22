<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="System Settings" scope="request" />
<c:set var="userRole" value="admin" scope="request" />

<!-- Set variables for form fields -->
<c:set var="emailEnabledChecked" value="${settings.emailEnabled eq 'true' ? 'true' : 'false'}" />

<c:set var="mainContent">
    <!-- Alerts are handled by layout.jsp -->

    <!-- Page title is displayed by layout.jsp -->

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Theme Settings Card -->
        <div class="lg:col-span-1">
            <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                <jsp:param name="icon" value="cog" />
                <jsp:param name="iconBgColor" value="primary" />
                <jsp:param name="title" value="Theme Settings" />
                <jsp:param name="content" value="
                    <div class='mt-4'>
                        <form action='${pageContext.request.contextPath}/settings' method='post' class='space-y-6'>
                            <div class='grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6'>
                                <div class='sm:col-span-6'>
                                    <label for='theme' class='block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2'>Theme Mode</label>
                                    <div class='relative'>
                                        <select id='theme' name='theme' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700 appearance-none bg-white dark:bg-gray-700 pr-10 cursor-pointer'>
                                            <option value='light' ${settings.theme == 'light' ? 'selected' : ''}>Light Mode</option>
                                            <option value='dark' ${settings.theme == 'dark' ? 'selected' : ''}>Dark Mode</option>
                                            <option value='system' ${settings.theme == 'system' ? 'selected' : ''}>System Default</option>
                                        </select>
                                        <div class='pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-gray-500 dark:text-gray-400'>
                                            <svg class='h-5 w-5' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='currentColor' aria-hidden='true'>
                                                <path fill-rule='evenodd' d='M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z' clip-rule='evenodd' />
                                            </svg>
                                        </div>
                                    </div>
                                    <p class='mt-1 text-sm text-gray-500 dark:text-gray-400'>Choose the theme mode for the application.</p>
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
                                        <input id='emailEnabled' name='emailEnabled' type='checkbox' ${settings.emailEnabled == 'true' ? 'checked' : ''} class='h-5 w-5 text-primary-600 focus:ring-primary-500 focus:ring-offset-1 border-gray-300 dark:border-gray-600 rounded transition-all duration-200 ease-in-out cursor-pointer'>
                                        <label for='emailEnabled' class='ml-3 block text-sm font-medium text-gray-700 dark:text-gray-300 cursor-pointer'>Enable Email Notifications</label>
                                    </div>
                                    <p class='mt-1 text-sm text-gray-500 dark:text-gray-400'>When enabled, the system will send email notifications for various events.</p>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='emailHost' class='block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2'>SMTP Host</label>
                                    <div class='relative'>
                                        <input type='text' id='emailHost' name='emailHost' value='${settings.emailHost}' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700'>
                                    </div>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='emailPort' class='block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2'>SMTP Port</label>
                                    <div class='relative'>
                                        <input type='text' id='emailPort' name='emailPort' value='${settings.emailPort}' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700'>
                                    </div>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='emailUsername' class='block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2'>Email Username</label>
                                    <div class='relative'>
                                        <input type='text' id='emailUsername' name='emailUsername' value='${settings.emailUsername}' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700'>
                                    </div>
                                </div>

                                <div class='sm:col-span-3'>
                                    <label for='emailPassword' class='block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2'>Email Password</label>
                                    <div class='relative'>
                                        <input type='password' id='emailPassword' name='emailPassword' placeholder='••••••••' class='shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700'>
                                    </div>
                                    <p class='mt-1 text-sm text-gray-500 dark:text-gray-400'>Leave blank to keep current password</p>
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
    <div class="mt-10">
        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
            <jsp:param name="icon" value="chart" />
            <jsp:param name="iconBgColor" value="gray" />
            <jsp:param name="title" value="System Information" />
            <jsp:param name="content" value="
                <div class='mt-4'>
                    <div class='bg-gray-50 dark:bg-gray-800 rounded-lg p-4'>
                        <div class='grid grid-cols-1 md:grid-cols-2 gap-4'>
                            <div>
                                <h3 class='text-sm font-medium text-gray-500 dark:text-gray-400'>Java Version</h3>
                                <p class='mt-1 text-sm text-gray-900 dark:text-gray-200'>${System.getProperty('java.version')}</p>
                            </div>
                            <div>
                                <h3 class='text-sm font-medium text-gray-500 dark:text-gray-400'>Operating System</h3>
                                <p class='mt-1 text-sm text-gray-900 dark:text-gray-200'>${System.getProperty('os.name')} ${System.getProperty('os.version')}</p>
                            </div>
                            <div>
                                <h3 class='text-sm font-medium text-gray-500 dark:text-gray-400'>Server Info</h3>
                                <p class='mt-1 text-sm text-gray-900 dark:text-gray-200'>${pageContext.servletContext.serverInfo}</p>
                            </div>
                            <div>
                                <h3 class='text-sm font-medium text-gray-500 dark:text-gray-400'>Database</h3>
                                <p class='mt-1 text-sm text-gray-900 dark:text-gray-200'>PostgreSQL</p>
                            </div>
                        </div>
                    </div>
                </div>
            " />
        </jsp:include>
    </div>
</c:set>

<c:set var="additionalScripts">
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Add event listener to theme select
        const themeSelect = document.getElementById('theme');
        if (themeSelect) {
            themeSelect.addEventListener('change', function() {
                const theme = this.value;
                localStorage.setItem('theme', theme);
                applyTheme(theme);
            });

            // Set initial value from localStorage
            const savedTheme = localStorage.getItem('theme');
            if (savedTheme) {
                themeSelect.value = savedTheme;
            }
        }
    });

    function applyTheme(theme) {
        const htmlElement = document.documentElement;
        if (theme === 'dark' || (theme === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
            htmlElement.classList.add('dark');
            document.querySelectorAll('.theme-toggle #sunIcon').forEach(icon => icon.classList.remove('hidden'));
            document.querySelectorAll('.theme-toggle #moonIcon').forEach(icon => icon.classList.add('hidden'));
        } else {
            htmlElement.classList.remove('dark');
            document.querySelectorAll('.theme-toggle #sunIcon').forEach(icon => icon.classList.add('hidden'));
            document.querySelectorAll('.theme-toggle #moonIcon').forEach(icon => icon.classList.remove('hidden'));
        }
    }
</script>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="additionalScripts" value="${additionalScripts}" />
</jsp:include>
