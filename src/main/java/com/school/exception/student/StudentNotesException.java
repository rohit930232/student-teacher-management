package com.school.exception.student;

public class StudentNotesException extends StudentException {

    public StudentNotesException(String message, Throwable cause) {
        super("Notes Error", message, "/student/notes", cause);
    }
}
