<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Department Statistics" scope="request" />
<c:set var="userRole" value="hr" scope="request" />

<c:set var="additionalHead">
    <!-- Chart.js and plugins -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
</c:set>

<c:set var="mainContent">
    <div class="px-4 py-5 sm:px-6">
        <h1 class="text-2xl font-semibold text-gray-900 dark:text-gray-100">Department Statistics</h1>
        <p class="mt-1 max-w-2xl text-sm text-gray-500 dark:text-gray-400">Detailed analytics for all departments.</p>
    </div>

    <!-- Department Statistics Section -->
    <div class="mt-4 w-full">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
            <!-- Employee Count by Department Chart -->
            <div class="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
                <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-4">Employee Count by Department</h3>
                <div class="h-64">
                    <canvas id="employeeCountChart"></canvas>
                </div>
            </div>
            
            <!-- Average Salary by Department Chart -->
            <div class="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
                <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-4">Average Salary by Department</h3>
                <div class="h-64">
                    <canvas id="averageSalaryChart"></canvas>
                </div>
            </div>
            
            <!-- Leave Usage by Department Chart -->
            <div class="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
                <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-4">Leave Usage by Department</h3>
                <div class="h-64">
                    <canvas id="leaveUsageChart"></canvas>
                </div>
            </div>
            
            <!-- Attendance Rate by Department Chart -->
            <div class="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
                <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-4">Attendance Rate by Department</h3>
                <div class="h-64">
                    <canvas id="attendanceRateChart"></canvas>
                </div>
            </div>
            
            <!-- Gender Distribution by Department Chart -->
            <div class="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md md:col-span-2">
                <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-4">Gender Distribution by Department</h3>
                <div class="h-64">
                    <canvas id="genderDistributionChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</c:set>

<c:set var="additionalScripts">
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Register Chart.js DataLabels plugin
        Chart.register(ChartDataLabels);
        
        // Load Employee Count by Department Data
        fetch('${pageContext.request.contextPath}/dashboard/analytics?type=employee-count-by-department')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('employeeCountChart').getContext('2d');
                
                // Convert data to arrays
                const labels = Object.keys(data.labels);
                const values = Object.values(data.data);
                
                // Add a title above the chart
                const chartTitle = document.createElement('div');
                chartTitle.className = 'text-sm text-center text-gray-500 mb-2';
                chartTitle.textContent = 'Number of employees in each department';
                document.getElementById('employeeCountChart').parentNode.insertBefore(chartTitle, document.getElementById('employeeCountChart'));
                
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Number of Employees',
                            data: values,
                            backgroundColor: 'rgba(79, 70, 229, 0.7)',
                            borderColor: 'rgba(79, 70, 229, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        indexAxis: 'y',
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: {
                                beginAtZero: true,
                                ticks: {
                                    precision: 0,
                                    stepSize: 1
                                },
                                title: {
                                    display: true,
                                    text: 'Number of Employees',
                                    font: {
                                        size: 12
                                    }
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false
                            },
                            datalabels: {
                                align: 'end',
                                anchor: 'end',
                                color: 'rgba(79, 70, 229, 1)',
                                font: {
                                    weight: 'bold'
                                },
                                formatter: function(value) {
                                    return value;
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                });
            })
            .catch(error => console.error('Error loading employee count data:', error));
            
        // Load Average Salary by Department Data
        fetch('${pageContext.request.contextPath}/dashboard/analytics?type=average-salary-by-department')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('averageSalaryChart').getContext('2d');
                
                // Convert data to arrays
                const labels = Object.keys(data.labels);
                const values = Object.values(data.data);
                
                // Add a title above the chart
                const chartTitle = document.createElement('div');
                chartTitle.className = 'text-sm text-center text-gray-500 mb-2';
                chartTitle.textContent = 'Average salary in each department';
                document.getElementById('averageSalaryChart').parentNode.insertBefore(chartTitle, document.getElementById('averageSalaryChart'));
                
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Average Salary',
                            data: values,
                            backgroundColor: 'rgba(16, 185, 129, 0.7)',
                            borderColor: 'rgba(16, 185, 129, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value) {
                                        return '$' + value.toLocaleString();
                                    }
                                },
                                title: {
                                    display: true,
                                    text: 'Average Salary ($)',
                                    font: {
                                        size: 12
                                    }
                                }
                            }
                        },
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        return '$' + context.parsed.y.toLocaleString();
                                    }
                                }
                            },
                            datalabels: {
                                align: 'top',
                                anchor: 'end',
                                color: 'rgba(16, 185, 129, 1)',
                                font: {
                                    weight: 'bold',
                                    size: 10
                                },
                                formatter: function(value) {
                                    return '$' + Math.round(value).toLocaleString();
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                });
            })
            .catch(error => console.error('Error loading average salary data:', error));
            
        // Load Leave Usage by Department Data
        fetch('${pageContext.request.contextPath}/dashboard/analytics?type=leave-usage-by-department')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('leaveUsageChart').getContext('2d');
                
                // Convert data to arrays
                const labels = Object.keys(data.labels);
                const values = Object.values(data.data);
                
                // Add a title above the chart
                const chartTitle = document.createElement('div');
                chartTitle.className = 'text-sm text-center text-gray-500 mb-2';
                chartTitle.textContent = 'Total leave days taken by each department this year';
                document.getElementById('leaveUsageChart').parentNode.insertBefore(chartTitle, document.getElementById('leaveUsageChart'));
                
                new Chart(ctx, {
                    type: 'pie',
                    data: {
                        labels: labels,
                        datasets: [{
                            data: values,
                            backgroundColor: [
                                'rgba(239, 68, 68, 0.7)',
                                'rgba(245, 158, 11, 0.7)',
                                'rgba(16, 185, 129, 0.7)',
                                'rgba(59, 130, 246, 0.7)',
                                'rgba(139, 92, 246, 0.7)',
                                'rgba(236, 72, 153, 0.7)',
                                'rgba(107, 114, 128, 0.7)'
                            ],
                            borderColor: [
                                'rgba(239, 68, 68, 1)',
                                'rgba(245, 158, 11, 1)',
                                'rgba(16, 185, 129, 1)',
                                'rgba(59, 130, 246, 1)',
                                'rgba(139, 92, 246, 1)',
                                'rgba(236, 72, 153, 1)',
                                'rgba(107, 114, 128, 1)'
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'right',
                                labels: {
                                    font: {
                                        size: 11
                                    },
                                    padding: 15,
                                    boxWidth: 15
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const value = context.parsed;
                                        return context.label + ': ' + value + (value === 1 ? ' day' : ' days');
                                    }
                                }
                            },
                            datalabels: {
                                color: '#fff',
                                font: {
                                    weight: 'bold',
                                    size: 11
                                },
                                formatter: function(value, context) {
                                    return value > 0 ? value : '';
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                });
            })
            .catch(error => console.error('Error loading leave usage data:', error));
            
        // Load Attendance Rate by Department Data
        fetch('${pageContext.request.contextPath}/dashboard/analytics?type=attendance-rate-by-department')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('attendanceRateChart').getContext('2d');
                
                // Convert data to arrays
                const labels = Object.keys(data.labels);
                const values = Object.values(data.data);
                
                // Add a title above the chart
                const chartTitle = document.createElement('div');
                chartTitle.className = 'text-sm text-center text-gray-500 mb-2';
                chartTitle.textContent = 'Average attendance rate by department this month';
                document.getElementById('attendanceRateChart').parentNode.insertBefore(chartTitle, document.getElementById('attendanceRateChart'));
                
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Attendance Rate',
                            data: values,
                            backgroundColor: function(context) {
                                const value = context.dataset.data[context.dataIndex];
                                if (value >= 90) return 'rgba(34, 197, 94, 0.7)';
                                else if (value >= 75) return 'rgba(245, 158, 11, 0.7)';
                                else return 'rgba(239, 68, 68, 0.7)';
                            },
                            borderColor: function(context) {
                                const value = context.dataset.data[context.dataIndex];
                                if (value >= 90) return 'rgba(34, 197, 94, 1)';
                                else if (value >= 75) return 'rgba(245, 158, 11, 1)';
                                else return 'rgba(239, 68, 68, 1)';
                            },
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                max: 100,
                                ticks: {
                                    callback: function(value) {
                                        return value + '%';
                                    }
                                },
                                title: {
                                    display: true,
                                    text: 'Attendance Rate (%)',
                                    font: {
                                        size: 12
                                    }
                                }
                            }
                        },
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        return context.parsed.y.toFixed(1) + '%';
                                    }
                                }
                            },
                            datalabels: {
                                align: 'top',
                                anchor: 'end',
                                color: function(context) {
                                    const value = context.dataset.data[context.dataIndex];
                                    if (value >= 90) return 'rgba(34, 197, 94, 1)';
                                    else if (value >= 75) return 'rgba(245, 158, 11, 1)';
                                    else return 'rgba(239, 68, 68, 1)';
                                },
                                font: {
                                    weight: 'bold'
                                },
                                formatter: function(value) {
                                    return value.toFixed(1) + '%';
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                });
            })
            .catch(error => console.error('Error loading attendance rate data:', error));
            
        // Load Gender Distribution by Department Data
        fetch('${pageContext.request.contextPath}/dashboard/analytics?type=gender-distribution-by-department')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('genderDistributionChart').getContext('2d');
                
                // Extract data from the response
                const departmentData = data.data;
                const departments = departmentData.departments;
                const maleData = departmentData.male;
                const femaleData = departmentData.female;
                const otherData = departmentData.other;
                
                // Add a title above the chart
                const chartTitle = document.createElement('div');
                chartTitle.className = 'text-sm text-center text-gray-500 mb-2';
                chartTitle.textContent = 'Gender distribution across departments';
                document.getElementById('genderDistributionChart').parentNode.insertBefore(chartTitle, document.getElementById('genderDistributionChart'));
                
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: departments,
                        datasets: [
                            {
                                label: 'Male',
                                data: maleData,
                                backgroundColor: 'rgba(59, 130, 246, 0.7)',
                                borderColor: 'rgba(59, 130, 246, 1)',
                                borderWidth: 1
                            },
                            {
                                label: 'Female',
                                data: femaleData,
                                backgroundColor: 'rgba(236, 72, 153, 0.7)',
                                borderColor: 'rgba(236, 72, 153, 1)',
                                borderWidth: 1
                            },
                            {
                                label: 'Other',
                                data: otherData,
                                backgroundColor: 'rgba(107, 114, 128, 0.7)',
                                borderColor: 'rgba(107, 114, 128, 1)',
                                borderWidth: 1
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: {
                                stacked: true,
                                title: {
                                    display: true,
                                    text: 'Department',
                                    font: {
                                        size: 12
                                    }
                                }
                            },
                            y: {
                                stacked: true,
                                beginAtZero: true,
                                ticks: {
                                    precision: 0,
                                    stepSize: 1
                                },
                                title: {
                                    display: true,
                                    text: 'Number of Employees',
                                    font: {
                                        size: 12
                                    }
                                }
                            }
                        },
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        return context.dataset.label + ': ' + context.parsed.y;
                                    }
                                }
                            },
                            datalabels: {
                                color: '#fff',
                                font: {
                                    weight: 'bold',
                                    size: 10
                                },
                                formatter: function(value) {
                                    return value > 0 ? value : '';
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                });
            })
            .catch(error => console.error('Error loading gender distribution data:', error));
    });
</script>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="additionalHead" value="${additionalHead}" />
    <jsp:param name="additionalScripts" value="${additionalScripts}" />
</jsp:include>
