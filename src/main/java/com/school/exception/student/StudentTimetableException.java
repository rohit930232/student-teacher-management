package com.school.exception.student;

public class StudentTimetableException extends StudentException {

    public StudentTimetableException(String message, Throwable cause) {
        super("Timetable Error", message, "/student/timetable", cause);
    }
}
