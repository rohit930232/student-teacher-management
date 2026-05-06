package com.school.exception.student;

public class StudentDashboardException extends StudentException {
    public StudentDashboardException(String message, Throwable cause) {
        super("Dashboard Error", message, "/student/dashboard", cause);
    }
}
