<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Tabs Component Usage:

<jsp:include page="/WEB-INF/components/tabs.jsp">
    <jsp:param name="tabsId" value="myTabs" />
    <jsp:param name="activeTab" value="tab1" />
    <jsp:param name="tabs" value="tab1,tab2,tab3" />
    <jsp:param name="tabLabels" value="Tab 1,Tab 2,Tab 3" />
    <jsp:param name="tabContents" value="${tab1Content},${tab2Content},${tab3Content}" />
</jsp:include>

Alternative usage with content provided after the include:

<jsp:include page="/WEB-INF/components/tabs.jsp">
    <jsp:param name="tabsId" value="myTabs" />
    <jsp:param name="activeTab" value="tab1" />
    <jsp:param name="tabs" value="tab1,tab2,tab3" />
    <jsp:param name="tabLabels" value="Tab 1,Tab 2,Tab 3" />
</jsp:include>

<div id="tab1" class="tab-content ${param.activeTab eq 'tab1' ? '' : 'hidden'}">
    Tab 1 content here
</div>
<div id="tab2" class="tab-content ${param.activeTab eq 'tab2' ? '' : 'hidden'}">
    Tab 2 content here
</div>
<div id="tab3" class="tab-content ${param.activeTab eq 'tab3' ? '' : 'hidden'}">
    Tab 3 content here
</div>
--%>

<c:set var="tabsId" value="${param.tabsId}" />
<c:set var="activeTab" value="${param.activeTab}" />
<c:set var="tabs" value="${param.tabs}" />
<c:set var="tabLabels" value="${param.tabLabels}" />
<c:set var="tabContents" value="${param.tabContents}" />

<%-- Default values --%>
<c:if test="${empty tabsId}">
    <c:set var="tabsId" value="tabs-${System.currentTimeMillis()}" />
</c:if>

<div class="tabs-container">
    <div class="border-b border-gray-200">
        <nav class="-mb-px flex space-x-8" aria-label="Tabs">
            <c:set var="tabIndex" value="0" />
            <c:forTokens items="${tabs}" delims="," var="tab">
                <c:forTokens items="${tabLabels}" delims="," var="label" begin="${tabIndex}" end="${tabIndex}">
                    <button 
                        id="tab-${tab}" 
                        class="tab-button whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm ${activeTab eq tab ? 'border-primary-500 text-primary-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}"
                        onclick="switchTab('${tabsId}', '${tab}')"
                        aria-current="${activeTab eq tab ? 'page' : 'false'}"
                    >
                        ${label}
                    </button>
                </c:forTokens>
                <c:set var="tabIndex" value="${tabIndex + 1}" />
            </c:forTokens>
        </nav>
    </div>
    
    <div class="mt-4">
        <c:if test="${not empty tabContents}">
            <c:set var="tabIndex" value="0" />
            <c:forTokens items="${tabs}" delims="," var="tab">
                <c:forTokens items="${tabContents}" delims="," var="content" begin="${tabIndex}" end="${tabIndex}">
                    <div id="${tab}" class="tab-content ${activeTab eq tab ? '' : 'hidden'}">
                        ${content}
                    </div>
                </c:forTokens>
                <c:set var="tabIndex" value="${tabIndex + 1}" />
            </c:forTokens>
        </c:if>
    </div>
</div>

<script>
    function switchTab(tabsId, tabId) {
        // Hide all tab content
        document.querySelectorAll('.tab-content').forEach(tab => {
            tab.classList.add('hidden');
        });
        
        // Show the selected tab content
        document.getElementById(tabId).classList.remove('hidden');
        
        // Update tab button styles
        document.querySelectorAll('.tab-button').forEach(button => {
            button.classList.remove('border-primary-500', 'text-primary-600');
            button.classList.add('border-transparent', 'text-gray-500', 'hover:text-gray-700', 'hover:border-gray-300');
            button.setAttribute('aria-current', 'false');
        });
        
        // Set active tab button style
        document.getElementById('tab-' + tabId).classList.remove('border-transparent', 'text-gray-500', 'hover:text-gray-700', 'hover:border-gray-300');
        document.getElementById('tab-' + tabId).classList.add('border-primary-500', 'text-primary-600');
        document.getElementById('tab-' + tabId).setAttribute('aria-current', 'page');
    }
</script>
