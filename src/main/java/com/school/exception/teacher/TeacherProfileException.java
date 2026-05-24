package com.school.exception.teacher;

public class TeacherProfileException extends TeacherException {
    public TeacherProfileException(String message, Throwable cause) {
        super("Profile Error", message, "/teacher/profile", cause);
    }
}