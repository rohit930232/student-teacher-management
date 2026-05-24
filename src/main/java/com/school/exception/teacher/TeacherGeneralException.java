package com.school.exception.teacher;

public class TeacherGeneralException extends TeacherException {
    public TeacherGeneralException(String message, Throwable cause) {
        super("Error", message, "/teacher/dashboard", cause);
    }
}