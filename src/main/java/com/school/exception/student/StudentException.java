package com.school.exception.student;

public class StudentException extends Exception {
    private String title;
    private String redirectUrl;

    public StudentException(String title, String message, String redirectUrl) {
        super(message);
        this.title = title;
        this.redirectUrl = redirectUrl;
    }

    public StudentException(String title, String message, String redirectUrl, Throwable cause) {
        super(message, cause);
        this.title = title;
        this.redirectUrl = redirectUrl;
    }

    public String getTitle() {
        return title;
    }

    public String getRedirectUrl() {
        return redirectUrl;
    }
}
