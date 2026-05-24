package com.school.exception.student;

public class StudentNotificationException extends StudentException {
    public StudentNotificationException(String message, Throwable cause) {
        super("Notification Error", message, "/student/notifications", cause);
    }
}