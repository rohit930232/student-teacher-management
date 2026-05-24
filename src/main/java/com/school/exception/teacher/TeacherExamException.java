package com.school.exception.teacher;

public class TeacherExamException extends TeacherException {
    public TeacherExamException(String message, Throwable cause) {
        super("Exam Error", message, "/teacher/exam", cause);
    }
}