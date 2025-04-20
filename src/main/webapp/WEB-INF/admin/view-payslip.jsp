<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="View Payslip" scope="request" />

<c:set var="additionalStyles">
    <style>
        @media print {
            body {
                background-color: white;
                font-size: 12pt;
            }
            .print\:hidden {
                display: none !important;
            }
            .print\:shadow-none {
                box-shadow: none !important;
            }
            .print\:bg-white {
                background-color: white !important;
            }
            .print\:border-none {
                border: none !important;
            }
            @page {
                size: A4;
                margin: 1cm;
            }
            .flex-1 {
                flex: none !important;
            }
            main {
                overflow: visible !important;
            }
            .shadow {
                box-shadow: none !important;
            }
            .border {
                border-color: #ddd !important;
            }
            .text-primary-600 {
                color: #0284c7 !important;
            }
            .company-header {
                text-align: center;
                margin-bottom: 20px;
            }
            .company-header h1 {
                font-size: 24pt;
                font-weight: bold;
                margin-bottom: 5px;
            }
            .company-header p {
                font-size: 10pt;
            }
        }
    </style>
</c:set>

<c:set var="mainContent">
                    <!-- Print Header - Only visible when printing -->
                    <div class="hidden print:block company-header">
                        <h1>HRMS Company Ltd.</h1>
                        <p>123 Business Avenue, Corporate District, City, Country</p>
                        <p>Phone: +1-234-567-8900 | Email: payroll@hrms.com</p>
                        <div class="mt-4 text-xl font-bold">PAYSLIP</div>
                    </div>

                    <div class="flex items-center justify-between print:hidden">
                        <h1 class="text-2xl font-semibold text-gray-900">Payslip Details</h1>
                        <div class="flex space-x-3">
                            <button onclick="window.print()" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700">
                                <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" />
                                </svg>
                                Print Payslip
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/payroll/download?id=${payroll.id}" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700">
                                <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                </svg>
                                Download PDF
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/payroll/generate" class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                Back to Payroll List
                            </a>
                        </div>
                    </div>

                    <!-- Payslip Header -->
                    <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg print:shadow-none">
                        <div class="px-4 py-5 sm:px-6 bg-gray-50 print:bg-white">
                            <div class="flex justify-between items-center">
                                <div>
                                    <h3 class="text-lg leading-6 font-medium text-gray-900">Payslip for ${payroll.formattedMonth}</h3>
                                    <p class="mt-1 max-w-2xl text-sm text-gray-500">
                                        Generated on <fmt:formatDate value="${payroll.generationDate}" pattern="MMMM d, yyyy" />
                                    </p>
                                </div>
                                <div class="text-right">
                                    <div class="text-sm font-medium text-gray-500">Status</div>
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
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Employee Information -->
                    <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg print:shadow-none">
                        <div class="px-4 py-5 sm:px-6 bg-gray-50 print:bg-white">
                            <h3 class="text-lg leading-6 font-medium text-gray-900">Employee Information</h3>
                        </div>
                        <div class="border-t border-gray-200">
                            <dl>
                                <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                                    <dt class="text-sm font-medium text-gray-500">Full name</dt>
                                    <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">${employee.name}</dd>
                                </div>
                                <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 print:bg-white">
                                    <dt class="text-sm font-medium text-gray-500">Email address</dt>
                                    <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">${employee.email}</dd>
                                </div>
                                <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                                    <dt class="text-sm font-medium text-gray-500">Department</dt>
                                    <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">${employee.departmentName}</dd>
                                </div>
                                <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 print:bg-white">
                                    <dt class="text-sm font-medium text-gray-500">Designation</dt>
                                    <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">${employee.designationTitle}</dd>
                                </div>
                                <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                                    <dt class="text-sm font-medium text-gray-500">Join date</dt>
                                    <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2"><fmt:formatDate value="${employee.joinDate}" pattern="MMMM d, yyyy" /></dd>
                                </div>
                            </dl>
                        </div>
                    </div>

                    <!-- Salary Details -->
                    <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg print:shadow-none">
                        <div class="px-4 py-5 sm:px-6 bg-gray-50 print:bg-white">
                            <h3 class="text-lg leading-6 font-medium text-gray-900">Salary Details</h3>
                        </div>
                        <div class="border-t border-gray-200">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 p-4">
                                <!-- Left Column: Earnings -->
                                <div class="bg-white p-4 rounded-lg border border-gray-200">
                                    <h4 class="text-md font-medium text-gray-900 mb-4">Earnings</h4>
                                    <div class="space-y-3">
                                        <div class="flex justify-between">
                                            <span class="text-sm text-gray-500">Base Salary</span>
                                            <span class="text-sm font-medium text-gray-900">$<fmt:formatNumber value="${payroll.baseSalary}" pattern="#,##0.00"/></span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-sm text-gray-500">Allowances</span>
                                            <span class="text-sm font-medium text-gray-900">$<fmt:formatNumber value="${payroll.allowances}" pattern="#,##0.00"/></span>
                                        </div>
                                        <div class="border-t border-gray-200 pt-2 mt-2">
                                            <div class="flex justify-between font-medium">
                                                <span class="text-sm text-gray-700">Total Earnings</span>
                                                <span class="text-sm text-gray-900">$<fmt:formatNumber value="${payroll.baseSalary + payroll.allowances}" pattern="#,##0.00"/></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Right Column: Deductions -->
                                <div class="bg-white p-4 rounded-lg border border-gray-200">
                                    <h4 class="text-md font-medium text-gray-900 mb-4">Deductions</h4>
                                    <div class="space-y-3">
                                        <div class="flex justify-between">
                                            <span class="text-sm text-gray-500">Attendance Deductions</span>
                                            <span class="text-sm font-medium text-gray-900">$<fmt:formatNumber value="${payroll.baseSalary - (payroll.baseSalary * payroll.effectiveWorkingDays / payroll.totalWorkingDays)}" pattern="#,##0.00"/></span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-sm text-gray-500">Other Deductions</span>
                                            <span class="text-sm font-medium text-gray-900">$<fmt:formatNumber value="${payroll.deductions}" pattern="#,##0.00"/></span>
                                        </div>
                                        <div class="border-t border-gray-200 pt-2 mt-2">
                                            <div class="flex justify-between font-medium">
                                                <span class="text-sm text-gray-700">Total Deductions</span>
                                                <span class="text-sm text-gray-900">$<fmt:formatNumber value="${(payroll.baseSalary - (payroll.baseSalary * payroll.effectiveWorkingDays / payroll.totalWorkingDays)) + payroll.deductions}" pattern="#,##0.00"/></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Net Salary -->
                            <div class="bg-gray-50 px-4 py-5 sm:px-6 border-t border-gray-200 print:bg-white">
                                <div class="flex justify-between items-center">
                                    <h4 class="text-lg font-medium text-gray-900">Net Salary</h4>
                                    <div class="text-2xl font-bold text-primary-600">$<fmt:formatNumber value="${payroll.netSalary}" pattern="#,##0.00"/></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Attendance Summary -->
                    <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg print:shadow-none">
                        <div class="px-4 py-5 sm:px-6 bg-gray-50 print:bg-white">
                            <h3 class="text-lg leading-6 font-medium text-gray-900">Attendance Summary</h3>
                        </div>
                        <div class="border-t border-gray-200">
                            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 p-6">
                                <!-- Present Days -->
                                <div class="bg-green-50 p-4 rounded-lg border border-green-200">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 bg-green-100 rounded-md p-3">
                                            <svg class="h-6 w-6 text-green-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                            </svg>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-500">Present</div>
                                            <div class="text-2xl font-semibold text-gray-900">${payroll.daysPresent}</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Late Days -->
                                <div class="bg-yellow-50 p-4 rounded-lg border border-yellow-200">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 bg-yellow-100 rounded-md p-3">
                                            <svg class="h-6 w-6 text-yellow-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                            </svg>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-500">Late</div>
                                            <div class="text-2xl font-semibold text-gray-900">${payroll.daysLate}</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Half Days -->
                                <div class="bg-orange-50 p-4 rounded-lg border border-orange-200">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 bg-orange-100 rounded-md p-3">
                                            <svg class="h-6 w-6 text-orange-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                            </svg>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-500">Half Day</div>
                                            <div class="text-2xl font-semibold text-gray-900">${payroll.daysHalf}</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Absent Days -->
                                <div class="bg-red-50 p-4 rounded-lg border border-red-200">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 bg-red-100 rounded-md p-3">
                                            <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                                            </svg>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-500">Absent</div>
                                            <div class="text-2xl font-semibold text-gray-900">${payroll.daysAbsent}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Attendance Percentage -->
                            <div class="border-t border-gray-200 px-6 py-4">
                                <div class="flex justify-between items-center">
                                    <div class="text-sm font-medium text-gray-500">Attendance Percentage</div>
                                    <div class="text-lg font-semibold text-primary-600">
                                        <fmt:formatNumber value="${(payroll.effectiveWorkingDays / payroll.totalWorkingDays) * 100}" maxFractionDigits="1" />%
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Notes Section -->
                    <c:if test="${not empty payroll.notes}">
                        <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg print:shadow-none">
                            <div class="px-4 py-5 sm:px-6 bg-gray-50 print:bg-white">
                                <h3 class="text-lg leading-6 font-medium text-gray-900">Notes</h3>
                            </div>
                            <div class="border-t border-gray-200 px-4 py-5 sm:p-6">
                                <p class="text-sm text-gray-700">${payroll.notes}</p>
                            </div>
                        </div>
                    </c:if>

                    <!-- Admin Actions -->
                    <c:if test="${payroll.status ne 'PAID'}">
                        <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg print:hidden">
                            <div class="px-4 py-5 sm:px-6 bg-gray-50">
                                <h3 class="text-lg leading-6 font-medium text-gray-900">Actions</h3>
                            </div>
                            <div class="border-t border-gray-200 px-4 py-5 sm:p-6">
                                <div class="flex flex-col space-y-3 sm:flex-row sm:space-y-0 sm:space-x-4">
                                    <c:if test="${payroll.status eq 'DRAFT'}">
                                        <form action="${pageContext.request.contextPath}/admin/payroll/generate" method="post">
                                            <input type="hidden" name="action" value="finalize">
                                            <input type="hidden" name="payrollId" value="${payroll.id}">
                                            <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                                Finalize Payroll
                                            </button>
                                        </form>

                                        <form action="${pageContext.request.contextPath}/admin/payroll/generate" method="post" onsubmit="return confirm('Are you sure you want to delete this payroll record?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="payrollId" value="${payroll.id}">
                                            <input type="hidden" name="month" value="${payroll.month}">
                                            <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                                                Delete Payroll
                                            </button>
                                        </form>
                                    </c:if>

                                    <c:if test="${payroll.status eq 'FINALIZED'}">
                                        <form action="${pageContext.request.contextPath}/admin/payroll/generate" method="post">
                                            <input type="hidden" name="action" value="markPaid">
                                            <input type="hidden" name="payrollId" value="${payroll.id}">
                                            <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                                                Mark as Paid
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="additionalStyles" value="${additionalStyles}" />
</jsp:include>
