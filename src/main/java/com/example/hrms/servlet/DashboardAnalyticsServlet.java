package com.example.hrms.servlet;

import com.example.hrms.dao.AttendanceDAO;
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
import org.json.JSONObject;

@WebServlet(name = "dashboardAnalyticsServlet", value = "/dashboard/analytics")
public class DashboardAnalyticsServlet extends HttpServlet {
    private AttendanceDAO attendanceDAO;
    private EmployeeDAO employeeDAO;
    private LeaveDAO leaveDAO;
    private PayrollDAO payrollDAO;

    @Override
    public void init() {
        attendanceDAO = new AttendanceDAO();
        employeeDAO = new EmployeeDAO();
        leaveDAO = new LeaveDAO();
        payrollDAO = new PayrollDAO();
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
