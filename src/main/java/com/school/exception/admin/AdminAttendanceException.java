package com.school.exception.admin;

public class AdminAttendanceException extends AdminException {
    public AdminAttendanceException(String message, Throwable cause) {
        super("Attendance Error", message, "/admin/attendance", cause);
    }
}