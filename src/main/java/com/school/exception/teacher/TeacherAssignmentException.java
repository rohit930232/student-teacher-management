package com.school.exception.teacher;

public class TeacherAssignmentException extends TeacherException {
    public TeacherAssignmentException(String message, Throwable cause) {
        super("Assignment Error", message, "/teacher/assignments", cause);
    }
}