<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Table Component:
<jsp:include page="/WEB-INF/components/table.jsp">
    <jsp:param name="tableId" value="employeesTable" />
    <jsp:param name="items" value="employees" />
    <jsp:param name="emptyMessage" value="No employees found" />
    <jsp:param name="columns" value="ID,Name,Email,Department,Designation,Join Date,Actions" />
    <jsp:param name="columnWidths" value="5%,20%,20%,15%,15%,15%,10%" />
    <jsp:attribute name="tableContent">
        <c:forEach var="employee" items="${employees}">
            <tr class="bg-white border-b hover:bg-gray-50">
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${employee.id}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${employee.name}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${employee.email}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${employee.departmentName}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${employee.designationTitle}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${employee.joinDate}</td>
                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                    <a href="${pageContext.request.contextPath}/admin/employees/edit?id=${employee.id}" class="text-primary-600 hover:text-primary-900 mr-3">Edit</a>
                    <a href="${pageContext.request.contextPath}/admin/employees/delete?id=${employee.id}" class="text-red-600 hover:text-red-900" onclick="return confirm('Are you sure you want to delete this employee?')">Delete</a>
                </td>
            </tr>
        </c:forEach>
    </jsp:attribute>
</jsp:include>
--%>

<div class="mt-6 flex flex-col">
    <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
            <div class="shadow overflow-hidden border-b border-gray-200 dark:border-gray-700 sm:rounded-lg">
                <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700" id="${param.tableId}">
                    <thead class="bg-gray-50 dark:bg-gray-700">
                        <tr>
                            <c:set var="columns" value="${param.columns}" />
                            <c:set var="columnWidths" value="${param.columnWidths}" />

                            <c:forEach var="column" items="${columns.split(',')}" varStatus="status">
                                <c:set var="width" value="" />
                                <c:if test="${not empty columnWidths}">
                                    <c:set var="widths" value="${columnWidths.split(',')}" />
                                    <c:if test="${status.index < widths.length}">
                                        <c:set var="width" value="width: ${widths[status.index]};" />
                                    </c:if>
                                </c:if>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider" style="${width}">
                                    ${column}
                                </th>
                            </c:forEach>
                        </tr>
                    </thead>
                    <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                        <c:set var="items" value="${requestScope[param.items]}" />
                        <c:choose>
                            <c:when test="${empty requestScope[param.items]}">
                                <tr>
                                    <td colspan="${columns.split(',').length}" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400 text-center">
                                        ${param.emptyMessage}
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${not empty param.tableContent}">
                                    ${param.tableContent}
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
