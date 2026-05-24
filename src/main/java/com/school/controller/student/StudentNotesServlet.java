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

@WebServlet("/student/notes")
public class StudentNotesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con  = DBConnection.getConnection();
            StudentDAO dao  = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            List<Map<String,String>> notes = new ArrayList<>();
            if (student != null && student.getClass_id() > 0) {
                String sql = "SELECT n.*, t.name AS teacher_name FROM st_notes n "
                           + "LEFT JOIN st_teacher t ON n.teacher_id = t.teacher_id "
                           + "WHERE n.class_id=? ORDER BY n.created_date DESC";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, student.getClass_id());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> n = new HashMap<>();
                    n.put("note_id",      String.valueOf(rs.getInt("note_id")));
                    n.put("title",        rs.getString("title"));
                    n.put("subject",      rs.getString("subject")      != null ? rs.getString("subject")      : "");
                    n.put("link",         rs.getString("link")         != null ? rs.getString("link")         : "");
                    n.put("file_path",    rs.getString("file_path")    != null ? rs.getString("file_path")    : "");
                    n.put("teacher_name", rs.getString("teacher_name") != null ? rs.getString("teacher_name") : "Teacher");
                    n.put("created_date", rs.getDate("created_date")   != null ? rs.getDate("created_date").toString() : "");
                    notes.add(n);
                }
            }
            request.setAttribute("notes", notes);

        } catch (Exception e) {
            StudentExceptionHandler.handle(request, response,
                new StudentNotesException("We could not load your study notes. Please try again later.", e));
            return;
        }
        request.getRequestDispatcher("/jsp/student/notes.jsp").forward(request, response);
    }
}