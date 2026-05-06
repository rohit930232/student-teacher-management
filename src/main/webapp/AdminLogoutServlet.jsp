package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin/logout")
public class AdminLogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();

        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("username".equals(c.getName()) || "password".equals(c.getName())) {
                    c.setMaxAge(0);
                    res.addCookie(c);
                }
            }
        }
        res.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
    }
}