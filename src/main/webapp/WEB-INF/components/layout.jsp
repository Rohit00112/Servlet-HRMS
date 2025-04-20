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
<html>
<head>
    <title>HRMS - ${param.pageTitle}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
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
    <c:if test="${not empty param.additionalHead}">
        ${param.additionalHead}
    </c:if>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col">
    <div class="flex flex-1 overflow-hidden w-full">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/components/sidebar.jsp" />

        <!-- Main Content -->
        <div class="flex flex-col flex-1 overflow-hidden w-full max-w-full">
            <!-- Top Navigation -->
            <jsp:include page="/WEB-INF/components/header.jsp" />

            <!-- Main Content -->
            <main class="flex-1 overflow-y-auto py-6 px-6 w-full max-w-full">
                <div class="w-full max-w-full">
                    <!-- Page Title and Back Button -->
                    <c:if test="${not empty param.pageTitle}">
                        <div class="flex items-center justify-between">
                            <h1 class="text-2xl font-semibold text-gray-900">${param.pageTitle}</h1>
                            <c:if test="${not empty param.backUrl}">
                                <a href="${pageContext.request.contextPath}${param.backUrl}" class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md shadow-sm text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                                    <svg class="-ml-1 mr-2 h-5 w-5 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
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

            <!-- Footer -->
            <jsp:include page="/WEB-INF/components/footer.jsp" />
        </div>
    </div>

    <!-- Additional Scripts -->
    <c:if test="${not empty param.additionalScripts}">
        ${param.additionalScripts}
    </c:if>
</body>
</html>
