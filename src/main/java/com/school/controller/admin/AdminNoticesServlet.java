package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminNoticeDAO;
import com.school.exception.admin.*;

@WebServlet("/admin/notices")
public class AdminNoticesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            AdminNoticeDAO dao = new AdminNoticeDAO();
            req.setAttribute("notices",   dao.getAllNotices());
            req.setAttribute("classList", dao.getClassList());
        } catch (Exception e) {
            AdminExceptionHandler.handle(req, res,
                new AdminNoticeException("We could not load notices. Please try again later.", e));
            return;
        }
        req.getRequestDispatcher("/jsp/admin/notices.jsp").forward(req, res);
    }
}