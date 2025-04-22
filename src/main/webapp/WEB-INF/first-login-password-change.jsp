<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html class="light">
<head>
    <title>HRMS - Change Password</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
    </style>
    <script>
        // Check if dark mode is enabled
        if (localStorage.getItem('darkMode') === 'true') {
            document.documentElement.classList.add('dark');
        }
    </script>
</head>
<body class="min-h-screen flex flex-col bg-fixed bg-white" style="background-image: url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiPjxkZWZzPjxwYXR0ZXJuIGlkPSJwYXR0ZXJuXzAiIHBhdHRlcm5Vbml0cz0idXNlclNwYWNlT25Vc2UiIHdpZHRoPSIxMCIgaGVpZ2h0PSIxMCIgcGF0dGVyblRyYW5zZm9ybT0icm90YXRlKDQ1KSI+PHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjUiIGhlaWdodD0iNSIgZmlsbD0icmdiYSgyMDAsMjE1LDI1MCwwLjA1KSIvPjwvcGF0dGVybj48L2RlZnM+PHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48cmVjdCB4PSIwIiB5PSIwIiB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJ1cmwoI3BhdHRlcm5fMCkiLz48L3N2Zz4='); background-size: cover; background-position: center; background-attachment: fixed;">
    <div class="min-h-screen flex flex-col justify-center py-12 sm:px-6 lg:px-8">
        <div class="sm:mx-auto sm:w-full sm:max-w-md">
            <img class="mx-auto h-16 w-auto" src="${pageContext.request.contextPath}/assets/img/logo.png" alt="HRMS Logo">
            <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900 dark:text-white">
                Change Your Password
            </h2>
            <p class="mt-2 text-center text-sm text-gray-600 dark:text-gray-400">
                You need to change your password before you can continue
            </p>
        </div>

        <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
            <div class="backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 dark:from-gray-800/80 dark:to-gray-900/80 border border-blue-100/50 dark:border-gray-700/50 rounded-xl shadow-lg p-7 hover:shadow-xl transition-all duration-300 hover:from-blue-50/90 hover:to-indigo-50/90 dark:hover:from-gray-700/90 dark:hover:to-gray-800/90">
                <c:if test="${not empty errorMessage}">
                    <div class="mb-6 bg-red-50 dark:bg-red-900/30 border border-red-200 dark:border-red-800/50 text-red-800 dark:text-red-300 rounded-lg p-4">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <svg class="h-5 w-5 text-red-400 dark:text-red-300" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                                </svg>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium">${errorMessage}</p>
                            </div>
                        </div>
                    </div>
                </c:if>

                <form class="space-y-6" action="${pageContext.request.contextPath}/first-login-password-change" method="POST">
                    <div class="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                        <div class="sm:col-span-6">
                            <label for="newPassword" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                                New Password <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <input
                                    type="password"
                                    id="newPassword"
                                    name="newPassword"
                                    required
                                    class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700"
                                >
                            </div>
                        </div>

                        <div class="sm:col-span-6">
                            <label for="confirmPassword" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                                Confirm New Password <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <input
                                    type="password"
                                    id="confirmPassword"
                                    name="confirmPassword"
                                    required
                                    class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700"
                                >
                            </div>
                        </div>
                    </div>

                    <div class="pt-4">
                        <button type="submit"
                                class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200">
                            Change Password
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
