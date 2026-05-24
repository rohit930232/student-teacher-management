package com.school.exception.admin;

public class AdminPaymentException extends AdminException {
    public AdminPaymentException(String message, Throwable cause) {
        super("Payment Error", message, "/admin/payment", cause);
    }
}