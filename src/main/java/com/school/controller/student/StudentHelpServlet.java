package com.school.controller.student;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.exception.student.*;

@WebServlet("/student/help")
public class StudentHelpServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.getRequestDispatcher("/jsp/student/help.jsp").forward(request, response);
        } catch (Exception e) {
            StudentExceptionHandler.handle(request, response,
                new StudentGeneralException("We could not load the help page. Please try again.", e));
        }
    }
}