package com.school.controller.admin;
import java.io.IOException;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminDAO;

@WebServlet("/Admin/Dashboard")
public class AdminDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("username") == null) {
                response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
                return;
            }
            AdminDAO dao = new AdminDAO();
            request.setAttribute("totalStudents", dao.getTotalStudents());
            request.setAttribute("totalTeachers", dao.getTotalTeachers());
            request.setAttribute("totalClasses", dao.getTotalClasses());
            request.setAttribute("totalFees", dao.getTotalFees());
            request.setAttribute("noticeBoardList", dao.getNotices());
            request.setAttribute("notificationsList", dao.getNotifications());
            RequestDispatcher rd = request.getRequestDispatcher("/jsp/admin/dashboard.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}