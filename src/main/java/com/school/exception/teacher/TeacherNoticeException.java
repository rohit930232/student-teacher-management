package com.school.exception.teacher;

public class TeacherNoticeException extends TeacherException {
    public TeacherNoticeException(String message, Throwable cause) {
        super("Notice Error", message, "/teacher/notices", cause);
    }
}