<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Payroll Management" scope="request" />
<c:set var="userRole" value="hr" scope="request" />

<c:set var="mainContent">

                    <!-- Generate Payroll Form -->
                    <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg">
                        <div class="px-4 py-5 sm:px-6 bg-gray-50">
                            <h3 class="text-lg leading-6 font-medium text-gray-900">Generate Payroll</h3>
                            <p class="mt-1 max-w-2xl text-sm text-gray-500">
                                Generate payroll for employees based on attendance records
                            </p>
                        </div>
                        <div class="border-t border-gray-200 px-4 py-5 sm:p-6">
                            <form action="${pageContext.request.contextPath}/hr/payroll/generate" method="post">
                                <input type="hidden" name="action" value="generate">

                                <div class="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                                    <c:set var="options" value="${months}" scope="request" />
                                    <jsp:include page="/WEB-INF/components/enhanced-dropdown.jsp">
                                        <jsp:param name="id" value="month" />
                                        <jsp:param name="name" value="month" />
                                        <jsp:param name="label" value="Month" />
                                        <jsp:param name="helpText" value="Select the month for which to generate payroll" />
                                        <jsp:param name="colSpan" value="3" />
                                        <jsp:param name="required" value="true" />
                                        <jsp:param name="selectedValue" value="${previousMonth}" />
                                    </jsp:include>

                                    <div class="sm:col-span-3">
                                        <label for="employeeId" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Employee <span class="text-red-500">*</span></label>
                                        <div class="relative">
                                            <select
                                                id="employeeId"
                                                name="employeeId"
                                                class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700 appearance-none bg-white dark:bg-gray-700 pr-10 cursor-pointer"
                                                required
                                            >
                                                <option value="all">All Employees</option>
                                                <c:forEach var="employee" items="${employees}">
                                                    <option value="${employee.id}">${employee.name}</option>
                                                </c:forEach>
                                            </select>
                                            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-gray-500 dark:text-gray-400">
                                                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                                    <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                                                </svg>
                                            </div>
                                        </div>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Select an employee or generate for all</p>
                                    </div>

                                    <div class="sm:col-span-6">
                                        <div class="flex justify-end">
                                            <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                                                Generate Payroll
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Payroll List -->
                    <c:if test="${not empty payrolls}">
                        <div class="mt-8 bg-white shadow overflow-hidden sm:rounded-lg">
                            <div class="px-4 py-5 sm:px-6 bg-gray-50">
                                <h3 class="text-lg leading-6 font-medium text-gray-900">Payroll Records - ${formattedMonth}</h3>
                                <p class="mt-1 max-w-2xl text-sm text-gray-500">
                                    Showing ${payrolls.size()} payroll records
                                </p>
                            </div>
                            <div class="border-t border-gray-200">
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
                                                            <img class="h-10 w-10 rounded-full" src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                                                        </div>
                                                        <div class="ml-4">
                                                            <div class="text-sm font-medium text-gray-900">${payroll.employeeName}</div>
                                                            <div class="text-sm text-gray-500">ID: ${payroll.employeeId}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="text-sm text-gray-900">${payroll.formattedMonth}</div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="text-sm text-gray-900">$<fmt:formatNumber value="${payroll.baseSalary}" pattern="#,##0.00"/></div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="text-sm text-gray-900">$<fmt:formatNumber value="${payroll.netSalary}" pattern="#,##0.00"/></div>
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
                                                    <a href="${pageContext.request.contextPath}/hr/payroll/view?id=${payroll.id}" class="text-primary-600 hover:text-primary-900 mr-3">View</a>

                                                    <c:if test="${payroll.status eq 'DRAFT'}">
                                                        <form action="${pageContext.request.contextPath}/hr/payroll/generate" method="post" class="inline">
                                                            <input type="hidden" name="action" value="finalize">
                                                            <input type="hidden" name="payrollId" value="${payroll.id}">
                                                            <button type="submit" class="text-blue-600 hover:text-blue-900 mr-3">Finalize</button>
                                                        </form>

                                                        <form action="${pageContext.request.contextPath}/hr/payroll/generate" method="post" class="inline" onsubmit="return confirm('Are you sure you want to delete this payroll record?');">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="payrollId" value="${payroll.id}">
                                                            <input type="hidden" name="month" value="${selectedMonth}">
                                                            <button type="submit" class="text-red-600 hover:text-red-900">Delete</button>
                                                        </form>
                                                    </c:if>

                                                    <c:if test="${payroll.status eq 'FINALIZED'}">
                                                        <form action="${pageContext.request.contextPath}/hr/payroll/generate" method="post" class="inline">
                                                            <input type="hidden" name="action" value="markPaid">
                                                            <input type="hidden" name="payrollId" value="${payroll.id}">
                                                            <button type="submit" class="text-green-600 hover:text-green-900">Mark as Paid</button>
                                                        </form>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:if>
                </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
</jsp:include>
