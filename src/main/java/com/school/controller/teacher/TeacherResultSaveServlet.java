package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;

@WebServlet("/teacher/result/save")
public class TeacherResultSaveServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("class_id");
        try {
            int studentId = Integer.parseInt(request.getParameter("student_id"));
            int examId    = Integer.parseInt(request.getParameter("exam_id"));
            int marks     = Integer.parseInt(request.getParameter("marks"));
            String grade  = request.getParameter("grade");

            Connection con = DBConnection.getConnection();
            PreparedStatement subPs = con.prepareStatement("SELECT subject FROM st_exam WHERE exam_id=?");
            subPs.setInt(1, examId);
            ResultSet subRs = subPs.executeQuery();
            String subject = subRs.next() ? subRs.getString("subject") : "";

            PreparedStatement ps = con.prepareStatement("INSERT INTO st_result (result_id, student_id, subject, marks, grade, exam_id, class_id, exam_date) SELECT st_result_seq.NEXTVAL, ?, ?, ?, ?, ?, class_id, exam_date FROM st_exam WHERE exam_id=?");
            ps.setInt(1, studentId);
            ps.setString(2, subject);
            ps.setInt(3, marks);
            ps.setString(4, grade);
            ps.setInt(5, examId);
            ps.setInt(6, examId);
            ps.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/teacher/result?class_id=" + classId);
    }
}