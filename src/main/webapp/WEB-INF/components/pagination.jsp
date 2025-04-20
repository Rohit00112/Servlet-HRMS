<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 
Pagination Component:
<jsp:include page="/WEB-INF/components/pagination.jsp">
    <jsp:param name="currentPage" value="${currentPage}" />
    <jsp:param name="totalPages" value="${totalPages}" />
    <jsp:param name="baseUrl" value="/admin/employees" />
    <jsp:param name="queryParams" value="${not empty searchTerm ? '&search='.concat(searchTerm) : ''}" />
</jsp:include>
--%>

<c:if test="${param.totalPages > 1}">
    <div class="mt-6 flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6">
        <div class="flex flex-1 justify-between sm:hidden">
            <c:if test="${param.currentPage > 1}">
                <a href="${pageContext.request.contextPath}${param.baseUrl}?page=${param.currentPage - 1}${param.queryParams}" class="relative inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">Previous</a>
            </c:if>
            <c:if test="${param.currentPage < param.totalPages}">
                <a href="${pageContext.request.contextPath}${param.baseUrl}?page=${param.currentPage + 1}${param.queryParams}" class="relative ml-3 inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">Next</a>
            </c:if>
        </div>
        <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
            <div>
                <p class="text-sm text-gray-700">
                    Showing page <span class="font-medium">${param.currentPage}</span> of <span class="font-medium">${param.totalPages}</span>
                </p>
            </div>
            <div>
                <nav class="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
                    <c:if test="${param.currentPage > 1}">
                        <a href="${pageContext.request.contextPath}${param.baseUrl}?page=${param.currentPage - 1}${param.queryParams}" class="relative inline-flex items-center rounded-l-md px-2 py-2 text-gray-400 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0">
                            <span class="sr-only">Previous</span>
                            <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                <path fill-rule="evenodd" d="M12.79 5.23a.75.75 0 01-.02 1.06L8.832 10l3.938 3.71a.75.75 0 11-1.04 1.08l-4.5-4.25a.75.75 0 010-1.08l4.5-4.25a.75.75 0 011.06.02z" clip-rule="evenodd" />
                            </svg>
                        </a>
                    </c:if>
                    
                    <c:set var="startPage" value="${Math.max(1, param.currentPage - 2)}" />
                    <c:set var="endPage" value="${Math.min(param.totalPages, startPage + 4)}" />
                    <c:if test="${endPage - startPage < 4 && startPage > 1}">
                        <c:set var="startPage" value="${Math.max(1, endPage - 4)}" />
                    </c:if>
                    
                    <c:forEach var="i" begin="${startPage}" end="${endPage}">
                        <c:choose>
                            <c:when test="${i == param.currentPage}">
                                <span class="relative z-10 inline-flex items-center bg-primary-600 px-4 py-2 text-sm font-semibold text-white focus:z-20 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary-600">
                                    ${i}
                                </span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}${param.baseUrl}?page=${i}${param.queryParams}" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0">
                                    ${i}
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:if test="${param.currentPage < param.totalPages}">
                        <a href="${pageContext.request.contextPath}${param.baseUrl}?page=${param.currentPage + 1}${param.queryParams}" class="relative inline-flex items-center rounded-r-md px-2 py-2 text-gray-400 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0">
                            <span class="sr-only">Next</span>
                            <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                <path fill-rule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clip-rule="evenodd" />
                            </svg>
                        </a>
                    </c:if>
                </nav>
            </div>
        </div>
    </div>
</c:if>
