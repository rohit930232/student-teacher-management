package com.school.exception.student;

public class StudentAssignmentException extends StudentException {
    public StudentAssignmentException(String message, Throwable cause) {
        super("Assignment Error", message, "/student/assignments", cause);
    }
}
