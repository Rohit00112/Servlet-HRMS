<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
File Upload Component Usage:

<jsp:include page="/WEB-INF/components/file-upload.jsp">
    <jsp:param name="inputId" value="profileImage" />
    <jsp:param name="name" value="profileImage" />
    <jsp:param name="label" value="Profile Image" />
    <jsp:param name="accept" value="image/*" />
    <jsp:param name="required" value="true" />
    <jsp:param name="multiple" value="false" />
    <jsp:param name="helpText" value="Upload a profile image (JPG, PNG, max 2MB)" />
    <jsp:param name="previewType" value="image" />
    <jsp:param name="maxSize" value="2" />
    <jsp:param name="currentFile" value="${employee.profileImagePath}" />
</jsp:include>
--%>

<c:set var="inputId" value="${param.inputId}" />
<c:set var="name" value="${param.name}" />
<c:set var="label" value="${param.label}" />
<c:set var="accept" value="${param.accept}" />
<c:set var="required" value="${param.required}" />
<c:set var="multiple" value="${param.multiple}" />
<c:set var="helpText" value="${param.helpText}" />
<c:set var="previewType" value="${param.previewType}" />
<c:set var="maxSize" value="${param.maxSize}" />
<c:set var="currentFile" value="${param.currentFile}" />

<%-- Default values --%>
<c:if test="${empty inputId}">
    <c:set var="inputId" value="file-${System.currentTimeMillis()}" />
</c:if>
<c:if test="${empty name}">
    <c:set var="name" value="${inputId}" />
</c:if>
<c:if test="${empty required}">
    <c:set var="required" value="false" />
</c:if>
<c:if test="${empty multiple}">
    <c:set var="multiple" value="false" />
</c:if>
<c:if test="${empty previewType}">
    <c:set var="previewType" value="none" />
</c:if>
<c:if test="${empty maxSize}">
    <c:set var="maxSize" value="5" />
</c:if>

<div class="file-upload-container">
    <label for="${inputId}" class="block text-sm font-medium text-gray-700 mb-1">${label}</label>
    
    <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md">
        <div class="space-y-1 text-center">
            <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
            
            <div class="flex text-sm text-gray-600">
                <label for="${inputId}" class="relative cursor-pointer bg-white rounded-md font-medium text-primary-600 hover:text-primary-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-primary-500">
                    <span>Upload a file</span>
                    <input id="${inputId}" 
                           name="${name}" 
                           type="file" 
                           class="sr-only" 
                           ${accept != null ? 'accept="'.concat(accept).concat('"') : ''} 
                           ${required eq 'true' ? 'required' : ''} 
                           ${multiple eq 'true' ? 'multiple' : ''}
                           onchange="handleFileSelect('${inputId}', '${previewType}', ${maxSize})">
                </label>
                <p class="pl-1">or drag and drop</p>
            </div>
            
            <c:if test="${not empty helpText}">
                <p class="text-xs text-gray-500">${helpText}</p>
            </c:if>
        </div>
    </div>
    
    <!-- File preview area -->
    <div id="${inputId}-preview" class="mt-3 ${empty currentFile ? 'hidden' : ''}">
        <c:choose>
            <c:when test="${previewType eq 'image' && not empty currentFile}">
                <div class="relative">
                    <img src="${pageContext.request.contextPath}${currentFile}" alt="Current file" class="h-32 w-auto rounded-md">
                    <div class="absolute top-0 right-0 -mt-2 -mr-2">
                        <button type="button" onclick="clearFileInput('${inputId}')" class="bg-red-100 text-red-600 rounded-full p-1 hover:bg-red-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                            <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                            </svg>
                        </button>
                    </div>
                </div>
            </c:when>
            <c:when test="${not empty currentFile}">
                <div class="flex items-center justify-between bg-gray-50 p-3 rounded-md">
                    <div class="flex items-center">
                        <svg class="h-5 w-5 text-gray-400 mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                        </svg>
                        <span class="text-sm text-gray-700">${currentFile.substring(currentFile.lastIndexOf('/') + 1)}</span>
                    </div>
                    <button type="button" onclick="clearFileInput('${inputId}')" class="text-red-600 hover:text-red-800 text-sm font-medium">
                        Remove
                    </button>
                </div>
            </c:when>
        </c:choose>
    </div>
    
    <!-- Error message area -->
    <div id="${inputId}-error" class="mt-2 text-sm text-red-600 hidden"></div>
</div>

<script>
    function handleFileSelect(inputId, previewType, maxSizeMB) {
        const input = document.getElementById(inputId);
        const previewArea = document.getElementById(inputId + '-preview');
        const errorArea = document.getElementById(inputId + '-error');
        
        // Clear previous error
        errorArea.textContent = '';
        errorArea.classList.add('hidden');
        
        if (input.files && input.files.length > 0) {
            const file = input.files[0];
            
            // Check file size
            const maxSizeBytes = maxSizeMB * 1024 * 1024;
            if (file.size > maxSizeBytes) {
                errorArea.textContent = `File size exceeds the maximum allowed size of ${maxSizeMB}MB.`;
                errorArea.classList.remove('hidden');
                input.value = '';
                return;
            }
            
            // Show preview based on type
            previewArea.innerHTML = '';
            previewArea.classList.remove('hidden');
            
            if (previewType === 'image' && file.type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const previewContainer = document.createElement('div');
                    previewContainer.className = 'relative';
                    
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'h-32 w-auto rounded-md';
                    img.alt = 'File preview';
                    
                    const removeButton = document.createElement('div');
                    removeButton.className = 'absolute top-0 right-0 -mt-2 -mr-2';
                    removeButton.innerHTML = `
                        <button type="button" onclick="clearFileInput('${inputId}')" class="bg-red-100 text-red-600 rounded-full p-1 hover:bg-red-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                            <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                            </svg>
                        </button>
                    `;
                    
                    previewContainer.appendChild(img);
                    previewContainer.appendChild(removeButton);
                    previewArea.appendChild(previewContainer);
                };
                reader.readAsDataURL(file);
            } else {
                // Generic file preview
                const filePreview = document.createElement('div');
                filePreview.className = 'flex items-center justify-between bg-gray-50 p-3 rounded-md';
                filePreview.innerHTML = `
                    <div class="flex items-center">
                        <svg class="h-5 w-5 text-gray-400 mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                        </svg>
                        <span class="text-sm text-gray-700">${file.name}</span>
                    </div>
                    <button type="button" onclick="clearFileInput('${inputId}')" class="text-red-600 hover:text-red-800 text-sm font-medium">
                        Remove
                    </button>
                `;
                previewArea.appendChild(filePreview);
            }
        } else {
            previewArea.classList.add('hidden');
        }
    }
    
    function clearFileInput(inputId) {
        const input = document.getElementById(inputId);
        const previewArea = document.getElementById(inputId + '-preview');
        const errorArea = document.getElementById(inputId + '-error');
        
        input.value = '';
        previewArea.innerHTML = '';
        previewArea.classList.add('hidden');
        errorArea.textContent = '';
        errorArea.classList.add('hidden');
        
        // Add a hidden input to indicate file removal if there was a current file
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = input.name + '_remove';
        hiddenInput.value = 'true';
        input.parentNode.appendChild(hiddenInput);
    }
    
    // Initialize drag and drop functionality
    document.addEventListener('DOMContentLoaded', function() {
        const inputId = '${inputId}';
        const dropArea = document.getElementById(inputId).closest('.file-upload-container').querySelector('.border-dashed');
        
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, preventDefaults, false);
        });
        
        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }
        
        ['dragenter', 'dragover'].forEach(eventName => {
            dropArea.addEventListener(eventName, highlight, false);
        });
        
        ['dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, unhighlight, false);
        });
        
        function highlight() {
            dropArea.classList.add('border-primary-300', 'bg-primary-50');
        }
        
        function unhighlight() {
            dropArea.classList.remove('border-primary-300', 'bg-primary-50');
        }
        
        dropArea.addEventListener('drop', handleDrop, false);
        
        function handleDrop(e) {
            const dt = e.dataTransfer;
            const files = dt.files;
            const input = document.getElementById(inputId);
            
            input.files = files;
            handleFileSelect(inputId, '${previewType}', ${maxSize});
        }
    });
</script>
