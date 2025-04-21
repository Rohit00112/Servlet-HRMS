<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Payslips" scope="request" />
<c:set var="userRole" value="employee" scope="request" />
<c:set var="backUrl" value="/employee/dashboard" scope="request" />
<c:set var="backLabel" value="Back to Dashboard" scope="request" />

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

    <!-- Payslips Table -->
    <div class="mt-6 backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 border border-blue-100/50 shadow overflow-hidden sm:rounded-lg">
        <div class="px-4 py-5 sm:px-6 flex justify-between items-center">
            <div>
                <h3 class="text-lg leading-6 font-medium text-gray-900">My Payslips</h3>
                <p class="mt-1 max-w-2xl text-sm text-gray-500">View and download your payslips</p>
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
                                        <a href="${pageContext.request.contextPath}/employee/payroll/view?id=${payroll.id}" class="text-primary-600 hover:text-primary-900 mr-3">View</a>
                                        <a href="${pageContext.request.contextPath}/employee/payroll/download?id=${payroll.id}" class="text-primary-600 hover:text-primary-900">Download</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="backUrl" value="${backUrl}" />
    <jsp:param name="backLabel" value="${backLabel}" />
</jsp:include>
