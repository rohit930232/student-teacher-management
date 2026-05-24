package com.school.exception.teacher;

public class TeacherTimetableException extends TeacherException {
    public TeacherTimetableException(String message, Throwable cause) {
        super("Timetable Error", message, "/teacher/timetable", cause);
    }
}