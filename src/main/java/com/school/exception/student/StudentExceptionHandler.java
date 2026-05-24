package com.school.exception.student;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class StudentExceptionHandler {

    public static void handle(HttpServletRequest req,
                               HttpServletResponse res,
                               StudentException ex)
            throws ServletException, IOException {

        ex.printStackTrace();
        req.setAttribute("errorTitle",   ex.getErrorTitle());
        req.setAttribute("errorMessage", ex.getErrorMessage());
        req.setAttribute("redirectUrl",  req.getContextPath() + ex.getRedirectUrl());
        req.getRequestDispatcher("/jsp/student/exception.jsp").forward(req, res);
    }

    public static void handle(HttpServletRequest req,
                               HttpServletResponse res,
                               Exception ex,
                               String defaultRedirect)
            throws ServletException, IOException {

        ex.printStackTrace();
        req.setAttribute("errorTitle",   "Something Went Wrong");
        req.setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
        req.setAttribute("redirectUrl",  req.getContextPath() + defaultRedirect);
        req.getRequestDispatcher("/jsp/student/exception.jsp").forward(req, res);
    }
}