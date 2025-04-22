<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html class="light">
<head>
    <title>HRMS - Forgot Password</title>
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
        .dark .border-gray-300 {
            border-color: #4b5563;
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
    </style>
</head>
<body class="bg-slate-50 dark:bg-gray-900 min-h-screen flex">
    <!-- Left side with image -->
    <div class="hidden lg:block lg:w-1/2 relative">
        <div class="absolute inset-0 bg-gradient-to-r from-primary-600 to-primary-800 opacity-90"></div>
        <img src="https://images.unsplash.com/photo-1497215728101-856f4ea42174?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80"
             alt="Office" class="h-full w-full object-cover">
        <div class="absolute inset-0 flex flex-col items-center justify-center text-white p-12">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 mb-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
            </svg>
            <h1 class="text-4xl font-bold mb-3">Password Reset</h1>
            <p class="text-xl opacity-90 text-center">We'll help you get back into your account</p>
        </div>
    </div>

    <!-- Right side with form -->
    <div class="w-full lg:w-1/2 flex items-center justify-center p-6 sm:p-12 relative">
        <!-- Theme Toggle Button -->
        <div class="absolute top-4 right-4">
            <button id="themeToggleBtn" class="flex items-center justify-center w-8 h-8 rounded-full focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 hover:bg-gray-100 dark:hover:bg-gray-700" aria-label="Toggle theme">
                <!-- Sun icon (for dark mode) -->
                <svg id="sunIcon" class="h-5 w-5 text-gray-500 dark:text-gray-300 hidden" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
                <!-- Moon icon (for light mode) -->
                <svg id="moonIcon" class="h-5 w-5 text-gray-500 dark:text-gray-300" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
                </svg>
            </button>
        </div>
        <div class="w-full max-w-md">
            <div class="flex justify-center lg:hidden mb-10">
                <div class="bg-primary-600 p-3 rounded-full">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
                    </svg>
                </div>
            </div>

            <h1 class="text-3xl font-bold text-gray-800 dark:text-white mb-2 text-center">Forgot Password</h1>
            <p class="text-gray-600 dark:text-gray-300 mb-8 text-center">Enter your email address or username to reset your password</p>

            <c:if test="${not empty error}">
                <div class="mb-6 bg-red-50 border-l-4 border-red-500 text-red-700 p-4 rounded-r-md" role="alert">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <svg class="h-5 w-5 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                            </svg>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm">${error}</p>
                        </div>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="mb-6 bg-green-50 border-l-4 border-green-500 text-green-700 p-4 rounded-r-md" role="alert">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <svg class="h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                            </svg>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm">${success}</p>
                        </div>
                    </div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="space-y-6">
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Reset Password Using</label>
                    <div class="flex space-x-4">
                        <div class="flex items-center">
                            <input type="radio" id="reset-email" name="reset-method" value="email" checked
                                   class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 dark:border-gray-600 rounded"
                                   onclick="toggleResetMethod('email')">
                            <label for="reset-email" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">Email</label>
                        </div>
                        <div class="flex items-center">
                            <input type="radio" id="reset-username" name="reset-method" value="username"
                                   class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 dark:border-gray-600 rounded"
                                   onclick="toggleResetMethod('username')">
                            <label for="reset-username" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">Username</label>
                        </div>
                    </div>
                </div>

                <div id="email-field">
                    <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Email Address</label>
                    <div class="mt-1 relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                            </svg>
                        </div>
                        <input type="email" id="email" name="email"
                               class="block w-full pl-10 pr-3 py-3 border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition duration-150 ease-in-out">
                    </div>
                </div>

                <div id="username-field" class="hidden">
                    <label for="username" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Username</label>
                    <div class="mt-1 relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                            </svg>
                        </div>
                        <input type="text" id="username" name="username"
                               class="block w-full pl-10 pr-3 py-3 border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition duration-150 ease-in-out">
                    </div>
                </div>

                <div>
                    <button type="submit"
                            class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition duration-150 ease-in-out">
                        Reset Password
                    </button>
                </div>
            </form>

            <div class="mt-6 text-center">
                <a href="${pageContext.request.contextPath}/login" class="text-sm font-medium text-primary-600 hover:text-primary-500 dark:text-primary-400 dark:hover:text-primary-300">
                    Back to Login
                </a>
            </div>
        </div>
    </div>
    <!-- Theme Toggle Script -->
    <script>
        // Check for saved theme preference or use system preference
        const savedTheme = localStorage.getItem('theme');

        // Function to set the theme
        function setTheme(theme) {
            if (theme === 'dark' || (theme === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.classList.add('dark');
                document.getElementById('sunIcon').classList.remove('hidden');
                document.getElementById('moonIcon').classList.add('hidden');
            } else {
                document.documentElement.classList.remove('dark');
                document.getElementById('sunIcon').classList.add('hidden');
                document.getElementById('moonIcon').classList.remove('hidden');
            }
        }

        // Set initial theme
        setTheme(savedTheme || 'light');

        // Toggle theme when button is clicked
        document.getElementById('themeToggleBtn').addEventListener('click', function() {
            const isDark = document.documentElement.classList.contains('dark');
            const newTheme = isDark ? 'light' : 'dark';
            localStorage.setItem('theme', newTheme);
            setTheme(newTheme);
        });

        // Listen for system theme changes
        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function(e) {
            if (localStorage.getItem('theme') === 'system') {
                setTheme('system');
            }
        });

        // Function to toggle between email and username fields
        function toggleResetMethod(method) {
            const emailField = document.getElementById('email-field');
            const usernameField = document.getElementById('username-field');
            const emailInput = document.getElementById('email');
            const usernameInput = document.getElementById('username');

            if (method === 'email') {
                emailField.classList.remove('hidden');
                usernameField.classList.add('hidden');
                emailInput.setAttribute('required', '');
                usernameInput.removeAttribute('required');
            } else {
                emailField.classList.add('hidden');
                usernameField.classList.remove('hidden');
                emailInput.removeAttribute('required');
                usernameInput.setAttribute('required', '');
            }
        }
    </script>
</body>
</html>
