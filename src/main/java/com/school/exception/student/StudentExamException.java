package com.school.exception.student;

public class StudentExamException extends StudentException {
    public StudentExamException(String message, Throwable cause) {
        super("Exam Error", message, "/student/exam", cause);
    }
}