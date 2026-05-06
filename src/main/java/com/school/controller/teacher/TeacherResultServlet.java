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

@WebServlet("/teacher/result")
public class TeacherResultServlet extends HttpServlet {

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

                List<Map<String,String>> results = new ArrayList<>();
                String sql = "SELECT r.*, s.name AS student_name, e.exam_date, e.total_marks AS max_marks FROM st_result r JOIN st_student s ON r.student_id=s.student_id JOIN st_exam e ON r.exam_id=e.exam_id WHERE e.teacher_id=? AND e.class_id=? ORDER BY e.exam_date DESC";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, teacher.getTeacher_id());
                ps.setInt(2, classId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> r = new HashMap<>();
                    r.put("student_name", rs.getString("student_name"));
                    r.put("subject",      rs.getString("subject"));
                    r.put("marks",        String.valueOf(rs.getInt("marks")));
                    r.put("max_marks",    String.valueOf(rs.getInt("max_marks")));
                    r.put("grade",        rs.getString("grade"));
                    r.put("exam_date",    rs.getDate("exam_date") != null ? rs.getDate("exam_date").toString() : "");
                    results.add(r);
                }
                request.setAttribute("results", results);

                List<Map<String,String>> students = new ArrayList<>();
                PreparedStatement sPs = con.prepareStatement("SELECT student_id, name FROM st_student WHERE class_id=? ORDER BY name");
                sPs.setInt(1, classId);
                ResultSet sRs = sPs.executeQuery();
                while (sRs.next()) {
                    Map<String,String> s = new HashMap<>();
                    s.put("student_id", String.valueOf(sRs.getInt("student_id")));
                    s.put("name",       sRs.getString("name"));
                    students.add(s);
                }
                request.setAttribute("students", students);

                List<Map<String,String>> exams = new ArrayList<>();
                PreparedStatement ePs = con.prepareStatement("SELECT * FROM st_exam WHERE teacher_id=? AND class_id=? ORDER BY exam_date DESC");
                ePs.setInt(1, teacher.getTeacher_id());
                ePs.setInt(2, classId);
                ResultSet eRs = ePs.executeQuery();
                while (eRs.next()) {
                    Map<String,String> e = new HashMap<>();
                    e.put("exam_id",   String.valueOf(eRs.getInt("exam_id")));
                    e.put("subject",   eRs.getString("subject"));
                    e.put("exam_date", eRs.getDate("exam_date") != null ? eRs.getDate("exam_date").toString() : "");
                    exams.add(e);
                }
                request.setAttribute("exams", exams);
            }
        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/result.jsp");
        rd.forward(request, response);
    }
}