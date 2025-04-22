<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Attendance Management" scope="request" />
<c:set var="userRole" value="hr" scope="request" />

<c:set var="mainContent">

                    <!-- Filter Form -->
                    <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg">
                        <div class="px-4 py-5 sm:p-6">
                            <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">Filter Attendance Records</h3>
                            <form action="${pageContext.request.contextPath}/hr/attendance/view" method="get" class="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                                <!-- Employee Filter -->
                                <c:set var="options" value="${employees}" scope="request" />
                                <jsp:include page="/WEB-INF/components/enhanced-dropdown.jsp">
                                    <jsp:param name="id" value="employeeId" />
                                    <jsp:param name="name" value="employeeId" />
                                    <jsp:param name="label" value="Employee" />
                                    <jsp:param name="colSpan" value="2" />
                                    <jsp:param name="placeholder" value="All Employees" />
                                    <jsp:param name="selectedValue" value="${param.employeeId}" />
                                    <jsp:param name="optionValue" value="id" />
                                    <jsp:param name="optionText" value="name" />
                                </jsp:include>

                                <!-- Department Filter -->
                                <c:set var="options" value="${departments}" scope="request" />
                                <jsp:include page="/WEB-INF/components/enhanced-dropdown.jsp">
                                    <jsp:param name="id" value="departmentId" />
                                    <jsp:param name="name" value="departmentId" />
                                    <jsp:param name="label" value="Department" />
                                    <jsp:param name="colSpan" value="2" />
                                    <jsp:param name="placeholder" value="All Departments" />
                                    <jsp:param name="selectedValue" value="${param.departmentId}" />
                                    <jsp:param name="optionValue" value="id" />
                                    <jsp:param name="optionText" value="name" />
                                </jsp:include>

                                <!-- Start Date Filter -->
                                <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                    <jsp:param name="id" value="startDate" />
                                    <jsp:param name="name" value="startDate" />
                                    <jsp:param name="type" value="date" />
                                    <jsp:param name="label" value="Start Date" />
                                    <jsp:param name="value" value="${startDate}" />
                                    <jsp:param name="colSpan" value="1" />
                                </jsp:include>

                                <!-- End Date Filter -->
                                <jsp:include page="/WEB-INF/components/enhanced-input.jsp">
                                    <jsp:param name="id" value="endDate" />
                                    <jsp:param name="name" value="endDate" />
                                    <jsp:param name="type" value="date" />
                                    <jsp:param name="label" value="End Date" />
                                    <jsp:param name="value" value="${endDate}" />
                                    <jsp:param name="colSpan" value="1" />
                                </jsp:include>

                                <!-- Apply Filter Button -->
                                <div class="sm:col-span-6 flex justify-end">
                                    <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                                        Apply Filter
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Employee Details (if filtered by employee) -->
                    <c:if test="${selectedEmployee != null}">
                        <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg">
                            <div class="px-4 py-5 sm:px-6 flex justify-between items-center">
                                <div>
                                    <h3 class="text-lg leading-6 font-medium text-gray-900">Employee Details</h3>
                                    <p class="mt-1 max-w-2xl text-sm text-gray-500">
                                        Personal details and attendance statistics
                                    </p>
                                </div>
                                <div class="text-3xl font-bold text-primary-600">
                                    <fmt:formatNumber value="${attendancePercentage}" maxFractionDigits="1" />%
                                    <span class="text-sm font-normal text-gray-500">Attendance</span>
                                </div>
                            </div>
                            <div class="border-t border-gray-200 px-4 py-5 sm:p-0">
                                <dl class="sm:divide-y sm:divide-gray-200">
                                    <div class="py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                                        <dt class="text-sm font-medium text-gray-500">Full name</dt>
                                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">${selectedEmployee.name}</dd>
                                    </div>
                                    <div class="py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                                        <dt class="text-sm font-medium text-gray-500">Email address</dt>
                                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">${selectedEmployee.email}</dd>
                                    </div>
                                    <div class="py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                                        <dt class="text-sm font-medium text-gray-500">Department</dt>
                                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">${selectedEmployee.departmentName}</dd>
                                    </div>
                                    <div class="py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                                        <dt class="text-sm font-medium text-gray-500">Designation</dt>
                                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">${selectedEmployee.designationTitle}</dd>
                                    </div>
                                    <div class="py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                                        <dt class="text-sm font-medium text-gray-500">Attendance Statistics</dt>
                                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                                            <div class="flex space-x-4">
                                                <div>
                                                    <span class="text-green-600 font-medium">${stats.PRESENT}</span> Present
                                                </div>
                                                <div>
                                                    <span class="text-yellow-600 font-medium">${stats.LATE}</span> Late
                                                </div>
                                                <div>
                                                    <span class="text-orange-600 font-medium">${stats.HALF_DAY}</span> Half Day
                                                </div>
                                                <div>
                                                    <span class="text-red-600 font-medium">${stats.ABSENT}</span> Absent
                                                </div>
                                            </div>
                                        </dd>
                                    </div>
                                </dl>
                            </div>
                        </div>
                    </c:if>

                    <!-- Department Details (if filtered by department) -->
                    <c:if test="${selectedDepartment != null}">
                        <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg">
                            <div class="px-4 py-5 sm:px-6">
                                <h3 class="text-lg leading-6 font-medium text-gray-900">Department: ${selectedDepartment.name}</h3>
                                <p class="mt-1 max-w-2xl text-sm text-gray-500">
                                    Showing attendance records for all employees in this department
                                </p>
                            </div>
                        </div>
                    </c:if>

                    <!-- Attendance Records Table -->
                    <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg">
                        <div class="px-4 py-5 sm:px-6 bg-gray-50">
                            <h3 class="text-lg leading-6 font-medium text-gray-900">Attendance Records</h3>
                            <p class="mt-1 max-w-2xl text-sm text-gray-500">
                                Showing ${attendanceList.size()} records
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
                                            Date
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Check In
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Check Out
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Duration
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Status
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Notes
                                        </th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:choose>
                                        <c:when test="${empty attendanceList}">
                                            <tr>
                                                <td colspan="7" class="px-6 py-4 text-center text-sm text-gray-500">
                                                    No attendance records found for the selected criteria
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="attendance" items="${attendanceList}">
                                                <tr>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="flex items-center">
                                                            <div class="flex-shrink-0 h-10 w-10">
                                                                <img class="h-10 w-10 rounded-full" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                                                            </div>
                                                            <div class="ml-4">
                                                                <div class="text-sm font-medium text-gray-900">${attendance.employeeName}</div>
                                                                <div class="text-sm text-gray-500">${attendance.departmentName}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="text-sm text-gray-900"><fmt:formatDate value="${attendance.date}" pattern="EEE, MMM d, yyyy" /></div>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="text-sm text-gray-900">
                                                            <c:choose>
                                                                <c:when test="${attendance.checkInTime != null}">
                                                                    <fmt:formatDate value="${attendance.checkInTime}" pattern="hh:mm a" />
                                                                </c:when>
                                                                <c:otherwise>-</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="text-sm text-gray-900">
                                                            <c:choose>
                                                                <c:when test="${attendance.checkOutTime != null}">
                                                                    <fmt:formatDate value="${attendance.checkOutTime}" pattern="hh:mm a" />
                                                                </c:when>
                                                                <c:otherwise>-</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="text-sm text-gray-900">${attendance.workDuration}</div>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <c:choose>
                                                            <c:when test="${attendance.status == 'PRESENT'}">
                                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                                    Present
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${attendance.status == 'LATE'}">
                                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                                    Late
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${attendance.status == 'HALF_DAY'}">
                                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-orange-100 text-orange-800">
                                                                    Half Day
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${attendance.status == 'ABSENT'}">
                                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                                                    Absent
                                                                </span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <div class="text-sm text-gray-900">${attendance.notes}</div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
</jsp:include>
