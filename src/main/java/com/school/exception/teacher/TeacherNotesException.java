package com.school.exception.teacher;

public class TeacherNotesException extends TeacherException {
    public TeacherNotesException(String message, Throwable cause) {
        super("Notes Error", message, "/teacher/notes", cause);
    }
}