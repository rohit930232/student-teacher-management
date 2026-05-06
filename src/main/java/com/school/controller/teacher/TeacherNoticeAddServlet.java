package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;

@WebServlet("/teacher/notices/add")
public class TeacherNoticeAddServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("class_id");
        try {
            String message = request.getParameter("message");
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO st_notice (notice_id, message, created_date) VALUES (st_notice_seq.NEXTVAL, ?, SYSDATE)");
            ps.setString(1, message);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        String redirect = classId != null && !classId.isEmpty()
            ? "/teacher/notices?class_id=" + classId
            : "/teacher/notices";
        response.sendRedirect(request.getContextPath() + redirect);
    }
}