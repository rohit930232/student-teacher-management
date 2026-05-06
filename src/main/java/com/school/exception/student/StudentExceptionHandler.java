package com.school.exception.student;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class StudentExceptionHandler {

    public static void handle(HttpServletRequest request, HttpServletResponse response, StudentException ex)
            throws ServletException, IOException {

        request.setAttribute("errorTitle", ex.getTitle());
        request.setAttribute("errorMessage", ex.getMessage());
        request.setAttribute("redirectUrl", request.getContextPath() + ex.getRedirectUrl());

        RequestDispatcher rd = request.getRequestDispatcher("/jsp/student/exception/error.jsp");
        rd.forward(request, response);
    }
}
