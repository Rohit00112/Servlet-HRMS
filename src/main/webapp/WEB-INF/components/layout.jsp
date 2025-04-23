<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Layout Component Usage:

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="Page Title" />
    <jsp:param name="backUrl" value="/back/url" />
    <jsp:param name="backLabel" value="Back" />
    <jsp:param name="additionalHead" value="<script>...</script>" />
    <jsp:param name="additionalScripts" value="<script>...</script>" />
    <jsp:param name="mainContent" value="Main content goes here" />
</jsp:include>
--%>

<!DOCTYPE html>
<html class="light">
<head>
    <title>HRMS - ${param.pageTitle}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="theme-color" content="#0ea5e9">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'sans-serif'],
                    },
                    colors: {
                        primary: {
                            50: '#f0f9ff',
                            100: '#e0f2fe',
                            200: '#bae6fd',
                            300: '#7dd3fc',
                            400: '#38bdf8',
                            500: '#0ea5e9',
                            600: '#0284c7',
                            700: '#0369a1',
                            800: '#075985',
                            900: '#0c4a6e',
                        }
                    },
                    screens: {
                        'xs': '475px',
                    }
                }
            }
        }
    </script>
    <style>
        /* Dark mode styles */
        .dark {
            color-scheme: dark;
        }
        .dark body {
            background-color: #111827;
            color: #f9fafb;
            background-image: url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiPjxkZWZzPjxwYXR0ZXJuIGlkPSJwYXR0ZXJuXzAiIHBhdHRlcm5Vbml0cz0idXNlclNwYWNlT25Vc2UiIHdpZHRoPSIxMCIgaGVpZ2h0PSIxMCIgcGF0dGVyblRyYW5zZm9ybT0icm90YXRlKDQ1KSI+PHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjUiIGhlaWdodD0iNSIgZmlsbD0icmdiYSg1MCw1MCw1MCwwLjA1KSIvPjwvcGF0dGVybj48L2RlZnM+PHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0iIzExMTgyNyIvPjxyZWN0IHg9IjAiIHk9IjAiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9InVybCgjcGF0dGVybl8wKSIvPjwvc3ZnPg==');
        }
        .dark .bg-white {
            background-color: #1f2937;
        }
        .dark .text-gray-700 {
            color: #e5e7eb;
        }
        .dark .text-gray-500 {
            color: #9ca3af;
        }
        .dark .text-gray-400 {
            color: #d1d5db;
        }
        .dark .text-gray-300 {
            color: #e5e7eb;
        }
        .dark .text-gray-900 {
            color: #f9fafb;
        }
        .dark .border-gray-200 {
            border-color: #374151;
        }
        .dark .shadow-sm {
            --tw-shadow-color: rgba(0, 0, 0, 0.3);
        }
        .dark .bg-gray-50 {
            background-color: #374151;
        }
        .dark .bg-gray-100 {
            background-color: #1f2937;
        }
        /* Form elements in dark mode */
        .dark input, .dark select, .dark textarea {
            background-color: #374151;
            border-color: #4b5563;
            color: #f9fafb;
        }
        .dark input:disabled, .dark select:disabled, .dark textarea:disabled {
            background-color: #1f2937;
            color: #9ca3af;
        }
        /* Buttons in dark mode */
        .dark .bg-primary-600 {
            background-color: #0284c7;
        }
        .dark .bg-primary-600:hover {
            background-color: #0369a1;
        }
        /* Hover states in dark mode */
        .dark a:hover, .dark button:hover {
            color: #f9fafb;
        }
        .dark .hover\:text-gray-900:hover {
            color: #f9fafb !important;
        }
        .dark .hover\:text-gray-700:hover {
            color: #f3f4f6 !important;
        }
        .dark .hover\:text-gray-500:hover {
            color: #e5e7eb !important;
        }
        /* Glassmorphism in dark mode */
        .dark .backdrop-blur-md.bg-blue-50\/80 {
            background-color: rgba(30, 41, 59, 0.8);
        }
        .dark .backdrop-blur-md.bg-blue-50\/70 {
            background-color: rgba(30, 41, 59, 0.7);
        }
        .dark .backdrop-blur-md.bg-blue-50\/80:hover,
        .dark .backdrop-blur-md.bg-blue-50\/70:hover {
            background-color: rgba(30, 41, 59, 0.9);
        }
    </style>
    <c:if test="${not empty param.additionalHead}">
        ${param.additionalHead}
    </c:if>
</head>
<body class="min-h-screen flex flex-col bg-fixed bg-white touch-manipulation" style="background-image: url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiPjxkZWZzPjxwYXR0ZXJuIGlkPSJwYXR0ZXJuXzAiIHBhdHRlcm5Vbml0cz0idXNlclNwYWNlT25Vc2UiIHdpZHRoPSIxMCIgaGVpZ2h0PSIxMCIgcGF0dGVyblRyYW5zZm9ybT0icm90YXRlKDQ1KSI+PHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjUiIGhlaWdodD0iNSIgZmlsbD0icmdiYSgyMDAsMjE1LDI1MCwwLjA1KSIvPjwvcGF0dGVybj48L2RlZnM+PHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48cmVjdCB4PSIwIiB5PSIwIiB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJ1cmwoI3BhdHRlcm5fMCkiLz48L3N2Zz4='); background-size: cover; background-position: center; background-attachment: fixed;">
    <div class="flex flex-1 w-full">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/components/sidebar.jsp" />

        <!-- Main Content -->
        <div class="flex flex-col flex-1 w-full">
            <!-- Top Navigation -->
            <jsp:include page="/WEB-INF/components/header.jsp" />

            <!-- Main Content -->
            <main class="flex-1 overflow-y-auto py-4 px-4 sm:py-6 sm:px-6 w-full">
                <div class="w-full max-w-7xl mx-auto">
                    <!-- Page Title and Back Button -->
                    <c:if test="${not empty param.pageTitle}">
                        <div class="flex flex-col xs:flex-row items-start xs:items-center justify-between mb-6 sm:mb-8 gap-4">
                            <h1 class="text-xl sm:text-2xl font-semibold text-gray-700 dark:text-white backdrop-blur-md bg-blue-50/80 dark:bg-gray-800/80 inline-block px-3 py-1.5 sm:px-4 sm:py-2 rounded-lg shadow-sm border border-blue-100/50 dark:border-gray-700/50">${param.pageTitle}</h1>
                            <c:if test="${not empty param.backUrl}">
                                <a href="${pageContext.request.contextPath}${param.backUrl}" class="inline-flex items-center px-3 py-1.5 sm:px-4 sm:py-2 border border-blue-100/50 dark:border-gray-700/50 text-sm font-medium rounded-md shadow-sm text-gray-700 dark:text-gray-200 backdrop-blur-md bg-blue-50/70 dark:bg-gray-800/70 hover:bg-blue-50/90 dark:hover:bg-gray-800/90 transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                                    <svg class="-ml-1 mr-2 h-5 w-5 text-gray-500 dark:text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                                    </svg>
                                    ${param.backLabel}
                                </a>
                            </c:if>
                        </div>
                    </c:if>

                    <!-- Alerts -->
                    <jsp:include page="/WEB-INF/components/alerts.jsp" />

                    <!-- Main Content -->
                    ${param.mainContent}
                </div>
            </main>


        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/components/footer.jsp" />

    <!-- Modals -->
    <c:if test="${not empty param.modals}">
        ${param.modals}
    </c:if>

    <!-- Additional Scripts -->
    <c:if test="${not empty param.additionalScripts}">
        ${param.additionalScripts}
    </c:if>
</body>
</html>
