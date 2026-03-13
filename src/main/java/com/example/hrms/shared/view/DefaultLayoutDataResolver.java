package com.example.hrms.shared.view;

import com.example.hrms.dao.EmployeeDAO;
import com.example.hrms.dao.NotificationDAO;
import com.example.hrms.model.Employee;
import com.example.hrms.model.Notification;
import com.example.hrms.model.User;

import java.util.Collections;
import java.util.List;

public class DefaultLayoutDataResolver implements LayoutDataResolver {
    private final EmployeeDAO employeeDAO;
    private final NotificationDAO notificationDAO;

    public DefaultLayoutDataResolver() {
        this(new EmployeeDAO(), new NotificationDAO());
    }

    DefaultLayoutDataResolver(EmployeeDAO employeeDAO, NotificationDAO notificationDAO) {
        this.employeeDAO = employeeDAO;
        this.notificationDAO = notificationDAO;
    }

    @Override
    public LayoutViewData resolve(User user) {
        if (user == null) {
            return new LayoutViewData(null, null, Collections.emptyList(), 0);
        }

        Employee employee = employeeDAO.getEmployeeByUserId(user.getId());
        if (employee == null) {
            employee = employeeDAO.getEmployeeByEmail(user.getUsername() + "@company.com");
        }

        if (employee == null) {
            return new LayoutViewData(user, null, Collections.emptyList(), 0);
        }

        int unreadCount = notificationDAO.getUnreadNotificationCount(employee.getId());
        List<Notification> notifications = notificationDAO.getNotificationsByEmployeeId(employee.getId());
        return new LayoutViewData(user, employee, notifications, unreadCount);
    }
}
