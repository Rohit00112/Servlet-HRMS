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
                    <div class="flex items-center justify-between">
                        <h1 class="text-2xl font-semibold text-gray-900">Mark Attendance</h1>
                        <a href="${pageContext.request.contextPath}/employee/attendance/view" class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md shadow-sm text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                            <svg class="-ml-1 mr-2 h-5 w-5 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                            </svg>
                            View Attendance
                        </a>
                    </div>

                    <!-- Success/Error Messages -->
                    <c:if test="${not empty successMessage}">
                        <div class="mt-4 bg-green-50 border-l-4 border-green-400 p-4">
                            <div class="flex">
                                <div class="flex-shrink-0">
                                    <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <div class="ml-3">
                                    <p class="text-sm text-green-700">${successMessage}</p>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="mt-4 bg-red-50 border-l-4 border-red-400 p-4">
                            <div class="flex">
                                <div class="flex-shrink-0">
                                    <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <div class="ml-3">
                                    <p class="text-sm text-red-700">${errorMessage}</p>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Attendance Rules -->
                    <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg">
                        <div class="px-4 py-5 sm:px-6 bg-blue-50">
                            <h3 class="text-lg leading-6 font-medium text-blue-900">Attendance Rules</h3>
                            <p class="mt-1 max-w-2xl text-sm text-blue-700">
                                Please review the company attendance policy
                            </p>
                        </div>
                        <div class="border-t border-gray-200 px-4 py-5 sm:p-6">
                            <div class="space-y-4 text-sm text-gray-600">
                                <div class="flex items-start">
                                    <div class="flex-shrink-0 mt-0.5">
                                        <svg class="h-4 w-4 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                    </div>
                                    <p class="ml-2">Working hours are from <span class="font-medium">9:00 AM to 5:00 PM</span>, Monday through Friday.</p>
                                </div>
                                <div class="flex items-start">
                                    <div class="flex-shrink-0 mt-0.5">
                                        <svg class="h-4 w-4 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                    </div>
                                    <p class="ml-2">Check-in after <span class="font-medium">9:15 AM</span> will be marked as <span class="font-medium text-yellow-600">LATE</span>.</p>
                                </div>
                                <div class="flex items-start">
                                    <div class="flex-shrink-0 mt-0.5">
                                        <svg class="h-4 w-4 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                    </div>
                                    <p class="ml-2">Working less than <span class="font-medium">6 hours</span> will be considered as <span class="font-medium text-orange-600">HALF DAY</span>.</p>
                                </div>
                                <div class="flex items-start">
                                    <div class="flex-shrink-0 mt-0.5">
                                        <svg class="h-4 w-4 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                    </div>
                                    <p class="ml-2">Failure to check-in or check-out will result in <span class="font-medium text-red-600">ABSENT</span> status.</p>
                                </div>
                                <div class="flex items-start">
                                    <div class="flex-shrink-0 mt-0.5">
                                        <svg class="h-4 w-4 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                    </div>
                                    <p class="ml-2">If you're working remotely, please mention it in the notes section.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Attendance Card -->
                    <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg">
                        <div class="px-4 py-5 sm:px-6 bg-gray-50">
                            <div class="flex justify-between items-center">
                                <div>
                                    <h3 class="text-lg leading-6 font-medium text-gray-900">Today's Attendance</h3>
                                    <p class="mt-1 max-w-2xl text-sm text-gray-500">
                                        <fmt:formatDate value="${today}" pattern="EEEE, MMMM d, yyyy" />
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
                                            <div>
                                                <label for="workType" class="block text-sm font-medium text-gray-700">Work Type</label>
                                                <div class="mt-1">
                                                    <select id="workType" name="workType" class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md">
                                                        <option value="OFFICE">Office</option>
                                                        <option value="REMOTE">Remote</option>
                                                        <option value="HYBRID">Hybrid</option>
                                                        <option value="FIELD">Field Work</option>
                                                    </select>
                                                </div>
                                                <p class="mt-2 text-sm text-gray-500">Select your work location for today.</p>
                                            </div>
                                            <div>
                                                <label for="notes" class="block text-sm font-medium text-gray-700">Notes (Optional)</label>
                                                <div class="mt-1">
                                                    <textarea id="notes" name="notes" rows="3" class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"></textarea>
                                                </div>
                                                <p class="mt-2 text-sm text-gray-500">Brief note about your work for today.</p>
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
                                            <div>
                                                <label for="workSummary" class="block text-sm font-medium text-gray-700">Work Summary</label>
                                                <div class="mt-1">
                                                    <textarea id="workSummary" name="workSummary" rows="3" class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" placeholder="Summarize your work for today"></textarea>
                                                </div>
                                                <p class="mt-2 text-sm text-gray-500">Provide a summary of tasks completed today.</p>
                                            </div>

                                            <div>
                                                <label for="tasksCompleted" class="block text-sm font-medium text-gray-700">Tasks Completed</label>
                                                <div class="mt-1">
                                                    <input type="number" name="tasksCompleted" id="tasksCompleted" min="0" class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" placeholder="Number of tasks completed">
                                                </div>
                                                <p class="mt-2 text-sm text-gray-500">Enter the number of tasks you completed today.</p>
                                            </div>

                                            <div>
                                                <label for="notes" class="block text-sm font-medium text-gray-700">Notes (Optional)</label>
                                                <div class="mt-1">
                                                    <textarea id="notes" name="notes" rows="3" class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md">${todayAttendance.notes}</textarea>
                                                </div>
                                                <p class="mt-2 text-sm text-gray-500">Additional notes or comments about your work day.</p>
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
                </div>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="additionalHead" value="${additionalHead}" />
</jsp:include>
