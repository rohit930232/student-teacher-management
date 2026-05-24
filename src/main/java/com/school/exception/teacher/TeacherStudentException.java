package com.school.exception.teacher;

public class TeacherStudentException extends TeacherException {
    public TeacherStudentException(String message, Throwable cause) {
        super("Students Error", message, "/teacher/students", cause);
    }
}