package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;

@WebServlet("/teacher/notices/delete")
public class TeacherNoticeDeleteServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("class_id");
        try {
            int noticeId = Integer.parseInt(request.getParameter("notice_id"));
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM st_notice WHERE notice_id=?");
            ps.setInt(1, noticeId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        String redirect = classId != null && !classId.isEmpty()
            ? "/teacher/notices?class_id=" + classId
            : "/teacher/notices";
        response.sendRedirect(request.getContextPath() + redirect);
    }
}