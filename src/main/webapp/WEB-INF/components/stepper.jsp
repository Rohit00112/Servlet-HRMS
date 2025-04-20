<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
Stepper Component Usage:

<jsp:include page="/WEB-INF/components/stepper.jsp">
    <jsp:param name="stepperId" value="onboardingStepper" />
    <jsp:param name="steps" value="Personal Details,Employment Details,Account Setup,Review" />
    <jsp:param name="currentStep" value="2" />
    <jsp:param name="completedSteps" value="1" />
    <jsp:param name="vertical" value="false" />
</jsp:include>

For vertical stepper with content:

<jsp:include page="/WEB-INF/components/stepper.jsp">
    <jsp:param name="stepperId" value="onboardingStepper" />
    <jsp:param name="steps" value="Personal Details,Employment Details,Account Setup,Review" />
    <jsp:param name="currentStep" value="2" />
    <jsp:param name="completedSteps" value="1" />
    <jsp:param name="vertical" value="true" />
    <jsp:param name="stepContents" value="${step1Content},${step2Content},${step3Content},${step4Content}" />
</jsp:include>
--%>

<c:set var="stepperId" value="${param.stepperId}" />
<c:set var="stepsString" value="${param.steps}" />
<c:set var="currentStep" value="${param.currentStep}" />
<c:set var="completedSteps" value="${param.completedSteps}" />
<c:set var="vertical" value="${param.vertical}" />
<c:set var="stepContents" value="${param.stepContents}" />

<%-- Default values --%>
<c:if test="${empty stepperId}">
    <c:set var="stepperId" value="stepper-${System.currentTimeMillis()}" />
</c:if>
<c:if test="${empty currentStep}">
    <c:set var="currentStep" value="1" />
</c:if>
<c:if test="${empty completedSteps}">
    <c:set var="completedSteps" value="0" />
</c:if>
<c:if test="${empty vertical}">
    <c:set var="vertical" value="false" />
</c:if>

<%-- Parse steps --%>
<c:set var="steps" value="${stepsString.split(',')}" />
<c:set var="totalSteps" value="${steps.length}" />

<%-- Horizontal Stepper --%>
<c:if test="${vertical eq 'false'}">
    <div id="${stepperId}" class="stepper-container">
        <div class="flex items-center">
            <c:forEach var="step" items="${steps}" varStatus="status">
                <c:set var="stepNumber" value="${status.index + 1}" />
                <c:set var="isCompleted" value="${stepNumber <= completedSteps}" />
                <c:set var="isCurrent" value="${stepNumber == currentStep}" />
                
                <div class="relative flex items-center">
                    <div class="flex items-center relative z-10">
                        <c:choose>
                            <c:when test="${isCompleted}">
                                <span class="h-8 w-8 rounded-full bg-primary-600 flex items-center justify-center">
                                    <svg class="h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                        <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                                    </svg>
                                </span>
                            </c:when>
                            <c:when test="${isCurrent}">
                                <span class="h-8 w-8 rounded-full border-2 border-primary-600 bg-white flex items-center justify-center">
                                    <span class="text-primary-600 font-medium">${stepNumber}</span>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="h-8 w-8 rounded-full border-2 border-gray-300 bg-white flex items-center justify-center">
                                    <span class="text-gray-500">${stepNumber}</span>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="ml-2 text-sm font-medium ${isCurrent ? 'text-primary-600' : isCompleted ? 'text-gray-900' : 'text-gray-500'}">
                        ${step}
                    </div>
                    
                    <c:if test="${!status.last}">
                        <div class="flex-1 mx-4 h-0.5 ${stepNumber < currentStep ? 'bg-primary-600' : 'bg-gray-300'}"></div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>
</c:if>

<%-- Vertical Stepper --%>
<c:if test="${vertical eq 'true'}">
    <div id="${stepperId}" class="stepper-container">
        <div class="space-y-6">
            <c:forEach var="step" items="${steps}" varStatus="status">
                <c:set var="stepNumber" value="${status.index + 1}" />
                <c:set var="isCompleted" value="${stepNumber <= completedSteps}" />
                <c:set var="isCurrent" value="${stepNumber == currentStep}" />
                
                <div class="relative">
                    <div class="flex items-center">
                        <div class="flex items-center relative z-10">
                            <c:choose>
                                <c:when test="${isCompleted}">
                                    <span class="h-8 w-8 rounded-full bg-primary-600 flex items-center justify-center">
                                        <svg class="h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                                        </svg>
                                    </span>
                                </c:when>
                                <c:when test="${isCurrent}">
                                    <span class="h-8 w-8 rounded-full border-2 border-primary-600 bg-white flex items-center justify-center">
                                        <span class="text-primary-600 font-medium">${stepNumber}</span>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="h-8 w-8 rounded-full border-2 border-gray-300 bg-white flex items-center justify-center">
                                        <span class="text-gray-500">${stepNumber}</span>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="ml-4 text-sm font-medium ${isCurrent ? 'text-primary-600' : isCompleted ? 'text-gray-900' : 'text-gray-500'}">
                            ${step}
                        </div>
                    </div>
                    
                    <c:if test="${not empty stepContents}">
                        <c:set var="stepContentArray" value="${stepContents.split(',')}" />
                        <c:if test="${isCurrent && status.index < stepContentArray.length}">
                            <div class="mt-4 ml-12">
                                <div class="bg-white p-4 rounded-md border border-gray-200">
                                    ${stepContentArray[status.index]}
                                </div>
                            </div>
                        </c:if>
                    </c:if>
                    
                    <c:if test="${!status.last}">
                        <div class="absolute top-8 left-4 -ml-px mt-0.5 h-full w-0.5 ${stepNumber < currentStep ? 'bg-primary-600' : 'bg-gray-300'}"></div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>
</c:if>

<script>
    // Function to update stepper programmatically
    function updateStepper(stepperId, currentStep, completedSteps) {
        const stepper = document.getElementById(stepperId);
        if (!stepper) return;
        
        const steps = stepper.querySelectorAll('.flex.items-center');
        steps.forEach((step, index) => {
            const stepNumber = index + 1;
            const isCompleted = stepNumber <= completedSteps;
            const isCurrent = stepNumber === currentStep;
            
            // Update step indicator
            const indicator = step.querySelector('.rounded-full');
            if (isCompleted) {
                indicator.className = 'h-8 w-8 rounded-full bg-primary-600 flex items-center justify-center';
                indicator.innerHTML = '<svg class="h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" /></svg>';
            } else if (isCurrent) {
                indicator.className = 'h-8 w-8 rounded-full border-2 border-primary-600 bg-white flex items-center justify-center';
                indicator.innerHTML = `<span class="text-primary-600 font-medium">${stepNumber}</span>`;
            } else {
                indicator.className = 'h-8 w-8 rounded-full border-2 border-gray-300 bg-white flex items-center justify-center';
                indicator.innerHTML = `<span class="text-gray-500">${stepNumber}</span>`;
            }
            
            // Update step label
            const label = step.querySelector('.text-sm.font-medium');
            if (isCurrent) {
                label.className = 'ml-2 text-sm font-medium text-primary-600';
            } else if (isCompleted) {
                label.className = 'ml-2 text-sm font-medium text-gray-900';
            } else {
                label.className = 'ml-2 text-sm font-medium text-gray-500';
            }
            
            // Update connector line
            if (index < steps.length - 1) {
                const connector = step.querySelector('.h-0.5, .w-0.5');
                if (connector) {
                    if (stepNumber < currentStep) {
                        connector.className = connector.className.replace('bg-gray-300', 'bg-primary-600');
                    } else {
                        connector.className = connector.className.replace('bg-primary-600', 'bg-gray-300');
                    }
                }
            }
            
            // Update content visibility for vertical stepper
            if (document.querySelector('.stepper-container .space-y-6')) {
                const contents = document.querySelectorAll('.stepper-container .mt-4.ml-12');
                contents.forEach((content, contentIndex) => {
                    if (contentIndex + 1 === currentStep) {
                        content.style.display = 'block';
                    } else {
                        content.style.display = 'none';
                    }
                });
            }
        });
    }
</script>
