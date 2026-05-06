package com.school.exception.student;

public class StudentGeneralException extends StudentException {
    public StudentGeneralException(String message, Throwable cause) {
        super("Something Went Wrong", message, "/student/dashboard", cause);
    }
}
