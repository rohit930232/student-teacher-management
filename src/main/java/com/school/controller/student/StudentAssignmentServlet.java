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

@WebServlet("/student/assignments")
public class StudentAssignmentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con = DBConnection.getConnection();
            StudentDAO dao = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            List<Map<String,String>> assignments = new ArrayList<>();
            if (student != null && student.getClass_id() > 0) {
                String sql = "SELECT a.*, t.name AS teacher_name FROM st_assignment a LEFT JOIN st_teacher t ON a.teacher_id=t.teacher_id WHERE a.class_id=? ORDER BY a.upload_date DESC";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, student.getClass_id());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> a = new HashMap<>();
                    a.put("assignment_id", String.valueOf(rs.getInt("assignment_id")));
                    a.put("title", rs.getString("title"));
                    a.put("description", rs.getString("description") != null ? rs.getString("description") : "");
                    a.put("file_path", rs.getString("file_path") != null ? rs.getString("file_path") : "");
                    a.put("upload_date", rs.getDate("upload_date") != null ? rs.getDate("upload_date").toString() : "");
                    a.put("teacher_name", rs.getString("teacher_name") != null ? rs.getString("teacher_name") : "Teacher");
                    assignments.add(a);
                }
            }
            request.setAttribute("assignments", assignments);
        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/student/assignments.jsp");
        rd.forward(request, response);
    }
}