<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Edit Payslip" scope="request" />
<c:set var="userRole" value="hr" scope="request" />
<c:set var="backUrl" value="/hr/payroll/view?id=${payroll.id}" scope="request" />
<c:set var="backLabel" value="Back to Payslip" scope="request" />

<c:set var="mainContent">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="mt-6 bg-white dark:bg-gray-800 shadow-lg overflow-hidden sm:rounded-lg border border-gray-200 dark:border-gray-700">
            <div class="px-4 py-5 sm:px-6 bg-gray-50 dark:bg-gray-700">
                <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-white">Edit Payslip for ${payroll.employeeName}</h3>
                <p class="mt-1 max-w-2xl text-sm text-gray-500 dark:text-gray-400">
                    Month: ${payroll.formattedMonth}
                </p>
            </div>
            
            <form action="${pageContext.request.contextPath}/hr/payroll/generate" method="post" class="p-6">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="payrollId" value="${payroll.id}">
                
                <div class="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                    <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                        <jsp:param name="id" value="baseSalary" />
                        <jsp:param name="name" value="baseSalary" />
                        <jsp:param name="type" value="number" />
                        <jsp:param name="label" value="Base Salary" />
                        <jsp:param name="value" value="${payroll.baseSalary}" />
                        <jsp:param name="helpText" value="Employee's base salary amount" />
                        <jsp:param name="colSpan" value="3" />
                        <jsp:param name="required" value="true" />
                        <jsp:param name="step" value="0.01" />
                        <jsp:param name="min" value="0" />
                    </jsp:include>
                    
                    <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                        <jsp:param name="id" value="allowances" />
                        <jsp:param name="name" value="allowances" />
                        <jsp:param name="type" value="number" />
                        <jsp:param name="label" value="Allowances" />
                        <jsp:param name="value" value="${payroll.allowances}" />
                        <jsp:param name="helpText" value="Additional allowances (bonuses, benefits, etc.)" />
                        <jsp:param name="colSpan" value="3" />
                        <jsp:param name="required" value="true" />
                        <jsp:param name="step" value="0.01" />
                        <jsp:param name="min" value="0" />
                    </jsp:include>
                    
                    <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                        <jsp:param name="id" value="deductions" />
                        <jsp:param name="name" value="deductions" />
                        <jsp:param name="type" value="number" />
                        <jsp:param name="label" value="Deductions" />
                        <jsp:param name="value" value="${payroll.deductions}" />
                        <jsp:param name="helpText" value="Deductions (taxes, insurance, etc.)" />
                        <jsp:param name="colSpan" value="3" />
                        <jsp:param name="required" value="true" />
                        <jsp:param name="step" value="0.01" />
                        <jsp:param name="min" value="0" />
                    </jsp:include>
                    
                    <div class="sm:col-span-6">
                        <label for="notes" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Notes</label>
                        <div class="mt-1">
                            <textarea id="notes" name="notes" rows="4" class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700">${payroll.notes}</textarea>
                        </div>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Additional notes about this payroll</p>
                    </div>
                    
                    <div class="sm:col-span-6 flex justify-end space-x-3">
                        <a href="${pageContext.request.contextPath}/hr/payroll/view?id=${payroll.id}" class="inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 shadow-sm text-sm font-medium rounded-md text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                            Cancel
                        </a>
                        <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                            Save Changes
                        </button>
                    </div>
                </div>
            </form>
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
