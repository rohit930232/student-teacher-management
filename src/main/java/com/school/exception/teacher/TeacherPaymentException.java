package com.school.exception.teacher;

public class TeacherPaymentException extends TeacherException {
    public TeacherPaymentException(String message, Throwable cause) {
        super("Payment Error", message, "/teacher/payment", cause);
    }
}