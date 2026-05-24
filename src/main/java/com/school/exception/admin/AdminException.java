package com.school.exception.admin;

public class AdminException extends RuntimeException {
    private String errorTitle;
    private String errorMessage;
    private String redirectUrl;

    public AdminException(String errorTitle, String errorMessage, String redirectUrl, Throwable cause) {
        super(errorMessage, cause);
        this.errorTitle   = errorTitle;
        this.errorMessage = errorMessage;
        this.redirectUrl  = redirectUrl;
    }

    public AdminException(String errorTitle, String errorMessage, String redirectUrl) {
        super(errorMessage);
        this.errorTitle   = errorTitle;
        this.errorMessage = errorMessage;
        this.redirectUrl  = redirectUrl;
    }

    public String getErrorTitle()   { return errorTitle;   }
    public String getErrorMessage() { return errorMessage; }
    public String getRedirectUrl()  { return redirectUrl;  }
}