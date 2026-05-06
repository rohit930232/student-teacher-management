package com.school.exception.student;

public class StudentPaymentException extends StudentException {
    public StudentPaymentException(String message, Throwable cause) {
        super("Payment Error", message, "/student/payment", cause);
    }
}
