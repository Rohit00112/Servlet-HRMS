<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Advanced Attendance Report" scope="request" />
<c:set var="userRole" value="admin" scope="request" />

<c:set var="additionalHead">
    <!-- Date picker CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</c:set>

<c:set var="mainContent">
    <div class="px-4 py-5 sm:px-6">
        <h1 class="text-2xl font-semibold text-gray-900 dark:text-gray-100">Advanced Attendance Report</h1>
        <p class="mt-1 max-w-2xl text-sm text-gray-500 dark:text-gray-400">Detailed attendance analysis with advanced metrics.</p>
    </div>

    <!-- Filters Section -->
    <div class="bg-white dark:bg-gray-800 shadow overflow-hidden sm:rounded-lg mb-6">
        <div class="px-4 py-5 sm:p-6">
            <form action="${pageContext.request.contextPath}/admin/attendance-report" method="get" class="space-y-4">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div>
                        <label for="startDate" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Start Date</label>
                        <input type="date" id="startDate" name="startDate" value="${startDate}" 
                               class="mt-1 block w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white shadow-sm focus:border-primary-500 focus:ring-primary-500">
                    </div>
                    <div>
                        <label for="endDate" class="block text-sm font-medium text-gray-700 dark:text-gray-300">End Date</label>
                        <input type="date" id="endDate" name="endDate" value="${endDate}" 
                               class="mt-1 block w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white shadow-sm focus:border-primary-500 focus:ring-primary-500">
                    </div>
                    <div>
                        <label for="departmentId" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Department</label>
                        <select id="departmentId" name="departmentId" 
                                class="mt-1 block w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white shadow-sm focus:border-primary-500 focus:ring-primary-500">
                            <option value="0">All Departments</option>
                            <c:forEach var="department" items="${departments}">
                                <option value="${department.id}" ${department.id == selectedDepartmentId ? 'selected' : ''}>${department.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label for="employeeId" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Employee</label>
                        <select id="employeeId" name="employeeId" 
                                class="mt-1 block w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white shadow-sm focus:border-primary-500 focus:ring-primary-500">
                            <option value="0">All Employees</option>
                            <c:forEach var="employee" items="${employees}">
                                <option value="${employee.id}" ${employee.id == selectedEmployeeId ? 'selected' : ''}>${employee.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="flex justify-end">
                    <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                        Apply Filters
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Summary Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <!-- Present Card -->
        <div class="bg-white dark:bg-gray-800 overflow-hidden shadow rounded-lg">
            <div class="p-5">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-green-100 dark:bg-green-900 rounded-md p-3">
                        <svg class="h-6 w-6 text-green-600 dark:text-green-300" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                        </svg>
                    </div>
                    <div class="ml-5 w-0 flex-1">
                        <dl>
                            <dt class="text-sm font-medium text-gray-500 dark:text-gray-400 truncate">Present</dt>
                            <dd>
                                <div class="text-lg font-medium text-gray-900 dark:text-white">${summary.presentCount} / ${summary.totalAttendance}</div>
                                <div class="text-sm text-gray-500 dark:text-gray-400"><fmt:formatNumber value="${summary.presentPercentage}" pattern="#0.0"/>%</div>
                            </dd>
                        </dl>
                    </div>
                </div>
            </div>
        </div>

        <!-- Absent Card -->
        <div class="bg-white dark:bg-gray-800 overflow-hidden shadow rounded-lg">
            <div class="p-5">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-red-100 dark:bg-red-900 rounded-md p-3">
                        <svg class="h-6 w-6 text-red-600 dark:text-red-300" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </div>
                    <div class="ml-5 w-0 flex-1">
                        <dl>
                            <dt class="text-sm font-medium text-gray-500 dark:text-gray-400 truncate">Absent</dt>
                            <dd>
                                <div class="text-lg font-medium text-gray-900 dark:text-white">${summary.absentCount} / ${summary.totalAttendance}</div>
                                <div class="text-sm text-gray-500 dark:text-gray-400"><fmt:formatNumber value="${summary.absentPercentage}" pattern="#0.0"/>%</div>
                            </dd>
                        </dl>
                    </div>
                </div>
            </div>
        </div>

        <!-- Late Card -->
        <div class="bg-white dark:bg-gray-800 overflow-hidden shadow rounded-lg">
            <div class="p-5">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-yellow-100 dark:bg-yellow-900 rounded-md p-3">
                        <svg class="h-6 w-6 text-yellow-600 dark:text-yellow-300" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                    </div>
                    <div class="ml-5 w-0 flex-1">
                        <dl>
                            <dt class="text-sm font-medium text-gray-500 dark:text-gray-400 truncate">Late</dt>
                            <dd>
                                <div class="text-lg font-medium text-gray-900 dark:text-white">${summary.lateCount} / ${summary.totalAttendance}</div>
                                <div class="text-sm text-gray-500 dark:text-gray-400"><fmt:formatNumber value="${summary.latePercentage}" pattern="#0.0"/>%</div>
                            </dd>
                        </dl>
                    </div>
                </div>
            </div>
        </div>

        <!-- Overtime Card -->
        <div class="bg-white dark:bg-gray-800 overflow-hidden shadow rounded-lg">
            <div class="p-5">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-purple-100 dark:bg-purple-900 rounded-md p-3">
                        <svg class="h-6 w-6 text-purple-600 dark:text-purple-300" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                    </div>
                    <div class="ml-5 w-0 flex-1">
                        <dl>
                            <dt class="text-sm font-medium text-gray-500 dark:text-gray-400 truncate">Overtime</dt>
                            <dd>
                                <div class="text-lg font-medium text-gray-900 dark:text-white">${summary.overtimeCount} instances</div>
                                <div class="text-sm text-gray-500 dark:text-gray-400">
                                    <c:set var="hours" value="${summary.totalOvertimeMinutes / 60}" />
                                    <c:set var="minutes" value="${summary.totalOvertimeMinutes % 60}" />
                                    <fmt:formatNumber value="${hours}" pattern="#0"/> hrs <fmt:formatNumber value="${minutes}" pattern="#0"/> mins
                                </div>
                            </dd>
                        </dl>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Attendance Table -->
    <div class="bg-white dark:bg-gray-800 shadow overflow-hidden sm:rounded-lg">
        <div class="px-4 py-5 sm:px-6 flex justify-between items-center">
            <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-white">Attendance Records</h3>
            <div class="flex space-x-2">
                <a href="${pageContext.request.contextPath}/export/attendance-report/pdf?startDate=${startDate}&endDate=${endDate}&departmentId=${selectedDepartmentId}&employeeId=${selectedEmployeeId}" 
                   class="inline-flex items-center px-3 py-1.5 border border-gray-300 dark:border-gray-600 text-sm font-medium rounded-md text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none">
                    <svg class="-ml-0.5 mr-1.5 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                    </svg>
                    Export PDF
                </a>
                <a href="${pageContext.request.contextPath}/export/attendance-report/excel?startDate=${startDate}&endDate=${endDate}&departmentId=${selectedDepartmentId}&employeeId=${selectedEmployeeId}" 
                   class="inline-flex items-center px-3 py-1.5 border border-gray-300 dark:border-gray-600 text-sm font-medium rounded-md text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none">
                    <svg class="-ml-0.5 mr-1.5 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                    Export Excel
                </a>
            </div>
        </div>
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                <thead class="bg-gray-50 dark:bg-gray-700">
                    <tr>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Date</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Employee</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Department</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Check In</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Check Out</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Status</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Work Hours</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Overtime</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Notes</th>
                    </tr>
                </thead>
                <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                    <c:forEach var="attendance" items="${attendanceList}">
                        <tr class="hover:bg-gray-50 dark:hover:bg-gray-700">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white">${attendance.formattedDate}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">${attendance.employeeName}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">${attendance.departmentName}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300 ${attendance.late ? 'text-yellow-600 dark:text-yellow-400 font-medium' : ''}">
                                ${attendance.formattedCheckInTime}
                                <c:if test="${attendance.late}">
                                    <span class="ml-1 inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300">Late</span>
                                </c:if>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300 ${attendance.earlyDeparture ? 'text-orange-600 dark:text-orange-400 font-medium' : ''}">
                                ${attendance.formattedCheckOutTime}
                                <c:if test="${attendance.earlyDeparture}">
                                    <span class="ml-1 inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-300">Early</span>
                                </c:if>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${attendance.statusClass}">
                                    ${attendance.status}
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">${attendance.workDuration}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">
                                <c:if test="${attendance.overtimeMinutes > 0}">
                                    <span class="text-purple-600 dark:text-purple-400 font-medium">${attendance.formattedOvertime}</span>
                                </c:if>
                                <c:if test="${attendance.overtimeMinutes <= 0}">-</c:if>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">
                                <c:if test="${not empty attendance.notes}">
                                    <span class="inline-block max-w-xs truncate" title="${attendance.notes}">${attendance.notes}</span>
                                </c:if>
                                <c:if test="${empty attendance.notes}">-</c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty attendanceList}">
                        <tr>
                            <td colspan="9" class="px-6 py-4 text-center text-sm text-gray-500 dark:text-gray-400">No attendance records found for the selected criteria.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</c:set>

<c:set var="additionalScripts">
    <!-- Date picker JS -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize date pickers
            flatpickr("#startDate", {
                dateFormat: "Y-m-d",
                maxDate: "today"
            });
            
            flatpickr("#endDate", {
                dateFormat: "Y-m-d",
                maxDate: "today"
            });
            
            // Department filter change handler
            document.getElementById('departmentId').addEventListener('change', function() {
                if (this.value !== '0') {
                    // If a department is selected, filter employees by department
                    filterEmployeesByDepartment(this.value);
                } else {
                    // If "All Departments" is selected, show all employees
                    resetEmployeeFilter();
                }
            });
            
            function filterEmployeesByDepartment(departmentId) {
                const employeeSelect = document.getElementById('employeeId');
                const options = employeeSelect.options;
                
                for (let i = 1; i < options.length; i++) {
                    const option = options[i];
                    const employeeDepartmentId = option.getAttribute('data-department-id');
                    
                    if (employeeDepartmentId === departmentId) {
                        option.style.display = '';
                    } else {
                        option.style.display = 'none';
                    }
                }
            }
            
            function resetEmployeeFilter() {
                const employeeSelect = document.getElementById('employeeId');
                const options = employeeSelect.options;
                
                for (let i = 1; i < options.length; i++) {
                    options[i].style.display = '';
                }
            }
        });
    </script>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="additionalHead" value="${additionalHead}" />
    <jsp:param name="additionalScripts" value="${additionalScripts}" />
</jsp:include>
