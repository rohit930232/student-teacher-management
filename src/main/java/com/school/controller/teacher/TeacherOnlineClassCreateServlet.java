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

            String subject   = request.getParameter("subject");
            String classLink = request.getParameter("class_link");
            String startTime = request.getParameter("start_time");
            String endTime   = request.getParameter("end_time");
            String status    = request.getParameter("status");

            // datetime-local format: "2026-05-08T11:00" → "2026-05-08 11:00:00"
            String startTs = startTime.replace("T", " ") + ":00";
            String endTs   = endTime.replace("T", " ")   + ":00";

            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO st_online_class " +
                         "(online_class_id, class_id, teacher_id, subject, class_link, start_time, end_time, status, created_date) " +
                         "VALUES (st_online_class_seq.NEXTVAL, ?, ?, ?, ?, " +
                         "TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), " +
                         "TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), ?, SYSDATE)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,    Integer.parseInt(classId));
            ps.setInt(2,    teacher.getTeacher_id());
            ps.setString(3, subject);
            ps.setString(4, classLink);
            ps.setString(5, startTs);
            ps.setString(6, endTs);
            ps.setString(7, status);
            int rows = ps.executeUpdate();
            System.out.println("Online class inserted: " + rows + " rows");

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ERROR in online class create: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/teacher/onlineclass?class_id=" + classId);
    }
}