<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Payroll Management" scope="request" />
<c:set var="userRole" value="admin" scope="request" />

<c:set var="mainContent">
    <!-- Alert Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <jsp:include page="/WEB-INF/components/alert.jsp">
            <jsp:param name="type" value="success" />
            <jsp:param name="message" value="${sessionScope.successMessage}" />
            <jsp:param name="dismissible" value="true" />
        </jsp:include>
        <c:remove var="successMessage" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <jsp:include page="/WEB-INF/components/alert.jsp">
            <jsp:param name="type" value="error" />
            <jsp:param name="message" value="${sessionScope.errorMessage}" />
            <jsp:param name="dismissible" value="true" />
        </jsp:include>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Action Buttons -->
    <div class="flex justify-end mb-4">
        <a href="${pageContext.request.contextPath}/admin/payroll/generate" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
            <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
            </svg>
            Generate Payroll
        </a>
    </div>

    <!-- Payslips Table -->
    <div class="mt-6 backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 border border-blue-100/50 shadow overflow-hidden sm:rounded-lg">
        <div class="px-4 py-5 sm:px-6 flex justify-between items-center">
            <div>
                <h3 class="text-lg leading-6 font-medium text-gray-900">All Payslips</h3>
                <p class="mt-1 max-w-2xl text-sm text-gray-500">View and manage employee payslips</p>
            </div>
        </div>
        <div class="border-t border-gray-200">
            <c:choose>
                <c:when test="${empty payrolls}">
                    <div class="px-4 py-5 sm:p-6 text-center">
                        <p class="text-gray-500">No payslips available yet.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Employee
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Month
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Base Salary
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Allowances
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Deductions
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Net Salary
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Status
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Actions
                                </th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach var="payroll" items="${payrolls}">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-10 w-10">
                                                <img class="h-10 w-10 rounded-full" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                                            </div>
                                            <div class="ml-4">
                                                <div class="text-sm font-medium text-gray-900">${payroll.employeeName}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        ${payroll.month}
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        <fmt:formatNumber value="${payroll.baseSalary}" type="currency" currencySymbol="$" />
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        <fmt:formatNumber value="${payroll.allowances}" type="currency" currencySymbol="$" />
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        <fmt:formatNumber value="${payroll.deductions}" type="currency" currencySymbol="$" />
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        <fmt:formatNumber value="${payroll.netSalary}" type="currency" currencySymbol="$" />
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${payroll.status eq 'DRAFT'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                    Draft
                                                </span>
                                            </c:when>
                                            <c:when test="${payroll.status eq 'FINALIZED'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                                    Finalized
                                                </span>
                                            </c:when>
                                            <c:when test="${payroll.status eq 'PAID'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                    Paid
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                        <a href="${pageContext.request.contextPath}/admin/payroll/view?id=${payroll.id}" class="text-primary-600 hover:text-primary-900 mr-3">View</a>
                                        <a href="${pageContext.request.contextPath}/admin/payroll/download?id=${payroll.id}" class="text-primary-600 hover:text-primary-900">Download</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Recent Payroll Activities -->
    <div class="mt-8 w-full">
        <jsp:include page="/WEB-INF/components/recent-activities.jsp">
            <jsp:param name="title" value="Recent Payroll Activities" />
            <jsp:param name="entityType" value="PAYROLL" />
            <jsp:param name="limit" value="5" />
        </jsp:include>
    </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
</jsp:include>
