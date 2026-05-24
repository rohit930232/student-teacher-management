package com.school.exception.student;

public class StudentResultException extends StudentException {
    public StudentResultException(String message, Throwable cause) {
        super("Result Error", message, "/student/result", cause);
    }
}