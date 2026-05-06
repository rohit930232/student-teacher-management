package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminNoticeDAO;

@WebServlet("/admin/notices")
public class AdminNoticesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        AdminNoticeDAO dao = new AdminNoticeDAO();
        req.setAttribute("notices",   dao.getAllNotices());
        req.setAttribute("classList", dao.getClassList());
        req.getRequestDispatcher("/jsp/admin/notices.jsp").forward(req, res);
    }
}