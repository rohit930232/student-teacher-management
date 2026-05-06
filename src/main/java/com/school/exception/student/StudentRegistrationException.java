package com.school.exception.student;

public class StudentRegistrationException extends StudentException {

    public StudentRegistrationException(String message, Throwable cause) {
        super("Registration Error", message, "/jsp/student/register.jsp", cause);
    }
}
