package com.school.exception.teacher;

public class TeacherNotificationException extends TeacherException {
    public TeacherNotificationException(String message, Throwable cause) {
        super("Notification Error", message, "/teacher/notifications", cause);
    }
}