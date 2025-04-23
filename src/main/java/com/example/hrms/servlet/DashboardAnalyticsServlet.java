package com.example.hrms.servlet;

import com.example.hrms.dao.AttendanceDAO;
import com.example.hrms.dao.DepartmentStatisticsDAO;
import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.LeaveDAO;
import com.example.hrms.dao.PayrollDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "dashboardAnalyticsServlet", value = "/dashboard/analytics")
public class DashboardAnalyticsServlet extends HttpServlet {
    private AttendanceDAO attendanceDAO;
    private EmployeeDAO employeeDAO;
    private LeaveDAO leaveDAO;
    private PayrollDAO payrollDAO;
    private DepartmentStatisticsDAO departmentStatsDAO;

    @Override
    public void init() {
        attendanceDAO = new AttendanceDAO();
        employeeDAO = new EmployeeDAO();
        leaveDAO = new LeaveDAO();
        payrollDAO = new PayrollDAO();
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
        String dataType = request.getParameter("type");

        // Get employee ID
        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());
        if (employee == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int employeeId = employee.getId();

        // Set response type to JSON
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        try {
            switch (dataType) {
                case "weekly-attendance":
                    // Get weekly attendance data
                    Map<String, String> weeklyData = attendanceDAO.getWeeklyAttendanceData(employeeId);
                    jsonResponse.put("labels", weeklyData.keySet());
                    jsonResponse.put("data", weeklyData.values());
                    break;

                case "monthly-attendance":
                    // Get monthly attendance data
                    Map<String, Integer> monthlyData = attendanceDAO.getMonthlyAttendanceData(employeeId);
                    jsonResponse.put("labels", monthlyData.keySet());
                    jsonResponse.put("data", monthlyData.values());
                    break;

                case "attendance-trend":
                    // Get attendance trend data
                    Map<String, Double> trendData = attendanceDAO.getAttendanceTrendData(employeeId);
                    jsonResponse.put("labels", trendData.keySet());
                    jsonResponse.put("data", trendData.values());
                    break;

                case "leave-usage-by-month":
                    // Get leave usage by month
                    Map<String, Integer> leaveByMonth = leaveDAO.getLeaveUsageByMonth(employeeId);
                    jsonResponse.put("labels", leaveByMonth.keySet());
                    jsonResponse.put("data", leaveByMonth.values());
                    break;

                case "leave-usage-by-type":
                    // Get leave usage by type
                    Map<String, Integer> leaveByType = leaveDAO.getLeaveUsageByType(employeeId);
                    jsonResponse.put("labels", leaveByType.keySet());
                    jsonResponse.put("data", leaveByType.values());
                    break;

                case "leave-status-distribution":
                    // Get leave status distribution
                    Map<String, Integer> leaveStatus = leaveDAO.getLeaveStatusDistribution(employeeId);
                    jsonResponse.put("labels", leaveStatus.keySet());
                    jsonResponse.put("data", leaveStatus.values());
                    break;

                // Department statistics for HR and Admin
                case "employee-count-by-department":
                    // Get employee count by department
                    Map<String, Integer> employeeCountByDept = departmentStatsDAO.getEmployeeCountByDepartment();
                    jsonResponse.put("labels", employeeCountByDept.keySet());
                    jsonResponse.put("data", employeeCountByDept.values());
                    break;

                case "average-salary-by-department":
                    // Get average salary by department
                    Map<String, Double> avgSalaryByDept = departmentStatsDAO.getAverageSalaryByDepartment();
                    jsonResponse.put("labels", avgSalaryByDept.keySet());
                    jsonResponse.put("data", avgSalaryByDept.values());
                    break;

                case "leave-usage-by-department":
                    // Get leave usage by department
                    Map<String, Integer> leaveUsageByDept = departmentStatsDAO.getLeaveUsageByDepartment();
                    jsonResponse.put("labels", leaveUsageByDept.keySet());
                    jsonResponse.put("data", leaveUsageByDept.values());
                    break;

                case "attendance-rate-by-department":
                    // Get attendance rate by department
                    Map<String, Double> attendanceRateByDept = departmentStatsDAO.getAttendanceRateByDepartment();
                    jsonResponse.put("labels", attendanceRateByDept.keySet());
                    jsonResponse.put("data", attendanceRateByDept.values());
                    break;

                case "gender-distribution-by-department":
                    // Get gender distribution by department
                    Map<String, Map<String, Integer>> genderDistByDept = departmentStatsDAO.getGenderDistributionByDepartment();

                    // Convert the nested map to a format suitable for Chart.js
                    JSONObject departmentsData = new JSONObject();
                    JSONArray maleData = new JSONArray();
                    JSONArray femaleData = new JSONArray();
                    JSONArray otherData = new JSONArray();

                    for (Map.Entry<String, Map<String, Integer>> entry : genderDistByDept.entrySet()) {
                        Map<String, Integer> genderCounts = entry.getValue();
                        maleData.put(genderCounts.getOrDefault("MALE", 0));
                        femaleData.put(genderCounts.getOrDefault("FEMALE", 0));
                        otherData.put(genderCounts.getOrDefault("OTHER", 0));
                    }

                    departmentsData.put("departments", genderDistByDept.keySet());
                    departmentsData.put("male", maleData);
                    departmentsData.put("female", femaleData);
                    departmentsData.put("other", otherData);

                    jsonResponse.put("data", departmentsData);
                    break;

                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    jsonResponse.put("error", "Invalid data type");
                    break;
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.put("error", e.getMessage());
        }

        out.print(jsonResponse.toString());
    }
}
