package com.example.hrms.servlet;

import com.example.hrms.dao.*;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;
import com.example.hrms.util.ExcelExporter;
import com.example.hrms.util.PDFExporter;
import com.itextpdf.text.DocumentException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "reportExportServlet", value = "/export/*")
public class ReportExportServlet extends HttpServlet {
    private AttendanceDAO attendanceDAO;
    private EmployeeDAO employeeDAO;
    private LeaveDAO leaveDAO;
    private DepartmentStatisticsDAO departmentStatsDAO;

    @Override
    public void init() {
        attendanceDAO = new AttendanceDAO();
        employeeDAO = new EmployeeDAO();
        leaveDAO = new LeaveDAO();
        departmentStatsDAO = new DepartmentStatisticsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        
        // Get the report type from the URL path
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Report type not specified");
            return;
        }
        
        // Extract report type and format
        String[] pathParts = pathInfo.split("/");
        if (pathParts.length < 3) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid URL format. Expected: /export/{report-type}/{format}");
            return;
        }
        
        String reportType = pathParts[1];
        String format = pathParts[2];
        
        try {
            // Get employee ID if needed
            Employee employee = null;
            int employeeId = 0;
            
            if (!"ADMIN".equals(role) && !"HR".equals(role)) {
                employee = employeeDAO.getEmployeeByUserId(user.getId());
                if (employee == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Employee not found");
                    return;
                }
                employeeId = employee.getId();
            }
            
            // Handle different report types
            switch (reportType) {
                case "attendance-trend":
                    exportAttendanceTrend(response, format, employeeId);
                    break;
                    
                case "leave-usage-by-month":
                    exportLeaveUsageByMonth(response, format, employeeId);
                    break;
                    
                case "leave-usage-by-type":
                    exportLeaveUsageByType(response, format, employeeId);
                    break;
                    
                case "leave-status-distribution":
                    exportLeaveStatusDistribution(response, format, employeeId);
                    break;
                    
                case "employee-count-by-department":
                    if ("ADMIN".equals(role) || "HR".equals(role)) {
                        exportEmployeeCountByDepartment(response, format);
                    } else {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    }
                    break;
                    
                case "average-salary-by-department":
                    if ("ADMIN".equals(role) || "HR".equals(role)) {
                        exportAverageSalaryByDepartment(response, format);
                    } else {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    }
                    break;
                    
                case "leave-usage-by-department":
                    if ("ADMIN".equals(role) || "HR".equals(role)) {
                        exportLeaveUsageByDepartment(response, format);
                    } else {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    }
                    break;
                    
                case "attendance-rate-by-department":
                    if ("ADMIN".equals(role) || "HR".equals(role)) {
                        exportAttendanceRateByDepartment(response, format);
                    } else {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    }
                    break;
                    
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report type");
                    break;
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating report: " + e.getMessage());
        }
    }
    
    private void exportAttendanceTrend(HttpServletResponse response, String format, int employeeId) throws IOException, DocumentException {
        Map<String, Double> trendData = attendanceDAO.getAttendanceTrendData(employeeId);
        
        String title = "Attendance Trend Report";
        String filename = "attendance_trend_report." + (format.equals("pdf") ? "pdf" : "xlsx");
        
        Map<String, Object> chartData = new HashMap<>();
        chartData.put("labels", new ArrayList<>(trendData.keySet()));
        chartData.put("data", new ArrayList<>(trendData.values()));
        
        if (format.equals("pdf")) {
            PDFExporter.exportChartToPDF(response, title, chartData, filename);
        } else {
            ExcelExporter.exportChartToExcel(response, title, chartData, filename);
        }
    }
    
    private void exportLeaveUsageByMonth(HttpServletResponse response, String format, int employeeId) throws IOException, DocumentException {
        Map<String, Integer> leaveData = leaveDAO.getLeaveUsageByMonth(employeeId);
        
        String title = "Leave Usage by Month Report";
        String filename = "leave_usage_by_month_report." + (format.equals("pdf") ? "pdf" : "xlsx");
        
        Map<String, Object> chartData = new HashMap<>();
        chartData.put("labels", new ArrayList<>(leaveData.keySet()));
        chartData.put("data", new ArrayList<>(leaveData.values()));
        
        if (format.equals("pdf")) {
            PDFExporter.exportChartToPDF(response, title, chartData, filename);
        } else {
            ExcelExporter.exportChartToExcel(response, title, chartData, filename);
        }
    }
    
    private void exportLeaveUsageByType(HttpServletResponse response, String format, int employeeId) throws IOException, DocumentException {
        Map<String, Integer> leaveData = leaveDAO.getLeaveUsageByType(employeeId);
        
        String title = "Leave Usage by Type Report";
        String filename = "leave_usage_by_type_report." + (format.equals("pdf") ? "pdf" : "xlsx");
        
        Map<String, Object> chartData = new HashMap<>();
        chartData.put("labels", new ArrayList<>(leaveData.keySet()));
        chartData.put("data", new ArrayList<>(leaveData.values()));
        
        if (format.equals("pdf")) {
            PDFExporter.exportChartToPDF(response, title, chartData, filename);
        } else {
            ExcelExporter.exportChartToExcel(response, title, chartData, filename);
        }
    }
    
    private void exportLeaveStatusDistribution(HttpServletResponse response, String format, int employeeId) throws IOException, DocumentException {
        Map<String, Integer> leaveData = leaveDAO.getLeaveStatusDistribution(employeeId);
        
        String title = "Leave Status Distribution Report";
        String filename = "leave_status_distribution_report." + (format.equals("pdf") ? "pdf" : "xlsx");
        
        Map<String, Object> chartData = new HashMap<>();
        chartData.put("labels", new ArrayList<>(leaveData.keySet()));
        chartData.put("data", new ArrayList<>(leaveData.values()));
        
        if (format.equals("pdf")) {
            PDFExporter.exportChartToPDF(response, title, chartData, filename);
        } else {
            ExcelExporter.exportChartToExcel(response, title, chartData, filename);
        }
    }
    
    private void exportEmployeeCountByDepartment(HttpServletResponse response, String format) throws IOException, DocumentException {
        Map<String, Integer> departmentData = departmentStatsDAO.getEmployeeCountByDepartment();
        
        String title = "Employee Count by Department Report";
        String filename = "employee_count_by_department_report." + (format.equals("pdf") ? "pdf" : "xlsx");
        
        Map<String, Object> chartData = new HashMap<>();
        chartData.put("labels", new ArrayList<>(departmentData.keySet()));
        chartData.put("data", new ArrayList<>(departmentData.values()));
        
        if (format.equals("pdf")) {
            PDFExporter.exportChartToPDF(response, title, chartData, filename);
        } else {
            ExcelExporter.exportChartToExcel(response, title, chartData, filename);
        }
    }
    
    private void exportAverageSalaryByDepartment(HttpServletResponse response, String format) throws IOException, DocumentException {
        Map<String, Double> departmentData = departmentStatsDAO.getAverageSalaryByDepartment();
        
        String title = "Average Salary by Department Report";
        String filename = "average_salary_by_department_report." + (format.equals("pdf") ? "pdf" : "xlsx");
        
        Map<String, Object> chartData = new HashMap<>();
        chartData.put("labels", new ArrayList<>(departmentData.keySet()));
        chartData.put("data", new ArrayList<>(departmentData.values()));
        
        if (format.equals("pdf")) {
            PDFExporter.exportChartToPDF(response, title, chartData, filename);
        } else {
            ExcelExporter.exportChartToExcel(response, title, chartData, filename);
        }
    }
    
    private void exportLeaveUsageByDepartment(HttpServletResponse response, String format) throws IOException, DocumentException {
        Map<String, Integer> departmentData = departmentStatsDAO.getLeaveUsageByDepartment();
        
        String title = "Leave Usage by Department Report";
        String filename = "leave_usage_by_department_report." + (format.equals("pdf") ? "pdf" : "xlsx");
        
        Map<String, Object> chartData = new HashMap<>();
        chartData.put("labels", new ArrayList<>(departmentData.keySet()));
        chartData.put("data", new ArrayList<>(departmentData.values()));
        
        if (format.equals("pdf")) {
            PDFExporter.exportChartToPDF(response, title, chartData, filename);
        } else {
            ExcelExporter.exportChartToExcel(response, title, chartData, filename);
        }
    }
    
    private void exportAttendanceRateByDepartment(HttpServletResponse response, String format) throws IOException, DocumentException {
        Map<String, Double> departmentData = departmentStatsDAO.getAttendanceRateByDepartment();
        
        String title = "Attendance Rate by Department Report";
        String filename = "attendance_rate_by_department_report." + (format.equals("pdf") ? "pdf" : "xlsx");
        
        Map<String, Object> chartData = new HashMap<>();
        chartData.put("labels", new ArrayList<>(departmentData.keySet()));
        chartData.put("data", new ArrayList<>(departmentData.values()));
        
        if (format.equals("pdf")) {
            PDFExporter.exportChartToPDF(response, title, chartData, filename);
        } else {
            ExcelExporter.exportChartToExcel(response, title, chartData, filename);
        }
    }
}
