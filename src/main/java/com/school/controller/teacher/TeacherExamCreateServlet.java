package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;
import com.school.util.DBConnection;

@WebServlet("/teacher/exam/create")
public class TeacherExamCreateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("class_id");
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            TeacherDAO dao = new TeacherDAO();
            Teacher teacher = dao.getTeacherByUsername(username);

            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO st_exam (exam_id, class_id, teacher_id, subject, exam_date, start_time, end_time, total_marks, created_date) VALUES (st_exam_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, SYSDATE)");
            ps.setInt(1, Integer.parseInt(classId));
            ps.setInt(2, teacher.getTeacher_id());
            ps.setString(3, request.getParameter("subject"));
            ps.setDate(4, java.sql.Date.valueOf(request.getParameter("exam_date")));
            ps.setString(5, request.getParameter("start_time"));
            ps.setString(6, request.getParameter("end_time"));
            ps.setInt(7, Integer.parseInt(request.getParameter("total_marks")));
            ps.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/teacher/exam?class_id=" + classId);
    }
}