<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="w-full px-3 py-3">
    <c:set var="headerGlassClasses">
        <jsp:include page="/WEB-INF/components/glassmorphism.jsp">
            <jsp:param name="type" value="header" />
            <jsp:param name="blur" value="lg" />
            <jsp:param name="opacity" value="10" />
            <jsp:param name="border" value="light" />
            <jsp:param name="shadow" value="md" />
            <jsp:param name="rounded" value="xl" />
        </jsp:include>
    </c:set>
    <div class="flex items-center justify-between px-6 py-3 w-full ${headerGlassClasses}">
        <div class="flex items-center md:hidden">
            <button type="button" class="text-gray-500 hover:text-gray-600 focus:outline-none focus:text-gray-600" id="mobile-menu-button">
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                </svg>
            </button>
        </div>
        <div class="text-xl font-bold text-white md:hidden">HRMS</div>
        <div class="flex items-center">
            <div class="relative">
                <button type="button" class="flex items-center max-w-xs text-sm rounded-full focus:outline-none focus:ring-2 focus:ring-white/50" id="user-menu-button">
                    <span class="mr-2 text-white font-medium">Welcome, ${username}</span>
                    <div class="h-10 w-10 rounded-full overflow-hidden border-2 border-white/30 bg-white/10 backdrop-blur-sm flex items-center justify-center">
                        <img class="h-9 w-9 rounded-full object-cover" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="Profile">
                    </div>
                </button>
                <!-- User dropdown menu -->
                <div class="hidden origin-top-right absolute right-0 mt-2 w-48 rounded-xl shadow-lg py-1 backdrop-blur-lg bg-white/20 border border-white/20" id="user-menu">
                    <a href="${pageContext.request.contextPath}/settings" class="block px-4 py-2 text-sm text-white hover:bg-white/20 transition-colors duration-200">Settings</a>
                    <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-sm text-white hover:bg-white/20 transition-colors duration-200">Logout</a>
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
