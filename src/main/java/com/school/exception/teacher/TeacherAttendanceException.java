package com.school.exception.teacher;

public class TeacherAttendanceException extends TeacherException {
    public TeacherAttendanceException(String message, Throwable cause) {
        super("Attendance Error", message, "/teacher/attendance", cause);
    }
}