<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Data Table Component Usage:

<jsp:include page="/WEB-INF/components/data-table.jsp">
    <jsp:param name="tableId" value="employeesTable" />
    <jsp:param name="title" value="Employees List" />
    <jsp:param name="description" value="Showing all employees" />
    <jsp:param name="columns" value="Name,Email,Department,Status,Actions" />
    <jsp:param name="data" value="${employeesList}" />
    <jsp:param name="emptyMessage" value="No employees found" />
    <jsp:param name="searchable" value="true" />
    <jsp:param name="sortable" value="true" />
    <jsp:param name="pagination" value="true" />
    <jsp:param name="currentPage" value="${currentPage}" />
    <jsp:param name="totalPages" value="${totalPages}" />
    <jsp:param name="pageSize" value="${pageSize}" />
    <jsp:param name="baseUrl" value="/admin/employees" />
</jsp:include>

Then add your table body content after including the component:

<jsp:attribute name="tableBody">
    <c:forEach var="employee" items="${employeesList}">
        <tr>
            <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center">
                    <div class="flex-shrink-0 h-10 w-10">
                        <img class="h-10 w-10 rounded-full" src="..." alt="">
                    </div>
                    <div class="ml-4">
                        <div class="text-sm font-medium text-gray-900">${employee.name}</div>
                        <div class="text-sm text-gray-500">${employee.id}</div>
                    </div>
                </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900">${employee.email}</div>
            </td>
            <!-- More cells... -->
        </tr>
    </c:forEach>
</jsp:attribute>
--%>

<c:set var="tableId" value="${param.tableId}" />
<c:set var="title" value="${param.title}" />
<c:set var="description" value="${param.description}" />
<c:set var="columns" value="${param.columns}" />
<c:set var="emptyMessage" value="${param.emptyMessage}" />
<c:set var="searchable" value="${param.searchable}" />
<c:set var="sortable" value="${param.sortable}" />
<c:set var="pagination" value="${param.pagination}" />
<c:set var="currentPage" value="${param.currentPage}" />
<c:set var="totalPages" value="${param.totalPages}" />
<c:set var="pageSize" value="${param.pageSize}" />
<c:set var="baseUrl" value="${param.baseUrl}" />

<%-- Default values --%>
<c:if test="${empty tableId}">
    <c:set var="tableId" value="dataTable-${System.currentTimeMillis()}" />
</c:if>
<c:if test="${empty emptyMessage}">
    <c:set var="emptyMessage" value="No data found" />
</c:if>
<c:if test="${empty searchable}">
    <c:set var="searchable" value="false" />
</c:if>
<c:if test="${empty sortable}">
    <c:set var="sortable" value="false" />
</c:if>
<c:if test="${empty pagination}">
    <c:set var="pagination" value="false" />
</c:if>

<div class="bg-white shadow overflow-hidden sm:rounded-lg">
    <c:if test="${not empty title}">
        <div class="px-4 py-5 sm:px-6 bg-gray-50 flex justify-between items-center">
            <div>
                <h3 class="text-lg leading-6 font-medium text-gray-900">${title}</h3>
                <c:if test="${not empty description}">
                    <p class="mt-1 max-w-2xl text-sm text-gray-500">${description}</p>
                </c:if>
            </div>
            
            <c:if test="${searchable eq 'true'}">
                <div class="relative">
                    <input type="text" id="${tableId}-search" 
                           placeholder="Search..." 
                           class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"
                           onkeyup="searchTable('${tableId}')">
                    <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                        <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                        </svg>
                    </div>
                </div>
            </c:if>
        </div>
    </c:if>
    
    <div class="border-t border-gray-200">
        <div class="overflow-x-auto">
            <table id="${tableId}" class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <c:forTokens items="${columns}" delims="," var="column">
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider ${sortable eq 'true' ? 'cursor-pointer' : ''}"
                                ${sortable eq 'true' ? 'onclick="sortTable(\'' += tableId += '\', ' += columnIndex += ')"' : ''}>
                                ${column}
                                <c:if test="${sortable eq 'true'}">
                                    <span class="sort-icon ml-1 inline-block">
                                        <svg class="h-4 w-4 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" />
                                        </svg>
                                    </span>
                                </c:if>
                            </th>
                        </c:forTokens>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    <jsp:doBody />
                    
                    <tr id="${tableId}-empty-row" class="hidden">
                        <td colspan="${fn:length(fn:split(columns, ','))}" class="px-6 py-4 text-center text-sm text-gray-500">
                            ${emptyMessage}
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    
    <c:if test="${pagination eq 'true' && not empty currentPage && not empty totalPages}">
        <div class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6">
            <div class="flex-1 flex justify-between sm:hidden">
                <c:choose>
                    <c:when test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}${baseUrl}?page=${currentPage - 1}&size=${pageSize}" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                            Previous
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-300 bg-gray-50 cursor-not-allowed">
                            Previous
                        </span>
                    </c:otherwise>
                </c:choose>
                
                <c:choose>
                    <c:when test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}${baseUrl}?page=${currentPage + 1}&size=${pageSize}" class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                            Next
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-300 bg-gray-50 cursor-not-allowed">
                            Next
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                <div>
                    <p class="text-sm text-gray-700">
                        Showing
                        <span class="font-medium">${(currentPage - 1) * pageSize + 1}</span>
                        to
                        <span class="font-medium">${Math.min(currentPage * pageSize, totalItems)}</span>
                        of
                        <span class="font-medium">${totalItems}</span>
                        results
                    </p>
                </div>
                
                <div>
                    <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}${baseUrl}?page=${currentPage - 1}&size=${pageSize}" class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                    <span class="sr-only">Previous</span>
                                    <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                        <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                                    </svg>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-gray-50 text-sm font-medium text-gray-300 cursor-not-allowed">
                                    <span class="sr-only">Previous</span>
                                    <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                        <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                                    </svg>
                                </span>
                            </c:otherwise>
                        </c:choose>
                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span aria-current="page" class="z-10 bg-primary-50 border-primary-500 text-primary-600 relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                                        ${i}
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}${baseUrl}?page=${i}&size=${pageSize}" class="bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                                        ${i}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}${baseUrl}?page=${currentPage + 1}&size=${pageSize}" class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                    <span class="sr-only">Next</span>
                                    <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                        <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                                    </svg>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-gray-50 text-sm font-medium text-gray-300 cursor-not-allowed">
                                    <span class="sr-only">Next</span>
                                    <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                        <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                                    </svg>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </nav>
                </div>
            </div>
        </div>
    </c:if>
</div>

<c:if test="${searchable eq 'true' || sortable eq 'true'}">
    <script>
        // Search functionality
        function searchTable(tableId) {
            const input = document.getElementById(tableId + '-search');
            const filter = input.value.toUpperCase();
            const table = document.getElementById(tableId);
            const rows = table.getElementsByTagName('tr');
            let visibleRows = 0;
            
            // Loop through all table rows except the header
            for (let i = 1; i < rows.length; i++) {
                if (rows[i].id === tableId + '-empty-row') continue;
                
                const cells = rows[i].getElementsByTagName('td');
                let rowVisible = false;
                
                // Loop through all cells in the row
                for (let j = 0; j < cells.length; j++) {
                    const cell = cells[j];
                    if (cell) {
                        const textValue = cell.textContent || cell.innerText;
                        if (textValue.toUpperCase().indexOf(filter) > -1) {
                            rowVisible = true;
                            break;
                        }
                    }
                }
                
                // Show/hide the row
                if (rowVisible) {
                    rows[i].style.display = '';
                    visibleRows++;
                } else {
                    rows[i].style.display = 'none';
                }
            }
            
            // Show/hide the empty message
            const emptyRow = document.getElementById(tableId + '-empty-row');
            if (visibleRows === 0 && emptyRow) {
                emptyRow.style.display = '';
            } else if (emptyRow) {
                emptyRow.style.display = 'none';
            }
        }
        
        // Sort functionality
        function sortTable(tableId, columnIndex) {
            const table = document.getElementById(tableId);
            const rows = Array.from(table.rows).slice(1); // Skip header row
            const headerRow = table.rows[0];
            const headerCell = headerRow.cells[columnIndex];
            
            // Determine sort direction
            const currentDirection = headerCell.getAttribute('data-sort-direction') || 'asc';
            const newDirection = currentDirection === 'asc' ? 'desc' : 'asc';
            
            // Reset all sort indicators
            for (let i = 0; i < headerRow.cells.length; i++) {
                headerRow.cells[i].setAttribute('data-sort-direction', '');
                const icon = headerRow.cells[i].querySelector('.sort-icon');
                if (icon) {
                    icon.innerHTML = '<svg class="h-4 w-4 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" /></svg>';
                }
            }
            
            // Set new sort direction and update icon
            headerCell.setAttribute('data-sort-direction', newDirection);
            const icon = headerCell.querySelector('.sort-icon');
            if (icon) {
                if (newDirection === 'asc') {
                    icon.innerHTML = '<svg class="h-4 w-4 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7" /></svg>';
                } else {
                    icon.innerHTML = '<svg class="h-4 w-4 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" /></svg>';
                }
            }
            
            // Sort the rows
            rows.sort((a, b) => {
                const aValue = a.cells[columnIndex].textContent.trim();
                const bValue = b.cells[columnIndex].textContent.trim();
                
                // Check if values are numbers
                const aNum = parseFloat(aValue);
                const bNum = parseFloat(bValue);
                
                if (!isNaN(aNum) && !isNaN(bNum)) {
                    return newDirection === 'asc' ? aNum - bNum : bNum - aNum;
                }
                
                // Sort as strings
                return newDirection === 'asc' 
                    ? aValue.localeCompare(bValue) 
                    : bValue.localeCompare(aValue);
            });
            
            // Reorder the table
            const tbody = table.tBodies[0];
            rows.forEach(row => tbody.appendChild(row));
        }
    </script>
</c:if>
