package com.school.exception.admin;

public class AdminDashboardException extends AdminException {
    public AdminDashboardException(String message, Throwable cause) {
        super("Dashboard Error", message, "/admin/dashboard", cause);
    }
}