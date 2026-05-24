package com.school.controller.student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.student.StudentDAO;
import com.school.model.student.Student;
import com.school.util.DBConnection;
import com.school.exception.student.*;

@WebServlet("/student/exam")
public class StudentExamServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con  = DBConnection.getConnection();
            StudentDAO dao  = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            List<Map<String,String>> exams = new ArrayList<>();
            if (student != null && student.getClass_id() > 0) {
                PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM st_exam WHERE class_id=? ORDER BY exam_date");
                ps.setInt(1, student.getClass_id());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> e = new HashMap<>();
                    e.put("exam_id",     String.valueOf(rs.getInt("exam_id")));
                    e.put("subject",     rs.getString("subject"));
                    e.put("exam_date",   rs.getDate("exam_date")  != null ? rs.getDate("exam_date").toString() : "");
                    e.put("start_time",  rs.getString("start_time"));
                    e.put("end_time",    rs.getString("end_time"));
                    e.put("total_marks", String.valueOf(rs.getInt("total_marks")));
                    exams.add(e);
                }
            }
            request.setAttribute("exams", exams);

        } catch (Exception e) {
            StudentExceptionHandler.handle(request, response,
                new StudentExamException("We could not load your exam schedule. Please try again later.", e));
            return;
        }
        request.getRequestDispatcher("/jsp/student/exam.jsp").forward(request, response);
    }
}