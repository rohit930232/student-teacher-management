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

@WebServlet("/teacher/assignments")
public class TeacherAssignmentServlet extends HttpServlet {

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

            // NULL check — class_id nahi hai toh skip karo
            if (classIdParam != null && !classIdParam.isEmpty() && !classIdParam.equals("null")) {
                int classId = Integer.parseInt(classIdParam);

                PreparedStatement totalPs = con.prepareStatement(
                    "SELECT COUNT(*) FROM st_student WHERE class_id=?"
                );
                totalPs.setInt(1, classId);
                ResultSet totalRs = totalPs.executeQuery();
                int totalStudents = totalRs.next() ? totalRs.getInt(1) : 0;
                request.setAttribute("totalStudents", totalStudents);

                List<Map<String,String>> assignments = new ArrayList<>();
                String sql =
                    "SELECT a.*, " +
                    "(SELECT COUNT(*) FROM st_assignment_submission sub WHERE sub.assignment_id = a.assignment_id) AS completed_count " +
                    "FROM st_assignment a " +
                    "WHERE a.class_id = ? " +
                    "ORDER BY a.upload_date DESC";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, classId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> a = new HashMap<>();
                    int completedCount = rs.getInt("completed_count");
                    a.put("assignment_id",   String.valueOf(rs.getInt("assignment_id")));
                    a.put("title",           rs.getString("title"));
                    a.put("description",     rs.getString("description")  != null ? rs.getString("description")  : "");
                    a.put("file_path",       rs.getString("file_path")    != null ? rs.getString("file_path")    : "");
                    a.put("upload_date",     rs.getDate("upload_date")    != null ? rs.getDate("upload_date").toString() : "");
                    a.put("deadline",        rs.getDate("deadline")       != null ? rs.getDate("deadline").toString() : "");
                    a.put("completed_count", String.valueOf(completedCount));
                    a.put("pending_count",   String.valueOf(totalStudents - completedCount));
                    a.put("total_students",  String.valueOf(totalStudents));
                    assignments.add(a);
                }
                request.setAttribute("assignments",  assignments);
                request.setAttribute("classIdParam", String.valueOf(classId));
            }
        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/assignments.jsp");
        rd.forward(request, response);
    }
}