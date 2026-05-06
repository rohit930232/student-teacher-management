package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminNoticeDAO;

@WebServlet("/admin/notices/add")
public class AdminNoticeAddServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String message  = req.getParameter("message");
        String classStr = req.getParameter("class_id");
        int classId = 0;
        if (classStr != null && !classStr.isEmpty()) classId = Integer.parseInt(classStr);

        AdminNoticeDAO dao = new AdminNoticeDAO();
        boolean ok = dao.addNotice(message, classId);
        res.sendRedirect(req.getContextPath() + "/admin/notices?msg=" + (ok ? "added" : "error"));
    }
}