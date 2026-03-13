package com.example.hrms.shared.view;

import com.example.hrms.model.Employee;
import com.example.hrms.model.Notification;
import com.example.hrms.model.User;

import java.util.Collections;
import java.util.List;

public class LayoutViewData {
    private final User currentUser;
    private final Employee employee;
    private final List<Notification> notifications;
    private final int unreadNotificationCount;

    public LayoutViewData(User currentUser, Employee employee, List<Notification> notifications, int unreadNotificationCount) {
        this.currentUser = currentUser;
        this.employee = employee;
        this.notifications = notifications == null ? Collections.emptyList() : Collections.unmodifiableList(notifications);
        this.unreadNotificationCount = unreadNotificationCount;
    }

    public User getCurrentUser() {
        return currentUser;
    }

    public Employee getEmployee() {
        return employee;
    }

    public List<Notification> getNotifications() {
        return notifications;
    }

    public int getUnreadNotificationCount() {
        return unreadNotificationCount;
    }

    public String getDisplayName() {
        if (employee != null && employee.getName() != null && !employee.getName().isBlank()) {
            return employee.getName();
        }
        return currentUser != null ? currentUser.getUsername() : "";
    }

    public boolean isEmployeeLinked() {
        return employee != null;
    }
}
