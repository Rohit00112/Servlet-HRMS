<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Notifications" scope="request" />
<c:set var="userRole" value="employee" scope="request" />

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

    <!-- Notification Header -->
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-semibold text-gray-800">All Notifications</h2>
        <c:if test="${not empty notifications}">
            <button id="mark-all-read-btn" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                Mark All as Read
            </button>
        </c:if>
    </div>

    <!-- Notifications List -->
    <div class="backdrop-blur-xl bg-gradient-to-br from-blue-50/80 to-indigo-50/80 border border-blue-100/50 shadow overflow-hidden sm:rounded-lg">
        <c:choose>
            <c:when test="${empty notifications}">
                <div class="p-8 text-center">
                    <svg class="mx-auto h-12 w-12 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                    </svg>
                    <h3 class="mt-2 text-lg font-medium text-gray-900">No notifications</h3>
                    <p class="mt-1 text-sm text-gray-500">You don't have any notifications at the moment.</p>
                </div>
            </c:when>
            <c:otherwise>
                <ul class="divide-y divide-gray-200">
                    <c:forEach var="notification" items="${notifications}">
                        <li class="notification-item p-6 hover:bg-blue-50/50 transition-colors duration-150 ${notification.read ? 'bg-gray-50/50' : ''}" data-id="${notification.id}">
                            <div class="flex items-start">
                                <!-- Notification Icon -->
                                <div class="flex-shrink-0 mr-4">
                                    <c:choose>
                                        <c:when test="${notification.type eq 'SUCCESS'}">
                                            <div class="h-10 w-10 rounded-full bg-green-100 flex items-center justify-center">
                                                <svg class="h-6 w-6 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                                </svg>
                                            </div>
                                        </c:when>
                                        <c:when test="${notification.type eq 'WARNING'}">
                                            <div class="h-10 w-10 rounded-full bg-yellow-100 flex items-center justify-center">
                                                <svg class="h-6 w-6 text-yellow-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                                    <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                                                </svg>
                                            </div>
                                        </c:when>
                                        <c:when test="${notification.type eq 'ERROR'}">
                                            <div class="h-10 w-10 rounded-full bg-red-100 flex items-center justify-center">
                                                <svg class="h-6 w-6 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                                                </svg>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center">
                                                <svg class="h-6 w-6 text-blue-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                                    <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
                                                </svg>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <!-- Notification Content -->
                                <div class="flex-1">
                                    <div class="flex items-center justify-between">
                                        <h3 class="text-lg font-medium text-gray-900">${notification.title}</h3>
                                        <c:if test="${!notification.read}">
                                            <button type="button" class="mark-read-btn ml-2 text-sm text-gray-500 hover:text-gray-700" data-id="${notification.id}">
                                                Mark as read
                                            </button>
                                        </c:if>
                                    </div>
                                    <p class="mt-1 text-sm text-gray-600">${notification.message}</p>
                                    <p class="mt-2 text-xs text-gray-500">
                                        <fmt:formatDate value="${notification.createdAt}" pattern="MMM dd, yyyy HH:mm" />
                                    </p>
                                </div>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
                
                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6">
                        <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                            <div>
                                <p class="text-sm text-gray-700">
                                    Showing <span class="font-medium">${(currentPage - 1) * 10 + 1}</span> to <span class="font-medium">${Math.min(currentPage * 10, totalNotifications)}</span> of <span class="font-medium">${totalNotifications}</span> notifications
                                </p>
                            </div>
                            <div>
                                <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                                    <!-- Previous Page -->
                                    <a href="${pageContext.request.contextPath}/notifications?page=${currentPage - 1}" class="${currentPage == 1 ? 'pointer-events-none bg-gray-100' : 'bg-white'} relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 text-sm font-medium text-gray-500 hover:bg-gray-50">
                                        <span class="sr-only">Previous</span>
                                        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                            <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                                        </svg>
                                    </a>
                                    
                                    <!-- Page Numbers -->
                                    <c:forEach begin="1" end="${totalPages}" var="page">
                                        <a href="${pageContext.request.contextPath}/notifications?page=${page}" class="${page == currentPage ? 'z-10 bg-primary-50 border-primary-500 text-primary-600' : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50'} relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                                            ${page}
                                        </a>
                                    </c:forEach>
                                    
                                    <!-- Next Page -->
                                    <a href="${pageContext.request.contextPath}/notifications?page=${currentPage + 1}" class="${currentPage == totalPages ? 'pointer-events-none bg-gray-100' : 'bg-white'} relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 text-sm font-medium text-gray-500 hover:bg-gray-50">
                                        <span class="sr-only">Next</span>
                                        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                                        </svg>
                                    </a>
                                </nav>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>
</c:set>

<c:set var="additionalScripts">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const markAllReadBtn = document.getElementById('mark-all-read-btn');
            const markReadBtns = document.querySelectorAll('.mark-read-btn');
            
            // Mark all notifications as read
            if (markAllReadBtn) {
                markAllReadBtn.addEventListener('click', function() {
                    fetch('${pageContext.request.contextPath}/notifications/mark-all-read', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        }
                    })
                    .then(response => {
                        if (response.ok) {
                            // Reload the page to show updated state
                            window.location.reload();
                        }
                    })
                    .catch(error => {
                        console.error('Error marking all notifications as read:', error);
                    });
                });
            }
            
            // Mark individual notification as read
            markReadBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const notificationId = this.getAttribute('data-id');
                    
                    fetch('${pageContext.request.contextPath}/notifications/mark-read', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: 'id=' + notificationId
                    })
                    .then(response => {
                        if (response.ok) {
                            // Update UI
                            this.remove();
                            const notificationItem = document.querySelector(`.notification-item[data-id="${notificationId}"]`);
                            if (notificationItem) {
                                notificationItem.classList.add('bg-gray-50/50');
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error marking notification as read:', error);
                    });
                });
            });
        });
    </script>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="additionalScripts" value="${additionalScripts}" />
</jsp:include>
