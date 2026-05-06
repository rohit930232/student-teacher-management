package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminNotificationDAO;

@WebServlet("/admin/notifications/delete")
public class AdminNotificationDeleteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        AdminNotificationDAO dao = new AdminNotificationDAO();
        boolean ok = dao.deleteNotification(id);
        res.sendRedirect(req.getContextPath() + "/admin/notifications?msg=" + (ok ? "deleted" : "error"));
    }
}