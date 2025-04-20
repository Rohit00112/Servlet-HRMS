<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<script>
    // Common form validation functions
    function validateForm(formId, validationRules) {
        document.getElementById(formId).addEventListener('submit', function(event) {
            let isValid = true;
            let errorMessage = '';
            
            // Process each validation rule
            for (const field in validationRules) {
                const rules = validationRules[field];
                const element = document.getElementById(field);
                
                if (!element) continue;
                
                let value = element.type === 'checkbox' ? element.checked : element.value.trim();
                
                // Required validation
                if (rules.required && !value) {
                    isValid = false;
                    errorMessage += rules.label + ' is required. ';
                }
                
                // Email validation
                if (value && rules.email && !isValidEmail(value)) {
                    isValid = false;
                    errorMessage += 'Please enter a valid email address for ' + rules.label + '. ';
                }
                
                // Min length validation
                if (value && rules.minLength && value.length < rules.minLength) {
                    isValid = false;
                    errorMessage += rules.label + ' must be at least ' + rules.minLength + ' characters. ';
                }
                
                // Max length validation
                if (value && rules.maxLength && value.length > rules.maxLength) {
                    isValid = false;
                    errorMessage += rules.label + ' must be at most ' + rules.maxLength + ' characters. ';
                }
                
                // Pattern validation
                if (value && rules.pattern && !new RegExp(rules.pattern).test(value)) {
                    isValid = false;
                    errorMessage += rules.label + ' is not in a valid format. ';
                }
                
                // Custom validation
                if (value && rules.custom && typeof rules.custom === 'function') {
                    const customResult = rules.custom(value);
                    if (customResult !== true) {
                        isValid = false;
                        errorMessage += customResult;
                    }
                }
                
                // Conditional validation
                if (rules.dependsOn) {
                    const dependentElement = document.getElementById(rules.dependsOn.field);
                    if (dependentElement) {
                        const dependentValue = dependentElement.type === 'checkbox' ? 
                            dependentElement.checked : dependentElement.value.trim();
                        
                        if (rules.dependsOn.condition(dependentValue) && !value) {
                            isValid = false;
                            errorMessage += rules.label + ' is required when ' + rules.dependsOn.message + '. ';
                        }
                    }
                }
            }
            
            if (!isValid) {
                event.preventDefault();
                alert('Please correct the following errors: ' + errorMessage);
            }
        });
    }
    
    function isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
</script>
