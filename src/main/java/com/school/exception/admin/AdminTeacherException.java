package com.school.exception.admin;

public class AdminTeacherException extends AdminException {
    public AdminTeacherException(String message, Throwable cause) {
        super("Teacher Management Error", message, "/admin/teachers", cause);
    }
}