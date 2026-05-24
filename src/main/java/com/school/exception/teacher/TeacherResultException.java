package com.school.exception.teacher;

public class TeacherResultException extends TeacherException {
    public TeacherResultException(String message, Throwable cause) {
        super("Result Error", message, "/teacher/result", cause);
    }
}