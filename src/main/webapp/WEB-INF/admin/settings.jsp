<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="System Settings" scope="request" />
<c:set var="userRole" value="admin" scope="request" />

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
                            <div class='space-y-4'>
                                <jsp:include page='/WEB-INF/components/form-field.jsp'>
                                    <jsp:param name='type' value='select' />
                                    <jsp:param name='name' value='theme' />
                                    <jsp:param name='label' value='Theme Mode' />
                                    <jsp:param name='helpText' value='Choose the theme mode for the application.' />
                                    <jsp:param name='colSpan' value='6' />
                                    <jsp:param name='options' value='themeOptions' />
                                    <jsp:param name='optionValue' value='value' />
                                    <jsp:param name='optionText' value='text' />
                                    <jsp:param name='selectedValue' value='${settings.theme}' />
                                </jsp:include>
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
                                <jsp:include page='/WEB-INF/components/form-field.jsp'>
                                    <jsp:param name='type' value='checkbox' />
                                    <jsp:param name='name' value='emailEnabled' />
                                    <jsp:param name='label' value='Enable Email Notifications' />
                                    <jsp:param name='checked' value='${settings.emailEnabled eq "true"}' />
                                    <jsp:param name='helpText' value='When enabled, the system will send email notifications for various events.' />
                                    <jsp:param name='colSpan' value='6' />
                                </jsp:include>

                                <jsp:include page='/WEB-INF/components/form-field.jsp'>
                                    <jsp:param name='type' value='text' />
                                    <jsp:param name='name' value='emailHost' />
                                    <jsp:param name='label' value='SMTP Host' />
                                    <jsp:param name='value' value='${settings.emailHost}' />
                                    <jsp:param name='colSpan' value='3' />
                                </jsp:include>

                                <jsp:include page='/WEB-INF/components/form-field.jsp'>
                                    <jsp:param name='type' value='text' />
                                    <jsp:param name='name' value='emailPort' />
                                    <jsp:param name='label' value='SMTP Port' />
                                    <jsp:param name='value' value='${settings.emailPort}' />
                                    <jsp:param name='colSpan' value='3' />
                                </jsp:include>

                                <jsp:include page='/WEB-INF/components/form-field.jsp'>
                                    <jsp:param name='type' value='text' />
                                    <jsp:param name='name' value='emailUsername' />
                                    <jsp:param name='label' value='Email Username' />
                                    <jsp:param name='value' value='${settings.emailUsername}' />
                                    <jsp:param name='colSpan' value='3' />
                                </jsp:include>

                                <jsp:include page='/WEB-INF/components/form-field.jsp'>
                                    <jsp:param name='type' value='password' />
                                    <jsp:param name='name' value='emailPassword' />
                                    <jsp:param name='label' value='Email Password' />
                                    <jsp:param name='placeholder' value='••••••••' />
                                    <jsp:param name='helpText' value='Leave blank to keep current password' />
                                    <jsp:param name='colSpan' value='3' />
                                </jsp:include>
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
