<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en" class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - HRMS</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <script>
        // Check if dark mode is enabled
        if (localStorage.getItem('darkMode') === 'true') {
            document.documentElement.classList.add('dark');
        }
    </script>
    <style>
        .dark {
            background-color: #1a202c;
            color: #e2e8f0;
        }
        .dark .bg-white {
            background-color: #2d3748 !important;
        }
        .dark .text-gray-900 {
            color: #e2e8f0 !important;
        }
        .dark .text-gray-600 {
            color: #cbd5e0 !important;
        }
        .dark .border-gray-300 {
            border-color: #4a5568 !important;
        }
    </style>
</head>
<body class="h-full">
    <div class="min-h-full flex flex-col justify-center py-12 sm:px-6 lg:px-8">
        <div class="sm:mx-auto sm:w-full sm:max-w-md">
            <img class="mx-auto h-12 w-auto" src="${pageContext.request.contextPath}/assets/img/logo.png" alt="HRMS Logo">
            <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
                Change Your Password
            </h2>
            <p class="mt-2 text-center text-sm text-gray-600">
                You need to change your password before you can continue
            </p>
        </div>

        <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
            <div class="backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 border border-blue-100/50 py-8 px-4 shadow sm:rounded-lg sm:px-10">
                <c:if test="${not empty errorMessage}">
                    <div class="mb-4 bg-red-50 border border-red-200 text-red-800 rounded-md p-4">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
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
                    <div>
                        <label for="newPassword" class="block text-sm font-medium text-gray-700">
                            New Password
                        </label>
                        <div class="mt-1">
                            <input id="newPassword" name="newPassword" type="password" required
                                   class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm">
                        </div>
                    </div>

                    <div>
                        <label for="confirmPassword" class="block text-sm font-medium text-gray-700">
                            Confirm New Password
                        </label>
                        <div class="mt-1">
                            <input id="confirmPassword" name="confirmPassword" type="password" required
                                   class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm">
                        </div>
                    </div>

                    <div>
                        <button type="submit"
                                class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                            Change Password
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
