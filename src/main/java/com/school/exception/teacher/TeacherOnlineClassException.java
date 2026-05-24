package com.school.exception.teacher;

public class TeacherOnlineClassException extends TeacherException {
    public TeacherOnlineClassException(String message, Throwable cause) {
        super("Online Class Error", message, "/teacher/onlineclass", cause);
    }
}