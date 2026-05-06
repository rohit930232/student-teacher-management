package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminNoticeDAO;

@WebServlet("/admin/notices/delete")
public class AdminNoticeDeleteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        AdminNoticeDAO dao = new AdminNoticeDAO();
        boolean ok = dao.deleteNotice(id);
        res.sendRedirect(req.getContextPath() + "/admin/notices?msg=" + (ok ? "deleted" : "error"));
    }
}