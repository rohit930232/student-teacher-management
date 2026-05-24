package com.school.exception.admin;

public class AdminTimetableException extends AdminException {
    public AdminTimetableException(String message, Throwable cause) {
        super("Timetable Error", message, "/admin/timetable", cause);
    }
}