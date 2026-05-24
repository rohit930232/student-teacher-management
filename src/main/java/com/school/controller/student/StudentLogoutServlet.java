package com.school.controller.student;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/student/logout")
public class StudentLogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("username".equals(c.getName()) || "password".equals(c.getName())) {
                    c.setMaxAge(0);
                    response.addCookie(c);
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    }
}