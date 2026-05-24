package com.school.exception.student;

public class StudentPasswordChangeException extends StudentException {
    public StudentPasswordChangeException(String message, Throwable cause) {
        super("Password Change Error", message, "/student/settings", cause);
    }
}