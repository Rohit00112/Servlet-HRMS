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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Poppins', 'sans-serif'],
                    },
                    colors: {
                        primary: {
                            50: '#f0f7ff',
                            100: '#e0eefe',
                            200: '#bae0fd',
                            300: '#90cafc',
                            400: '#5eacf9',
                            500: '#3b8ef3',
                            600: '#2570e3',
                            700: '#1d5bce',
                            800: '#1c4aa6',
                            900: '#1c4183',
                        },
                        secondary: {
                            50: '#f5f3ff',
                            100: '#ede9fe',
                            200: '#ddd6fe',
                            300: '#c4b5fd',
                            400: '#a78bfa',
                            500: '#8b5cf6',
                            600: '#7c3aed',
                            700: '#6d28d9',
                            800: '#5b21b6',
                            900: '#4c1d95',
                        },
                        accent: {
                            50: '#f0fdfa',
                            100: '#ccfbf1',
                            200: '#99f6e4',
                            300: '#5eead4',
                            400: '#2dd4bf',
                            500: '#14b8a6',
                            600: '#0d9488',
                            700: '#0f766e',
                            800: '#115e59',
                            900: '#134e4a',
                        }
                    },
                    backdropBlur: {
                        xs: '2px',
                    },
                    animation: {
                        'gradient-x': 'gradient-x 15s ease infinite',
                        'gradient-y': 'gradient-y 15s ease infinite',
                        'gradient-xy': 'gradient-xy 15s ease infinite',
                    },
                    keyframes: {
                        'gradient-y': {
                            '0%, 100%': {
                                'background-size': '400% 400%',
                                'background-position': 'center top'
                            },
                            '50%': {
                                'background-size': '200% 200%',
                                'background-position': 'center center'
                            }
                        },
                        'gradient-x': {
                            '0%, 100%': {
                                'background-size': '200% 200%',
                                'background-position': 'left center'
                            },
                            '50%': {
                                'background-size': '200% 200%',
                                'background-position': 'right center'
                            }
                        },
                        'gradient-xy': {
                            '0%, 100%': {
                                'background-size': '400% 400%',
                                'background-position': 'left center'
                            },
                            '50%': {
                                'background-size': '200% 200%',
                                'background-position': 'right center'
                            }
                        }
                    }
                }
            }
        }
    </script>
    <style>
        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        ::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
        }
        ::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.3);
            border-radius: 10px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.5);
        }

        /* Gradient animations */
        .animate-gradient-x {
            background-size: 200% 200%;
            animation: gradient-x 15s ease infinite;
        }
        .animate-gradient-y {
            background-size: 200% 200%;
            animation: gradient-y 15s ease infinite;
        }
        .animate-gradient-xy {
            background-size: 400% 400%;
            animation: gradient-xy 15s ease infinite;
        }
    </style>
    <c:if test="${not empty param.additionalHead}">
        ${param.additionalHead}
    </c:if>
</head>
<body class="min-h-screen bg-gradient-to-br from-primary-900 via-secondary-800 to-accent-900 animate-gradient-xy overflow-hidden">
    <div class="absolute inset-0 bg-[url('https://grainy-gradients.vercel.app/noise.svg')] opacity-[0.15] pointer-events-none"></div>
    <div class="flex h-screen overflow-hidden w-full relative z-10">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/components/sidebar.jsp" />

        <!-- Main Content -->
        <div class="flex flex-col flex-1 overflow-hidden w-full max-w-full">
            <!-- Top Navigation -->
            <jsp:include page="/WEB-INF/components/header.jsp" />

            <!-- Main Content -->
            <main class="flex-1 overflow-y-auto py-6 px-6 w-full max-w-full">
                <div class="w-full max-w-full relative">
                    <!-- Page Title and Back Button -->
                    <c:if test="${not empty param.pageTitle}">
                        <div class="flex items-center justify-between mb-6">
                            <div>
                                <h1 class="text-3xl font-bold text-white">${param.pageTitle}</h1>
                                <div class="h-1 w-20 bg-gradient-to-r from-primary-500 to-secondary-500 rounded-full mt-2"></div>
                            </div>
                            <c:if test="${not empty param.backUrl}">
                                <a href="${pageContext.request.contextPath}${param.backUrl}" class="inline-flex items-center px-4 py-2 border border-white/20 text-sm font-medium rounded-lg shadow-lg text-white bg-white/10 backdrop-blur-md hover:bg-white/20 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-white/30">
                                    <svg class="-ml-1 mr-2 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
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
