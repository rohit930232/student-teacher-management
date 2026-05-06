package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;
import com.school.util.DBConnection;

@WebServlet("/teacher/exam")
public class TeacherExamServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con = DBConnection.getConnection();
            TeacherDAO dao = new TeacherDAO();
            Teacher teacher = dao.getTeacherByUsername(username);
            String classIdParam = request.getParameter("class_id");

            List<Map<String,String>> classes = new ArrayList<>();
            PreparedStatement cPs = con.prepareStatement("SELECT * FROM st_class ORDER BY class_name");
            ResultSet cRs = cPs.executeQuery();
            while (cRs.next()) {
                Map<String,String> c = new HashMap<>();
                c.put("class_id",   String.valueOf(cRs.getInt("class_id")));
                c.put("class_name", cRs.getString("class_name"));
                classes.add(c);
            }
            request.setAttribute("classes", classes);

            if (classIdParam != null && !classIdParam.isEmpty() && teacher != null) {
                int classId = Integer.parseInt(classIdParam);
                List<Map<String,String>> exams = new ArrayList<>();
                PreparedStatement ps = con.prepareStatement("SELECT * FROM st_exam WHERE teacher_id=? AND class_id=? ORDER BY exam_date DESC");
                ps.setInt(1, teacher.getTeacher_id());
                ps.setInt(2, classId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> e = new HashMap<>();
                    e.put("exam_id",     String.valueOf(rs.getInt("exam_id")));
                    e.put("subject",     rs.getString("subject"));
                    e.put("exam_date",   rs.getDate("exam_date")   != null ? rs.getDate("exam_date").toString()   : "");
                    e.put("start_time",  rs.getString("start_time"));
                    e.put("end_time",    rs.getString("end_time"));
                    e.put("total_marks", String.valueOf(rs.getInt("total_marks")));
                    exams.add(e);
                }
                request.setAttribute("exams", exams);
            }
        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/exam.jsp");
        rd.forward(request, response);
    }
}