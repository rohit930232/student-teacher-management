package com.school.exception.student;

public class StudentOnlineClassException extends StudentException {
    public StudentOnlineClassException(String message, Throwable cause) {
        super("Online Class Error", message, "/student/onlineclass", cause);
    }
}