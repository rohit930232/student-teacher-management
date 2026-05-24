package com.school.exception.admin;

public class AdminGeneralException extends AdminException {
    public AdminGeneralException(String message, Throwable cause) {
        super("Error", message, "/admin/dashboard", cause);
    }
}