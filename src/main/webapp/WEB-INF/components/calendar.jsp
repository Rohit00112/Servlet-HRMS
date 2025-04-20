<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%--
Calendar Component Usage:

<jsp:include page="/WEB-INF/components/calendar.jsp">
    <jsp:param name="calendarId" value="attendanceCalendar" />
    <jsp:param name="year" value="${year}" />
    <jsp:param name="month" value="${month}" />
    <jsp:param name="events" value="${events}" />
    <jsp:param name="selectable" value="true" />
    <jsp:param name="onDateSelect" value="handleDateSelect" />
</jsp:include>

Events should be in the format:
[
  {
    "date": "2023-06-15",
    "title": "Event Title",
    "type": "success|warning|danger|info",
    "url": "/path/to/event"
  }
]
--%>

<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.DayOfWeek" %>
<%@ page import="java.util.Locale" %>

<c:set var="calendarId" value="${param.calendarId}" />
<c:set var="yearParam" value="${param.year}" />
<c:set var="monthParam" value="${param.month}" />
<c:set var="events" value="${param.events}" />
<c:set var="selectable" value="${param.selectable}" />
<c:set var="onDateSelect" value="${param.onDateSelect}" />

<%-- Default values --%>
<c:if test="${empty calendarId}">
    <c:set var="calendarId" value="calendar-${System.currentTimeMillis()}" />
</c:if>
<c:if test="${empty selectable}">
    <c:set var="selectable" value="false" />
</c:if>

<%
    // Get current date if not provided
    LocalDate today = LocalDate.now();
    int year = today.getYear();
    int month = today.getMonthValue();
    
    if (request.getParameter("year") != null) {
        year = Integer.parseInt(request.getParameter("year"));
    }
    if (request.getParameter("month") != null) {
        month = Integer.parseInt(request.getParameter("month"));
    }
    
    // Create YearMonth object
    YearMonth yearMonth = YearMonth.of(year, month);
    
    // Get the first day of the month
    LocalDate firstOfMonth = yearMonth.atDay(1);
    
    // Get the day of week for the first day (1 = Monday, 7 = Sunday)
    int dayOfWeekValue = firstOfMonth.getDayOfWeek().getValue();
    
    // Adjust for Sunday as first day of week (0-indexed)
    int firstDayOffset = dayOfWeekValue % 7;
    
    // Get the number of days in the month
    int daysInMonth = yearMonth.lengthOfMonth();
    
    // Format month name
    String monthName = firstOfMonth.getMonth().toString();
    monthName = monthName.substring(0, 1) + monthName.substring(1).toLowerCase();
    
    // Set attributes for JSP
    request.setAttribute("year", year);
    request.setAttribute("month", month);
    request.setAttribute("monthName", monthName);
    request.setAttribute("firstDayOffset", firstDayOffset);
    request.setAttribute("daysInMonth", daysInMonth);
    request.setAttribute("today", today);
    request.setAttribute("currentYearMonth", YearMonth.of(today.getYear(), today.getMonthValue()));
    request.setAttribute("yearMonth", yearMonth);
    
    // Previous and next month links
    YearMonth prevMonth = yearMonth.minusMonths(1);
    YearMonth nextMonth = yearMonth.plusMonths(1);
    request.setAttribute("prevYear", prevMonth.getYear());
    request.setAttribute("prevMonth", prevMonth.getMonthValue());
    request.setAttribute("nextYear", nextMonth.getYear());
    request.setAttribute("nextMonth", nextMonth.getMonthValue());
%>

<div id="${calendarId}" class="calendar-container bg-white shadow overflow-hidden sm:rounded-lg">
    <div class="px-4 py-5 sm:px-6 bg-gray-50 flex justify-between items-center">
        <h3 class="text-lg leading-6 font-medium text-gray-900">${monthName} ${year}</h3>
        <div class="flex space-x-2">
            <a href="?year=${prevYear}&month=${prevMonth}" class="inline-flex items-center px-3 py-1 border border-gray-300 text-sm leading-5 font-medium rounded-md text-gray-700 bg-white hover:text-gray-500 focus:outline-none focus:border-blue-300 focus:shadow-outline-blue active:text-gray-800 active:bg-gray-50 transition ease-in-out duration-150">
                <svg class="h-5 w-5 mr-1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                Previous
            </a>
            <a href="?year=${nextYear}&month=${nextMonth}" class="inline-flex items-center px-3 py-1 border border-gray-300 text-sm leading-5 font-medium rounded-md text-gray-700 bg-white hover:text-gray-500 focus:outline-none focus:border-blue-300 focus:shadow-outline-blue active:text-gray-800 active:bg-gray-50 transition ease-in-out duration-150">
                Next
                <svg class="h-5 w-5 ml-1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                </svg>
            </a>
        </div>
    </div>
    
    <div class="border-t border-gray-200">
        <div class="grid grid-cols-7 gap-px bg-gray-200">
            <div class="bg-gray-50 py-2 text-center text-sm font-medium text-gray-500">Sun</div>
            <div class="bg-gray-50 py-2 text-center text-sm font-medium text-gray-500">Mon</div>
            <div class="bg-gray-50 py-2 text-center text-sm font-medium text-gray-500">Tue</div>
            <div class="bg-gray-50 py-2 text-center text-sm font-medium text-gray-500">Wed</div>
            <div class="bg-gray-50 py-2 text-center text-sm font-medium text-gray-500">Thu</div>
            <div class="bg-gray-50 py-2 text-center text-sm font-medium text-gray-500">Fri</div>
            <div class="bg-gray-50 py-2 text-center text-sm font-medium text-gray-500">Sat</div>
            
            <%-- Empty cells for days before the first day of the month --%>
            <c:forEach begin="0" end="${firstDayOffset - 1}" varStatus="loop">
                <div class="bg-white p-2 h-24 sm:h-32 border-b border-gray-200"></div>
            </c:forEach>
            
            <%-- Calendar days --%>
            <c:forEach begin="1" end="${daysInMonth}" varStatus="dayLoop">
                <c:set var="currentDate" value="${yearMonth.atDay(dayLoop.index)}" />
                <c:set var="isToday" value="${currentDate.equals(today)}" />
                <c:set var="dateString" value="${year}-${month < 10 ? '0' : ''}${month}-${dayLoop.index < 10 ? '0' : ''}${dayLoop.index}" />
                
                <div class="bg-white p-2 h-24 sm:h-32 border-b border-gray-200 relative ${selectable eq 'true' ? 'cursor-pointer hover:bg-gray-50' : ''}"
                     ${selectable eq 'true' ? 'onclick="' += onDateSelect += '(\'' += dateString += '\')"' : ''}>
                    <div class="absolute top-2 left-2 ${isToday ? 'bg-primary-600 text-white' : 'text-gray-700'} ${isToday ? 'rounded-full' : ''} h-6 w-6 flex items-center justify-center">
                        ${dayLoop.index}
                    </div>
                    
                    <%-- Events for this day --%>
                    <div class="mt-6 space-y-1">
                        <c:if test="${not empty events}">
                            <c:forEach var="event" items="${events}">
                                <c:if test="${event.date eq dateString}">
                                    <c:set var="eventTypeClass" value="" />
                                    <c:choose>
                                        <c:when test="${event.type eq 'success'}">
                                            <c:set var="eventTypeClass" value="bg-green-100 text-green-800" />
                                        </c:when>
                                        <c:when test="${event.type eq 'warning'}">
                                            <c:set var="eventTypeClass" value="bg-yellow-100 text-yellow-800" />
                                        </c:when>
                                        <c:when test="${event.type eq 'danger'}">
                                            <c:set var="eventTypeClass" value="bg-red-100 text-red-800" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="eventTypeClass" value="bg-blue-100 text-blue-800" />
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <c:choose>
                                        <c:when test="${not empty event.url}">
                                            <a href="${event.url}" class="block px-2 py-1 rounded text-xs ${eventTypeClass} truncate">
                                                ${event.title}
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="px-2 py-1 rounded text-xs ${eventTypeClass} truncate">
                                                ${event.title}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
            
            <%-- Calculate remaining cells to fill the grid --%>
            <c:set var="remainingCells" value="${(7 - ((firstDayOffset + daysInMonth) % 7)) % 7}" />
            <c:forEach begin="1" end="${remainingCells}" varStatus="loop">
                <div class="bg-white p-2 h-24 sm:h-32 border-b border-gray-200"></div>
            </c:forEach>
        </div>
    </div>
</div>

<c:if test="${selectable eq 'true' && not empty onDateSelect}">
    <script>
        // The date selection handler is defined by the onDateSelect parameter
        // and is called with the date string in format YYYY-MM-DD
    </script>
</c:if>
