package com.school.exception.student;

public class StudentProfileException extends StudentException {
    public StudentProfileException(String message, Throwable cause) {
        super("Profile Error", message, "/student/profile", cause);
    }
}
