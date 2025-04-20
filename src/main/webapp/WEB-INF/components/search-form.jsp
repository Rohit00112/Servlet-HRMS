<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="mt-6">
    <form action="${pageContext.request.contextPath}${searchUrl}" method="get" class="flex w-full md:w-1/2 space-x-2">
        <div class="flex-grow">
            <input type="text" name="search" value="${searchTerm}" placeholder="${searchPlaceholder}" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500">
        </div>
        <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
            Search
        </button>
        <c:if test="${not empty searchTerm}">
            <a href="${pageContext.request.contextPath}${searchUrl}" class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md shadow-sm text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                Clear
            </a>
        </c:if>
    </form>
</div>
