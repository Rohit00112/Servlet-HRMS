<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Chart Component Usage:

<jsp:include page="/WEB-INF/components/chart.jsp">
    <jsp:param name="chartId" value="attendanceChart" />
    <jsp:param name="chartType" value="bar|line|pie|doughnut" />
    <jsp:param name="chartTitle" value="Attendance Statistics" />
    <jsp:param name="chartHeight" value="300" />
    <jsp:param name="labels" value="Jan,Feb,Mar,Apr,May,Jun" />
    <jsp:param name="datasets" value="[{label:'Present',data:[65,59,80,81,56,55],backgroundColor:'rgba(34, 197, 94, 0.2)',borderColor:'rgba(34, 197, 94, 1)'},{label:'Absent',data:[28,48,40,19,36,27],backgroundColor:'rgba(239, 68, 68, 0.2)',borderColor:'rgba(239, 68, 68, 1)'}]" />
    <jsp:param name="options" value="{responsive:true,plugins:{legend:{position:'top'},title:{display:true,text:'Attendance Statistics'}}}" />
</jsp:include>
--%>

<c:set var="chartId" value="${param.chartId}" />
<c:set var="chartType" value="${param.chartType}" />
<c:set var="chartTitle" value="${param.chartTitle}" />
<c:set var="chartHeight" value="${param.chartHeight}" />
<c:set var="labels" value="${param.labels}" />
<c:set var="datasets" value="${param.datasets}" />
<c:set var="options" value="${param.options}" />

<%-- Default values --%>
<c:if test="${empty chartId}">
    <c:set var="chartId" value="chart-${System.currentTimeMillis()}" />
</c:if>
<c:if test="${empty chartType}">
    <c:set var="chartType" value="bar" />
</c:if>
<c:if test="${empty chartHeight}">
    <c:set var="chartHeight" value="300" />
</c:if>
<c:if test="${empty options}">
    <c:set var="options" value="{responsive:true,maintainAspectRatio:false}" />
</c:if>

<div class="chart-container" style="position: relative; height: ${chartHeight}px; width: 100%;">
    <canvas id="${chartId}"></canvas>
</div>

<script>
    // Load Chart.js if not already loaded
    if (typeof Chart === 'undefined') {
        const script = document.createElement('script');
        script.src = 'https://cdn.jsdelivr.net/npm/chart.js';
        script.onload = function() {
            initializeChart_${chartId.replace('-', '_')}();
        };
        document.head.appendChild(script);
    } else {
        document.addEventListener('DOMContentLoaded', function() {
            initializeChart_${chartId.replace('-', '_')}();
        });
    }
    
    function initializeChart_${chartId.replace('-', '_')}() {
        const ctx = document.getElementById('${chartId}').getContext('2d');
        
        // Parse labels and datasets
        const labels = '${labels}'.split(',');
        const datasets = ${datasets};
        const options = ${options};
        
        // Create chart
        new Chart(ctx, {
            type: '${chartType}',
            data: {
                labels: labels,
                datasets: datasets
            },
            options: options
        });
    }
</script>
