package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminNotificationDAO;

@WebServlet("/admin/notifications")
public class AdminNotificationsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        AdminNotificationDAO dao = new AdminNotificationDAO();
        req.setAttribute("notifications", dao.getAllNotifications());
        req.getRequestDispatcher("/jsp/admin/notifications.jsp").forward(req, res);
    }
}