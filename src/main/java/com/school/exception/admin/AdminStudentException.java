package com.school.exception.admin;

public class AdminStudentException extends AdminException {
    public AdminStudentException(String message, Throwable cause) {
        super("Student Management Error", message, "/admin/students", cause);
    }
}