package com.school.exception.student;

public class StudentAttendanceException extends StudentException {
    public StudentAttendanceException(String message, Throwable cause) {
        super("Attendance Error", message, "/student/attendance", cause);
    }
}
