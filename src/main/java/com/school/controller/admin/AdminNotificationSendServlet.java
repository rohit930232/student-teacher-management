package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminNotificationDAO;

@WebServlet("/admin/notifications/send")
public class AdminNotificationSendServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String message = req.getParameter("message");
        AdminNotificationDAO dao = new AdminNotificationDAO();
        boolean ok = dao.sendNotification(message);
        res.sendRedirect(req.getContextPath() + "/admin/notifications?msg=" + (ok ? "sent" : "error"));
    }
}