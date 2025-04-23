<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="bg-white shadow-sm w-full">
    <div class="flex items-center justify-between px-4 sm:px-6 py-3 w-full">
        <div class="flex items-center md:hidden">
            <button type="button" class="text-gray-500 hover:text-gray-600 focus:outline-none focus:text-gray-600" id="mobile-menu-button" aria-label="Open menu">
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                </svg>
            </button>
        </div>
        <div class="text-xl font-bold text-gray-800 md:hidden">HRMS</div>
        <div class="flex items-center space-x-2 sm:space-x-4">
            <!-- Theme Toggle Button -->
            <jsp:include page="/WEB-INF/components/theme-toggle.jsp" />

            <!-- Notification Bell -->
            <jsp:include page="/WEB-INF/components/notification-bell.jsp" />

            <div class="relative">
                <button type="button" class="flex items-center max-w-xs text-sm rounded-full focus:outline-none focus:shadow-outline" id="user-menu-button" aria-label="User menu">
                    <span class="hidden sm:inline mr-2 text-gray-700">Welcome, ${username}</span>
                    <img class="h-8 w-8 rounded-full object-cover" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="Profile">
                </button>
                <!-- User dropdown menu -->
                <div class="hidden origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg py-1 bg-white dark:bg-gray-800 ring-1 ring-black ring-opacity-5 z-10" id="user-menu">
                    <div class="block px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-200 border-b border-gray-200 dark:border-gray-700 sm:hidden">Welcome, ${username}</div>
                    <a href="${pageContext.request.contextPath}/profile" class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700">My Profile</a>
                    <a href="${pageContext.request.contextPath}/settings" class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700">Settings</a>
                    <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700">Logout</a>
                </div>
            </div>
        </div>
    </div>
</header>

<!-- Include Mobile Sidebar -->
<jsp:include page="/WEB-INF/components/mobile-sidebar.jsp" />

<script>
    // Toggle user dropdown menu
    document.getElementById('user-menu-button').addEventListener('click', function() {
        document.getElementById('user-menu').classList.toggle('hidden');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function(event) {
        const userMenu = document.getElementById('user-menu');
        const userMenuButton = document.getElementById('user-menu-button');

        if (!userMenuButton.contains(event.target) && !userMenu.contains(event.target)) {
            userMenu.classList.add('hidden');
        }
    });

    // Mobile menu toggle
    document.getElementById('mobile-menu-button').addEventListener('click', function() {
        document.getElementById('mobile-sidebar').style.display = 'flex';
    });

    // Close mobile sidebar
    document.getElementById('close-mobile-sidebar').addEventListener('click', function() {
        document.getElementById('mobile-sidebar').style.display = 'none';
    });

    // Close mobile sidebar when clicking on backdrop
    document.getElementById('mobile-sidebar-backdrop').addEventListener('click', function() {
        document.getElementById('mobile-sidebar').style.display = 'none';
    });
</script>
