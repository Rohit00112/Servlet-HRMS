<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Primary Button:
<jsp:include page="/WEB-INF/components/button.jsp">
    <jsp:param name="type" value="primary" />
    <jsp:param name="text" value="Save" />
    <jsp:param name="icon" value="save" />
    <jsp:param name="buttonType" value="submit" />
</jsp:include>

Secondary Button:
<jsp:include page="/WEB-INF/components/button.jsp">
    <jsp:param name="type" value="secondary" />
    <jsp:param name="text" value="Cancel" />
    <jsp:param name="url" value="/admin/dashboard" />
</jsp:include>
--%>

<c:set var="buttonType" value="${param.buttonType != null ? param.buttonType : 'button'}" />
<c:set var="buttonClass" value="" />

<c:choose>
    <c:when test="${param.type == 'primary'}">
        <c:set var="buttonClass" value="inline-flex items-center px-4 py-2 border border-primary-400/30 text-sm font-medium rounded-lg shadow-lg text-white bg-primary-600/80 backdrop-blur-md hover:bg-primary-500/90 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-primary-400/50" />
    </c:when>
    <c:when test="${param.type == 'secondary'}">
        <c:set var="buttonClass" value="inline-flex items-center px-4 py-2 border border-white/20 text-sm font-medium rounded-lg shadow-lg text-white bg-white/10 backdrop-blur-md hover:bg-white/20 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-white/30" />
    </c:when>
    <c:when test="${param.type == 'danger'}">
        <c:set var="buttonClass" value="inline-flex items-center px-4 py-2 border border-red-400/30 text-sm font-medium rounded-lg shadow-lg text-white bg-red-600/80 backdrop-blur-md hover:bg-red-500/90 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-red-400/50" />
    </c:when>
    <c:when test="${param.type == 'success'}">
        <c:set var="buttonClass" value="inline-flex items-center px-4 py-2 border border-green-400/30 text-sm font-medium rounded-lg shadow-lg text-white bg-green-600/80 backdrop-blur-md hover:bg-green-500/90 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-green-400/50" />
    </c:when>
    <c:when test="${param.type == 'warning'}">
        <c:set var="buttonClass" value="inline-flex items-center px-4 py-2 border border-yellow-400/30 text-sm font-medium rounded-lg shadow-lg text-white bg-yellow-600/80 backdrop-blur-md hover:bg-yellow-500/90 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-yellow-400/50" />
    </c:when>
    <c:when test="${param.type == 'info'}">
        <c:set var="buttonClass" value="inline-flex items-center px-4 py-2 border border-blue-400/30 text-sm font-medium rounded-lg shadow-lg text-white bg-blue-600/80 backdrop-blur-md hover:bg-blue-500/90 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-blue-400/50" />
    </c:when>
    <c:otherwise>
        <c:set var="buttonClass" value="inline-flex items-center px-4 py-2 border border-white/20 text-sm font-medium rounded-lg shadow-lg text-white bg-white/10 backdrop-blur-md hover:bg-white/20 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-white/30" />
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${not empty param.url}">
        <a href="${pageContext.request.contextPath}${param.url}" class="${buttonClass} ${param.additionalClass}">
            <c:if test="${not empty param.icon}">
                <c:choose>
                    <c:when test="${param.icon == 'save'}">
                        <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3 3m0 0l-3-3m3 3V4" />
                        </svg>
                    </c:when>
                    <c:when test="${param.icon == 'add'}">
                        <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                    </c:when>
                    <c:when test="${param.icon == 'edit'}">
                        <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                        </svg>
                    </c:when>
                    <c:when test="${param.icon == 'delete'}">
                        <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                        </svg>
                    </c:when>
                    <c:when test="${param.icon == 'back'}">
                        <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                        </svg>
                    </c:when>
                </c:choose>
            </c:if>
            ${param.text}
        </a>
    </c:when>
    <c:otherwise>
        <button type="${buttonType}" class="${buttonClass} ${param.additionalClass}" ${not empty param.id ? 'id="'.concat(param.id).concat('"') : ''} ${not empty param.onClick ? 'onclick="'.concat(param.onClick).concat('"') : ''}>
            <c:if test="${not empty param.icon}">
                <c:choose>
                    <c:when test="${param.icon == 'save'}">
                        <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3 3m0 0l-3-3m3 3V4" />
                        </svg>
                    </c:when>
                    <c:when test="${param.icon == 'add'}">
                        <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                    </c:when>
                    <c:when test="${param.icon == 'edit'}">
                        <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                        </svg>
                    </c:when>
                    <c:when test="${param.icon == 'delete'}">
                        <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                        </svg>
                    </c:when>
                    <c:when test="${param.icon == 'back'}">
                        <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                        </svg>
                    </c:when>
                </c:choose>
            </c:if>
            ${param.text}
        </button>
    </c:otherwise>
</c:choose>
