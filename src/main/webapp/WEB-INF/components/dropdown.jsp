<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Dropdown Menu Component Usage:

<jsp:include page="/WEB-INF/components/dropdown.jsp">
    <jsp:param name="dropdownId" value="userDropdown" />
    <jsp:param name="buttonText" value="Options" />
    <jsp:param name="buttonIcon" value="dots-vertical" />
    <jsp:param name="buttonClass" value="text-gray-500 hover:text-gray-700" />
    <jsp:param name="items" value="[
        {
            'text': 'Edit',
            'icon': 'pencil',
            'url': '/edit/1',
            'type': 'link'
        },
        {
            'text': 'Delete',
            'icon': 'trash',
            'onClick': 'deleteItem(1)',
            'type': 'button',
            'class': 'text-red-600 hover:text-red-900'
        },
        {
            'type': 'divider'
        },
        {
            'text': 'View Details',
            'icon': 'eye',
            'url': '/view/1',
            'type': 'link'
        }
    ]" />
</jsp:include>
--%>

<c:set var="dropdownId" value="${param.dropdownId}" />
<c:set var="buttonText" value="${param.buttonText}" />
<c:set var="buttonIcon" value="${param.buttonIcon}" />
<c:set var="buttonClass" value="${param.buttonClass}" />
<c:set var="items" value="${param.items}" />

<%-- Default values --%>
<c:if test="${empty dropdownId}">
    <c:set var="dropdownId" value="dropdown-${System.currentTimeMillis()}" />
</c:if>
<c:if test="${empty buttonClass}">
    <c:set var="buttonClass" value="text-gray-500 hover:text-gray-700" />
</c:if>

<div class="relative inline-block text-left" id="${dropdownId}-container">
    <div>
        <button type="button" 
                class="inline-flex items-center justify-center ${buttonClass} focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 rounded-md"
                id="${dropdownId}-button"
                aria-expanded="false"
                aria-haspopup="true"
                onclick="toggleDropdown('${dropdownId}')">
            <c:if test="${not empty buttonText}">
                <span>${buttonText}</span>
            </c:if>
            
            <c:choose>
                <c:when test="${buttonIcon eq 'dots-vertical'}">
                    <svg class="${not empty buttonText ? 'ml-2' : ''} h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path d="M10 6a2 2 0 110-4 2 2 0 010 4zM10 12a2 2 0 110-4 2 2 0 010 4zM10 18a2 2 0 110-4 2 2 0 010 4z" />
                    </svg>
                </c:when>
                <c:when test="${buttonIcon eq 'dots-horizontal'}">
                    <svg class="${not empty buttonText ? 'ml-2' : ''} h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z" />
                    </svg>
                </c:when>
                <c:when test="${buttonIcon eq 'chevron-down'}">
                    <svg class="${not empty buttonText ? 'ml-2' : ''} h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                    </svg>
                </c:when>
                <c:when test="${buttonIcon eq 'user'}">
                    <svg class="${not empty buttonText ? 'ml-2' : ''} h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                    </svg>
                </c:when>
                <c:when test="${buttonIcon eq 'cog'}">
                    <svg class="${not empty buttonText ? 'ml-2' : ''} h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path fill-rule="evenodd" d="M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 01-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 01.947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 012.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 012.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 01.947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 01-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 01-2.287-.947zM10 13a3 3 0 100-6 3 3 0 000 6z" clip-rule="evenodd" />
                    </svg>
                </c:when>
            </c:choose>
        </button>
    </div>
    
    <div class="origin-top-right absolute right-0 mt-2 w-56 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 focus:outline-none z-10 hidden"
         role="menu"
         aria-orientation="vertical"
         aria-labelledby="${dropdownId}-button"
         tabindex="-1"
         id="${dropdownId}-menu">
        <div class="py-1" role="none">
            <c:if test="${not empty items}">
                <script>
                    try {
                        const itemsJson = ${items};
                        
                        // Create dropdown items
                        const menuElement = document.getElementById('${dropdownId}-menu');
                        if (menuElement) {
                            const menuContent = document.createElement('div');
                            menuContent.className = 'py-1';
                            menuContent.setAttribute('role', 'none');
                            
                            itemsJson.forEach(item => {
                                if (item.type === 'divider') {
                                    // Add divider
                                    const divider = document.createElement('div');
                                    divider.className = 'border-t border-gray-100 my-1';
                                    menuContent.appendChild(divider);
                                } else if (item.type === 'link') {
                                    // Add link item
                                    const link = document.createElement('a');
                                    link.href = item.url;
                                    link.className = item.class || 'text-gray-700 hover:bg-gray-100 hover:text-gray-900 block px-4 py-2 text-sm';
                                    link.setAttribute('role', 'menuitem');
                                    link.tabIndex = '-1';
                                    
                                    // Create content with icon if provided
                                    if (item.icon) {
                                        link.innerHTML = getIconHtml(item.icon) + ' ' + item.text;
                                        link.className += ' flex items-center';
                                    } else {
                                        link.textContent = item.text;
                                    }
                                    
                                    menuContent.appendChild(link);
                                } else if (item.type === 'button') {
                                    // Add button item
                                    const button = document.createElement('button');
                                    button.type = 'button';
                                    button.className = item.class || 'text-gray-700 hover:bg-gray-100 hover:text-gray-900 block w-full text-left px-4 py-2 text-sm';
                                    button.setAttribute('role', 'menuitem');
                                    button.tabIndex = '-1';
                                    
                                    if (item.onClick) {
                                        button.setAttribute('onclick', item.onClick);
                                    }
                                    
                                    // Create content with icon if provided
                                    if (item.icon) {
                                        button.innerHTML = getIconHtml(item.icon) + ' ' + item.text;
                                        button.className += ' flex items-center';
                                    } else {
                                        button.textContent = item.text;
                                    }
                                    
                                    menuContent.appendChild(button);
                                }
                            });
                            
                            menuElement.innerHTML = '';
                            menuElement.appendChild(menuContent);
                        }
                    } catch (e) {
                        console.error('Error parsing dropdown items:', e);
                    }
                    
                    // Helper function to get icon HTML
                    function getIconHtml(iconName) {
                        let iconHtml = '';
                        
                        switch (iconName) {
                            case 'pencil':
                                iconHtml = '<svg class="mr-3 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" /></svg>';
                                break;
                            case 'trash':
                                iconHtml = '<svg class="mr-3 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" /></svg>';
                                break;
                            case 'eye':
                                iconHtml = '<svg class="mr-3 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path d="M10 12a2 2 0 100-4 2 2 0 000 4z" /><path fill-rule="evenodd" d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z" clip-rule="evenodd" /></svg>';
                                break;
                            case 'download':
                                iconHtml = '<svg class="mr-3 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M3 17a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm3.293-7.707a1 1 0 011.414 0L9 10.586V3a1 1 0 112 0v7.586l1.293-1.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd" /></svg>';
                                break;
                            case 'check':
                                iconHtml = '<svg class="mr-3 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" /></svg>';
                                break;
                            case 'x':
                                iconHtml = '<svg class="mr-3 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" /></svg>';
                                break;
                            default:
                                iconHtml = '';
                        }
                        
                        return iconHtml;
                    }
                </script>
            </c:if>
        </div>
    </div>
</div>

<script>
    // Close all dropdowns when clicking outside
    document.addEventListener('click', function(event) {
        const dropdowns = document.querySelectorAll('[id$="-menu"]');
        dropdowns.forEach(dropdown => {
            const container = document.getElementById(dropdown.id.replace('-menu', '-container'));
            if (container && !container.contains(event.target)) {
                dropdown.classList.add('hidden');
            }
        });
    });
    
    // Toggle dropdown visibility
    function toggleDropdown(dropdownId) {
        const menu = document.getElementById(dropdownId + '-menu');
        if (menu) {
            menu.classList.toggle('hidden');
            
            // Close other dropdowns
            const allDropdowns = document.querySelectorAll('[id$="-menu"]');
            allDropdowns.forEach(dropdown => {
                if (dropdown.id !== dropdownId + '-menu') {
                    dropdown.classList.add('hidden');
                }
            });
        }
    }
</script>
