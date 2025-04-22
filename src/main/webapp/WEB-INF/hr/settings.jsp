<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Settings" scope="request" />
<c:set var="userRole" value="hr" scope="request" />

<c:set var="mainContent">
    <!-- Alerts are handled by layout.jsp -->

    <!-- Page title is displayed by layout.jsp -->

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <!-- Theme Settings Card -->
        <div class="lg:col-span-1">
            <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                <jsp:param name="icon" value="cog" />
                <jsp:param name="iconBgColor" value="primary" />
                <jsp:param name="title" value="Theme Settings" />
                <jsp:param name="content" value="
                    <div class='mt-4'>
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

                            <div class='flex justify-end'>
                                <button type='button' id='saveTheme' class='inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500'>
                                    Save Theme
                                </button>
                            </div>
                        </div>
                    </div>
                " />
            </jsp:include>
        </div>

        <!-- Notification Settings Card -->
        <div class="lg:col-span-1">
            <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
                <jsp:param name="icon" value="bell" />
                <jsp:param name="iconBgColor" value="purple" />
                <jsp:param name="title" value="Notification Settings" />
                <jsp:param name="content" value="
                    <div class='mt-4'>
                        <div class='space-y-4'>
                            <div class='flex items-center'>
                                <input id='emailNotifications' name='emailNotifications' type='checkbox' checked class='h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded'>
                                <label for='emailNotifications' class='ml-2 block text-sm font-medium text-gray-700'>Email Notifications</label>
                            </div>
                            <p class='text-sm text-gray-500'>Receive email notifications for leave requests, approvals, and other important updates.</p>

                            <div class='flex items-center'>
                                <input id='browserNotifications' name='browserNotifications' type='checkbox' checked class='h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded'>
                                <label for='browserNotifications' class='ml-2 block text-sm font-medium text-gray-700'>Browser Notifications</label>
                            </div>
                            <p class='text-sm text-gray-500'>Receive browser notifications when you're using the application.</p>

                            <div class='flex justify-end'>
                                <button type='button' id='saveNotifications' class='inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500'>
                                    Save Preferences
                                </button>
                            </div>
                        </div>
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
                    <div class='mt-4 text-sm text-gray-500'>
                        <p>For system-wide settings, please contact the administrator.</p>
                    </div>
                </div>
            " />
        </jsp:include>
    </div>

    <script>
        document.getElementById('saveTheme').addEventListener('click', function() {
            const theme = document.getElementById('theme').value;
            localStorage.setItem('theme', theme);
            applyTheme(theme);
            showToast('Theme settings saved successfully');
        });

        document.getElementById('saveNotifications').addEventListener('click', function() {
            const emailNotifications = document.getElementById('emailNotifications').checked;
            const browserNotifications = document.getElementById('browserNotifications').checked;
            localStorage.setItem('emailNotifications', emailNotifications);
            localStorage.setItem('browserNotifications', browserNotifications);
            showToast('Notification preferences saved successfully');
        });

        function showToast(message) {
            // Simple toast notification
            const toast = document.createElement('div');
            toast.className = 'fixed bottom-4 right-4 bg-green-500 text-white px-4 py-2 rounded shadow-lg';
            toast.textContent = message;
            document.body.appendChild(toast);
            setTimeout(() => {
                toast.remove();
            }, 3000);
        }

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

        // Initialize from localStorage
        window.addEventListener('DOMContentLoaded', function() {
            const savedTheme = localStorage.getItem('theme');
            if (savedTheme) {
                document.getElementById('theme').value = savedTheme;
            }

            const emailNotifications = localStorage.getItem('emailNotifications');
            if (emailNotifications !== null) {
                document.getElementById('emailNotifications').checked = emailNotifications === 'true';
            }

            const browserNotifications = localStorage.getItem('browserNotifications');
            if (browserNotifications !== null) {
                document.getElementById('browserNotifications').checked = browserNotifications === 'true';
            }
        });
    </script>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
</jsp:include>
