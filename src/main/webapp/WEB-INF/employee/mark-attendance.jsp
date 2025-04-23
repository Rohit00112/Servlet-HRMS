<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Mark Attendance" scope="request" />
<c:set var="userRole" value="employee" scope="request" />

<c:set var="additionalHead">
    <script>
        function updateClock() {
            const now = new Date();
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            const seconds = String(now.getSeconds()).padStart(2, '0');
            document.getElementById('current-time').textContent = `${hours}:${minutes}:${seconds}`;
            setTimeout(updateClock, 1000);
        }
        document.addEventListener('DOMContentLoaded', updateClock);
    </script>
</c:set>

<c:set var="mainContent">
                    <div class="flex justify-end">
                        <a href="${pageContext.request.contextPath}/employee/attendance/view" class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md shadow-sm text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                            <svg class="-ml-1 mr-2 h-5 w-5 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                            </svg>
                            View Attendance History
                        </a>
                    </div>

                    <!-- Attendance Card -->
                    <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg">
                        <div class="px-4 py-5 sm:px-6 bg-gray-50">
                            <div class="flex justify-between items-center">
                                <div>
                                    <h3 class="text-lg leading-6 font-medium text-gray-900">Today's Attendance</h3>
                                    <p class="mt-1 max-w-2xl text-sm text-gray-500">
                                        ${today.getDayOfWeek().toString().substring(0, 1).concat(today.getDayOfWeek().toString().substring(1).toLowerCase())}, ${today.getMonth().toString().substring(0, 1).concat(today.getMonth().toString().substring(1).toLowerCase())} ${today.getDayOfMonth()}, ${today.getYear()}
                                    </p>
                                </div>
                                <div class="text-right">
                                    <div id="current-time" class="text-2xl font-bold text-primary-600">--:--:--</div>
                                    <p class="text-xs text-gray-500">Current Time</p>
                                </div>
                            </div>
                        </div>

                        <!-- Clock is updated by the script in additionalHead -->
                        <div class="border-t border-gray-200 px-4 py-5 sm:p-6">
                            <c:choose>
                                <c:when test="${todayAttendance == null}">
                                    <!-- Check-in Form -->
                                    <form action="${pageContext.request.contextPath}/employee/attendance/mark" method="post">
                                        <input type="hidden" name="action" value="check-in">
                                        <div class="space-y-6">
                                            <div class="sm:col-span-6">
                                                <label for="workType" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Work Type</label>
                                                <div class="relative">
                                                    <select
                                                        id="workType"
                                                        name="workType"
                                                        class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700 appearance-none bg-white dark:bg-gray-700 pr-10 cursor-pointer"
                                                    >
                                                        <option value="OFFICE">Office</option>
                                                        <option value="REMOTE">Remote</option>
                                                        <option value="HYBRID">Hybrid</option>
                                                        <option value="FIELD">Field Work</option>
                                                    </select>
                                                    <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-gray-500 dark:text-gray-400">
                                                        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                                            <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                                                        </svg>
                                                    </div>
                                                </div>
                                                <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Select your work location for today.</p>
                                            </div>

                                            <div class="sm:col-span-6">
                                                <label for="notes" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Notes (Optional)</label>
                                                <div class="relative">
                                                    <textarea
                                                        id="notes"
                                                        name="notes"
                                                        rows="4"
                                                        class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700 resize-none"
                                                        placeholder="Enter any notes or comments about your work today..."
                                                    ></textarea>
                                                </div>
                                                <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Brief note about your work for today.</p>
                                            </div>

                                            <div>
                                                <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                                                    <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" />
                                                    </svg>
                                                    Check In
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </c:when>
                                <c:when test="${todayAttendance.checkInTime != null && todayAttendance.checkOutTime == null}">
                                    <!-- Check-out Form -->
                                    <div class="mb-6">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 bg-green-100 rounded-md p-3">
                                                <svg class="h-6 w-6 text-green-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                                </svg>
                                            </div>
                                            <div class="ml-4">
                                                <h4 class="text-lg font-medium text-gray-900">Checked In</h4>
                                                <p class="text-sm text-gray-500">You checked in at <fmt:formatDate value="${todayAttendance.checkInTime}" pattern="hh:mm a" /></p>
                                            </div>
                                        </div>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/employee/attendance/mark" method="post">
                                        <input type="hidden" name="action" value="check-out">
                                        <div class="space-y-6">
                                            <div class="sm:col-span-6">
                                                <label for="workSummary" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Work Summary</label>
                                                <div class="relative">
                                                    <textarea
                                                        id="workSummary"
                                                        name="workSummary"
                                                        rows="4"
                                                        class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700 resize-none"
                                                        placeholder="Summarize your work for today"
                                                    ></textarea>
                                                </div>
                                                <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Provide a summary of tasks completed today.</p>
                                            </div>

                                            <div class="sm:col-span-6">
                                                <label for="tasksCompleted" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Tasks Completed</label>
                                                <div class="relative">
                                                    <input
                                                        type="number"
                                                        name="tasksCompleted"
                                                        id="tasksCompleted"
                                                        min="0"
                                                        class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700"
                                                        placeholder="Number of tasks completed"
                                                    >
                                                </div>
                                                <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Enter the number of tasks you completed today.</p>
                                            </div>

                                            <div class="sm:col-span-6">
                                                <label for="notes" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Notes (Optional)</label>
                                                <div class="relative">
                                                    <textarea
                                                        id="notes"
                                                        name="notes"
                                                        rows="4"
                                                        class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg px-4 py-3 transition-all duration-200 ease-in-out hover:border-primary-300 dark:hover:border-primary-700 resize-none"
                                                        placeholder="Enter any notes or comments about your work today..."
                                                    >${todayAttendance.notes}</textarea>
                                                </div>
                                                <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Additional notes or comments about your work day.</p>
                                            </div>

                                            <div>
                                                <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                                                    <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m-4-4v8a3 3 0 003 3h8a3 3 0 003-3V7a3 3 0 00-3-3H6a3 3 0 00-3 3v8" />
                                                    </svg>
                                                    Check Out
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <!-- Already Checked Out -->
                                    <div class="py-8">
                                        <div class="flex items-center justify-center mb-6">
                                            <div class="flex items-center justify-center h-16 w-16 rounded-full bg-green-100">
                                                <svg class="h-8 w-8 text-green-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                                </svg>
                                            </div>
                                            <div class="ml-4 text-left">
                                                <h3 class="text-lg font-medium text-gray-900">Attendance Completed</h3>
                                                <p class="text-sm text-gray-500">You have successfully recorded your attendance for today</p>
                                            </div>
                                        </div>

                                        <div class="bg-gray-50 rounded-lg p-4 mb-6">
                                            <h4 class="text-md font-medium text-gray-900 mb-3">Attendance Details</h4>
                                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                                <div class="bg-white p-3 rounded shadow-sm">
                                                    <div class="text-xs text-gray-500">Check-in Time</div>
                                                    <div class="text-lg font-semibold text-primary-600"><fmt:formatDate value="${todayAttendance.checkInTime}" pattern="hh:mm a" /></div>
                                                </div>
                                                <div class="bg-white p-3 rounded shadow-sm">
                                                    <div class="text-xs text-gray-500">Check-out Time</div>
                                                    <div class="text-lg font-semibold text-primary-600"><fmt:formatDate value="${todayAttendance.checkOutTime}" pattern="hh:mm a" /></div>
                                                </div>
                                                <div class="bg-white p-3 rounded shadow-sm">
                                                    <div class="text-xs text-gray-500">Work Duration</div>
                                                    <div class="text-lg font-semibold text-primary-600">${todayAttendance.workDuration}</div>
                                                </div>
                                                <div class="bg-white p-3 rounded shadow-sm">
                                                    <div class="text-xs text-gray-500">Status</div>
                                                    <div class="text-lg font-semibold ${todayAttendance.status == 'PRESENT' ? 'text-green-600' : todayAttendance.status == 'LATE' ? 'text-yellow-600' : todayAttendance.status == 'HALF_DAY' ? 'text-orange-600' : 'text-red-600'}">${todayAttendance.status}</div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="bg-gray-50 rounded-lg p-4 mb-6">
                                            <h4 class="text-md font-medium text-gray-900 mb-2">Notes</h4>
                                            <p class="text-sm text-gray-700">${empty todayAttendance.notes ? 'No notes provided' : todayAttendance.notes}</p>
                                        </div>

                                        <div class="flex justify-center mt-6">
                                            <a href="${pageContext.request.contextPath}/employee/attendance/view" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                                                <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                                                </svg>
                                                View Attendance History
                                            </a>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Recent Attendance Activities -->
                    <div class="mt-8 w-full">
                        <jsp:include page="/WEB-INF/components/recent-activities.jsp">
                            <jsp:param name="title" value="Recent Attendance Activities" />
                            <jsp:param name="entityType" value="ATTENDANCE" />
                            <jsp:param name="limit" value="5" />
                        </jsp:include>
                    </div>
                </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="additionalHead" value="${additionalHead}" />
</jsp:include>
