<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Add New Employee" scope="request" />
<c:set var="backUrl" value="/admin/employees" scope="request" />
<c:set var="backLabel" value="Back to Employees" scope="request" />

<c:set var="additionalScriptsContent">
    <jsp:include page="/WEB-INF/components/form-validation.jsp" />
</c:set>

<c:set var="mainContent">

        <!-- Add Employee Form -->
        <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg">
            <form action="${pageContext.request.contextPath}/admin/employees/add" method="post" class="p-6" id="employeeForm">
                <div class="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                    <jsp:include page="/WEB-INF/components/employee-form-fields.jsp" />
                </div>

                <div class="mt-6 flex justify-end">
                    <jsp:include page="/WEB-INF/components/button.jsp">
                        <jsp:param name="type" value="secondary" />
                        <jsp:param name="text" value="Cancel" />
                        <jsp:param name="url" value="/admin/employees" />
                        <jsp:param name="additionalClass" value="mr-3" />
                    </jsp:include>

                    <jsp:include page="/WEB-INF/components/button.jsp">
                        <jsp:param name="type" value="primary" />
                        <jsp:param name="text" value="Save Employee" />
                        <jsp:param name="icon" value="save" />
                        <jsp:param name="buttonType" value="submit" />
                    </jsp:include>
                </div>
            </form>
        </div>

        <script>
            // Form validation
            validateForm('employeeForm', {
                'name': {
                    required: true,
                    label: 'Name'
                },
                'email': {
                    required: true,
                    email: true,
                    label: 'Email'
                },
                'departmentId': {
                    required: true,
                    label: 'Department'
                },
                'designationId': {
                    required: true,
                    label: 'Designation'
                },
                'joinDate': {
                    required: true,
                    label: 'Join Date'
                },
                'role': {
                    label: 'Role',
                    dependsOn: {
                        field: 'createAccount',
                        condition: function(value) { return value === true; },
                        message: 'creating a user account'
                    }
                }
            });
        </script>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="backUrl" value="${backUrl}" />
    <jsp:param name="backLabel" value="${backLabel}" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="additionalScripts" value="${additionalScriptsContent}" />
</jsp:include>
