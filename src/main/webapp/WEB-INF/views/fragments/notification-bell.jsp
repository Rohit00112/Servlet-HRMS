<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="relative">
    <button type="button" class="relative p-1 text-gray-600 hover:text-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 rounded-full" id="notification-bell-button" aria-expanded="false" aria-haspopup="true">
        <span class="sr-only">View notifications</span>
        <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
        </svg>

        <c:if test="${not empty layout and layout.unreadNotificationCount > 0}">
            <span class="absolute top-0 right-0 block h-5 w-5 rounded-full bg-red-500 text-white text-xs font-bold flex items-center justify-center">
                <c:choose>
                    <c:when test="${layout.unreadNotificationCount > 9}">9+</c:when>
                    <c:otherwise>${layout.unreadNotificationCount}</c:otherwise>
                </c:choose>
            </span>
        </c:if>
    </button>

    <div class="hidden origin-top-right absolute right-0 mt-2 w-full sm:w-80 rounded-md shadow-lg bg-white dark:bg-gray-800 ring-1 ring-black ring-opacity-5 z-20 max-h-96 overflow-hidden flex flex-col" id="notification-dropdown">
        <div class="py-2 px-4 bg-gray-50 dark:bg-gray-700 border-b border-gray-200 dark:border-gray-600 flex justify-between items-center">
            <h3 class="text-sm font-medium text-gray-700 dark:text-gray-200">Notifications</h3>
            <div class="flex space-x-2">
                <c:if test="${not empty layout and layout.unreadNotificationCount > 0}">
                    <button type="button" id="mark-all-read-btn" class="text-xs text-primary-600 hover:text-primary-800 dark:text-primary-400 dark:hover:text-primary-300">
                        Mark all as read
                    </button>
                </c:if>
                <a href="${pageContext.request.contextPath}/notifications" class="text-xs text-gray-600 hover:text-gray-800 dark:text-gray-300 dark:hover:text-gray-100">
                    View all
                </a>
            </div>
        </div>

        <div class="overflow-y-auto max-h-80" id="notification-list">
            <c:choose>
                <c:when test="${empty layout or not layout.employeeLinked}">
                    <div class="py-4 px-4 text-center text-sm text-gray-500 dark:text-gray-400">
                        Notifications will appear once your employee profile is linked.
                    </div>
                </c:when>
                <c:when test="${empty layout.notifications}">
                    <div class="py-4 px-4 text-center text-sm text-gray-500 dark:text-gray-400">
                        No new notifications
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${layout.notifications}" var="notification">
                        <div class="notification-item p-4 border-b border-gray-100 hover:bg-gray-50" data-id="${notification.id}">
                            <div class="flex items-start">
                                <div class="flex-shrink-0 mr-3">
                                    <c:choose>
                                        <c:when test="${notification.type eq 'SUCCESS'}">
                                            <div class="h-8 w-8 rounded-full bg-green-100 flex items-center justify-center">
                                                <svg class="h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                                </svg>
                                            </div>
                                        </c:when>
                                        <c:when test="${notification.type eq 'WARNING'}">
                                            <div class="h-8 w-8 rounded-full bg-yellow-100 flex items-center justify-center">
                                                <svg class="h-5 w-5 text-yellow-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                                    <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                                                </svg>
                                            </div>
                                        </c:when>
                                        <c:when test="${notification.type eq 'ERROR'}">
                                            <div class="h-8 w-8 rounded-full bg-red-100 flex items-center justify-center">
                                                <svg class="h-5 w-5 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                                                </svg>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="h-8 w-8 rounded-full bg-blue-100 flex items-center justify-center">
                                                <svg class="h-5 w-5 text-blue-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                                    <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
                                                </svg>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="flex-1">
                                    <div class="flex items-center justify-between">
                                        <p class="text-sm font-medium text-gray-900">${notification.title}</p>
                                        <button type="button" class="mark-read-btn ml-2 text-xs text-gray-400 hover:text-gray-600" data-id="${notification.id}">
                                            <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                                            </svg>
                                        </button>
                                    </div>
                                    <p class="text-xs text-gray-500 mt-1">${notification.message}</p>
                                    <p class="text-xs text-gray-400 mt-1"><fmt:formatDate value="${notification.createdAt}" pattern="MMM dd, yyyy HH:mm" /></p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    const notificationBellButton = document.getElementById('notification-bell-button');
    const notificationDropdown = document.getElementById('notification-dropdown');
    const markAllReadBtn = document.getElementById('mark-all-read-btn');
    const markReadBtns = document.querySelectorAll('.mark-read-btn');

    if (notificationBellButton && notificationDropdown) {
        notificationBellButton.addEventListener('click', function() {
            notificationDropdown.classList.toggle('hidden');
        });

        document.addEventListener('click', function(event) {
            if (!notificationBellButton.contains(event.target) && !notificationDropdown.contains(event.target)) {
                notificationDropdown.classList.add('hidden');
            }
        });
    }

    if (markAllReadBtn) {
        markAllReadBtn.addEventListener('click', function() {
            fetch('${pageContext.request.contextPath}/notifications/mark-all-read', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            }).then(response => {
                if (response.ok) {
                    document.querySelectorAll('.notification-item').forEach(item => item.remove());
                    const badge = notificationBellButton.querySelector('span.absolute');
                    if (badge) {
                        badge.remove();
                    }
                    document.getElementById('notification-list').innerHTML =
                        '<div class="py-4 px-4 text-center text-sm text-gray-500">No new notifications</div>';
                    markAllReadBtn.style.display = 'none';
                }
            }).catch(error => console.error('Error marking all notifications as read:', error));
        });
    }

    markReadBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            const notificationId = this.getAttribute('data-id');

            fetch('${pageContext.request.contextPath}/notifications/mark-read', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'id=' + notificationId
            }).then(response => {
                if (!response.ok) {
                    return;
                }

                const notificationItem = this.closest('.notification-item');
                if (notificationItem) {
                    notificationItem.remove();
                }

                const badge = notificationBellButton.querySelector('span.absolute');
                if (badge) {
                    const count = parseInt(badge.textContent, 10);
                    if (count > 1 && !Number.isNaN(count)) {
                        badge.textContent = count - 1;
                    } else {
                        badge.remove();
                    }
                }

                if (document.querySelectorAll('.notification-item').length === 0) {
                    document.getElementById('notification-list').innerHTML =
                        '<div class="py-4 px-4 text-center text-sm text-gray-500">No new notifications</div>';
                }
            }).catch(error => console.error('Error marking notification as read:', error));
        });
    });
</script>
