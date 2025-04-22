<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="mt-6">
    <form action="${pageContext.request.contextPath}${searchUrl}" method="get" class="flex w-full md:w-1/2 space-x-3">
        <div class="flex-grow">
            <div class="relative rounded-lg shadow-md">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
                    </svg>
                </div>
                <input type="text" name="search" value="${searchTerm}" placeholder="${searchPlaceholder}" class="block w-full pl-10 pr-4 py-3 border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg shadow-sm placeholder-gray-400 dark:placeholder-gray-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700">
            </div>
        </div>
        <button type="submit" class="inline-flex items-center px-5 py-3 border border-transparent text-sm font-medium rounded-lg shadow-md text-white bg-gradient-to-r from-primary-500 to-primary-600 hover:from-primary-600 hover:to-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transform transition-all duration-200 hover:translate-y-[-1px] hover:shadow-lg active:translate-y-[1px]">
            Search
        </button>
        <c:if test="${not empty searchTerm}">
            <a href="${pageContext.request.contextPath}${searchUrl}" class="inline-flex items-center px-5 py-3 border border-gray-300 dark:border-gray-600 text-sm font-medium rounded-lg shadow-md text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transform transition-all duration-200 hover:translate-y-[-1px] hover:shadow-lg active:translate-y-[1px]">
                Clear
            </a>
        </c:if>
    </form>
</div>
