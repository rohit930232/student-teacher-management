package com.school.exception.admin;

public class AdminStaffException extends AdminException {
    public AdminStaffException(String message, Throwable cause) {
        super("Staff Management Error", message, "/admin/staff", cause);
    }
}