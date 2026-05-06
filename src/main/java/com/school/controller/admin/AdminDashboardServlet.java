package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminDashboardDAO;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            res.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        AdminDashboardDAO dao = new AdminDashboardDAO();
        req.setAttribute("totalStudents",   dao.getTotalStudents());
        req.setAttribute("totalTeachers",   dao.getTotalTeachers());
        req.setAttribute("totalClasses",    dao.getTotalClasses());
        req.setAttribute("totalStaff",      dao.getTotalStaff());
        req.setAttribute("notices",         dao.getRecentNotices());
        req.setAttribute("notifications",   dao.getRecentNotifications());
        req.setAttribute("upcomingExams",   dao.getUpcomingExams());

        req.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(req, res);
    }
}