<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="relative" id="notification-bell-container">
    <!-- Notification Bell Button -->
    <button type="button" class="relative p-1 text-gray-600 hover:text-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 rounded-full" id="notification-bell-button">
        <span class="sr-only">View notifications</span>
        <!-- Bell Icon -->
        <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
        </svg>
        
        <!-- Notification Badge -->
        <span id="notification-badge" class="hidden absolute top-0 right-0 block h-4 w-4 rounded-full bg-red-500 text-white text-xs font-bold flex items-center justify-center">0</span>
    </button>
    
    <!-- Notification Dropdown -->
    <div id="notification-dropdown" class="hidden origin-top-right absolute right-0 mt-2 w-80 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 z-20 max-h-96 overflow-y-auto">
        <div class="py-1">
            <div class="px-4 py-2 border-b border-gray-200">
                <div class="flex justify-between items-center">
                    <h3 class="text-sm font-medium text-gray-900">Notifications</h3>
                    <button id="mark-all-read" class="text-xs text-primary-600 hover:text-primary-800">Mark all as read</button>
                </div>
            </div>
            
            <!-- Loading Indicator -->
            <div id="notification-loading" class="px-4 py-8 text-center">
                <svg class="animate-spin h-6 w-6 text-primary-500 mx-auto" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                <p class="mt-2 text-sm text-gray-500">Loading notifications...</p>
            </div>
            
            <!-- Empty State -->
            <div id="notification-empty" class="hidden px-4 py-8 text-center">
                <svg class="h-12 w-12 text-gray-400 mx-auto" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                </svg>
                <p class="mt-2 text-sm text-gray-500">No notifications</p>
            </div>
            
            <!-- Notification List -->
            <div id="notification-list" class="hidden">
                <!-- Notifications will be dynamically inserted here -->
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const bellButton = document.getElementById('notification-bell-button');
        const dropdown = document.getElementById('notification-dropdown');
        const badge = document.getElementById('notification-badge');
        const loading = document.getElementById('notification-loading');
        const empty = document.getElementById('notification-empty');
        const list = document.getElementById('notification-list');
        const markAllReadBtn = document.getElementById('mark-all-read');
        
        let notifications = [];
        let unreadCount = 0;
        
        // Toggle dropdown
        bellButton.addEventListener('click', function() {
            dropdown.classList.toggle('hidden');
            if (!dropdown.classList.contains('hidden')) {
                fetchNotifications();
            }
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(event) {
            if (!bellButton.contains(event.target) && !dropdown.contains(event.target)) {
                dropdown.classList.add('hidden');
            }
        });
        
        // Mark all as read
        markAllReadBtn.addEventListener('click', function() {
            markAllAsRead();
        });
        
        // Fetch notifications
        function fetchNotifications() {
            loading.classList.remove('hidden');
            empty.classList.add('hidden');
            list.classList.add('hidden');
            list.innerHTML = '';
            
            fetch('${pageContext.request.contextPath}/api/notifications')
                .then(response => response.json())
                .then(data => {
                    notifications = data.notifications;
                    unreadCount = data.unreadCount;
                    
                    // Update badge
                    if (unreadCount > 0) {
                        badge.textContent = unreadCount > 9 ? '9+' : unreadCount;
                        badge.classList.remove('hidden');
                    } else {
                        badge.classList.add('hidden');
                    }
                    
                    // Show empty state if no notifications
                    if (notifications.length === 0) {
                        loading.classList.add('hidden');
                        empty.classList.remove('hidden');
                        return;
                    }
                    
                    // Render notifications
                    renderNotifications();
                    
                    loading.classList.add('hidden');
                    list.classList.remove('hidden');
                })
                .catch(error => {
                    console.error('Error fetching notifications:', error);
                    loading.classList.add('hidden');
                    empty.classList.remove('hidden');
                });
        }
        
        // Render notifications
        function renderNotifications() {
            list.innerHTML = '';
            
            notifications.forEach(notification => {
                const notificationEl = document.createElement('div');
                notificationEl.className = `px-4 py-3 hover:bg-gray-50 border-b border-gray-100 ${notification.read ? 'bg-white' : 'bg-blue-50'}`;
                
                // Format date
                const date = new Date(notification.createdAt);
                const formattedDate = formatDate(date);
                
                // Set notification type icon
                let typeIcon = '';
                switch(notification.type) {
                    case 'INFO':
                        typeIcon = '<div class="flex-shrink-0 h-8 w-8 rounded-full bg-blue-100 flex items-center justify-center"><svg class="h-5 w-5 text-blue-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" /></svg></div>';
                        break;
                    case 'SUCCESS':
                        typeIcon = '<div class="flex-shrink-0 h-8 w-8 rounded-full bg-green-100 flex items-center justify-center"><svg class="h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" /></svg></div>';
                        break;
                    case 'WARNING':
                        typeIcon = '<div class="flex-shrink-0 h-8 w-8 rounded-full bg-yellow-100 flex items-center justify-center"><svg class="h-5 w-5 text-yellow-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" /></svg></div>';
                        break;
                    case 'ERROR':
                        typeIcon = '<div class="flex-shrink-0 h-8 w-8 rounded-full bg-red-100 flex items-center justify-center"><svg class="h-5 w-5 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" /></svg></div>';
                        break;
                    default:
                        typeIcon = '<div class="flex-shrink-0 h-8 w-8 rounded-full bg-gray-100 flex items-center justify-center"><svg class="h-5 w-5 text-gray-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" /></svg></div>';
                }
                
                notificationEl.innerHTML = `
                    <div class="flex items-start">
                        ${typeIcon}
                        <div class="ml-3 flex-1">
                            <p class="text-sm font-medium text-gray-900">${notification.title}</p>
                            <p class="text-sm text-gray-500">${notification.message}</p>
                            <p class="text-xs text-gray-400 mt-1">${formattedDate}</p>
                        </div>
                        ${!notification.read ? `
                        <button class="mark-read-btn flex-shrink-0 ml-2 p-1 text-gray-400 hover:text-gray-500 rounded-full" data-id="${notification.id}">
                            <span class="sr-only">Mark as read</span>
                            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                            </svg>
                        </button>
                        ` : ''}
                    </div>
                `;
                
                list.appendChild(notificationEl);
            });
            
            // Add event listeners to mark read buttons
            document.querySelectorAll('.mark-read-btn').forEach(button => {
                button.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const id = this.getAttribute('data-id');
                    markAsRead(id);
                });
            });
        }
        
        // Mark notification as read
        function markAsRead(id) {
            fetch(`${pageContext.request.contextPath}/api/notifications/mark-read?id=${id}`, {
                method: 'POST'
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Update local data
                        notifications = notifications.map(notification => {
                            if (notification.id == id) {
                                notification.read = true;
                            }
                            return notification;
                        });
                        
                        unreadCount = Math.max(0, unreadCount - 1);
                        
                        // Update UI
                        if (unreadCount > 0) {
                            badge.textContent = unreadCount > 9 ? '9+' : unreadCount;
                            badge.classList.remove('hidden');
                        } else {
                            badge.classList.add('hidden');
                        }
                        
                        renderNotifications();
                    }
                })
                .catch(error => {
                    console.error('Error marking notification as read:', error);
                });
        }
        
        // Mark all notifications as read
        function markAllAsRead() {
            fetch('${pageContext.request.contextPath}/api/notifications/mark-all-read', {
                method: 'POST'
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Update local data
                        notifications = notifications.map(notification => {
                            notification.read = true;
                            return notification;
                        });
                        
                        unreadCount = 0;
                        
                        // Update UI
                        badge.classList.add('hidden');
                        renderNotifications();
                    }
                })
                .catch(error => {
                    console.error('Error marking all notifications as read:', error);
                });
        }
        
        // Format date helper
        function formatDate(date) {
            const now = new Date();
            const diffMs = now - date;
            const diffSec = Math.floor(diffMs / 1000);
            const diffMin = Math.floor(diffSec / 60);
            const diffHour = Math.floor(diffMin / 60);
            const diffDay = Math.floor(diffHour / 24);
            
            if (diffSec < 60) {
                return 'Just now';
            } else if (diffMin < 60) {
                return `${diffMin} minute${diffMin > 1 ? 's' : ''} ago`;
            } else if (diffHour < 24) {
                return `${diffHour} hour${diffHour > 1 ? 's' : ''} ago`;
            } else if (diffDay < 7) {
                return `${diffDay} day${diffDay > 1 ? 's' : ''} ago`;
            } else {
                const options = { year: 'numeric', month: 'short', day: 'numeric' };
                return date.toLocaleDateString(undefined, options);
            }
        }
        
        // Initial fetch to update badge
        fetchNotifications();
        
        // Fetch notifications every 5 minutes
        setInterval(fetchNotifications, 5 * 60 * 1000);
    });
</script>

<style>
    #notification-dropdown {
        max-height: 400px;
        overflow-y: auto;
    }
    
    /* Dark mode styles */
    .dark #notification-bell-button {
        color: #e5e7eb;
    }
    
    .dark #notification-bell-button:hover {
        color: #f9fafb;
    }
    
    .dark #notification-dropdown {
        background-color: #1f2937;
        border-color: #374151;
    }
    
    .dark #notification-dropdown h3 {
        color: #f9fafb;
    }
    
    .dark #notification-dropdown .border-gray-200 {
        border-color: #374151;
    }
    
    .dark #notification-dropdown .border-gray-100 {
        border-color: #374151;
    }
    
    .dark #notification-dropdown .bg-white {
        background-color: #1f2937;
    }
    
    .dark #notification-dropdown .bg-blue-50 {
        background-color: rgba(59, 130, 246, 0.1);
    }
    
    .dark #notification-dropdown .hover\:bg-gray-50:hover {
        background-color: #374151;
    }
    
    .dark #notification-dropdown .text-gray-900 {
        color: #f9fafb;
    }
    
    .dark #notification-dropdown .text-gray-500 {
        color: #9ca3af;
    }
    
    .dark #notification-dropdown .text-gray-400 {
        color: #9ca3af;
    }
    
    .dark #notification-empty svg {
        color: #6b7280;
    }
</style>
