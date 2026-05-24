package com.school.exception.teacher;

public class TeacherDashboardException extends TeacherException {
    public TeacherDashboardException(String message, Throwable cause) {
        super("Dashboard Error", message, "/teacher/dashboard", cause);
    }
}