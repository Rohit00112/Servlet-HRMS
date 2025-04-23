<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- 
    Recent Activities Component
    
    Parameters:
    - activities: List of UserActivity objects
    - title: Optional title for the activities section (default: "Recent Activities")
    - limit: Optional limit for the number of activities to display (default: all)
    - entityType: Optional filter for entity type
-->

<c:set var="activityTitle" value="${param.title != null ? param.title : 'Recent Activities'}" />
<c:set var="activityLimit" value="${param.limit != null ? param.limit : activities.size()}" />

<div class="mt-6 backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 border border-blue-100/50 shadow overflow-hidden sm:rounded-lg">
    <div class="px-4 py-5 sm:px-6">
        <h3 class="text-lg leading-6 font-medium text-gray-900">${activityTitle}</h3>
    </div>
    <div class="border-t border-gray-200">
        <ul class="divide-y divide-gray-200">
            <c:choose>
                <c:when test="${not empty activities}">
                    <c:set var="count" value="0" />
                    <c:forEach var="activity" items="${activities}">
                        <c:if test="${(param.entityType == null || activity.entityType == param.entityType) && count < activityLimit}">
                            <c:set var="count" value="${count + 1}" />
                            <li class="hover:bg-gray-50 transition-colors duration-150">
                                <div class="px-4 py-4 sm:px-6">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-10 w-10 rounded-full bg-${activity.colorClass}-100 flex items-center justify-center">
                                                <svg class="h-6 w-6 text-${activity.colorClass}-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <c:choose>
                                                        <c:when test="${activity.iconClass == 'login'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" />
                                                        </c:when>
                                                        <c:when test="${activity.iconClass == 'logout'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                                                        </c:when>
                                                        <c:when test="${activity.iconClass == 'plus'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                                                        </c:when>
                                                        <c:when test="${activity.iconClass == 'pencil'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                                                        </c:when>
                                                        <c:when test="${activity.iconClass == 'trash'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                                        </c:when>
                                                        <c:when test="${activity.iconClass == 'check'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                                        </c:when>
                                                        <c:when test="${activity.iconClass == 'x'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                                                        </c:when>
                                                        <c:when test="${activity.iconClass == 'eye'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                                        </c:when>
                                                        <c:when test="${activity.iconClass == 'download'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                                                        </c:when>
                                                        <c:when test="${activity.iconClass == 'upload'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
                                                        </c:when>
                                                        <c:when test="${activity.iconClass == 'clock'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                        </c:when>
                                                        <c:when test="${activity.iconClass == 'calendar'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                                        </c:when>
                                                        <c:when test="${activity.iconClass == 'currency-dollar'}">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </svg>
                                            </div>
                                            <div class="ml-4">
                                                <div class="text-sm font-medium text-gray-900">${activity.activityType}</div>
                                                <div class="text-sm text-gray-500">${activity.description}</div>
                                            </div>
                                        </div>
                                        <div class="ml-2 flex-shrink-0 flex">
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-${activity.colorClass}-100 text-${activity.colorClass}-800">${activity.formattedTimestamp}</span>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <li class="py-8">
                        <div class="text-center">
                            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                            </svg>
                            <h3 class="mt-2 text-sm font-medium text-gray-900">No recent activities</h3>
                            <p class="mt-1 text-sm text-gray-500">No activities found for this section.</p>
                        </div>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</div>
