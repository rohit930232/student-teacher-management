package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;
import com.school.util.DBConnection;

@WebServlet("/teacher/onlineclass/create")
public class TeacherOnlineClassCreateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("class_id");
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            TeacherDAO dao = new TeacherDAO();
            Teacher teacher = dao.getTeacherByUsername(username);

            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO st_online_class (class_id, teacher_id, subject, class_link, start_time, end_time, status, created_date) VALUES (st_online_class_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, SYSDATE)");
            ps.setInt(1, teacher.getTeacher_id());
            ps.setString(2, request.getParameter("subject"));
            ps.setString(3, request.getParameter("class_link"));
            ps.setTimestamp(4, Timestamp.valueOf(request.getParameter("start_time").replace("T", " ") + ":00"));
            ps.setTimestamp(5, Timestamp.valueOf(request.getParameter("end_time").replace("T", " ")   + ":00"));
            ps.setString(6, request.getParameter("status"));
            ps.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/teacher/onlineclass?class_id=" + classId);
    }
}