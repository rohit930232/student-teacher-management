package com.school.exception.student;

public class StudentNoticeException extends StudentException {

    public StudentNoticeException(String message, Throwable cause) {
        super("Notice Error", message, "/student/notices", cause);
    }
}
