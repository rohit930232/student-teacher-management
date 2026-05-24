package com.school.exception.admin;

public class AdminNoticeException extends AdminException {
    public AdminNoticeException(String message, Throwable cause) {
        super("Notice Error", message, "/admin/notices", cause);
    }
}